//
//  AppDelegate+FaceCaptchaDelegate.swift
//  Runner
//
//  Created by Vitor Souza on 07/08/23.
//

import FaceCaptcha

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
