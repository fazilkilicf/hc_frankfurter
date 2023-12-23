import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hc_frankfurter/screens/converter_home_screen/converter_home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/constants.dart';
import '../../constants/size_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initCheckNetwork();
  }

  initCheckNetwork() async {
    if (await _checkNetwork()) {
      Timer(const Duration(milliseconds: 700), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const ConverterHomeScreen()));
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.checkConnection)));
      }
    }
  }

  Future<bool> _checkNetwork() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      debugPrint('connection: ${connectivityResult.name.toString()}');
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: screenWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.payment,
              color: Colors.green,
              size: 64.0,
            ),
            Text(
              appName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.green[700]),
            )
          ],
        ),
      ),
    ));
  }
}
