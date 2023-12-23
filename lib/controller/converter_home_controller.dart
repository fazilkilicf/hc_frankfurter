import 'package:flutter/material.dart';
import 'package:hc_frankfurter/constants/constants.dart';
import 'package:hc_frankfurter/models/rates_model.dart';
import 'package:hc_frankfurter/services/frankfurter_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConverterHomeController extends ChangeNotifier {
  final FrankfurterService _frankfurterService = FrankfurterService();
  /* var currentCurrencyBox = Hive.box(currentCurrencyPreferenceKey);
  var latestConversionsBox = Hive.box(latestCurrencyConversionsKey); */

  /// list of all currencies
  List<String> currencyList = [];

  /// for last conversions
  late String? currentDropdownCurrency;
  List<RatesModel> latestConversions = [];

  /// for currency conversion
  late String? fromCurrency;
  late String? toCurrency;
  late double? resultConversion = 0.0;

  bool isLoading = false;

  Future<void> initConverterHome() async {
    currencyList.clear();
    currentDropdownCurrency = null;
    fromCurrency = null;
    toCurrency = null;
    isLoading = true;
    notifyListeners();
    await getSelectedCurrencyFromLocal();
    await getCurrencyList();
    await getLatestConversionsFromHive();
    isLoading = false;
    notifyListeners();
  }

  getSelectedCurrencyFromLocal() async {
    var currentCurrencyBox = await Hive.openBox(currentCurrencyPreferenceKey);

    currentDropdownCurrency = await currentCurrencyBox
        .get(currentCurrencyPreferenceKey, defaultValue: "TRY");
    notifyListeners();
    debugPrint(
        'currentCurrencyPreferenceKey: ${currentCurrencyPreferenceKey.toString()}');
    debugPrint(
        'currentDropdownCurrency: ${currentDropdownCurrency.toString()}');
  }

  Future<void> setSelectedCurrencyToHive(String currency) async {
    var currentCurrencyBox = await Hive.openBox(currentCurrencyPreferenceKey);
    await currentCurrencyBox.put(currentCurrencyPreferenceKey, currency);
    debugPrint(
        'currentCurrencyBox: ${currentCurrencyBox.get(currentCurrencyPreferenceKey).toString()}');
    await getLatestConversionsFromHive();
  }

  Future<void> getCurrencyList() async {
    var shortFormatCurrencies = await _frankfurterService.getCurrencies();
    if (shortFormatCurrencies.isNotEmpty) {
      currencyList.addAll(shortFormatCurrencies);
      fromCurrency = currencyList.elementAt(0);
      toCurrency = currencyList.elementAt(1);
      notifyListeners();
    }
  }

  Future<void> addCurrencyConversionToHive(
      Map<String, dynamic> conversion) async {
    var latestConversionsBox = await Hive.openBox(latestCurrencyConversionsKey);
    await latestConversionsBox.add(conversion);
    debugPrint('amount data is: ${latestConversionsBox.length}');
    await getLatestConversionsFromHive();
  }

  Future<void> getLatestConversionsFromHive() async {
    var latestConversionsBox = await Hive.openBox(latestCurrencyConversionsKey);
    // modified...
    final data = latestConversionsBox.keys.map((key) {
      final conversion = latestConversionsBox.get(key);
      return RatesModel.customFromJson(conversion);
    }).toList();
    latestConversions.clear();
    notifyListeners();

    // filter
    for (var conversion in data) {
      if (conversion.rate?.currency == currentDropdownCurrency) {
        latestConversions.add(conversion);
      }
    }
    latestConversions = latestConversions.reversed.toList();
    notifyListeners();
    debugPrint('latestConversions length: ${data.length}');
  }

  Future<void> convertCurrency(
      {required String to,
      required String from,
      required double amount}) async {
    var result = await _frankfurterService.convertCurrency(
        from: from, to: to, amount: amount);
    if (result != null) {
      resultConversion = result.rate?.result ?? 0.0;
      notifyListeners();
      debugPrint("result.rate?.result: ${result.rate?.result.toString()}");
      addCurrencyConversionToHive(result.toJson());
    }
  }

  /// for last conversions
  void selectCurrency(String currency) {
    currentDropdownCurrency = currency;
    notifyListeners();
    setSelectedCurrencyToHive(currency);
  }

  /// for currency conversion
  void selectFromCurrency(String currency) {
    fromCurrency = currency;
    notifyListeners();
  }

  void selectToCurrency(String currency) {
    toCurrency = currency;
    resultConversion = 0.0;
    notifyListeners();
  }
}
