import UIKit
import Flutter
import FaceCaptcha

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var flutterResult: FlutterResult? = nil
    
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
    
    // MARK: - Method Channel Handlers
    
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
}
