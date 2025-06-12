import 'package:flutter/material.dart';

class _CoinFlyUp extends StatefulWidget {
  final Offset startPosition;

  const _CoinFlyUp({required this.startPosition});

  @override
  State<_CoinFlyUp> createState() => _CoinFlyUpState();
}

class _CoinFlyUpState extends State<_CoinFlyUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _position;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _position = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.startPosition - const Offset(0, 60), // bay lên
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _position,
      builder: (context, child) {
        return Positioned(
          left: _position.value.dx,
          top: _position.value.dy,
          child: Opacity(
            opacity: 1 - _controller.value,
            child: Icon(Icons.monetization_on, color: Colors.amber, size: 24),
          ),
        );
      },
    );
  }
}

Future<void> animateCoinFlyUp({
  required BuildContext context,
  required GlobalKey fromKey,
}) async {
  final renderBox = fromKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;

  final start = renderBox.localToGlobal(Offset.zero);
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (context) {
      return _CoinFlyUp(startPosition: start);
    },
  );

  overlay.insert(entry);

  await Future.delayed(Duration(milliseconds: 600));
  entry.remove();
}
