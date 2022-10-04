import 'package:flutter/material.dart';
import 'package:buking_test/helpers/fontHelper.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(this.text,{
    Key? key,
    this.icon,
    this.flex = 1,
    this.paddingButton = const EdgeInsets.all(0),
    this.marginButton = const EdgeInsets.all(0.0),
    this.paddingText,
    this.transparent = false,
    this.height = 32,
    this.onPress,
    this.enabled = true,
    this.font = Fonts.title2,
    this.textColor,
    this.textDisabledColor=DefColor.gray,
    this.backgroundColor,
    this.backgroundPressedColor,
    this.backgroundDisabledColor="#E3E3E3",
    this.radius=8
  }): super(key: key);
  final String text;
  final Widget? icon;
  final int flex;
  final double height;
  final EdgeInsetsGeometry paddingButton;
  final EdgeInsetsGeometry marginButton;
  final EdgeInsetsGeometry? paddingText;
  final bool transparent;
  final bool enabled;
  final void Function()? onPress;
  final Fonts font;
  final DefColor? textColor;
  final DefColor textDisabledColor;
  final String? backgroundColor;
  final String? backgroundPressedColor;
  final String backgroundDisabledColor;
  final double radius;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    // debugPrint("${widget.font} ${widget.transparent} ${widget.text}");
    Widget tw = Text(
      widget.text,
      style: defaultTextStyle(widget.font,color: !widget.enabled ? widget.textDisabledColor : widget.textColor ?? (widget.transparent ? DefColor.black : DefColor.white)),
    );
    if (widget.paddingText != null) {
      tw = Padding(padding: widget.paddingText!, child: tw);
    }
    if (widget.icon != null) {
      tw = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [widget.icon!, tw],
      );
    }
    Widget w = Container(
      height: widget.height,
      padding: widget.paddingButton,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: widget.transparent
              ? Colors.transparent
              : widget.enabled?getColor(isPressed ? (widget.backgroundPressedColor??widget.backgroundColor??"#214EEE") : (widget.backgroundColor??"#456BF1")):getColor(widget.backgroundDisabledColor)),
      child: Center(child: tw),
    );
    if (widget.flex != 0) {
      w = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: widget.flex,
            child: w,
          )
        ],
      );
    }
    if(widget.enabled){
      w = GestureDetector(
        onTap: widget.onPress,
        onTapDown: (_) {
          if(!isPressed&&!widget.transparent){
            setState(() {
              isPressed = true;
            });
          }
        },
        onTapUp: (_) {
          if(isPressed&&!widget.transparent){
            setState(() {
              isPressed = false;
            });
          }
        },
        child: w,
      );
    }
    return Center(
      child: Padding(
        padding: widget.marginButton,
        child: w,
      ),
    );
  }
}
