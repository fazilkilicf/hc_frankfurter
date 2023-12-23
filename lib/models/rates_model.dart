import 'package:flutter/material.dart';

class RatesModel {
  double? amount;
  String? base;
  String? date;
  Rate? rate;

  RatesModel({this.amount, this.base, this.date, this.rate});

  RatesModel.fromJson(Map<String, dynamic> json) {
    if (json["amount"] is double) {
      amount = json["amount"];
      debugPrint('@ratesmodel amount: $amount');
    }

    if (json["base"] is String) {
      base = json["base"];
    }
    if (json["date"] is String) {
      date = json["date"];
    }
    if (json["rates"] is Map<String, dynamic>) {
      rate = json["rates"] == null ? null : Rate.fromJson(json["rates"]);
    }
  }

  RatesModel.customFromJson(Map<dynamic, dynamic> json) {
    if (json["amount"] is double) {
      amount = json["amount"];
    }

    if (json["base"] is String) {
      base = json["base"];
    }
    if (json["date"] is String) {
      date = json["date"];
    }
    rate = Rate(currency: json["currency"], result: json['result']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["base"] = base;
    data["amount"] = amount;
    data["date"] = date;
    data["result"] = rate?.result;
    data["currency"] = rate?.currency;

    return data;
  }
}

class Rate {
  String? currency;
  double? result;

  Rate({this.currency, this.result});

  Rate.fromJson(Map<String, dynamic> json) {
    currency = json.keys.first;
    debugPrint('currency: ${currency.toString()}');
    if (json.values.first is double) {
      result = json.values.first;
    }
    debugPrint('result: ${result.toString()}');
  }
}
