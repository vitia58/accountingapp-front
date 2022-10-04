import 'package:flutter/material.dart';

IndexedWidgetBuilder listViewWithHeader(Widget Function(BuildContext context, int index) widget,{Widget? header,bool isColumn=true}){
  return (context, index) {
    if (index == 0 && header!=null) {
      if(isColumn) {
        return Column(
          children: [
            header,
            widget(context,index)
          ],
        );
      }else{
        return Row(
          children: [
            header,
            widget(context,index)
          ],
        );
      }
    }
    return widget(context,index);
  };
}