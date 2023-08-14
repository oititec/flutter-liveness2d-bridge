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
