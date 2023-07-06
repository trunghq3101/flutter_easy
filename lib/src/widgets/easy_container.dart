import 'package:flutter/widgets.dart';

enum ContainerType {
  column,
  row,
  box,
}

class EasyStyle {
  EasyStyle({
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.widthFactor,
    this.heightFactor,
    this.offstage = false,
    this.flex,
  })  : assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(constraints == null || constraints.debugAssertIsValid()),
        assert(decoration != null || clipBehavior == Clip.none),
        assert(
          color == null || decoration == null,
          'Cannot provide both a color and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: color)".',
        ),
        constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints;

  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;

  final double? widthFactor;
  final double? heightFactor;

  final bool offstage;

  final int? flex;
}

class EasyContainer extends StatelessWidget {
  EasyContainer({
    super.key,
    this.child,
    this.children,
    this.containerType = ContainerType.box,
    EasyStyle? easyStyle,
  })  : assert(child == null || children == null,
            'Cannot provide both child and children'),
        easyStyle = easyStyle ?? EasyStyle();

  final Widget? child;
  final List<Widget>? children;
  final ContainerType containerType;
  final EasyStyle easyStyle;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (containerType == ContainerType.column) {
      assert(children != null);
      child = Column(
        mainAxisAlignment: easyStyle.mainAxisAlignment,
        mainAxisSize: easyStyle.mainAxisSize,
        crossAxisAlignment: easyStyle.crossAxisAlignment,
        textDirection: easyStyle.textDirection,
        verticalDirection: easyStyle.verticalDirection,
        textBaseline: easyStyle.textBaseline,
        children: children!,
      );
    }
    if (containerType == ContainerType.row) {
      assert(children != null);
      child = Row(
        mainAxisAlignment: easyStyle.mainAxisAlignment,
        mainAxisSize: easyStyle.mainAxisSize,
        crossAxisAlignment: easyStyle.crossAxisAlignment,
        textDirection: easyStyle.textDirection,
        verticalDirection: easyStyle.verticalDirection,
        textBaseline: easyStyle.textBaseline,
        children: children!,
      );
    }
    child = Container(
      alignment: easyStyle.alignment,
      padding: easyStyle.padding,
      color: easyStyle.color,
      decoration: easyStyle.decoration,
      foregroundDecoration: easyStyle.foregroundDecoration,
      constraints: easyStyle.constraints,
      margin: easyStyle.margin,
      transform: easyStyle.transform,
      transformAlignment: easyStyle.transformAlignment,
      clipBehavior: easyStyle.clipBehavior,
      child: child ?? this.child,
    );
    if (easyStyle.widthFactor != null || easyStyle.heightFactor != null) {
      child = FractionallySizedBox(
        widthFactor: easyStyle.widthFactor,
        heightFactor: easyStyle.heightFactor,
        child: child,
      );
    }
    child = Offstage(
      offstage: easyStyle.offstage,
      child: child,
    );
    if (easyStyle.flex != null) {
      child = Expanded(flex: easyStyle.flex!, child: child);
    }
    return child;
  }
}
