import os
import shutil

import tensorflow as tf
import numpy as np
import cv2

# Classes do COCO usadas pelo modelo YOLO padrão.
COCO_CLASSES = [
    "person", "bicycle", "car", "motorcycle", "airplane", "bus", "train", "truck", "boat", "traffic light",
    "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat", "dog", "horse", "sheep", "cow",
    "elephant", "bear", "zebra", "giraffe", "backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee",
    "skis", "snowboard", "sports ball", "kite", "baseball bat", "baseball glove", "skateboard", "surfboard", "tennis racket", "bottle",
    "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange",
    "broccoli", "carrot", "hot dog", "pizza", "donut", "cake", "chair", "couch", "potted plant", "bed",
    "dining table", "toilet", "tv", "laptop", "mouse", "remote", "keyboard", "cell phone", "microwave", "oven",
    "toaster", "sink", "refrigerator", "book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush"
]

def resolve_tflite_model_path():
    candidates = [
        "yolo11n_int8.tflite",
        os.path.join("yolo11n_saved_model", "yolo11n_full_integer_quant.tflite"),
        os.path.join("yolo11n_saved_model", "yolo11n_dynamic_range_quant.tflite"),
        os.path.join("yolo11n_saved_model", "yolo11n_float16.tflite"),
        os.path.join("yolo11n_saved_model", "yolo11n_float32.tflite"),
    ]

    for path in candidates:
        if os.path.isfile(path):
            return path

    raise FileNotFoundError(
        "Nenhum modelo TFLite encontrado. Verifique se existe um dos arquivos esperados: "
        + ", ".join(candidates)
    )


def prepare_saved_model_dir(saved_model_dir="yolo11n_saved_model"):
    # If a stale file/folder with this name exists, remove it to avoid export collisions.
    if os.path.isfile(saved_model_dir):
        os.remove(saved_model_dir)
        return

    if os.path.isdir(saved_model_dir):
        has_saved_model = os.path.isfile(os.path.join(saved_model_dir, "saved_model.pb")) or os.path.isfile(
            os.path.join(saved_model_dir, "saved_model.pbtxt")
        )
        if not has_saved_model:
            shutil.rmtree(saved_model_dir)


def export_tflite_if_needed(export_enabled=False):
    if not export_enabled:
        return

    from ultralytics import YOLO

    prepare_saved_model_dir("yolo11n_saved_model")
    model = YOLO("yolo11n.pt")
    model.export(format="tflite", int8=True)


def load_model():
    model_path = resolve_tflite_model_path()
    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    return interpreter, model_path

def preprocess_image(image_path, input_details):
    input_shape = input_details[0]['shape']
    height, width = input_shape[1], input_shape[2]
    
    original = cv2.imread(image_path)
    if original is None:
        raise FileNotFoundError(f"Imagem não encontrada: {image_path}")

    resized = cv2.resize(original, (width, height))
    model_input = cv2.cvtColor(resized, cv2.COLOR_BGR2RGB)

    if input_details[0]['dtype'] == np.int8 or input_details[0]['dtype'] == np.uint8:
        input_data = np.expand_dims(model_input, axis=0).astype(input_details[0]['dtype'])
    else:
        input_data = np.expand_dims(model_input / 255.0, axis=0).astype(np.float32)
        
    return input_data, original, width, height

def post_process(output_data, original_shape, input_width, input_height, confidence_threshold=0.5, nms_threshold=0.45):
    predictions = np.squeeze(output_data).T
    orig_h, orig_w = original_shape[:2]

    scale_x = orig_w / float(input_width)
    scale_y = orig_h / float(input_height)
    coords_normalized = float(np.max(predictions[:, :4])) <= 1.5
    
    boxes = []
    scores = []
    class_ids = []

    for pred in predictions:
        class_scores = pred[4:]
        class_id = np.argmax(class_scores)
        confidence = float(class_scores[class_id])

        if confidence > confidence_threshold:
            xc, yc, w, h = pred[:4]

            if coords_normalized:
                x1 = int((xc - w / 2) * orig_w)
                y1 = int((yc - h / 2) * orig_h)
                bw = int(w * orig_w)
                bh = int(h * orig_h)
            else:
                x1 = int((xc - w / 2) * scale_x)
                y1 = int((yc - h / 2) * scale_y)
                bw = int(w * scale_x)
                bh = int(h * scale_y)

            x1 = max(0, min(x1, orig_w - 1))
            y1 = max(0, min(y1, orig_h - 1))
            bw = max(1, min(bw, orig_w - x1))
            bh = max(1, min(bh, orig_h - y1))
            boxes.append([x1, y1, bw, bh])
            scores.append(confidence)
            class_ids.append(int(class_id))

    if not boxes:
        return []

    indices = cv2.dnn.NMSBoxes(boxes, scores, confidence_threshold, nms_threshold)
    if len(indices) == 0:
        return []

    detections = []
    for idx in np.array(indices).flatten():
        detections.append((boxes[idx], scores[idx], class_ids[idx]))
    return detections


def draw_detections(image, detections):
    output = image.copy()
    for box, score, class_id in detections:
        x, y, w, h = box
        x2 = x + w
        y2 = y + h
        label_name = COCO_CLASSES[class_id] if 0 <= class_id < len(COCO_CLASSES) else f"class_{class_id}"
        label = f"{label_name}: {score:.2f}"

        cv2.rectangle(output, (x, y), (x2, y2), (0, 255, 0), 2)

        (text_w, text_h), _ = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.55, 1)
        text_y = y - 10 if y - 10 > text_h else y + text_h + 10
        cv2.rectangle(output, (x, text_y - text_h - 6), (x + text_w + 4, text_y + 2), (0, 255, 0), -1)
        cv2.putText(output, label, (x + 2, text_y - 2), cv2.FONT_HERSHEY_SIMPLEX, 0.55, (0, 0, 0), 1, cv2.LINE_AA)

    return output


def list_jpg_images(directory="."):
    images = []
    for file_name in os.listdir(directory):
        file_path = os.path.join(directory, file_name)
        if os.path.isfile(file_path) and file_name.lower().endswith(".jpg"):
            images.append(file_path)
    return sorted(images)


def process_image(interpreter, input_details, output_details, image_path, output_path):
    input_data, original_image, model_w, model_h = preprocess_image(image_path, input_details)

    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]['index'])

    detections = post_process(output_data, original_image.shape, model_w, model_h)
    result_image = draw_detections(original_image, detections)
    cv2.imwrite(output_path, result_image)

    return output_data.shape, len(detections)

if __name__ == "__main__":
    # Set to True only when you need to regenerate TFLite files from .pt.
    export_tflite_if_needed(export_enabled=False)

    input_dir = "."
    output_dir = "output"
    os.makedirs(output_dir, exist_ok=True)

    image_paths = list_jpg_images(input_dir)
    if not image_paths:
        raise FileNotFoundError("Nenhuma imagem .jpg encontrada no diretório atual.")

    interpreter, model_path = load_model()
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    print(f"Modelo TFLite utilizado: {model_path}")
    print(f"Imagens .jpg encontradas: {len(image_paths)}")

    total_detections = 0
    for image_path in image_paths:
        output_path = os.path.join(output_dir, os.path.basename(image_path))
        output_shape, detection_count = process_image(
            interpreter,
            input_details,
            output_details,
            image_path,
            output_path,
        )
        total_detections += detection_count
        print(f"[{os.path.basename(image_path)}] shape saída: {output_shape} | detecções: {detection_count} | output: {output_path}")

    print(f"Total de detecções em lote: {total_detections}")
    print(f"Resultados salvos em: {output_dir}")