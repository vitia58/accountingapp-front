import 'package:buking_test/helpers/ValueGet.dart';
import 'package:flutter/material.dart';

import '../../helpers/fontHelper.dart';

class TextInput extends StatefulWidget {
  TextInput(
      {Key? key,
      this.controller,
      this.text = "",
      this.enabled = true,
      this.placeholder = "",
      this.nextIcon,
        this.keyboard = TextInputType.text,
        this.multiline = false,
        this.validator,
        this.valueGet,
        this.hideError=true,
        this.textVisible=true
      })
      : super(key: key){
    if(multiline) keyboard=TextInputType.multiline;
  }
  String text;
  TextEditingController? controller;
  bool enabled;
  bool hideError;
  bool textVisible;
  String placeholder;
  Widget? nextIcon;
  TextInputType keyboard;
  bool multiline;
  FormFieldValidator<String>? validator;
  ValueGet<String>? valueGet;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  ValueGet<String>? valueGet;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=widget.controller??controller;
    if(widget.valueGet!=null)controller.text = widget.valueGet!.value;
  }

  @override
  Widget build(BuildContext context) {
    valueGet??=widget.valueGet??ValueGet(initial: "");
    border(DefColor color)=>OutlineInputBorder(
        borderSide:
            BorderSide(width: 1, color: defaultColor(color)),
        borderRadius: BorderRadius.circular(14));
    return Stack(
      alignment: Alignment.center,
      children: [
        TextFormField(
          onChanged: (value)=>{
            if(widget.enabled)valueGet!.value=value,
          },
          obscureText: !widget.textVisible,
          // onEditingComplete: (){debugPrint("complete");},
          validator: widget.validator,
          keyboardType: widget.keyboard,
          maxLines: widget.multiline?5:1,
            autofocus: false,
            controller: widget.controller,
            style: defaultTextStyle(Fonts.body, color: DefColor.black),
            enabled: widget.enabled,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: widget.multiline?12:0, horizontal: 16),
              filled: true,
              fillColor: defaultColor(DefColor.white),
              border: border(DefColor.grayLight),
              disabledBorder: border(DefColor.grayLight),
              enabledBorder: border(DefColor.grayLight),
              focusedBorder:border(DefColor.blue),
              errorBorder: border(DefColor.red),
              errorStyle: const TextStyle(height: 0),
              hintText: widget.placeholder,
              hintStyle: defaultTextStyle(Fonts.body, color: DefColor.gray),
            )),
        widget.nextIcon!=null?Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: widget.nextIcon,
          ),
        ):Container()
      ],
    );
  }
}
