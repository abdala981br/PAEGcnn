# Auxílio a Deficientes Visuais com Redes Neurais Convolucionais — Aplicativo Flutter (PAEG)

## Sobre o projeto

Este repositório faz parte do projeto PAEG (Projeto Acadêmico de Extensão Guiada) e registra a etapa prática de desenvolvimento e integração de um aplicativo mobile para auxílio a pessoas com deficiência visual. A proposta do sistema combina captura de imagem assíncrona, inteligência artificial local com redes neurais convolucionais e retorno por voz em tempo real.

No estado atual, este repositório concentra a implementação de um aplicativo em Flutter que realiza a captura periódica através da câmera do celular em segundo plano, executa a inferência local de objetos utilizando o modelo YOLO11 nano quantizado para TFLite, e gera um retorno sonoro ao usuário via TTS (Text-to-Speech) informando o objeto e sua posição espacial.

## Objetivo do aplicativo

Este desenvolvimento foi projetado para validar a viabilidade de execução de modelos de deep learning diretamente em dispositivos móveis (on-device AI) de forma fluida e acessível. O fluxo implementado permite:

* Captura automatizada: Execução da câmera em segundo plano com capturas em intervalos programados de 3 segundos;
* Gestão eficiente de memória: Limpeza automática do cache de imagens do disco a cada ciclo de processamento;
* Inferência offline: Execução local do modelo YOLO11 nano sem dependência de APIs externas ou conexão com a internet;
* Espacialização e tradução: Mapeamento da posição horizontal do objeto detectado (Esquerda, Centro, Direita) e tradução dinâmica das classes do dataset COCO para o português;
* Retorno sonoro: Feedback instantâneo por síntese de voz (TTS) para orientação em tempo real do usuário.

## Contexto do repositório

Este repositório representa a frente de desenvolvimento mobile e integração de hardware do ecossistema PAEG. Enquanto outras frentes do grupo focaram na validação estática de modelos de detecção em ambientes isolados, esta implementação consolida a aplicação prática direta na ponta, aproximando a tecnologia da experiência de uso real.

Os testes do aplicativo foram conduzidos diretamente em dispositivos físicos dos integrantes do grupo utilizando o ambiente Android Studio. Esse esforço serviu como uma prova de conceito (PoC) crucial para avaliar em tempo real a latência do modelo YOLO11 nano e a usabilidade prática da interface de voz em cenários dinâmicos do dia a dia.

## Estrutura do código principal

O projeto está dividido nas seguintes estruturas de serviço e telas:

* `lib/core/constants.dart`: Contém as classes originais do dataset COCO e o dicionário de tradução dinâmica (cocoTranslations) para o português.
* `lib/services/tts_service.dart`: Centraliza a inicialização e controle do motor de síntese de voz (FlutterTts), configurado para o idioma local (pt-BR).
* `lib/services/yolo_service.dart`: Gerencia o interpretador do TensorFlow Lite (tflite_flutter), lidando com o redimensionamento da imagem para 640x640, normalização de pixels, execução do modelo yolo11n_int8.tflite e pós-processamento de coordenadas para determinar a orientação (Esquerda, Centro, Direita).
* `lib/screens/hidden_camera.dart`: Tela principal que coordena o ciclo assíncrono de inicialização de hardware, o timer de captura a cada 3 segundos e a atualização de tela com a última detecção realizada.

## Documentos adicionais

Para manter o foco no desenvolvimento do aplicativo e evitar poluição visual neste arquivo, outros aspectos técnicos e planejamentos foram organizados nos arquivos abaixo:

`HARDWARE.md`: Estudo técnico de viabilidade para uso de uma câmera externa Wi-Fi (RTSP/FFmpeg) visando a segurança do usuário.

`NEXT_STEPS.md`: Planejamento detalhado dos próximos passos, incluindo melhorias no dataset, acessibilidade e novas integrações.

## Instalação e Configuração

### Pré-requisitos
* Flutter SDK instalado na versão estável mais recente.
* Android Studio ou VS Code configurado para desenvolvimento Flutter.
* Dispositivo físico Android para testes em tempo real.

### Passos de Instalação

1. Clonar o repositório:
   ```bash
   git clone https://github.com/abdala981br/PAEGcnn/flutter-camera/

2. Inserir o modelo TFLite:
    Certifique-se de que o arquivo do modelo yolo11n_int8.tflite esteja localizado em:
    ```bash
    assets/yolo11n_int8.tflite
    ```
    (Verifique se a pasta assets está devidamente declarada no arquivo pubspec.yaml).

3. Instalar as dependências:
    ```bash
    flutter pub get

4. Executar o aplicativo:
    ```bash
    flutter run
