import 'package:buking_test/helpers/fontHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TextInputWithClear extends StatefulWidget {
  TextInputWithClear({Key? key, required this.onSubmit}) : super(key: key);
  void Function(String) onSubmit;
  @override
  State<TextInputWithClear> createState() => _TextInputWithClearState();
}

class _TextInputWithClearState extends State<TextInputWithClear> {
  TextEditingController controller = TextEditingController();
  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    var border = OutlineInputBorder(
        borderSide: const BorderSide(width: 0, color: Colors.transparent),
        borderRadius: BorderRadius.circular(14));
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: false,
                controller: controller,
                style: defaultTextStyle(Fonts.body, color: DefColor.black),
                onChanged: (value) {
                // controller.text = value;
                  if(value.isEmpty!=isEmpty){
                    setState(() {
                      isEmpty = value.isEmpty;
                    });
                  }
                },
                onSubmitted: widget.onSubmit,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  filled: true,
                  fillColor: getColor("#8E8E931F"),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                  prefixIcon: Icon(Icons.search,color: defaultColor(DefColor.gray),),
                  hintText: 'Поиск',
                  hintStyle: defaultTextStyle(Fonts.body, color: DefColor.gray),
                  suffixIcon: isEmpty
                      ? null
                      : IconButton(
                          onPressed: (){
                            controller.clear();
                            if(!isEmpty){
                              setState(() {
                                isEmpty = true;
                              });
                            }
                            widget.onSubmit("");
                          },
                          icon: SvgPicture.asset("assets/images/clear.svg"),
                        ),
                )),
          ),
          isEmpty
              ? Container()
              : GestureDetector(

            behavior: HitTestBehavior.translucent,
            onTap: (){
              controller.clear();
              if(!isEmpty){
                setState(() {
                  isEmpty = true;
                });
              }
              widget.onSubmit("");
            },
            child: Padding(
            padding: EdgeInsets.only(left: 12,top: 5,bottom: 5),
            child: Text(
                "Отменить",
                style: defaultTextStyle(Fonts.caption1regular,
                    colorHex: "#0C6BFF"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
