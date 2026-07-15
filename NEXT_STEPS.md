# Sugestão de Passos Futuros para o Projeto

Com base nas limitações identificadas no protótipo atual e nos testes de campo conduzidos, as seguintes iniciativas são recomendadas para a evolução técnica do sistema:

## 1. Conectividade e Hardware Externo

* **Integração RTSP Nativa**: Pesquisar e implementar reprodutores de vídeo ou decodificadores RTSP (como implementações estáveis com FFmpeg nativo ou plugins do VLC para Flutter) diretamente no ciclo de processamento de imagem do aplicativo.
* **Alternativas de Conexão Física (USB OTG)**: Investigar o uso de microcâmeras com suporte a conexão direta via cabo USB OTG, contornando a dependência do canal Wi-Fi e permitindo que o usuário continue conectado aos dados móveis do celular.

## 2. Otimização do Modelo de Visão Computacional

* **Dataset Especializado para Acessibilidade**: Treinar o modelo YOLO com classes focadas em obstáculos cotidianos de deficientes visuais (como orelhões, guias rebaixadas, buracos em calçadas, galhos baixos e semáforos de pedestres).
* **Ajuste de Hiperparâmetros**: Refinar a precisão e confiança de detecção para diminuir taxas de falsos positivos/negativos sem onerar o tempo de execução no celular.

## 3. Experiência do Usuário (UX) e Acessibilidade

* **Integração com Leitores de Tela**: Garantir suporte total e compatibilidade com ferramentas nativas de acessibilidade dos sistemas operacionais (TalkBack no Android e VoiceOver no iOS).
* **Interface Tátil Sem Visual**: Desenvolver uma tela de interação minimalista controlada inteiramente por gestos táteis simples (toques longos, arrastar de dedos) para inicializar, pausar ou alterar as configurações de velocidade do sintetizador de voz.
