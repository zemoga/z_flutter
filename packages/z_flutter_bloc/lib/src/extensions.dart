part of z.flutter.bloc;

extension AsyncValueEmitter<State> on Emitter<State> {
  /// Subscribes to the provided [stream] and invokes the [onValue] callback
  /// when the [stream] emits new data.
  ///
  /// [onEachAsAsyncValue] completes when the event handler is cancelled or when
  /// the provided [stream] has ended.
  Future<void> onEachAsAsyncValue<T>(
    Stream<T> stream, {
    required void Function(AsyncValue<T> value) onValue,
  }) {
    onValue(AsyncValue<T>.loading());
    return onEach<T>(
      stream,
      onData: (data) {
        onValue(AsyncValue.data(data));
      },
      onError: (error, stackTrace) {
        onValue(AsyncValue.error(error, stackTrace));
      },
    );
  }

  /// Subscribes to the provided [stream] and invokes the [onValue] callback
  /// when the [stream] emits new data and the result of [onValue] is emitted.
  ///
  /// [forEachAsAsyncValue] completes when the event handler is cancelled or when
  /// the provided [stream] has ended.
  Future<void> forEachAsAsyncValue<T>(
    Stream<T> stream, {
    required State Function(AsyncValue<T> value) onValue,
  }) {
    return onEachAsAsyncValue<T>(
      stream,
      onValue: (value) => call(onValue(value)),
    );
  }
}
