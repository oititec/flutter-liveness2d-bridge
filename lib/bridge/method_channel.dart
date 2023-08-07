import 'package:flutter/services.dart';
import 'package:oiti_liveness2d_bridge/bridge/platform_interface.dart';

class MethodChannelLiveness2D extends OitiLiveness2DPlatform {
  final methodChannel = const MethodChannel('oiti_liveness2d_bridge');

  @override
  Future startFaceCaptcha(String appKey, bool isProd) async {
    return await methodChannel.invokeMapMethod(
      'OITI.startFaceCaptcha',
      {
        'appkey': appKey,
        'isProd': isProd,
      },
    );
  }

  @override
  Future startDocumentscopy(String? ticket, String appKey, bool isProd) async {
    return await methodChannel.invokeMapMethod(
      'OITI.startDocumentscopy',
      {
        'ticket': ticket,
        'appkey': appKey,
        'isProd': isProd,
      },
    );
  }
}