import 'package:flutter/material.dart';
import 'package:hc_frankfurter/app.dart';
import 'package:hc_frankfurter/controller/converter_home_controller.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init shared prefs

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ConverterHomeController(),
      )
    ],
    child: const App(),
  ));
}
