
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/AppColor.dart';
import '../res/ImageRes.dart';

class MyElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const MyElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColor().whiteColor,
            ),
            color: AppColor().whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: child,
      ),

    );
  }

  // ElevatedButton(
  // onPressed: onPressed,
  // style: ElevatedButton.styleFrom(
  // shadowColor: Colors.transparent,
  // shape: RoundedRectangleBorder(borderRadius: borderRadius),
  // ),
  // child: child,
  // ),
}