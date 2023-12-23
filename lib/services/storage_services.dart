import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences? prefs;

Future<void> initSharedPrefs() async {
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    if (prefs != null) prefs?.clear();
  }
}
