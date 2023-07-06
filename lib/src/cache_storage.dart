import 'dart:async';

import 'package:flutter/widgets.dart';

class CachedItem {
  final DateTime createdAt;
  final dynamic data;

  CachedItem({required this.createdAt, this.data});
}

class CacheStorage {
  final Map<String, CachedItem> _cache = {};
  Duration staleTime = Duration.zero;
  Duration cacheTime = const Duration(minutes: 5);

  @visibleForTesting
  Map<String, CachedItem> get cache => _cache;

  Future<T> cachedRequest<T>(String key, FutureOr<T> Function() fn) async {
    T? data;
    if (_cache.containsKey(key)) {
      final item = _cache[key]!;
      if (item.data is! T) {
        throw ArgumentError(
            'Type $T is not matched with cached type ${item.runtimeType}');
      }
      if (DateTime.now().difference(item.createdAt) < cacheTime) {
        data = item.data;
      } else {
        _cache.remove(key);
      }
    }
    if (data == null) {
      data = await fn();
      _cache[key] = CachedItem(createdAt: DateTime.now(), data: data);
    } else if (DateTime.now().difference(_cache[key]!.createdAt) > staleTime) {
      Future(() => fn()).then(
        (value) =>
            _cache[key] = CachedItem(createdAt: DateTime.now(), data: value),
      );
    }
    return data!;
  }
}
