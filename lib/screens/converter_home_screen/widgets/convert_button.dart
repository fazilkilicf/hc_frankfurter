import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/size_constants.dart';

class ConvertButton extends StatelessWidget {
  final Function onPressed;
  const ConvertButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth(context),
      height: 54.0,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0))),
          onPressed: () async => onPressed(),
          child: Text(
            AppLocalizations.of(context)!.convert,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                color: Colors.green[700]),
          )),
    );
  }
}
