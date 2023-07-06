import 'package:flutter/widgets.dart';

class LoosenAspectRatio extends StatelessWidget {
  const LoosenAspectRatio({
    super.key,
    required this.aspectRatio,
    this.child,
  });

  final double aspectRatio;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => UnconstrainedBox(
        child: ConstrainedBox(
          constraints: constraints.loosen(),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: child,
          ),
        ),
      ),
    );
  }
}
