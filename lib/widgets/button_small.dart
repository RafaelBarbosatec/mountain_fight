import 'package:flutter/material.dart';

class ButtonSmall extends StatefulWidget {
  final String pathUnSelected;
  final String pathSelected;
  final VoidCallback onPress;
  final double size;

  const ButtonSmall(
      {Key key,
      this.pathUnSelected,
      this.pathSelected,
      this.onPress,
      this.size = 50})
      : super(key: key);
  @override
  _ButtonSmallState createState() => _ButtonSmallState();
}

class _ButtonSmallState extends State<ButtonSmall> {
  bool press = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTapDown: (d) {
        setState(() {
          press = true;
        });
      },
      onTap: () {
        setState(() {
          press = false;
        });
        if (widget.onPress != null) {
          widget.onPress();
        }
      },
      onTapCancel: () {
        setState(() {
          press = false;
        });
      },
      child: Image.asset(
        press ? widget.pathSelected : widget.pathUnSelected,
        width: widget.size,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
