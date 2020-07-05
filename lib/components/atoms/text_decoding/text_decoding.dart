import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vizor/components/atoms/text_decoding/text_decoding_controller.dart';
import 'package:vizor/components/atoms/text_typing/text_typing_controller.dart';

class TextDecoding extends StatefulWidget {
  final String data;
  final TextStyle style;
  final bool softWrap;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior textHeightBehavior;
  final TextTypingController controller;
  final Duration effectDuration;

  const TextDecoding(
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
  _TextDecodingState createState() => _TextDecodingState();
}

class _TextDecodingState extends State<TextDecoding> {
  TextTypingController _controller;
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
          TextDecodingController(
            _effectCallback,
          );
    });
    super.initState();
    _controller.setData(widget.data);
  }

  @override
  void didUpdateWidget(TextDecoding oldWidget) {
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
