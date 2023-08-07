import 'package:oiti_liveness2d_bridge/bridge/facecaptcha_validate_model.dart';
import 'package:oiti_liveness2d_bridge/bridge/platform_interface.dart';

class OitiLiveness2D {
  static Future startFaceCaptcha({
    required String appKey,
    required bool isProd,
  }) async {
    final result = await OitiLiveness2DPlatform.instance.startFaceCaptcha(
      appKey,
      isProd,
    );
    return FaceCaptchaValidateModel(
      valid: result['valid'] ?? false,
      cause: result['cause'] ?? '',
      codId: result['cod_id'] ?? '',
      uidProtocol: result['uid_protocol'] ?? '',
    );
  }

  static Future startDocumentscopy({
    String? ticket,
    required String appKey,
    required bool isProd,
  }) async {
    return await OitiLiveness2DPlatform.instance.startDocumentscopy(
      ticket,
      appKey,
      isProd,
    );
  }
}
