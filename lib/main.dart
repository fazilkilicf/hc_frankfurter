import 'package:flutter/material.dart';
import 'package:hc_frankfurter/app.dart';
import 'package:hc_frankfurter/controller/converter_home_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init hive storage
  await Hive.initFlutter();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ConverterHomeController(),
      )
    ],
    child: const App(),
  ));
}
