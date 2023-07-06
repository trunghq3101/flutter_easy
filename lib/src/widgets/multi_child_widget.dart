import 'package:flutter/widgets.dart';

abstract class MultiChildWidget extends StatelessWidget {
  const MultiChildWidget({super.key, required this.children});

  final List<Widget> children;
}
