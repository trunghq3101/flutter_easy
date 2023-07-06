import 'package:flutter/material.dart';
import 'package:flutter_easy/flutter_easy.dart';

class EffectBuilder<T> extends StatelessWidget {
  const EffectBuilder({
    super.key,
    required this.effect,
    required this.data,
    this.idle,
    this.loading,
    this.error,
  });

  final Effect effect;
  final Widget Function()? idle;
  final Widget Function()? loading;
  final Widget Function(Object? error)? error;
  final Widget Function(T data) data;

  @override
  Widget build(BuildContext context) {
    const defaultLoadingIndicator = Center(child: CircularProgressIndicator());
    return ListenableBuilder(
      listenable: effect,
      builder: (_, __) {
        return (switch (effect.status) {
          EffectStatus.idle =>
            idle?.call() ?? loading?.call() ?? defaultLoadingIndicator,
          EffectStatus.loading => loading?.call() ?? defaultLoadingIndicator,
          EffectStatus.error =>
            error?.call(effect.error) ?? Center(child: Text('${effect.error}')),
          EffectStatus.success => data(effect.data)
        });
      },
    );
  }
}
