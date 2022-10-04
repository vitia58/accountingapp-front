import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/fontHelper.dart';

AppBar getAppBar(String title,BuildContext context,{Widget? right,void Function()? onClick}){
  return AppBar(
    title: Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 38,left: 16),
          child: Text(title,style: defaultTextStyle(Fonts.title1,color: DefColor.black)),
        ),
        Navigator.canPop(context)?GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: Navigator.of(context).pop,
          child: Padding(
            padding: const EdgeInsets.only(top: 10,left: 10,right: 70,bottom: 50),
            child: SvgPicture.asset("assets/images/back.svg"),
          ),
        ):Container(),
        right!=null?
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onClick,
              child: Container(
                padding: const EdgeInsets.only(top: 10,left: 30,right: 10,bottom: 30),
                child: right,
              ),
            ),
          )
        :Container()
      ],
    ),
    titleSpacing: 0,
    leading: Container(),
    leadingWidth: 0,
    toolbarHeight: 85,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}