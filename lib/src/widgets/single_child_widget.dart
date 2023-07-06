import 'package:flutter/widgets.dart';

abstract class SingleChildWidget extends StatelessWidget {
  const SingleChildWidget({super.key, required this.child});

  final Widget child;
}
