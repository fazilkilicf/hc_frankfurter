import 'package:flutter/material.dart';
import 'package:hc_frankfurter/constants/constants.dart';
import 'package:hc_frankfurter/controller/converter_home_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../constants/size_constants.dart';

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
                            'Currency Converter',
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
                                return const Text('Bir hata oluştu');
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildConvertedResult(converterController),
                                    verticalSpace16,
                                    buildConvertCurrencyField(
                                        converterController),
                                    verticalSpace8,
                                    buildConvertButton(converterController),
                                    verticalSpace12,
                                    Divider(
                                      color: Colors.green[300],
                                      thickness: 0.5,
                                    ),
                                    verticalSpace12,
                                    buildSelectedCurrency(converterController),
                                    verticalSpace24,
                                    Expanded(
                                        child: buildLastConversionList(
                                            converterController))
                                  ],
                                );
                              }
                            }),
                          )
                        ],
                      ),
                    )))));
  }

  Widget buildConvertButton(ConverterHomeController controller) {
    return SizedBox(
      width: screenWidth(context),
      height: 54.0,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0))),
          onPressed: () async {
            if (inputField.text.trim().isNotEmpty) {
              await controller.convertCurrency(
                  to: controller.toCurrency ?? '',
                  from: controller.fromCurrency ?? '',
                  amount: double.parse(inputField.text));
            }
          },
          child: Text(
            'Convert',
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
                color: Colors.green[700]),
          )),
    );
  }

  Widget buildConvertedResult(ConverterHomeController converterHomeController) {
    return GestureDetector(
      onTap: () async {
        await Hive.box(latestCurrencyConversionsKey).deleteFromDisk();
      },
      child: SizedBox(
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
      ),
    );
  }

  Widget buildConvertCurrencyField(ConverterHomeController controller) {
    return Container(
      width: screenWidth(context),
      height: screenHeight(context) * 0.1,
      color: const Color(0xFFF0FFFF),
      padding: defaultFieldPadding,
      child: Row(
        children: [
          buildFromCurrency(controller),
          horizontalSpace8,
          Expanded(
              child: TextField(
            controller: inputField,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'e.g 100',
                hintStyle: TextStyle(fontWeight: FontWeight.w400)),
          )),
          horizontalSpace8,
          buildToCurrency(controller)
        ],
      ),
    );
  }

  Widget buildFromCurrency(ConverterHomeController controller) {
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
  }

  Widget buildToCurrency(ConverterHomeController controller) {
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
  }

  Widget buildLastConversionList(
      ConverterHomeController converterHomeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Last Conversions',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.0),
        ),
        verticalSpace12,
        Expanded(
          child: converterHomeController.latestConversions.isEmpty
              ? const Text(
                  "It looks like you haven't converted any currency yet.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final conversion = converterHomeController.latestConversions
                        .elementAt(index);
                    debugPrint(conversion.toJson().toString());
                    return ListTile(
                      leading: Text(
                        conversion.rate?.currency ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                            fontSize: 18.0),
                      ),
                      title: Text(
                        "${conversion.amount ?? 0.0} ${conversion.base ?? ''} to ${conversion.rate?.currency ?? ''} = ${(conversion.rate?.result ?? 0.0).toStringAsFixed(3)}",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.green[800],
                            fontSize: 16.0),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: converterHomeController.latestConversions.length),
        ),
      ],
    );
  }

  Widget buildSelectedCurrency(ConverterHomeController controller) {
    return SizedBox(
      width: screenWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Currency",
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
  }
}
