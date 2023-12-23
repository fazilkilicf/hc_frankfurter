import 'package:flutter/material.dart';
import 'package:hc_frankfurter/constants/constants.dart';
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

  Future<void> setSelectedCurrencyToSharedPrefs(String currency) async {
    var currentCurrencyBox = await Hive.openBox(currentCurrencyPreferenceKey);
    await currentCurrencyBox.put(currentCurrencyPreferenceKey, currency);
    debugPrint(
        'currentCurrencyBox: ${currentCurrencyBox.get(currentCurrencyPreferenceKey).toString()}');
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

  Future<void> convertCurrency(
      {required String to,
      required String from,
      required double amount}) async {
    var result = await _frankfurterService.convertCurrency(
        from: from, to: to, amount: amount);
    if (result != null) {
      resultConversion = result.rate?.result ?? 0.0;
      notifyListeners();
    } else {}
  }

  /// for last conversions
  void selectCurrency(String currency) {
    currentDropdownCurrency = currency;
    notifyListeners();
    setSelectedCurrencyToSharedPrefs(currency);
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
