import 'package:flutter/material.dart';
import 'package:hc_frankfurter/app.dart';

import 'services/storage_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init shared prefs
  initSharedPrefs();
  runApp(const App());
}
