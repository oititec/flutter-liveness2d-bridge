class FaceCaptchaValidateModel {
  final bool valid;
  final String cause;
  final String codId;
  final String uidProtocol;

  FaceCaptchaValidateModel({
    required this.valid,
    required this.cause,
    required this.codId,
    required this.uidProtocol,
  });
}
