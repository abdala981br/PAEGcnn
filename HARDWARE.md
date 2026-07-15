# Estudo de Viabilidade de Hardware Externo (Câmera Wi-Fi)

Durante as reuniões e desenvolvimento do projeto PAEG, foi identificada uma preocupação de segurança pública: a necessidade do usuário transitar em vias públicas expondo um smartphone de alto custo para que a câmera capture o ambiente à sua frente.

Como alternativa, o grupo investigou a viabilidade de utilizar uma câmera de monitoramento externa e compacta acoplada de forma discreta ao usuário (por exemplo, na roupa ou boné) transmitindo as imagens diretamente ao celular guardado no bolso.

## Descobertas Técnicas e Metodologia de Investigação

Para mapear o funcionamento da câmera externa sem documentação oficial do fabricante, o grupo realizou uma análise de infraestrutura de rede:

1. **Interceptação de Tráfego**: Utilizando a ferramenta de diagnóstico de rede PCAPdroid, monitoramos as conexões realizadas pelo aplicativo oficial da câmera (GoPlus CamPro) sob a rede Wi-Fi local gerada pelo próprio dispositivo de captura.
   
2. **Protocolo Identificado**: Descobrimos que a câmera transmite os pacotes de vídeo em tempo real utilizando o protocolo RTSP (Real-Time Streaming Protocol) através de portas dinâmicas sobre TCP e UDP.

3. **Validação Externa**: Utilizando a biblioteca multimídia FFmpeg em ambiente de teste no computador, conseguimos conectar e receber com sucesso o fluxo de streaming em tempo real gerado pelas rotas e portas mapeadas na interceptação.

## Desafios de Integração Identificados

Embora a conexão externa via FFmpeg tenha sido bem-sucedida, a implementação direta no aplicativo Flutter apresentou limitações que inviabilizaram sua inclusão no protótipo atual:

* **Complexidade no Flutter**: O consumo direto e decode de pacotes RTSP em tempo real dentro do fluxo assíncrono do Flutter exige bibliotecas adicionais complexas que demandam mais tempo de pesquisa.
* **Limitação de Conectividade**: Como a câmera externa transmite dados gerando sua própria rede Wi-Fi local (sem acesso à internet) para se comunicar com o smartphone, o celular do usuário fica incapacitado de utilizar simultaneamente seus dados móveis (4G/5G) ou outra rede WIFI. Isso impossibilitaria o funcionamento de outros serviços online de localização ou emergência em paralelo.
