part of '../flutter_bloc.dart';

sealed class AsyncValue<T> {
  const AsyncValue();

  const factory AsyncValue.loading() = AsyncLoading<T>;

  const factory AsyncValue.data(T t) = AsyncData<T>;

  const factory AsyncValue.error(Object error, StackTrace stackTrace) =
      AsyncError<T>;

  R fold<R>({
    required R Function() ifLoading,
    required R Function(T data) ifData,
    required R Function(Object error, StackTrace stackTrace) ifError,
  });

  bool get isLoading {
    return fold(
      ifLoading: () => true,
      ifData: (_) => false,
      ifError: (e, st) => false,
    );
  }

  bool get isData {
    return fold(
      ifLoading: () => false,
      ifData: (_) => true,
      ifError: (e, st) => false,
    );
  }

  bool get isError {
    return fold(
      ifLoading: () => false,
      ifData: (_) => false,
      ifError: (e, st) => true,
    );
  }

  bool isErrorOfType<E extends Exception>() {
    return fold(
      ifLoading: () => false,
      ifData: (_) => false,
      ifError: (e, st) => e is E,
    );
  }

  T? getOrNull() {
    return fold(
      ifLoading: () => null,
      ifData: (data) => data,
      ifError: (e, st) => null,
    );
  }

  T getOrElse(T Function() dflt) {
    return fold(
      ifLoading: dflt,
      ifData: (data) => data,
      ifError: (e, st) => dflt(),
    );
  }

  T operator |(T dflt) => getOrElse(() => dflt);

  AsyncValue<R> map<R>(R Function(T t) mapper) {
    return fold(
      ifLoading: AsyncValue.loading,
      ifData: (t) => AsyncValue.data(mapper(t)),
      ifError: AsyncValue.error,
    );
  }

  void when({
    void Function()? isLoading,
    void Function(T data)? isData,
    void Function(Object error, StackTrace stackTrace)? isError,
  }) {
    fold(
      ifLoading: isLoading ?? () {},
      ifData: isData ?? (d) {},
      ifError: isError ?? (e, st) {},
    );
  }

  @override
  String toString() {
    return fold(
      ifLoading: () => 'Loading',
      ifData: (data) => 'Data($data)',
      ifError: (e, st) => 'Error($e, $st)',
    );
  }
}

class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading();

  @override
  R fold<R>({
    required R Function() ifLoading,
    required R Function(T data) ifData,
    required R Function(Object error, StackTrace stackTrace) ifError,
  }) {
    return ifLoading();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncLoading && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AsyncData<T> extends AsyncValue<T> {
  const AsyncData(this.value);

  final T value;

  @override
  R fold<R>({
    required R Function() ifLoading,
    required R Function(T data) ifData,
    required R Function(Object error, StackTrace stackTrace) ifError,
  }) {
    return ifData(value);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncData &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class AsyncError<T> extends AsyncValue<T> {
  const AsyncError(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;

  @override
  R fold<R>({
    required R Function() ifLoading,
    required R Function(T data) ifData,
    required R Function(Object error, StackTrace stackTrace) ifError,
  }) {
    return ifError(error, stackTrace);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsyncError &&
          runtimeType == other.runtimeType &&
          error == other.error &&
          stackTrace == other.stackTrace;

  @override
  int get hashCode => Object.hash(error, stackTrace);
}
