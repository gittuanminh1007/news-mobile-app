import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton(
      {this.child,
      this.color,
      this.height: 50.0,
      this.borderRadius: 4.0,
      this.onPressed})
      : assert(borderRadius != null);
  final Widget child;
  final Color color;
  final double height;
  final double borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: child,
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
