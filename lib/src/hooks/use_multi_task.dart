import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../flutter_easy.dart';

class MultiTask<TData> {
  final void Function() run;
  final ValueNotifier<Map<String, TaskResult<TData>>> result;

  MultiTask(this.run, this.result);
}

MultiTask<TData> useMultiTasks<TData>(
  Map<String, FutureOr<TData> Function()> fns, {
  bool debug = false,
  Duration delay = Duration.zero,
}) {
  final result = useState(<String, TaskResult<TData>>{});

  useEffect(() {
    result.value = fns.map((k, v) => MapEntry(k, TaskResult<TData>()));
    return null;
  }, [fns]);

  Future runItem(String id, FutureOr<TData> Function() fn) async {
    final newValue = Map<String, TaskResult<TData>>.from(result.value
      ..update(id, (value) => value.copyWith(state: TaskState.loading)));
    result.value = newValue;
    try {
      final data = await fn();
      result.value = Map.from(result.value
        ..update(
            id,
            (value) =>
                value.copyWith(state: TaskState.success).withData(data)));
    } catch (e) {
      result.value = Map.from(result.value
        ..update(id,
            (value) => value.copyWith(state: TaskState.error).withError(e)));
      if (debug) rethrow;
    }
  }

  void run() {
    final futures = fns
        .map((key, value) => MapEntry(key, () => runItem(key, value)))
        .entries
        .toList();

    int index = 0;
    while (index < futures.length) {
      final fn = futures[index].value;
      Future.delayed(delay * index, fn);
      index++;
    }
  }

  return MultiTask(run, result);
}
