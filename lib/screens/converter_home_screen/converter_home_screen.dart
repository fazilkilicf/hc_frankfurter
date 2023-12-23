import 'package:flutter/material.dart';
import 'package:hc_frankfurter/controller/converter_home_controller.dart';
import 'package:hc_frankfurter/screens/converter_home_screen/widgets/convert_button.dart';
import 'package:hc_frankfurter/screens/converter_home_screen/widgets/currency_select_button.dart';
import 'package:hc_frankfurter/screens/converter_home_screen/widgets/currency_value_field.dart';
import 'package:hc_frankfurter/screens/converter_home_screen/widgets/latest_conversion_list.dart';
import 'package:provider/provider.dart';
import '../../constants/size_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'widgets/conversion_result.dart';

class ConverterHomeScreen extends StatefulWidget {
  const ConverterHomeScreen({super.key});

  @override
  State<ConverterHomeScreen> createState() => _ConverterHomeScreenState();
}

class _ConverterHomeScreenState extends State<ConverterHomeScreen> {
  final inputField = TextEditingController();

  @override
  void dispose() {
    inputField.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final converterProvider =
          Provider.of<ConverterHomeController>(context, listen: false);
      converterProvider.initConverterHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: SizedBox(
                    width: screenWidth(context),
                    height: screenHeight(context),
                    child: Padding(
                      padding: defaultScaffoldPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.green[700]),
                          ),
                          verticalSpace24,
                          Expanded(
                            child: Consumer<ConverterHomeController>(
                                builder: (context, converterController, _) {
                              if (converterController.isLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (converterController
                                  .currencyList.isEmpty) {
                                return Text(
                                    AppLocalizations.of(context)!.hasError);
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const ConversionResult(),
                                    verticalSpace16,
                                    CurrencyValueField(
                                      inputController: inputField,
                                    ),
                                    verticalSpace8,
                                    ConvertButton(onPressed: () async {
                                      if (inputField.text.trim().isNotEmpty) {
                                        await converterController
                                            .convertCurrency(
                                                to: converterController
                                                        .toCurrency ??
                                                    '',
                                                from: converterController
                                                        .fromCurrency ??
                                                    '',
                                                amount: double.parse(
                                                    inputField.text));
                                      }
                                    }),
                                    verticalSpace12,
                                    Divider(
                                      color: Colors.green[300],
                                      thickness: 0.5,
                                    ),
                                    verticalSpace12,
                                    const CurrencySelectButton(),
                                    verticalSpace24,
                                    const Expanded(
                                        child: LatestConversionList())
                                  ],
                                );
                              }
                            }),
                          )
                        ],
                      ),
                    )))));
  }
}
