# Configuração do FlutterEngine e MethodChannel no Android

## Passo 1: Implementar o FlutterResult

Adicione logo no inicio da classe `MainActivity` o `FlutterResult` para controle dos retornos

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/MainActivity.kt).

```kotlin
private var resultFlutter: Result? = null
```

## Passo 2: Configurar o FlutterMethodChannel

No arquivo `MainActivity.kt`, implemente a função `configureFlutterEngine()` do FlutterActivity e configure o MethodChannel do Flutter.

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/MainActivity.kt).

```kotlin
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    val binaryMessenger = flutterEngine.dartExecutor.binaryMessenger
    val channel = MethodChannel(binaryMessenger, "oiti_liveness2d_bridge")

    channel.setMethodCallHandler { call, result ->
        this.resultFlutter = result

        when (call.method) {
            "OITI.startFaceCaptcha" -> {
                try {
                    startFaceCaptcha(call)
                } catch (e: Exception) {
                    result.error("UNKNOWN_ERROR", e.message, e.stackTrace)
                }
            }

            "OITI.startDocumentscopy" -> {
                try {
                    startDocumentscopy(call)
                } catch (e: Exception) {
                    result.error("UNKNOWN_ERROR", e.message, e.stackTrace)
                }
            }

            else -> result.notImplemented()
        }
    }
}
```

## Passo 3: Implementar a interface Manageable

Crie dentro do pacote `utils` a interface Manageable.

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/utils/Manageable.kt).

```kotlin
interface Manageable {
    fun getIntent(): Intent
    fun onResultSuccess(data: Intent?, result: MethodChannel.Result?)
    fun onResultCancelled(data: Intent?, result: MethodChannel.Result?)
}
```

## Passo 4: Implementar a classe FaceCaptchaManager

Crie dentro do pacote `utils` a classe FaceCaptchaManager que implementa a interface Manageable e implemente o método `getIntent()`.

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/utils/FaceCaptchaManager.kt).

```kotlin
class FaceCaptchaManager(
    private var context: Context,
    private val userData: UserData,
    private val endpoint: String
): Manageable {

    override fun getIntent(): Intent {
        return Intent(context, FaceCaptchaActivity::class.java).apply {
            putExtra(FaceCaptchaActivity.PARAM_ENDPOINT, endpoint)
            putExtra(FaceCaptchaActivity.PARAM_USER_DATA, userData)
            putExtra(FaceCaptchaActivity.PARAM_DEBUG_ON, false)
        }
    }

    override fun onResultSuccess(data: Intent?, result: MethodChannel.Result?) {
        TODO("Not yet implemented")
    }

    override fun onResultCancelled(data: Intent?, result: MethodChannel.Result?) {
        TODO("Not yet implemented")
    }
}
```

## Passo 5: Implementar a classe DocumentscopyManager

Crie dentro do pacote `utils` a classe DocumentscopyManager que implementa a interface Manageable e implemente o método `getIntent()`.

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/utils/DocumentscopyManager.kt).

```kotlin
class DocumentscopyManager(
    private var context: Context,
    private val ticket: String?,
    private val appKey: String,
    private val endpoint: String,
    private val environment: CertifaceEnviroment
): Manageable {

    override fun getIntent(): Intent {
        return Intent(context, DocumentscopyActivity::class.java).apply {
            putExtra(DocumentscopyActivity.PARAM_TICKET, ticket)
            putExtra(DocumentscopyActivity.PARAM_APP_KEY, appKey)
            putExtra(DocumentscopyActivity.PARAM_ENDPOINT, endpoint)
            putExtra(DocumentscopyActivity.PARAM_CERTIFACE_ENV, environment)
            putExtra(DocumentscopyActivity.PARAM_DEBUG_ON, false)
        }
    }

    override fun onResultSuccess(data: Intent?, result: MethodChannel.Result?) {
        TODO("Not yet implemented")
    }

    override fun onResultCancelled(data: Intent?, result: MethodChannel.Result?) {
        TODO("Not yet implemented")
    }
}
```

## Passo 6: Implementar os métodos auxiliares

Implemente os métodos auxiliares que serão utilizados nos processo de apresentação dos fluxos e tratativa dos retornos.
A implementação desses métodos será feita através da classe ActivityUtility criada dentro do pacote `utils`.

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/utils/ActivityUtility.kt).

```kotlin
class ActivityUtility {
    companion object {
        fun getArgumentsFrom(call: MethodCall): Triple<String?, String, CertifaceEnviroment> {
            val ticket = call.argument<String?>("ticket")
            val appKey = call.argument<String?>("appkey") ?: ""
            val isProd: Boolean? = call.argument("isProd")
            val environment = when (isProd == true) {
                true -> CertifaceEnviroment.PRD
                else -> CertifaceEnviroment.HML
            }

            return Triple(ticket, appKey, environment)
        }

        fun getEndpointFrom(environment: CertifaceEnviroment): String {
            return when (environment) {
                CertifaceEnviroment.PRD -> "https://certiface.com.br"
                CertifaceEnviroment.HML -> "https://comercial.certiface.com.br"
            }
        }

        fun getUserDataFrom(call: MethodCall, appKey: String): UserData {
            return UserData(
                appKey = appKey,
                user = call.argument<String?>("user") ?: "",
                nome = call.argument<String?>("name") ?: "",
                cpf = call.argument<String?>("cpf") ?: "",
                nascimento = call.argument<String?>("birthdate") ?: "",
                pass = call.argument<String?>("pass") ?: ""
            )
        }
    }
}
```

## Passo 7: Implementar os métodos para uso do Liveness 2D e Doc Core

Crie dentro da classe MainActivity os dois métodos citados na configuração do MethodChannel no **passo 2** para uso do Liveness 2D e Doc Core.

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/MainActivity.kt).

```kotlin
private fun startFaceCaptcha(call: MethodCall) {
    val (_, appKey, environment) = ActivityUtility.getArgumentsFrom(call)
    val endpoint = ActivityUtility.getEndpointFrom(environment)
    val userData = ActivityUtility.getUserDataFrom(call, appKey)
    val manager = FaceCaptchaManager(this, userData, endpoint)

    faceCaptchaManager = manager
    activity.startActivityForResult(manager.getIntent(), FC_RESULT_REQUEST)
}

private fun startDocumentscopy(call: MethodCall) {
    val (ticket, appKey, environment) = ActivityUtility.getArgumentsFrom(call)
    val endpoint = ActivityUtility.getEndpointFrom(environment)
    val manager = DocumentscopyManager(this, ticket, appKey, endpoint, environment)

    documentscopyManager = manager
    activity.startActivityForResult(manager.getIntent(), DC_RESULT_REQUEST)
}
```