
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'InputStyles.dart';

@optionalTypeArgs
mixin SuffixIconMixin<T extends StatefulWidget> on State<T> {
  bool showSuffix = false;
  bool showPwd = false;

  bool _obscureText = false;
  bool _autoSuffix = false;
  TextEditingController _controller;

  void initSuffixIconState(TextEditingController controller, bool obscureText, InputStyles styles) {
    _obscureText = obscureText;
    _controller = controller;
    _autoSuffix = styles.autoSuffix;
    if (styles.autoSuffix) {
      controller.addListener(_textChanged);
      showSuffix = obscureText || controller.text.isNotEmpty;
    } else
      showSuffix = false;
  }

  void disposeSuffixIcon() {
    if (_autoSuffix && _controller != null)
      _controller.removeListener(_textChanged);
  }

  void _textChanged() {
    if (!_obscureText && showSuffix != _controller.text.isNotEmpty) {
      setState(() {
        showSuffix = !showSuffix;
      });
    }
  }

  Widget createSuffixIcon(Icon icon, InputStyles styles, VoidCallback onPressed) {
    return icon == null ? null : InkWell (
      onTap: onPressed,
      child: Container(
        width: styles.suffixIconSize,
        height: styles.suffixIconSize,
        margin: styles.suffixMargin ?? const EdgeInsets.only(left: 8.0, right: 1.0),
        child: IconTheme.merge(
          data: IconThemeData(
              size: 16.0,
              opacity: 0.75,
              color: styles.suffixIconColor ?? Colors.black26
          ),
          child: icon,
        ),
      ),
    );
  }

  Widget createSuffixWidget(Widget child, InputStyles styles) {
    return child == null ? null : Container(
      width: styles.suffixIconSize,
      height: styles.suffixIconSize,
      alignment: Alignment.center,
      margin: styles.suffixMargin ?? const EdgeInsets.only(left: 8.0, bottom: 1.0, right: 1.0),
      child: IconTheme.merge(
        data: IconThemeData(
            size: 16.0,
            color: styles.suffixIconColor ?? Colors.black26
        ),
        child: child,
      ),
    );
  }

  Widget buildSuffixIcon(BuildContext context, InputStyles styles, Widget child,  bool hasFocus) {
    if (child != null) {
      return createSuffixWidget(child, styles);
    }
    if (!showSuffix)
      return null;
    var color = styles.suffixIconColor ?? Colors.black87;
    if (_obscureText) {
      return createSuffixIcon(Icon(Icons.remove_red_eye,
          color: showPwd ? color : (hasFocus ? color.withAlpha(100) : color.withAlpha(80))), styles, () {
        setState(() {
          showPwd = !showPwd;
        });
      });
    } else {
      return createSuffixIcon(Icon(Icons.clear, color: hasFocus ? color : color.withAlpha(100)), styles, () {
        setState(() {
          showSuffix = false;
          if (_controller != null)
            _controller.text = "";
        });
      });
    }
  }
}