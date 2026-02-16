import 'dart:async';

import 'package:flutter/material.dart';

class AutoScrollingTextWidget extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double velocity;
  final double gap;
  final Duration pause;

  const AutoScrollingTextWidget({
    super.key,
    required this.text,
    this.style,
    this.velocity = 30,
    this.pause = const Duration(seconds: 2),
    this.gap = 40,
  });

  @override
  State<AutoScrollingTextWidget> createState() => _AutoScrollingTextWidgetState();
}

//TODO: сделать плавное затухание по краям и скролл при наведении или когда карточка появилась
class _AutoScrollingTextWidgetState extends State<AutoScrollingTextWidget> with SingleTickerProviderStateMixin {
  late final ScrollController _controller;
  bool _shouldScroll = false;
  double _textWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    final availableWidth = context.size?.width ?? 0;

    if (textPainter.width > availableWidth && !_shouldScroll) {
      setState(() {
        _shouldScroll = true;
        _textWidth = textPainter.width;
      });
      _startScrolling();
    }
  }

  Future<void> _startScrolling() async {

    await Future.delayed(widget.pause);
    if (!mounted) return;

    _scrollOnce();
  }

  Future<void> _scrollOnce() async {
    final scrollDistance = _textWidth + widget.gap;

    final duration = Duration(
      milliseconds: (scrollDistance / widget.velocity * 1000).toInt(),
    );

    await _controller.animateTo(scrollDistance, duration: duration, curve: Curves.linear);

    await Future.delayed(widget.pause);
    if (!mounted) return;

    _controller.jumpTo(0);
    _scrollOnce();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldScroll) {
      return Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.black,
              Colors.black,
              Colors.transparent,
            ],
          stops: const [
            0.0,
            0.05,
            0.95,
            1.0
          ]
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            Text(widget.text, style: widget.style,),
            SizedBox(width: widget.gap,),
            Text(widget.text, style: widget.style,)
          ],
        ),
      ),
    );
  }
}
