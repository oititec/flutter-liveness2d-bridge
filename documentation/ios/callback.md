# Configuração dos Retornos do SDK

## Importação do módulo

Para ter acessos aos protocolos responsáveis pela tratativa dos retornos do SDK é necessário primeiro fazer a importação do módulo **FaceCaptcha**.

```swift
import FaceCaptcha
```

## Implementação do `FaceCaptchaDelegate`

Crie uma `extension` do **AppDelegate** para colocá-lo em conformidade com o protocolo `FaceCaptchaDelegate`, responsável por tratar os retornos do Liveness 2D.

- [Acessar arquivo de exemplo](../../ios/Runner/Extensions/AppDelegate+FaceCaptchaDelegate.swift).

```swift
extension AppDelegate: FaceCaptchaDelegate {
    
    func handleFaceCaptchaValidation(validateModel: FaceCaptcha.FCValidCaptchaModel) {
        dismiss(animated: true) { [weak self] in
            let faceCaptchaResponse: Dictionary<String, Any> = [
                "valid": validateModel.valid ?? false,
                "cause": validateModel.cause ?? "",
                "cod_id": String(validateModel.codID ?? 0.0),
                "uid_protocol": validateModel.uidProtocol ?? ""
            ]
            self?.flutterResult?(faceCaptchaResponse)
        }
    }
    
    func handleFaceCaptchaError(error: FaceCaptcha.FaceCaptchaError) {
        let (errorCode, errorMessage) = errorDetail(from: error)
        dismiss(animated: true) { [weak self] in
            self?.finishWithError(
                code: errorCode,
                message: errorMessage
            )
        }
    }
    
    func handleFaceCaptchaCanceled() {
        dismiss(animated: true) { [weak self] in
            self?.finishWithError(code: "FACECAPTCHA_CANCELED", message: nil)
        }
    }
    
    private func errorDetail(from error: FaceCaptchaError) -> (String, String?) {
        switch error {
        case .invalidAppKey: return ("INVALID_APPKEY", "App Key inválido")
        case .certifaceOff: return ("CERTIFACE_OFF", "Certiface offline")
        case .noCameraPermission: return ("NO_CAMERA_PERMISSION", "Não foi concedida permissão de acesso à câmera do aparelho")
        case .noInternetConnection: return ("NO_INTERNET_CONNECTION", "Sem conexão à Internet")
        case .phoneCallInProgress: return ("PHONE_CALL_IN_PROGRESS", "Chamada telefônica em andamento. Não é possível iniciar o desafio durante uma chamada telefônica")
        case .validationError: return ("VALIDATION_ERROR", "Erro na requisição de validação dos desafios")
        case .challengeInterrupted: return ("CHALLENGE_INTERRUPTED", "App foi minimizado durante o uso do FaceCaptcha, isso faz com que o desafio seja encerrado")
        case .requestError: return ("REQUEST_ERROR", "Erro inesperado em algum request")
        case .errorCameraSetup: return ("ERROR_CAMERA_SETUP", "Falha em configurar câmera")
        case .errorCapturePicture: return ("ERROR_CAPTURE_PICTURE", "Erro ao capturar foto")
        @unknown default: return ("UNKNOWN_ERROR", nil)
        }
    }
}
```

## Implementação do `DocumentscopyDelegate`

Crie uma `extension` do **AppDelegate** para colocá-lo em conformidade com o protocolo `DocumentscopyDelegate`, responsável por tratar os retornos do Doc Core.

- [Acessar arquivo de exemplo](../../ios/Runner/Extensions/AppDelegate+DocumentscopyDelegate.swift).

```swift
extension AppDelegate: DocumentscopyDelegate {
    
    func handleDocumentscopyCompleted() {
        flutterResult?(nil)
    }
    
    func handleDocumentscopyError(error: FaceCaptcha.DocumentscopyError) {
        let (errorCode, errorMessage) = errorDetail(from: error)
        finishWithError(
            code: errorCode,
            message: errorMessage
        )
    }
    
    func handleDocumentscopyCanceled() {
        finishWithError(code: "DOCUMENTSCOPY_CANCELED", message: nil)
    }

    private func errorDetail(from error: DocumentscopyError) -> (String, String?) {
        switch error {
        case .invalidAppKey: return ("INVALID_APPKEY", "App Key inválido")
        case .certifaceOff: return ("CERTIFACE_OFF", "Certiface offline")
        case .cameraSetupFailed: return ("CAMERA_SETUP_FAILED", "Problema ao configurar a câmera")
        case .noCameraPermission: return ("NO_CAMERA_PERMISSION", "Não foi concedida permissão de acesso à câmera do aparelho")
        case .errorCapturePicture: return ("ERROR_CAPTURE_PICTURE", "Erro ao capturar foto")
        case .noInternetConnection: return ("NO_INTERNET_CONNECTION", "Sem conexão à Internet")
        case .validationError: return ("VALIDATION_ERROR", "Erro na requisição de validação dos desafios")
        case .faceCaptchaNotExecuted: return ("FACECAPTCHA_NOT_EXECUTED", "FaceCaptcha não foi realizada")
        @unknown default: return ("UNKNOWN_ERROR", nil)
        }
    }
}
```
