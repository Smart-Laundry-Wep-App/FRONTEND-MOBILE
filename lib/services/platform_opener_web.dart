// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

Future<bool> openExternalUrl(String url) async {
  try {
    html.window.open(url, '_blank');
    return true;
  } catch (_) {
    return false;
  }
}
