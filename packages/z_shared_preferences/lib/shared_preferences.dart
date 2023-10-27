// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

export 'package:shared_preferences/shared_preferences.dart';

extension ExtSharedPreferences on SharedPreferences {
  T? getStructureData<T>(
    String key,
    T? Function(String? value) parser,
  ) {
    return parser(getString(key));
  }

  Future<bool> setStructuredData<T>(
    String key,
    T value,
    String Function(T value) parser,
  ) {
    return setString(key, parser(value));
  }
}

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

  T getAndEmitStructuredData<T>(
    StreamController<T> controller,
    String key, {
    required T dfltValue,
    required T? Function(String? value) parser,
  }) {
    final value = getStructureData(key, parser) ?? dfltValue;
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

  Future<bool> setAndEmitStructuredData<T>(
    StreamController<T> controller,
    String key,
    T value,
    String Function(T value) parser,
  ) async {
    final success = await setStructuredData(key, value, parser);
    if (success) {
      controller.add(value);
    }
    return success;
  }
}
