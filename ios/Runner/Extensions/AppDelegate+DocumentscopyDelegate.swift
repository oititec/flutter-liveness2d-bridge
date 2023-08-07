//
//  AppDelegate+DocumentscopyDelegate.swift
//  Runner
//
//  Created by Vitor Souza on 07/08/23.
//

import FaceCaptcha

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
