import 'dart:io';

Future<bool> openExternalUrl(String url) async {
  try {
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', url]);
      return true;
    } else if (Platform.isMacOS) {
      await Process.run('open', [url]);
      return true;
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', [url]);
      return true;
    }
  } catch (_) {}
  return false;
}
