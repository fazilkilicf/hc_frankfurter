import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/size_constants.dart';
import '../../../controller/converter_home_controller.dart';

class CurrencySelectButton extends StatelessWidget {
  const CurrencySelectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConverterHomeController>(builder: (context, controller, _) {
      return SizedBox(
        width: screenWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.currency,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Colors.green[700]),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12.0)),
              child: DropdownButton<String>(
                menuMaxHeight: screenHeight(context) * 0.5,
                value: controller.currentDropdownCurrency,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: const SizedBox(),
                onChanged: (String? value) {
                  controller.selectCurrency(value!);
                },
                items: controller.currencyList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green[800],
                          fontSize: 16.0),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
