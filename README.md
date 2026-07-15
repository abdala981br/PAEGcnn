# Caminho Livre

## Sobre o projeto

O **Caminho Livre** é um aplicativo móvel desenvolvido em Flutter com foco em acessibilidade para pessoas com deficiência visual. O objetivo do projeto é fornecer auxílio durante a locomoção por meio da identificação de obstáculos utilizando a câmera do dispositivo e recursos de feedback acessíveis.

Nesta etapa do desenvolvimento, foi implementada a estrutura base da aplicação, incluindo a interface gráfica, a navegação entre telas, o gerenciamento de permissões da câmera e as configurações de acessibilidade.

## Funcionalidades implementadas

* Solicitação e gerenciamento da permissão de uso da câmera.
* Visualização da câmera em tempo real.
* Interface principal preparada para exibição de notificações e feedback ao usuário.
* Tela de configurações contendo:

  * Ativação/desativação do feedback tátil.
  * Ativação/desativação do Text-to-Speech.
  * Controle do tamanho da fonte.
* Navegação entre as telas da aplicação.

## Tecnologias utilizadas

* Flutter
* Dart
* Package `camera`
* Package `permission_handler`

## Estrutura do projeto

```
lib/
├── main.dart
├── permission_page.dart
├── main_page.dart
└── settings_page.dart
```

### Descrição das telas

#### PermissionPage

Tela responsável por solicitar ao usuário a permissão de acesso à câmera antes do início da utilização do aplicativo.

#### MainPage

Tela principal da aplicação, contendo:

* Preview da câmera;
* Painel para notificações e feedback;
* Indicador de status do caminho;
* Acesso à tela de configurações;
* Botão para futuras funcionalidades de áudio.

#### SettingsPage

Tela destinada às configurações de acessibilidade da aplicação, permitindo ao usuário personalizar funcionalidades como feedback tátil, leitura em voz alta e tamanho da fonte.

## Como executar o projeto

### Pré-requisitos

* Flutter SDK instalado
* Android Studio ou Visual Studio Code
* Emulador Android ou dispositivo físico

### Instalação

Clone o repositório:

```bash
git clone <URL_DO_REPOSITORIO>
```

Acesse a pasta do projeto:

```bash
cd CaminhoLivre
```

Instale as dependências:

```bash
flutter pub get
```

Execute a aplicação:

```bash
flutter run
```

## Próximos passos

As próximas etapas previstas para o desenvolvimento incluem:

* Persistência das configurações do usuário.
* Implementação do Text-to-Speech.
* Implementação do feedback tátil.
* Integração do painel de notificações com os demais módulos do projeto.
* Integração com o módulo responsável pela detecção de obstáculos desenvolvido pela equipe de visão computacional.

## Equipe

Projeto desenvolvido como parte de uma atividade acadêmica, com foco em acessibilidade e auxílio à mobilidade de pessoas com deficiência visual.
