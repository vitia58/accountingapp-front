import 'package:flutter/material.dart';

import '../../helpers/fontHelper.dart';

class Field extends StatelessWidget {
  Field({Key? key,this.onClick,required this.fieldName,required this.child,this.bottom}) : super(key: key);
  void Function()? onClick;
  String fieldName;
  Widget child;
  Widget? bottom;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onClick,
        child: Column(
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(fieldName,style: defaultTextStyle(Fonts.caption1semibold,color: DefColor.black)),
            ),
            child,
            bottom??Container()
          ],
        ),
      ),
    );
  }
}
