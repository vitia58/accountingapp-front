import 'package:flutter/material.dart';

class BottomView extends StatefulWidget {
  BottomView({Key? key,this.child,this.bottom,required this.height}) : super(key: key);
  final Widget? child;
  final Widget? bottom;
  double height;

  @override
  State<BottomView> createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    if(widget.height==0){
      if(visible) {
        setState(() {
          visible=false;
        });
      }
    }else{
      if(!visible) {
        setState(() {
          visible=true;
        });
      }
    }
    return Stack(
      children: [
        Padding(padding: EdgeInsets.only(bottom: visible?0:60),child: widget.child??Container(),),
        visible?Container():Positioned(bottom: 20,left: 16,right: 16,child: SizedBox(height: 40,child: widget.bottom??Container(),),)
      ],
    );
  }
}
