import 'package:flutter/material.dart';

class FABAnimated extends StatefulWidget {
  final Widget? floatingActionButton;
  final bool visible;
  const FABAnimated({
    Key? key,
    this.visible = false,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  State<FABAnimated> createState() => FABAnimatedState();
}

class FABAnimatedState extends State<FABAnimated> {
  late bool visible = widget.visible;

  void show() {
    setState(() {
      visible = true;
    });
  }

  void hide() {
    setState(() {
      visible = false;
    });
  }

  void toggle() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.floatingActionButton == null) return Container();
    return AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: widget.floatingActionButton);

  }
}
