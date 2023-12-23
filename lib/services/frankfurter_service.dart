import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hc_frankfurter/models/rates_model.dart';

import '../constants/constants.dart';

class FrankfurterService {
  final Dio _dio = Dio();

  Future<List<String>> getCurrencies() async {
    List<String> shortFormatCurrencies = [];

    try {
      Response response = await _dio.get(apiBaseUrl + apiCurrenciesPath);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        shortFormatCurrencies = responseData.keys.toList();
        debugPrint(
            'shortFormatCurrencies length: ${shortFormatCurrencies.length}');
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
    return shortFormatCurrencies;
  }

  Future<RatesModel?> convertCurrency(
      {required String to,
      required String from,
      required double amount}) async {
    late RatesModel? rates;
    try {
      Response response = await _dio.get(
        apiBaseUrl + apiRatesPath,
        queryParameters: {"to": to, "from": from, "amount": amount},
      );
      debugPrint('response: ${response.data.toString()}');
      if (response.statusCode == 200) {
        rates = RatesModel.fromJson(response.data);
        debugPrint('_rates: ${rates.rate?.result.toString()}');
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
    return rates;
  }
}
