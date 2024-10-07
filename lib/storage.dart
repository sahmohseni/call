import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataBase {
  static final ValueNotifier<String> incomingMobileNumberNotifier =
      ValueNotifier("");

  Future<void> savingIncominMobileNumber(String mobileNumber) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("incomingMobileNumber", mobileNumber);
    loadingIncomingMobileNumber();
  }

  Future<void> loadingIncomingMobileNumber() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String mobileNumber =
        sharedPreferences.getString("incomingMobileNumber") ?? "";
    incomingMobileNumberNotifier.value = mobileNumber;
  }
}
