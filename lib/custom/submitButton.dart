import 'package:ecom_seller_app/my_theme.dart';
import 'package:flutter/material.dart';

class SubmitBtn {
  static Widget show(
      {EdgeInsetsGeometry padding = EdgeInsets.zero,
      Color borderColor = const Color.fromRGBO(255, 255, 255, 0.0),
      double elevation = 0.0,
      Alignment alignment = Alignment.centerLeft,
      Color backgroundColor = MyTheme.app_accent_color,
      VoidCallback? onTap,
      double height = 0.0,
      double width = 0.0,
      double radius = 0.0,
      Widget child = const Text("")}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation,
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: borderColor)),
      ),
      onPressed: onTap,
      child: Container(
          height: height, width: width, alignment: alignment, child: child),
    );
  }
}
