import 'package:flutter_easy/src/cache_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CacheStorage', () {
    late CacheStorage cacheStorage;

    setUp(() {
      cacheStorage = CacheStorage();
    });

    test('Cached request with existing data', () async {
      const testData = 'Test Data';
      const testKey = 'testKey';
      cacheStorage.cache[testKey] =
          CachedItem(createdAt: DateTime.now(), data: testData);

      final result = await cacheStorage.cachedRequest<String>(
          testKey, () => throw 'This should not be called');

      expect(result, equals(testData));
    });

    test('Cached request with stale data', () async {
      const testData = 'Test Data';
      const testKey = 'testKey';
      cacheStorage.staleTime = const Duration(days: 1);
      cacheStorage.cacheTime = const Duration(days: 3);
      cacheStorage.cache[testKey] = CachedItem(
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        data: testData,
      );

      final result = await cacheStorage.cachedRequest(testKey, () async {
        return 'New Data';
      });

      expect(result, isNot('New Data'));
    });

    test('Cached request with expired data', () async {
      const testData = 'Test Data';
      const testKey = 'testKey';
      cacheStorage.staleTime = const Duration(days: 1);
      cacheStorage.cacheTime = Duration.zero;
      cacheStorage.cache[testKey] = CachedItem(
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        data: testData,
      );

      final result = await cacheStorage.cachedRequest(testKey, () async {
        return 'New Data';
      });

      expect(result, equals('New Data'));
    });

    test('Cached request with new data', () async {
      const testData = 'Test Data';
      const testKey = 'testKey';

      final result = await cacheStorage.cachedRequest(testKey, () async {
        return testData;
      });

      expect(result, equals(testData));
      expect(cacheStorage.cache.containsKey(testKey), isTrue);
    });

    test('Cached request with invalid cached type', () async {
      const testKey = 'testKey';
      cacheStorage.cache[testKey] =
          CachedItem(createdAt: DateTime.now(), data: 'Invalid Data');

      try {
        await cacheStorage.cachedRequest<int>(testKey, () async {
          throw 'This should not be called';
        });
        fail('Exception expected');
      } catch (e) {
        expect(e, isArgumentError);
      }
    });
  });
}
