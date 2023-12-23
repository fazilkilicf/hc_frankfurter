import 'package:flutter/material.dart';
import 'package:hc_frankfurter/constants/constants.dart';
import 'package:hc_frankfurter/services/frankfurter_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConverterHomeController extends ChangeNotifier {
  final FrankfurterService _frankfurterService = FrankfurterService();
  List<String> shortCurrencyList = [];
  late String? currentDropdownCurrency;

  bool isLoading = false;

  Future<void> initConverterHome() async {
    shortCurrencyList.clear();
    currentDropdownCurrency = null;
    isLoading = true;
    notifyListeners();
    await getSelectedCurrencyFromLocal();
    await getShortedCurrenciesList();
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

  Future<void> getShortedCurrenciesList() async {
    var shortCurrencies = await _frankfurterService.getShortCurrencies();
    if (shortCurrencies.isNotEmpty) {
      shortCurrencyList.addAll(shortCurrencies);
      notifyListeners();
    }
    debugPrint(
        'shortCurrencyList.length: ${shortCurrencyList.length.toString()}');
    debugPrint('shortCurrencyList[0]: ${shortCurrencyList.first.toString()}');
  }

  void selectShortCurrency(String currency) {
    currentDropdownCurrency = currency;
    notifyListeners();
  }
}
