import 'package:oiti_liveness2d_bridge/bridge/platform_interface.dart';

class OitiLiveness2D {
  static Future startFaceCaptcha(String appKey, bool isProd) async {
    return await OitiLiveness2DPlatform.instance.startFaceCaptcha(
      appKey,
      isProd,
    );
  }

  static Future startDocumentscopy(String appKey, bool isProd) async {
    return await OitiLiveness2DPlatform.instance.startDocumentscopy(
      appKey,
      isProd,
    );
  }
}
