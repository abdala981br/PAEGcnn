# PAEG Visual App

Este projeto registra um teste simples de visão computacional para validar o uso de um modelo YOLO exportado para TFLite. O script principal executa inferência sobre imagens `.jpg` presentes na pasta raiz, processa as detecções encontradas e salva as imagens anotadas na pasta `output/`.

## Objetivo do teste

O foco deste repositório é validar o comportamento do modelo em um cenário controlado e direto, antes de avançar para integrações mais amplas. O fluxo atual permite:

- localizar automaticamente um arquivo de modelo TFLite compatível;
- carregar o modelo com TensorFlow Lite;
- processar imagens de teste estáticas;
- aplicar pós-processamento nas detecções;
- gerar imagens de saída com caixas e rótulos.

Em termos práticos, este teste serve para confirmar se o modelo consegue ser executado localmente, identificar objetos nas imagens e produzir uma saída visual utilizável para análise inicial.

## Como o teste do modelo funciona

O arquivo `model.py` procura imagens `.jpg` no diretório principal do projeto e usa o modelo TFLite disponível para rodar a inferência. Depois disso, o script desenha as detecções encontradas sobre a imagem original e grava o resultado na pasta `output/`.

Esse processo foi montado como um teste funcional simples, com entradas estáticas, para validar a execução do modelo e apoiar comparações com outros experimentos semelhantes.

## Documentos adicionais

### MORE_INFO.md

O arquivo `MORE_INFO.md` explica o contexto deste experimento. Ele descreve que este repositório representa um script simples, feito com entradas estáticas apenas para teste do modelo, e que esse tipo de validação está sendo repetido para muitos outros modelos. Também registra que existe um projeto no Hugging Face reunindo outros modelos já testados.

### NEXT_STEPS.md

O arquivo `NEXT_STEPS.md` descreve os próximos avanços esperados para a iniciativa. Entre eles estão a realização de novos testes com outros modelos, a construção de um dataset mais trabalhado e, por fim, a definição da comunicação e da utilização desses modelos via API.
