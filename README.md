# Oiti - Bridge para o Liveness 2D

## Sobre este Repositório

Este repositório é responsável pela conexão do **Platform Channels do Flutter**, com ele é possível instalar e usar o SDK do Liveness 2D e Doc Core da Oiti.

### Saiba mais sobre o Liveness 2D e Doc Core

- [Descrição e Resultados - Liveness 2D](https://github.com/oititec/liveness-ios-sdk/blob/main/Documentation/Liveness2D/Liveness2D-Description.md)
- [Descrição e Resultados - Doc Core](https://github.com/oititec/liveness-ios-sdk/blob/main/Documentation/Liveness2D/Documentoscopy-Description.md)

## O que é Bridge?

A "bridge" no contexto do Flutter refere-se à infraestrutura subjacente que permite a comunicação entre o código Dart e o código nativo da plataforma, possibilitando a criação de aplicativos que podem acessar recursos e funcionalidades específicas de cada sistema operacional, além das capacidades oferecidas pelo próprio framework Flutter.

### Platform Channel:

Para realizar a comunicação entre o código Dart e o código nativo da plataforma, o Flutter usa o conceito de "platform channels" (canais de plataforma). Esses canais permitem que você envie mensagens de um lado para o outro da "ponte" entre o código Dart e o código nativo. Isso é útil quando você precisa acessar recursos ou funcionalidades específicas da plataforma que não estão diretamente disponíveis no Flutter.

### MethodChannel:

O Flutter fornece duas classes principais para facilitar a comunicação através dos canais de plataforma: MethodChannel e EventChannel. Nesse projeto utilizamos apenas do MethodChannel que permite que você invoque métodos do código nativo a partir do Dart e obtenha callback`s.

<p style="align:center;">
 <img src="https://miro.medium.com/v2/0*33bydz0LNvKaJ4kY.png"/>
</p>

## Sumário

As instruções de uso, integração, implementação e customização do **Liveness 2D** e **Doc Core** podem ser acessados através do sumário abaixo:

### Flutter

- [Configuração do Platform Channel](documentation/flutter/platform_channel_config.md).
- [Tratamento de Responses/Callback](documentation/flutter/callback.md).

### Android

- **Geral**
    - [Configuração Inicial](documentation/android/initial_config.md)
    - [Configuração do FlutterEngine e MethodChannel](documentation/android/flutter_engine_config.md)
    - [Configuração dos Responses/Callback](documentation/android/callback.md)

- **Liveness 2D**
    - [Guia de Uso e Integração](https://github.com/oititec/liveness-android-sdk/blob/main/Documentation/Liveness-Usage.md)
    - [Guia de Customização](https://github.com/oititec/liveness-android-sdk/blob/main/Documentation/Liveness-CustomView.md)

- **Doc Core**
    - [Guia de Uso e Integração](https://github.com/oititec/liveness-android-sdk/blob/main/Documentation/Documentscopy-Usage.md)
    - [Guia de Customização](https://github.com/oititec/liveness-android-sdk/blob/main/Documentation/Documentscopy-CustomView.md)

### iOS

- **Geral**
    - [Configuração Inicial](documentation/ios/initial_config.md)
    - [Configuração do FlutterEngine e MethodChannel](documentation/ios/flutter_engine_config.md)
    - [Configuração dos Retornos do SDK](documentation/ios/callback.md)

- **Liveness 2D**
    - [Guia de Uso e Integração](https://github.com/oititec/liveness-ios-sdk/blob/main/Documentation/Liveness3D/Liveness3D-Usage.md)
    - [Guia de Customização](https://github.com/oititec/liveness-ios-sdk/blob/main/Documentation/Liveness2D/FaceCaptcha-CustomView.md)

- **Doc Core**
    - [Guia de Uso e Integração](https://github.com/oititec/liveness-ios-sdk/blob/main/Documentation/Liveness2D/Documentscopy-Usage.md)
    - [Guia de Customização](https://github.com/oititec/liveness-ios-sdk/blob/main/Documentation/Liveness2D/Documentscopy-CustomView.md)

### Como executar o clone do Repositório?

Execute o clone do repositório abaixo para baixar o código:

```sh
git clone https://github.com/oititec/flutter-liveness2d-bridge
```

### Como rodar o Script?

Para rodar o script desse repositório você deve instalar as dependências do projeto executando o seguinte comando no terminal;

#### Dependências

```sh
flutter pub get
```

### Como executar o projeto?

> Executar sempre em dispositivos físicos e não no simulador do iOS e Android pois nossa SDK tem emulator detection.

```sh
flutter run
```

Em seguida deve seguir escolher o dispositivo android ou iOS de debug listado no terminal.

