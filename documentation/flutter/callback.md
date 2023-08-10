# Tratamento dos Retornos

Aqui fica a seção de controle dos retornos dos SDKs nativos.

## Passo 1: Importar dependências do arquivo

- [Acessar arquivo de exemplo](../../lib/main.dart).

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oiti_liveness2d_bridge/bridge/call_liveness2d.dart';
import 'package:oiti_liveness2d_bridge/bridge/facecaptcha_validate_model.dart';
```

## Passo 2: Criar os botões responsáveis por iniciar as jornadas

Crie um botão para cada jornada e implemente dentro do `onPressed` a função assíncrona responsável por iniciar o Liveness 2D ou Doc Core.

- [Acessar arquivo de exemplo](../../lib/main.dart).

**Liveness 2D**

```dart
ElevatedButton(
  onPressed: () async {
    try {
      await OitiLiveness2D.startFaceCaptcha(
        appKey: appKey,
        isProd: isProd,
        user: "flutter.app",
        name: "Flutter App",
        cpf: "52998850081",
        birthdate: "01/01/2000",
        password: "flutter_passwword",
      ).then((result) => _onFaceCaptchaSuccess(result));
    } on PlatformException catch (error) {
      _onFaceCaptchaError(error);
    } catch (error) {
      print(error);
    }
  },
  child: const Text("Iniciar FaceCaptcha"),
)
```

**Doc Core**

```dart
ElevatedButton(
  onPressed: () async {
    try {
      await OitiLiveness2D.startDocumentscopy(
        ticket: ticket,
        appKey: appKey,
        isProd: isProd,
      ).then((_) => _onDocumentscopySuccess());
    } on PlatformException catch (error) {
      _onDocumentscopyError(error);
    } catch (error) {
      print(error);
    }
  },
  child: const Text("Iniciar Documentoscopia"),
)
```

## Passo 3: Criar Funções para Tratar os Dados de Callback

- [Acessar arquivo de exemplo](../../lib/main.dart).

**Liveness 2D**

```dart
_onFaceCaptchaSuccess(FaceCaptchaValidateModel result) {
  setState(() {
    resultStatus = 'FaceCaptcha Success';
    resultContent =
        'Valid: ${result.valid}\nCodID: ${result.codId}\nCause: ${result.cause}\nProtocol: ${result.uidProtocol}';
  });
}

_onFaceCaptchaError(PlatformException error) {
  setState(() {
    resultStatus = 'FaceCaptcha Error';
    resultContent = 'Code: ${error.code}\nMessage: ${error.message}';
  });
}
```

**Doc Core**

```dart
_onDocumentscopySuccess() {
  setState(() {
    resultStatus = 'Documentscopy Success';
    resultContent = '';
  });
}

_onDocumentscopyError(PlatformException error) {
  setState(() {
    resultStatus = 'Documentscopy Error';
    resultContent = 'Code: ${error.code}\nMessage: ${error.message}';
  });
}
```