import 'package:flutter/material.dart';
import 'package:hc_frankfurter/controller/converter_home_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/size_constants.dart';

class CurrencyValueField extends StatelessWidget {
  final TextEditingController inputController;
  const CurrencyValueField({super.key, required this.inputController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: screenHeight(context) * 0.1,
      color: const Color(0xFFF0FFFF),
      padding: defaultFieldPadding,
      child: Row(
        children: [
          buildFromCurrency(context),
          horizontalSpace8,
          Expanded(
              child: TextField(
            controller: inputController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '${AppLocalizations.of(context)!.example} 100',
                hintStyle: const TextStyle(fontWeight: FontWeight.w400)),
          )),
          horizontalSpace8,
          buildToCurrency(context)
        ],
      ),
    );
  }

  Widget buildFromCurrency(BuildContext context) {
    return Consumer<ConverterHomeController>(builder: (context, controller, _) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 2.0,
            color: Colors.green.shade200,
          ), /* borderRadius: BorderRadius.circular(12.0) */
        ),
        child: DropdownButton<String>(
          value: controller.fromCurrency,
          menuMaxHeight: screenHeight(context) * 0.5,
          borderRadius: BorderRadius.circular(20),
          icon: const SizedBox(),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: const SizedBox(),
          onChanged: (String? value) {
            controller.selectFromCurrency(value!);
          },
          items: controller.currencyList
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                    fontSize: 16.0),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget buildToCurrency(BuildContext context) {
    return Consumer<ConverterHomeController>(builder: (context, controller, _) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 2.0,
            color: Colors.green.shade200,
          ), /* borderRadius: BorderRadius.circular(12.0) */
        ),
        child: DropdownButton<String>(
          value: controller.toCurrency,
          menuMaxHeight: screenHeight(context) * 0.5,
          borderRadius: BorderRadius.circular(20),
          icon: const SizedBox(),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: const SizedBox(),
          onChanged: (String? value) {
            controller.selectToCurrency(value!);
          },
          items: controller.currencyList
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                    fontSize: 16.0),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
