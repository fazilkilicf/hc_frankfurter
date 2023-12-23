import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class FrankfurterService {
  final Dio _dio = Dio();

  Future<List<String>> getShortCurrencies() async {
    List<String> shortCurrencies = [];

    try {
      Response response = await _dio.get(apiBaseUrl + apiCurrenciesPath);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        shortCurrencies = responseData.keys.toList();
        debugPrint('shortCurrencies length: ${shortCurrencies.length}');
      }
    } on DioException catch (e) {
      debugPrint(e.message);
      throw Exception(e.message);
    }
    return shortCurrencies;
  }
}
