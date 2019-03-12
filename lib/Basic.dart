import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:vector_math/vector_math_64.dart' as Vector;
import 'InputStyles.dart';
import 'SuffixIconMixin.dart';

class BasicInput extends StatefulWidget {
  final InputStyles styles;
  final String label;
  final String defaultText;
  final Widget child;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final bool autoFocus, obscureText, enabled, autocorrect, enableInteractiveSelection;
  final int maxLength, maxLines;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final FocusNode focusNode;

  BasicInput({
    Key key,
    this.styles,
    this.label,
    this.defaultText,
    this.child,
    this.keyboardType,
    this.controller,
    this.textInputAction,
    this.autoFocus = false,
    this.obscureText = false,
    this.enabled = true,
    this.enableInteractiveSelection = false,
    this.autocorrect = false,
    this.maxLength,
    this.maxLines,
    this.focusNode,
    this.inputFormatters,

    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
  }) : assert(styles != null), super(key: key);

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<BasicInput> with SuffixIconMixin {
  FocusNode _focusNode;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
    _controller = widget.controller ?? new TextEditingController(text: widget.defaultText);
    initSuffixIconState(_controller, widget.obscureText, widget.styles);
  }

  @override
  void didUpdateWidget(BasicInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null)
      _controller = TextEditingController.fromValue(oldWidget.controller.value);
    else if (widget.controller != null && oldWidget.controller == null)
      _controller = null;
    final bool isEnabled = widget.enabled ?? true;
    final bool wasEnabled = oldWidget.enabled ?? true;
    if (wasEnabled && !isEnabled) {
      _focusNode?.unfocus();
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    disposeSuffixIcon();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = widget.styles;
    final _hasFocus = _focusNode.hasFocus;
    final isEmpty = _controller.value.text.isEmpty;

    Widget view = TextField(
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType,
      controller: _controller,
      textInputAction: widget.textInputAction,
      autofocus: widget.autoFocus,
      autocorrect: widget.autocorrect,
      obscureText: widget.obscureText && !showPwd,
      enabled: widget.enabled,
      maxLines: widget.maxLines ?? 1,
      maxLengthEnforced: false,
      inputFormatters: widget.inputFormatters,
      style: styles.textStyle,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      cursorColor: styles.cursorColor,
      cursorRadius: styles.cursorRadius,
      cursorWidth: styles.cursorWidth,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) {
        return SizedBox();
      },
      decoration: InputDecoration(
        contentPadding: styles.inputPadding ?? const EdgeInsets.only(top: 12.0, right: 12.0, bottom: 12.0, left: 5.0),
        border: InputBorder.none,
        enabled: widget.enabled ?? true,
        labelText: widget.label,
        labelStyle: styles.labelStyle ??
            TextStyle(fontSize: 14.0, color: Colors.black38, letterSpacing: 1.5, fontWeight: FontWeight.w300, height: 0.5),
        filled: styles.backgroundColor == null ? false : true,
        fillColor: styles.backgroundColor,
        prefixIcon: styles.icon == null ? null : Icon(styles.icon, color: styles.iconColor ?? Colors.white),
        suffixIcon: buildSuffixIcon(context, styles, widget.child, _hasFocus),
      ),
      focusNode: _focusNode,
    );

    final color = styles.borderColor ?? Colors.black;

    return Container(
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: DefaultTextStyle(style: TextStyle(
          color: Colors.black87,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w500
        ), child: view),
      ),
      margin: styles.margin,
      width: styles.width,
      height: styles.height,
      decoration: styles.border != null && styles.border <= 0.001 ? null : BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _hasFocus ? color : color.withAlpha(100), width: styles.border ?? 0.3),
        )
      ),
    );
  }

}
