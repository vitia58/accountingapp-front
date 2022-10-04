import 'package:flutter/material.dart';

Color getColor(String hex) {
  hex = hex.replaceAll("#", "");
  int num = int.parse(hex.substring(6)+hex.substring(0,6), radix: 16);
  if(hex.length==6)num+=0xff000000;
  return Color(num);
}

Color defaultColor(DefColor color){
  switch (color) {
    case DefColor.blue:
      return const Color(0xff456BF1);
    case DefColor.blueLight:
      return const Color(0xffE4F2FF);
    case DefColor.green:
      return const Color(0xff42D336);
    case DefColor.greenLight:
      return const Color(0xffE7FFE4);
    case DefColor.red:
      return const Color(0xffD63737);
    case DefColor.redLight:
      return const Color(0xffFFE4E4);
    case DefColor.black:
      return const Color(0xff222222);
    case DefColor.gray:
      return const Color(0xff646464);
    case DefColor.grayLight:
      return const Color(0xffE4E4E4);
    case DefColor.grayBg:
      return const Color(0xffF9F9F9);
    case DefColor.white:
      return const Color(0xffFFFFFF);
  }
}

TextStyle defaultTextStyle(Fonts font,{DefColor? color,String? colorHex,Color? colorObj,TextStyle style = const TextStyle()}) {
  if(color!=null) {
    style = style.merge(TextStyle(color: defaultColor(color)));
  } else if(colorHex!=null) {
    style = style.merge(TextStyle(color: getColor(colorHex)));
  }
  switch (font) {
    case Fonts.title1:
      return const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w500,
          fontFamily: "SFPro",
          letterSpacing: 0.4,
          height: 1.206).merge(style);
    case Fonts.title2:
      return const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: "SFPro",
          letterSpacing: -0.24,
          height: 1.176).merge(style);
    case Fonts.body:
      return const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w300,
          fontFamily: "SFPro",
          letterSpacing: -0.24,
          height: 1.176).merge(style);
    case Fonts.caption1regular:
      return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: "SFPro",
          letterSpacing: -0.24,
          height: 1.429).merge(style);
    case Fonts.caption1semibold:
      return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: "SFPro",
          letterSpacing: -0.24,
          height: 1.429).merge(style);
    case Fonts.caption2:
      return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontFamily: "SFPro",
          letterSpacing: -0.24,
          height: 1.667).merge(style);
  }
}

enum Fonts {
  title1,
  title2,
  body,
  caption1regular,
  caption1semibold,
  caption2,
}
/**
 * blue: #456BF1
 * blueLight: #E4F2FF
 * green: #42D336
 * greenLight: #E7FFE4
 * red: #D63737
 * redLight: #FFE4E4
 * black: #222222
 * gray: #646464
 * grayLight: #E4E4E4
 * grayBg: #F9F9F9
 * white: #FFFFFF
 */
enum DefColor {
  blue,
  blueLight,
  green,
  greenLight,
  red,
  redLight,
  black,
  gray,
  grayLight,
  grayBg,
  white,
}
