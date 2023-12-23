import 'package:flutter/material.dart';
import 'package:hc_frankfurter/constants/constants.dart';
import 'package:hc_frankfurter/services/frankfurter_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConverterHomeController extends ChangeNotifier {
  final FrankfurterService _frankfurterService = FrankfurterService();

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentDropdownCurrency =
        prefs.getString(currentCurrencyPreferenceKey) ?? 'TRY';
    debugPrint(
        'currentCurrencyPreferenceKey: ${currentCurrencyPreferenceKey.toString()}');
    debugPrint(
        'currentDropdownCurrency: ${currentDropdownCurrency.toString()}');
  }

  Future<void> getCurrencyList() async {
    var shortFormatCurrencies = await _frankfurterService.getCurrencies();
    if (shortFormatCurrencies.isNotEmpty) {
      currencyList.addAll(shortFormatCurrencies);
      fromCurrency = currencyList.elementAt(0);
      toCurrency = currencyList.elementAt(1);
      notifyListeners();
      debugPrint('currencyList.length: ${currencyList.length.toString()}');
      debugPrint('currencyList[0]: ${currencyList.first.toString()}');
    }
  }

  Future<void> convertCurrency(
      {required String to,
      required String from,
      required double amount}) async {
    debugPrint('@convertCurrency controller amount: ${amount.toString()}');
    var result = await _frankfurterService.convertCurrency(
        from: from, to: to, amount: amount);
    if (result != null) {
      debugPrint('result: ${result.rate?.result.toString()}');
      resultConversion = result.rate?.result ?? 0.0;
      notifyListeners();
    } else {
      debugPrint('convertCurrency() error');
    }
  }

  /// for last conversions
  void selectCurrency(String currency) {
    currentDropdownCurrency = currency;
    notifyListeners();
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
