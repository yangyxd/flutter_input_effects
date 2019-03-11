import 'package:flutter/material.dart';

/// 输入框样式
class InputStyles {
  final Color color, iconColor, backgroundColor;
  final IconData icon;
  final String label;
  final TextStyle textStyle, labelStyle;
  final EdgeInsets inputPadding, margin;
  final double height;
  final double width;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;

  const InputStyles({
    this.color,
    this.backgroundColor,
    this.iconColor,
    this.icon,
    this.label,
    this.labelStyle,
    this.textStyle,
    this.inputPadding,
    this.margin,
    this.width,
    this.height,
    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth = 2.0,
  });
}