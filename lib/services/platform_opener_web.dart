import 'dart:html' as html;

Future<bool> openExternalUrl(String url) async {
  try {
    html.window.open(url, '_blank');
    return true;
  } catch (_) {
    return false;
  }
}
