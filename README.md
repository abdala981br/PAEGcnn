# Auxilio a Deficientes Visuais com Redes Neurais Convolucionais

## Sobre o projeto

Este repositorio faz parte do projeto PAEG e registra uma etapa pratica de teste de modelo para apoio ao desenvolvimento de uma solucao de auxilio a pessoas com deficiencia visual. A proposta geral combina visao computacional, inteligencia artificial e aplicacoes futuras em ambientes integrados.

No estado atual, o repositorio concentra um teste simples de inferencia com um modelo YOLO exportado para TFLite. O script principal executa o processamento de imagens `.jpg`, identifica deteccoes e salva os resultados anotados na pasta `output/`.

## Objetivo do teste do modelo

Este teste foi montado para validar o comportamento do modelo em um cenario direto e controlado, com entradas estaticas, antes de avancar para uma estrutura mais ampla. O fluxo atual permite:

- localizar automaticamente um arquivo de modelo TFLite compativel;
- carregar o modelo com TensorFlow Lite;
- processar imagens de teste locais;
- aplicar pos-processamento nas deteccoes;
- gerar imagens de saida com caixas e rotulos.

Em termos praticos, o objetivo e confirmar se o modelo consegue ser executado localmente, identificar objetos nas imagens e produzir uma saida visual util para avaliacao inicial.

## Contexto do repositorio

Este repositorio representa uma nova implementacao dentro do contexto do projeto. A decisao de seguir com uma estrutura nova permitiu organizar melhor os experimentos, simplificar a manutencao e documentar cada etapa com mais clareza.

Esse experimento especifico esta focado apenas na validacao do modelo. Ele nao representa ainda a solucao final do projeto, mas sim uma base controlada para testes comparativos e evolucao tecnica.

## Documentos adicionais

### MORE_INFO.md

O arquivo `MORE_INFO.md` explica o contexto deste experimento. Ele descreve que foi feito um script simples com inputs estaticos apenas para testar o modelo, que esse mesmo processo esta sendo realizado para muitos outros modelos e que existe um projeto no Hugging Face reunindo outros modelos ja testados.

### NEXT_STEPS.md

O arquivo `NEXT_STEPS.md` descreve os proximos passos da iniciativa. Ele cobre a realizacao de novos testes com outros modelos, a montagem de um dataset mais bem trabalhado e a futura comunicacao e utilizacao dos modelos via API.
