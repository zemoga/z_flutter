import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:z_flutter_bloc/flutter_bloc.dart';

void main() {
  group('map:', () {
    test('isLoading => keepsLoading', () async {
      const input = AsyncValue.loading();
      final output = input.map((t) => t.hashCode);

      expect(output.isLoading, isTrue);
    });
    test('isData => transformsData', () async {
      const input = AsyncData('A');
      final output = input.map((t) => t.hashCode);

      expect(output.isData, isTrue);
      expect(output.getOrNull(), isNotNull);
      expect(output.getOrNull(), input.value.hashCode);
    });
    test('isError => keepsError', () async {
      final input = AsyncError(const FormatException(), StackTrace.current);
      final output = input.map((t) => t.hashCode);

      expect(output.isError, isTrue);
      expect(output.isErrorOfType<FormatException>(), isTrue);
    });
  });

  group('when:', () {
    test('isLoading => invokesLoadingCallback', () {
      const input = AsyncValue.loading();
      final completer = Completer();
      input.when(isLoading: completer.complete);

      expect(completer.isCompleted, isTrue);
    });
    test('isData => invokesDataCallback', () {
      const input = AsyncData(10);
      final completer = Completer<int>();
      input.when(isData: completer.complete);

      expect(completer.isCompleted, isTrue);
      expect(completer.future, completion(input.value));
    });
    test('isError => invokesErrorCallback', () {
      final input = AsyncError(const FormatException(), StackTrace.current);
      final completer = Completer();
      input.when(isError: completer.completeError);

      expect(completer.isCompleted, isTrue);
      expect(completer.future, throwsA(isA<FormatException>()));
    });
  });

  group('getOrNull:', () {
    test('isLoading  => returnsNull', () {
      const input = AsyncValue.loading();
      final output = input.getOrNull();

      expect(output, isNull);
    });
    test('isData  => returnsData', () {
      const input = AsyncData(10);
      final output = input.getOrNull();

      expect(output, isNotNull);
      expect(output, input.value);
    });
    test('isError  => returnsNull', () {
      final input = AsyncError(const FormatException(), StackTrace.current);
      final output = input.getOrNull();

      expect(output, isNull);
    });
  });

  group('getOrElse:', () {
    test('isLoading  => returnsFallbackData', () {
      const fallbackData = 5;
      const input = AsyncValue.loading();
      final output = input | fallbackData;

      expect(output, isNotNull);
      expect(output, fallbackData);
    });
    test('isData  => returnsData', () {
      const fallbackData = 5;
      const input = AsyncData(10);
      final output = input | fallbackData;

      expect(output, isNotNull);
      expect(output, input.value);
    });
    test('isError  => returnsFallbackData', () {
      const fallbackData = 5;
      final input = AsyncError(const FormatException(), StackTrace.current);
      final output = input | fallbackData;

      expect(output, isNotNull);
      expect(output, fallbackData);
    });
  });
}
