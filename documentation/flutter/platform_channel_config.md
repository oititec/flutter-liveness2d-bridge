# Configuração do Platform Channel

Neste projeto, vamos criar um aplicativo Flutter simples que contém dois botões que darão inicio as jornadas de Liveness 2D e Doc Core nos SDKs nativos da Oiti e realizando a tratativa dos retornos fornecidos.
<br><br>

## Passo 1: Criar a pasta `bridge`

Crie uma pasta chamada `bridge` para adicionar todos os arquivos de configuração listados abaixo.

- [Acessar pasta de exemplo](../../lib/bridge/).
<br>

## Passo 2: Configurar o MethodChannel

Para iniciar a criação da conexão com os SDKs nativos utilizaremos a classe MethodChannel para criar o canal de comunicação entre as plataformas.

Crie um arquivo chamado `method_channel.dart` na pasta `bridge` contendo o código abaixo.

- [Acessar arquivo de exemplo](../../lib/bridge/method_channel.dart).

```dart
import 'package:flutter/services.dart';
import 'package:oiti_liveness2d_bridge/bridge/platform_interface.dart';

class MethodChannelLiveness2D extends OitiLiveness2DPlatform {
  final methodChannel = const MethodChannel('oiti_liveness2d_bridge');

  @override
  Future startFaceCaptcha(
    String appKey,
    bool isProd,
    String user,
    String name,
    String cpf,
    String birthdate,
    String password,
  ) async {
    return await methodChannel.invokeMapMethod(
      'OITI.startFaceCaptcha',
      {
        'appkey': appKey,
        'isProd': isProd,
        'user': user,
        'name': name,
        'cpf': cpf,
        'birthdate': birthdate,
        'pass': password
      },
    );
  }

  @override
  Future startDocumentscopy(String? ticket, String appKey, bool isProd) async {
    return await methodChannel.invokeMapMethod(
      'OITI.startDocumentscopy',
      {
        'ticket': ticket,
        'appkey': appKey,
        'isProd': isProd,
      },
    );
  }
}
```

<br>

## Passo 3: Configurar o PlatformInterface

Este pacote de classe fornece funcionalidade comum para interfaces de plataforma, a fim de garantir a checagem de que as Futures estão implementadas corretamente.

Crie um arquivo chamado `platform_interface.dart` na pasta `bridge` contendo o código abaixo.

- [Acessar arquivo de exemplo](../../lib/bridge/platform_interface.dart).

```dart
import 'package:oiti_liveness2d_bridge/bridge/method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class OitiLiveness2DPlatform extends PlatformInterface {
  OitiLiveness2DPlatform() : super(token: _token);

  static final Object _token = Object();

  static OitiLiveness2DPlatform _instance = MethodChannelLiveness2D();

  static OitiLiveness2DPlatform get instance => _instance;

  static set instance(OitiLiveness2DPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future startFaceCaptcha(
    String appKey,
    bool isProd,
    String user,
    String name,
    String cpf,
    String birthdate,
    String password,
  ) {
    throw UnimplementedError('startFaceCaptcha() has not been implemented.');
  }

  Future startDocumentscopy(String? ticket, String appKey, bool isProd) {
    throw UnimplementedError('startDocumentscopy() has not been implemented.');
  }
}
```

<br>

## Passo 4: Criar a classe FaceCaptchaValidateModel

Crie um arquivo chamado `facecaptcha_validate_model.dart` na pasta `bridge` contendo o código abaixo.

- [Acessar arquivo de exemplo](../../lib/bridge/facecaptcha_validate_model.dart).

```dart
class FaceCaptchaValidateModel {
  final bool valid;
  final String cause;
  final String codId;
  final String uidProtocol;

  FaceCaptchaValidateModel({
    required this.valid,
    required this.cause,
    required this.codId,
    required this.uidProtocol,
  });
}
```

<br>

## Passo 5: Invocar as Futures para iniciar o Liveness 2D e Doc Core

Precisamos criar a classe responsável por chamar os métodos criados no **passo 3**, passando os parâmetros necessários para iniciar os SDKs.

Crie um arquivo chamado `call_liveness2d.dart` na pasta `bridge` contendo o código abaixo.

- [Acessar arquivo de exemplo](../../lib/bridge/call_liveness2d.dart).

```dart
import 'package:oiti_liveness2d_bridge/bridge/facecaptcha_validate_model.dart';
import 'package:oiti_liveness2d_bridge/bridge/platform_interface.dart';

class OitiLiveness2D {
  static Future startFaceCaptcha({
    required String appKey,
    required bool isProd,
    required String user,
    required String name,
    required String cpf,
    required String birthdate,
    required String password,
  }) async {
    final result = await OitiLiveness2DPlatform.instance
        .startFaceCaptcha(appKey, isProd, user, name, cpf, birthdate, password);

    return FaceCaptchaValidateModel(
      valid: result['valid'] ?? false,
      cause: result['cause'] ?? '',
      codId: result['cod_id'] ?? '',
      uidProtocol: result['uid_protocol'] ?? '',
    );
  }

  static Future startDocumentscopy({
    String? ticket,
    required String appKey,
    required bool isProd,
  }) async {
    return await OitiLiveness2DPlatform.instance.startDocumentscopy(
      ticket,
      appKey,
      isProd,
    );
  }
}
```