import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:session_next/session_next.dart';

var session = SessionNext();
Future<bool> getCurrentTheme(bool darkMode) async {
  dynamic savedThemeMode = await AdaptiveTheme.getThemeMode();
  if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
    print('mode sombre');
    darkMode = true;
    // session.get("darkmode");
    // session.set("darkmode", darkmode);
  } else {
    // session.get("darkmode");
    // session.set("darkmode", darkmode);
    darkMode = false;
    print('mode clair');
  }
  return darkMode;
}
