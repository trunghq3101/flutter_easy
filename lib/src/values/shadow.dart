import 'package:flutter/widgets.dart';

class Easy {
  static shadowLg([Color? color]) => [
        BoxShadow(
          color: color ?? const Color.fromRGBO(0, 0, 0, 0.1),
          offset: const Offset(0, 10),
          blurRadius: 15,
          spreadRadius: -3,
        ),
        BoxShadow(
          color: color ?? const Color.fromRGBO(0, 0, 0, 0.1),
          offset: const Offset(0, 4),
          blurRadius: 6,
          spreadRadius: -4,
        ),
      ];
}
