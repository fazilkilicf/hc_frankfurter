import 'package:flutter/material.dart';
import 'package:hc_frankfurter/controller/converter_home_controller.dart';
import 'package:provider/provider.dart';

import '../../../constants/size_constants.dart';

class ConversionResult extends StatelessWidget {
  const ConversionResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConverterHomeController>(
        builder: (context, converterHomeController, _) {
      return SizedBox(
        width: screenWidth(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(converterHomeController.toCurrency ?? '',
                style: const TextStyle(
                    fontSize: 12.0, fontWeight: FontWeight.bold)),
            Text(
                (converterHomeController.resultConversion ?? 0.0)
                    .toStringAsFixed(3)
                    .toString(),
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.w400))
          ],
        ),
      );
    });
  }
}
