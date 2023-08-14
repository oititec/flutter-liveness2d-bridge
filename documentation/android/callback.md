# Como Enviar para o Flutter os Responses/Callback no Android

## Passo 1: Implementar o método `onActivityResult()`

No arquivo `MainActivity.kt`, implemente a função `onActivityResult()` do FlutterActivity e configure a tratativa dos retornos.

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/MainActivity.kt).

```kotlin
private var faceCaptchaManager: Manageable? = null
private var documentscopyManager: Manageable? = null

override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)

    when (requestCode) {
        FC_RESULT_REQUEST -> {
            when (resultCode) {
                Activity.RESULT_OK -> faceCaptchaManager?.onResultSuccess(data, resultFlutter)
                Activity.RESULT_CANCELED -> faceCaptchaManager?.onResultCancelled(data, resultFlutter)
            }
        }

        DC_RESULT_REQUEST -> {
            when (resultCode) {
                Activity.RESULT_OK -> documentscopyManager?.onResultSuccess(data, resultFlutter)
                Activity.RESULT_CANCELED -> documentscopyManager?.onResultCancelled(data, resultFlutter)
            }
        }
    }
}
```

## Passo 2: Implementar os métodos de retorno no FaceCaptchaManager

Implemente os métodos `onResultSuccess()` e `onResultCancelled` na classe FaceCaptchaManager.

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/utils/FaceCaptchaManager.kt).

```kotlin
override fun onResultSuccess(data: Intent?, result: MethodChannel.Result?) {
    val codID = data?.getDoubleExtra(FaceCaptchaActivity.PARAM_RESULT_COD_ID, 0.0)
    val response = mapOf<String, Any?>(
        "valid" to data?.getBooleanExtra(FaceCaptchaActivity.PARAM_RESULT, false),
        "cause" to data?.getStringExtra(FaceCaptchaActivity.PARAM_RESULT_CAUSE),
        "cod_id" to codID.toString(),
        "uid_protocol" to data?.getStringExtra(FaceCaptchaActivity.PARAM_RESULT_PROTOCOL),
    )

    result?.success(response)
}

override fun onResultCancelled(data: Intent?, result: MethodChannel.Result?) {
    val rawErrorCode = data?.getSerializableExtra(FaceCaptchaActivity.PARAM_RESULT_ERROR_CODE) as? FaceCaptchaErrorCode
    val errorCode = rawErrorCode?.toString() ?: ""
    val errorMessage = data?.getStringExtra(FaceCaptchaActivity.PARAM_RESULT_ERROR)

    result?.error(errorCode, errorMessage, null)
}
```

## Passo 3: Implementar os métodos de retorno no DocumentscopyManager

Implemente os métodos `onResultSuccess()` e `onResultCancelled` na classe DocumentscopyManager.

- [Acessar arquivo de exemplo](../../android/app/src/main/kotlin/br/com/oiti/flutter/liveness2d/bridge/utils/DocumentscopyManager.kt).

```kotlin
override fun onResultSuccess(data: Intent?, result: MethodChannel.Result?) {
    result?.success(null)
}

override fun onResultCancelled(data: Intent?, result: MethodChannel.Result?) {
    val rawErrorCode = data?.getSerializableExtra(DocumentscopyActivity.PARAM_RESULT_ERROR_CODE) as? DocumentscopyErrorCode
    val errorCode = rawErrorCode?.toString() ?: ""
    val errorMessage = data?.getStringExtra(DocumentscopyActivity.PARAM_RESULT_ERROR)

    result?.error(errorCode, errorMessage, null)
}
```