# Configuração do FlutterEngine e MethodChannel no iOS

## Passo 1: Importar os módulos

- [Acessar arquivo de exemplo](../../ios/Runner/AppDelegate.swift).

```swift
import UIKit
import Flutter
import FaceCaptcha
```

## Passo 2: Implementar o FlutterResult

Adicione logo no inicio da classe AppDelegate o FlutterResult para controle de retornos:

```swift
var flutterResult: FlutterResult? = nil
```

## Passo 3: Configurar o FlutterMethodChannel

No arquivo `AppDelegate.swift` na pasta `ios/Renner` e faça a configuração FlutterMethodChannel dentro do método `application(_:didFinishLaunchingWithOptions:)`:

- [Acessar arquivo de exemplo](../../ios/Runner/AppDelegate.swift).

```swift
override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    if let flutterRootController = (window?.rootViewController as? FlutterViewController) {
        let methodChannel = FlutterMethodChannel(
            name: "oiti_liveness2d_bridge",
            binaryMessenger: flutterRootController.binaryMessenger
        )
        
        methodChannel.setMethodCallHandler { [weak self] (call, result) in
            self?.flutterResult = result
            
            switch call.method {
            case "OITI.startFaceCaptcha":
                self?.startFaceCaptcha(arguments: call.arguments)
            case "OITI.startDocumentscopy":
                self?.startDocumentscopy(arguments: call.arguments)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

## Passo 4: Implementar os métodos para uso do Liveness 2D e Doc Core

Crie dentro da classe AppDelegate os dois métodos citados na configuração do FlutterMethodChannel no **passo 3** para uso do Liveness 2D e Doc Core.

- [Acessar arquivo de exemplo](../../ios/Runner/AppDelegate.swift).

```swift
private func startFaceCaptcha(arguments rawArguments: Any?) {
    let (_, appKey, environment) = getArguments(from: rawArguments)
    
    let controller = FaceCaptchaViewController(
        appKey: appKey,
        environment: environment,
        delegate: self
    )
    
    controller.modalPresentationStyle = .fullScreen
    present(controller, animated: true)
}

private func startDocumentscopy(arguments rawArguments: Any?) {
    let (ticket, appKey, environment) = getArguments(from: rawArguments)
    
    let controller = DocumentscopyViewController(
        ticket: ticket,
        appKey: appKey,
        environment: environment,
        delegate: self
    )
    
    controller.modalPresentationStyle = .fullScreen
    present(controller, animated: true)
}
```

## Passo 5: Implementar os métodos auxiliares

Implemente os métodos auxiliares que serão utilizados nos processo de apresentação dos fluxos e tratativa dos retornos.
A implementação desses métodos podem ser feitos através de uma `extension` da classe AppDelegate.

- [Acessar arquivo de exemplo](../../ios/Runner/Extensions/AppDelegate+Utils.swift).

```swift
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
```
