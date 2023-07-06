import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_easy/src/cache_storage.dart';

enum EffectStatus { idle, loading, error, success }

class Effect<I, R> extends ChangeNotifier {
  Effect(
    FutureOr<R> Function(I? variables) runner, {
    this.onSuccess,
    this.onError,
    this.throwError = false,
  }) : _runner = runner;

  late final FutureOr<R> Function(I? variables) _runner;
  final Function(R? data)? onSuccess;
  final Function(Object error)? onError;
  final bool throwError;

  var status = EffectStatus.idle;
  R? data;
  Object? error;

  get isIdle => status == EffectStatus.idle;
  get isLoading => status == EffectStatus.loading;
  get isSuccess => status == EffectStatus.success;
  get isError => status == EffectStatus.error;

  void run({
    I? variables,
    Function(R? data)? onSuccess,
    Function(Object? error)? onError,
  }) async {
    data = null;
    error = null;
    status = EffectStatus.loading;
    notifyListeners();
    try {
      data = await _runner(variables);
      status = EffectStatus.success;
      onSuccess?.call(data);
      this.onSuccess?.call(data);
      notifyListeners();
    } catch (e) {
      if (throwError) rethrow;
      error = e;
      status = EffectStatus.error;
      onError?.call(e);
      this.onError?.call(e);
      notifyListeners();
    }
  }
}

class EffectFactory {
  EffectFactory({required this.cacheStorage});

  final CacheStorage cacheStorage;

  QueryEffect<I, R> query<I, R>(
    String key,
    FutureOr<R> Function(I? variables) runner, {
    Function(R? data)? onSuccess,
    Function(Object error)? onError,
    bool? throwError,
  }) =>
      QueryEffect(cacheStorage, key, runner);
}

class QueryEffect<I, R> extends Effect<I, R> {
  QueryEffect(
    this.cacheStorage,
    this.key,
    FutureOr<R> Function(I? variables) runner, {
    super.onSuccess,
    super.onError,
    super.throwError,
  }) : super((variables) =>
            cacheStorage.cachedRequest(key, () => runner(variables)));

  final String key;
  final CacheStorage cacheStorage;
}
