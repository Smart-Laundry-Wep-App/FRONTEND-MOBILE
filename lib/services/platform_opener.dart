import 'platform_opener_stub.dart'
    if (dart.library.html) 'platform_opener_web.dart'
    if (dart.library.io) 'platform_opener_io.dart';

class PlatformOpener {
  static Future<bool> openUrl(String url) async {
    if (url.isEmpty) return false;
    return openExternalUrl(url);
  }
}
