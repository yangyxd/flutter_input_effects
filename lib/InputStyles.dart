import 'package:flutter/material.dart';

/// 输入框样式
class InputStyles {
  final Color color, iconColor, backgroundColor, borderColor;
  final IconData icon;
  final IconData prefixIcon;
  final String label;
  final TextStyle textStyle, labelStyle;
  final EdgeInsets inputPadding, margin, padding, suffixMargin;
  final double height;
  final double width;
  final double border;

  final bool autoSuffix;
  final double suffixIconSize;
  final Color suffixIconColor;

  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;

  const InputStyles({
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.icon,
    this.prefixIcon,
    this.label,
    this.labelStyle,
    this.textStyle,
    this.inputPadding,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.border,


    this.suffixIconSize = 24.0,
    this.suffixMargin,
    this.suffixIconColor,
    this.autoSuffix = true,


    this.cursorColor,
    this.cursorRadius,
    this.cursorWidth = 2.0,
  });
}