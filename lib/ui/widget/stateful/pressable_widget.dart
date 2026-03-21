import 'package:flutter/cupertino.dart';

class PressableWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongTap;
  final Duration duration;

  const PressableWidget({
    super.key,
    required this.child,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 120,), this.onLongTap,
  });

  @override
  State<PressableWidget> createState() => _PressableWidgetState();
}

class _PressableWidgetState extends State<PressableWidget> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _pressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _pressed = false);
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      onLongPress: widget.onLongTap,
      behavior: HitTestBehavior.translucent,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _pressed ? 0.85 : 1.0,
          duration: widget.duration,
          child: widget.child,
        ),
      ),
    );
  }
}
