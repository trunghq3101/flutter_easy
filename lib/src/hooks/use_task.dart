import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Task<TData> {
  final void Function() run;
  final ValueNotifier<TaskResult<TData>> result;

  Task(this.run, this.result);
}

enum TaskState { idle, loading, success, error }

class TaskResult<TData> {
  final TaskState state;
  final TData? data;
  final Object? error;

  bool get hasData => data != null;
  bool get isLoading => state == TaskState.loading;
  bool get isSuccess => state == TaskState.success;
  bool get isError => state == TaskState.error;

  TaskResult({this.state = TaskState.idle, this.data, this.error});

  TaskResult<TData> copyWith({
    TaskState? state,
  }) =>
      TaskResult(
          state: state ?? this.state, data: this.data, error: this.error);

  TaskResult<TData> withData(TData? data) =>
      TaskResult(state: this.state, data: data, error: this.error);

  TaskResult<TData> withError(Object? error) => TaskResult(
        state: this.state,
        data: this.data,
        error: error,
      );
}

Task<TData> useTask<TData>(FutureOr<TData> Function() fn,
    {bool debug = false}) {
  final result = useState(TaskResult<TData>());

  void run() async {
    result.value = result.value.copyWith(state: TaskState.loading);
    try {
      final data = await fn();
      result.value =
          result.value.copyWith(state: TaskState.success).withData(data);
    } catch (e) {
      result.value = result.value.copyWith(state: TaskState.error).withError(e);
      if (debug) rethrow;
    }
  }

  return Task(run, result);
}
