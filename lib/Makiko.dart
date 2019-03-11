import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'InputStyles.dart';

class MakikoInput extends StatefulWidget {
  final InputStyles styles;
  final String label;
  final Widget child;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final bool autofocus, obscureText, enabled, autocorrect, enableInteractiveSelection;
  final int maxLength, maxLines;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final FocusNode focusNode;

  MakikoInput({
    Key key,
    this.styles,
    this.label,
    this.child,
    this.keyboardType,
    this.controller,
    this.textInputAction,
    this.autofocus = false,
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

class _State extends State<MakikoInput> with TickerProviderStateMixin {
  AnimationController _ani;
  FocusNode _focusNode;
  TextEditingController _controller;

  Set<InteractiveInkFeature> _splashes;
  InteractiveInkFeature _currentSplash;

  bool isAni = false;

  @override
  void initState() {
    super.initState();

    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {
        isAni = true;
        if (_focusNode.hasFocus) {
          _ani.forward();
        } else
          _ani.animateBack(0.0, duration: Duration(milliseconds: 80));
      });
    });

    _ani = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _ani.addStatusListener((ss) {
      if (ss == AnimationStatus.completed)
        setState(() {
          isAni = false;
        });
    });

    _controller = widget.controller ?? new TextEditingController();
  }

  @override
  void didUpdateWidget(MakikoInput oldWidget) {
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
    _ani.dispose();
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
      autofocus: widget.autofocus,
      autocorrect: widget.autocorrect,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      maxLines: widget.maxLines ?? 1,
      maxLengthEnforced: false,
      inputFormatters: widget.inputFormatters,
      style: _hasFocus || !isEmpty ? styles.textStyle : TextStyle(color: styles.iconColor),
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
        contentPadding: styles.inputPadding,
        border: InputBorder.none,
        enabled: widget.enabled ?? true,
        hintText: widget.label,
        hintStyle: _hasFocus ? null : TextStyle(color: styles.iconColor ?? Colors.white),
        isDense: false,
        hasFloatingPlaceholder: false,
        alignLabelWithHint: false,
        prefixIcon: _hasFocus || !isEmpty ? null : Icon(styles.icon, color: styles.iconColor ?? Colors.white),
      ),
      focusNode: _focusNode,
    );

    view = Container(
      child: Theme(
        data: Theme.of(context).copyWith(splashColor: Colors.transparent),
        child: view,
      ),
      margin: styles.margin,
      width: styles.width,
      height: styles.height ?? 50.0,
    );

    return Stack(
      children: <Widget>[
        AniBackLayout(
          height: styles.height ?? 50.0,
          aning: isAni && isEmpty,
          animation: _ani,
          color: styles.backgroundColor ?? Colors.white,
          bgColor: (_hasFocus && !isAni) || !isEmpty ? (styles.backgroundColor ?? Colors.white) : styles.color,
        ),
        view,
      ],
    );
  }

  @override
  bool get wantKeepAlive => _splashes != null && _splashes.isNotEmpty;

  @override
  void deactivate() {
    if (_splashes != null) {
      final Set<InteractiveInkFeature> splashes = _splashes;
      _splashes = null;
      for (InteractiveInkFeature splash in splashes)
        splash.dispose();
      _currentSplash = null;
    }
    assert(_currentSplash == null);
    super.deactivate();
  }
}

class AniBackLayout extends StatefulWidget {
  final AnimationController animation;
  final Color color, bgColor;
  final bool aning;
  final double height;
  const AniBackLayout({Key key, this.color = Colors.white, this.bgColor, this.aning, this.height, this.animation});
  @override
  State<StatefulWidget> createState() {
    return new _AniBackLayoutState();
  }
}

class _AniBackLayoutState extends State<AniBackLayout> {

  @override
  Widget build(BuildContext context) {
    if (!widget.aning)
      return Container(color: widget.bgColor, width: double.infinity, height: widget.height);
    return LayoutBuilder(
      builder: (context, v) {
        return IgnorePointer(
          child: AnimatedBuilder(animation: widget.animation, builder: (context, child) {
            Animation<double> animation = Tween(
              begin: 0.0,
              end: v.widthConstraints().maxWidth,
            ).animate(widget.animation);
            return TextSelectionGestureDetector(
              child: Stack(
                children: <Widget>[
                  Container(color: widget.bgColor, width: double.infinity, height: widget.height),
                  Container(
                    color: widget.color,
                    height: widget.height,
                    width: animation.value,
                    child: ClipPath(
                      clipper: RectClipper(),
                    ),
                  )
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class RectClipper extends CustomClipper<Path> {
  RectClipper();

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height * 2.0);
    path.lineTo(0.0, size.height * 2.0);
    path.lineTo(0.0, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}