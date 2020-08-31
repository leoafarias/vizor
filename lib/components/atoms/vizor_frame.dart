import 'package:flutter/material.dart';
import 'package:vizor/providers/sound_provider.dart';
import 'package:vizor/providers/theme_provider.dart';

class VizorFrame extends StatefulWidget {
  final Color color;
  final Color lineColor;
  final double lineStroke;
  final double cornerStroke;
  final double cornerLengthRatio;
  final Gradient gradient;
  final List<BoxShadow> boxShadow;
  final BlendMode backgroundBlendMode;
  final DecorationPosition position;
  final bool enableSoundEffect;
  final Sound soundEffect;
  final Widget child;

  const VizorFrame({
    Key key,
    this.color,
    this.lineColor,
    this.lineStroke = 1.0,
    this.cornerStroke = 3.0,
    this.cornerLengthRatio = 0.15,
    this.gradient,
    this.boxShadow,
    this.backgroundBlendMode,
    this.position = DecorationPosition.background,
    this.enableSoundEffect = false,
    this.soundEffect,
    this.child,
  }) : super(key: key);

  @override
  _VizorFrameState createState() => _VizorFrameState();
}

class _VizorFrameState extends State<VizorFrame>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    final vtheme = VizorTheme.of(context);

    _controller =
        AnimationController(duration: vtheme.animationDuration, vsync: this)
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if ([AnimationStatus.forward, AnimationStatus.reverse]
                .contains(status)) {
              _playSoundEffect();
            }
          })
          ..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: vtheme.animationCurve))
        .animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _playSoundEffect() {
    if (widget.enableSoundEffect == false) {
      return;
    }

    if (widget.soundEffect != null) {
      widget.soundEffect.play();
    } else {
      SoundProvider.of(context).deploy.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VizorTheme.of(context)?.frameTheme ??
        VizorThemeData.fallback()?.frameTheme;

    return DecoratedBox(
      position: widget.position,
      decoration: FrameDecoration(
        step: _animation.value,
        color: widget.color ?? theme.color,
        lineColor: widget.lineColor ?? theme.lineColor,
        lineStroke: widget.lineStroke ?? theme.lineStroke,
        cornerStroke: widget.cornerStroke ?? theme.cornerStroke,
        cornerLengthRatio: widget.cornerLengthRatio ?? theme.cornerLengthRatio,
        gradient: widget.gradient ?? theme.gradient,
        boxShadow: widget.boxShadow ?? theme.boxShadow,
        backgroundBlendMode:
            widget.backgroundBlendMode ?? theme.backgroundBlendMode,
      ),
      child: widget.child,
    );
  }
}

class FrameDecoration extends Decoration {
  final double step;
  final Color color;
  final Color lineColor;
  final double lineStroke;
  final double cornerStroke;
  final double cornerLengthRatio;
  final Gradient gradient;
  final List<BoxShadow> boxShadow;
  final BlendMode backgroundBlendMode;

  const FrameDecoration({
    @required this.lineColor,
    this.color,
    this.step = 1.0,
    this.lineStroke = 1.0,
    this.cornerStroke = 3.0,
    this.cornerLengthRatio = 0.15,
    this.gradient,
    this.boxShadow,
    this.backgroundBlendMode,
  });

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return _FrameDecorationPainter(
      step: step,
      color: color,
      lineColor: lineColor,
      lineStroke: lineStroke,
      cornerStroke: cornerStroke,
      cornerLengthRatio: cornerLengthRatio,
      gradient: gradient,
      boxShadow: boxShadow,
      backgroundBlendMode: backgroundBlendMode,
    );
  }
}

class _FrameDecorationPainter extends BoxPainter {
  final double step;
  final Color color;
  final Color lineColor;
  final double lineStroke;
  final double cornerStroke;
  final double cornerLengthRatio;
  final Gradient gradient;
  final List<BoxShadow> boxShadow;
  final BlendMode backgroundBlendMode;

  const _FrameDecorationPainter({
    this.step = 1.0,
    this.color,
    @required this.lineColor,
    @required this.lineStroke,
    @required this.cornerStroke,
    @required this.cornerLengthRatio,
    this.gradient,
    this.boxShadow,
    this.backgroundBlendMode,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size;

    _paintShadows(canvas, rect);
    _paintBackgroundColor(canvas, rect);
    _drawRect(canvas, rect);
    _drawCorners(canvas, rect);
  }

  void _drawCorners(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = lineColor.withOpacity(step)
      ..strokeWidth = cornerStroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final length = step * rect.shortestSide * cornerLengthRatio;

    final topLeftCorner = Path()
      ..moveTo(rect.topLeft.dx, rect.topLeft.dy + length)
      ..relativeLineTo(0.0, -length)
      ..relativeLineTo(length, 0.0);

    canvas.drawPath(topLeftCorner, paint);

    final topRightCorner = Path()
      ..moveTo(rect.topRight.dx - length, rect.topRight.dy)
      ..relativeLineTo(length, 0.0)
      ..relativeLineTo(0.0, length);

    canvas.drawPath(topRightCorner, paint);

    final bottomLeftCorner = Path()
      ..moveTo(rect.bottomLeft.dx, rect.bottomLeft.dy - length)
      ..relativeLineTo(0.0, length)
      ..relativeLineTo(length, 0.0);

    canvas.drawPath(bottomLeftCorner, paint);

    final bottomRightCorner = Path()
      ..moveTo(rect.bottomRight.dx - length, rect.bottomRight.dy)
      ..relativeLineTo(length, 0.0)
      ..relativeLineTo(0.0, -length);

    canvas.drawPath(bottomRightCorner, paint);
  }

  void _drawRect(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = lineColor.withOpacity(step)
      ..strokeWidth = lineStroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    canvas.drawPath(_topPath(rect), paint);
    canvas.drawPath(_rightPath(rect), paint);
    canvas.drawPath(_bottomPath(rect), paint);
    canvas.drawPath(_leftPath(rect), paint);
  }

  Path _topPath(Rect rect) {
    final tween = RectTween(
      begin: Rect.zero.shift(rect.topCenter),
      end: rect,
    ).transform(step);

    return Path()
      ..moveTo(tween.topLeft.dx, tween.topLeft.dy)
      ..relativeLineTo(tween.width, 0.0);
  }

  Path _rightPath(Rect rect) {
    final tween = RectTween(
      begin: Rect.zero.shift(rect.centerRight),
      end: rect,
    ).transform(step);

    return Path()
      ..moveTo(tween.topRight.dx, tween.topRight.dy)
      ..relativeLineTo(0.0, tween.height);
  }

  Path _bottomPath(Rect rect) {
    final tween = RectTween(
      begin: Rect.zero.shift(rect.bottomCenter),
      end: rect,
    ).transform(step);

    return Path()
      ..moveTo(tween.bottomLeft.dx, tween.bottomLeft.dy)
      ..relativeLineTo(tween.width, 0.0);
  }

  Path _leftPath(Rect rect) {
    final tween = RectTween(
      begin: Rect.zero.shift(rect.centerLeft),
      end: rect,
    ).transform(step);

    return Path()
      ..moveTo(tween.topLeft.dx, tween.topLeft.dy)
      ..relativeLineTo(0.0, tween.height);
  }

  void _paintShadows(Canvas canvas, Rect rect) {
    if (boxShadow == null) {
      return;
    }

    for (final shadow in boxShadow) {
      final paint = shadow.toPaint();
      final bounds = rect.shift(shadow.offset).inflate(shadow.spreadRadius);
      canvas.drawRect(bounds, paint);
    }
  }

  void _paintBackgroundColor(Canvas canvas, Rect rect) {
    if (color == null) {
      return;
    }

    final paint = Paint();

    if (backgroundBlendMode != null) paint.blendMode = backgroundBlendMode;
    if (color != null) paint.color = color;
    if (gradient != null) {
      paint.shader = gradient.createShader(rect);
    }

    canvas.drawRect(rect, paint);
  }
}
