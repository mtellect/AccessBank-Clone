part of 'RaveApi.dart';

class Verification {
  final String pubKey;
  final String secKey;
  final String encKey;
  final bool liveMode;
  final String requestUrl;

  Verification(
      {@required this.pubKey,
      @required this.secKey,
      @required this.encKey,
      @required this.liveMode,
      @required this.requestUrl});
}
