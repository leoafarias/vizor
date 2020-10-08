import 'package:flutter/material.dart';

/// Just like [Theme], applies a theme to descendant vizor widgets.
///
/// Descendant widgets obtain the current theme's [VizorThemeData] object using
/// [VizorTheme.of]. When a widget uses [VizorTheme.of], it is automatically
/// rebuilt if the theme later changes, so that the changes can be applied.
class VizorTheme extends StatelessWidget {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const VizorTheme({
    Key key,
    @required this.data,
    @required this.child,
  })  : assert(child != null),
        assert(data != null),
        super(key: key);

  /// Specifies the color and typography values for descendant widgets.
  final VizorThemeData data;

  /// The widget below this widget in the tree.
  final Widget child;

  static final VizorThemeData _kFallbackTheme = VizorThemeData.fallback();

  /// The data from the closest [VizorTheme] instance that encloses the given
  /// context.
  ///
  /// Defaults to [VizorTheme.fallback] if there is no [VizorTheme] in the given
  /// build context.
  static VizorThemeData of(BuildContext context) {
    final _InheritedVizorTheme inheritedVizorTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedVizorTheme>();

    return inheritedVizorTheme?.theme?.data ?? _kFallbackTheme;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedVizorTheme(
      theme: this,
      child: child,
    );
  }
}

class _InheritedVizorTheme extends InheritedTheme {
  const _InheritedVizorTheme({
    Key key,
    @required this.theme,
    @required Widget child,
  })  : assert(theme != null),
        super(key: key, child: child);

  final VizorTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final _InheritedVizorTheme ancestorVizorTheme =
        context.findAncestorWidgetOfExactType<_InheritedVizorTheme>();
    return identical(this, ancestorVizorTheme)
        ? child
        : VizorTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedVizorTheme old) =>
      theme.data != old.theme.data;
}

@immutable
class VizorThemeData {
  const VizorThemeData({
    this.animationCurve = Curves.fastOutSlowIn,
    this.animationDuration = const Duration(milliseconds: 800),
    this.frameTheme = const VizorFrameTheme(),
    this.buttonTheme = const VizorButtonTheme(),
  });

  factory VizorThemeData.fallback() {
    return VizorThemeData();
  }

  final Curve animationCurve;
  final Duration animationDuration;
  final VizorFrameTheme frameTheme;
  final VizorButtonTheme buttonTheme;
}

@immutable
class VizorFrameTheme {
  const VizorFrameTheme({
    this.color = Colors.black54,
    this.lineColor = Colors.tealAccent,
    this.lineStroke = 1.0,
    this.cornerStroke = 3.0,
    this.cornerLengthRatio = 0.15,
    this.gradient,
    this.boxShadow = const [
      BoxShadow(
        color: Color(0x5164FFDA),
        blurRadius: 3.0,
        spreadRadius: 3.0,
      )
    ],
    this.backgroundBlendMode,
    this.position,
  });

  final Color color;
  final Color lineColor;
  final double lineStroke;
  final double cornerStroke;
  final double cornerLengthRatio;
  final Gradient gradient;
  final List<BoxShadow> boxShadow;
  final BlendMode backgroundBlendMode;
  final DecorationPosition position;
}

@immutable
class VizorButtonTheme {
  const VizorButtonTheme({
    this.color = Colors.tealAccent,
    this.borderColor = Colors.tealAccent,
    this.textColor = Colors.tealAccent,
    this.backgroundColor = Colors.black87,
    this.padding = const EdgeInsets.all(15.0),
  });

  final Color color;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final EdgeInsets padding;
}
