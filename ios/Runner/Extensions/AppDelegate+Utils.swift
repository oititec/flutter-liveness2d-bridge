//
//  AppDelegate+Utils.swift
//  Runner
//
//  Created by Vitor Souza on 07/08/23.
//

import UIKit
import Flutter
import FaceCaptcha

extension AppDelegate {
    
    func getArguments(from rawArguments: Any?) -> (String?, String, Environment) {
        let arguments = rawArguments as? Dictionary<String, Any>
        let ticket = arguments?["ticket"] as? String
        let appKey = arguments?["appkey"] as? String ?? ""
        let isProd = arguments?["isProd"] as? Bool ?? false
        
        return (ticket, appKey, isProd ? .PRD : .HML)
    }
    
    func finishWithError(code: String, message: String?) {
        let flutterError = FlutterError(
            code: code,
            message: message,
            details: nil
        )
        flutterResult?(flutterError)
    }
    
    // MARK: - UIViewController Methods
    
    func present(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: animated, completion: completion)
    }
    
    func dismiss(
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: animated, completion: completion)
    }
}
