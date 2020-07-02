import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vizor/components/atoms/typing_text/typing_effect_controller.dart';

class TypingText extends StatefulWidget {
  final String data;
  final TextStyle style;
  final bool softWrap;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior textHeightBehavior;
  final TypingEffectController controller;
  final Duration effectDuration;

  const TypingText(
    this.data, {
    Key key,
    this.style,
    this.textAlign,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.maxLines,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.controller,
    this.effectDuration,
  }) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  TypingEffectController _controller;
  String _data = '';

  void _effectCallback(String data) {
    setState(() {
      _data = data;
    });
  }

  @override
  void initState() {
    setState(() {
      _controller = widget.controller ??
          TypingEffectController(
            _effectCallback,
            duration: widget.effectDuration,
          );
    });
    super.initState();
    _controller.setData(widget.data);
  }

  @override
  void didUpdateWidget(TypingText oldWidget) {
    if (oldWidget.data != widget.data) {
      _controller.setData(
        widget.data,
        removeFirst: true,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        _data,
        style: widget.style,
        textAlign: widget.textAlign,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        maxLines: widget.maxLines,
        textWidthBasis: widget.textWidthBasis,
        textHeightBehavior: widget.textHeightBehavior,
      ),
    );
  }
}
