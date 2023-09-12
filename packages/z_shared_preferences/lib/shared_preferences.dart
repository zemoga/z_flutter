// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

export 'package:shared_preferences/shared_preferences.dart';

extension RxSharedPreferences on SharedPreferences {
  bool getAndEmitBool(
    StreamController<bool> controller,
    String key, {
    required bool dfltValue,
  }) {
    final value = getBool(key) ?? dfltValue;
    controller.add(value);
    return value;
  }

  int getAndEmitInt(
    StreamController<int> controller,
    String key, {
    required int dfltValue,
  }) {
    final value = getInt(key) ?? dfltValue;
    controller.add(value);
    return value;
  }

  double getAndEmitDouble(
    StreamController<double> controller,
    String key, {
    required double dfltValue,
  }) {
    final value = getDouble(key) ?? dfltValue;
    controller.add(value);
    return value;
  }

  String getAndEmitString(
    StreamController<String> controller,
    String key, {
    required String dfltValue,
  }) {
    final value = getString(key) ?? dfltValue;
    controller.add(value);
    return value;
  }

  Future<bool> setAndEmitBool(
    StreamController<bool> controller,
    String key,
    bool value,
  ) async {
    final success = await setBool(key, value);
    if (success) {
      controller.add(value);
    }
    return success;
  }

  Future<bool> setAndEmitInt(
    StreamController<int> controller,
    String key,
    int value,
  ) async {
    final success = await setInt(key, value);
    if (success) {
      controller.add(value);
    }
    return success;
  }

  Future<bool> setAndEmitDouble(
    StreamController<double> controller,
    String key,
    double value,
  ) async {
    final success = await setDouble(key, value);
    if (success) {
      controller.add(value);
    }
    return success;
  }

  Future<bool> setAndEmitString(
    StreamController<String> controller,
    String key,
    String value,
  ) async {
    final success = await setString(key, value);
    if (success) {
      controller.add(value);
    }
    return success;
  }
}
