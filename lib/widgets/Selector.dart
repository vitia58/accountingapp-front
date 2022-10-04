import 'package:buking_test/helpers/ValueGet.dart';
import 'package:buking_test/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/fontHelper.dart';
import 'FullScreenBottomSheet.dart';
import 'inputs/TextInput.dart';

class Selector extends StatefulWidget {
  Selector(
      {Key? key,
      List<String> items = const [],
      List<SelectListItem>? fullList,
      this.multiple = false,
      int initial = -1,
      this.title = "",
      this.placeholder = "",
      ValueGet<String>? valueGet,
      String Function(List<String> list)? getTitle})
      : super(key: key) {
    this.items =
        fullList ?? items.map((e) => SelectListItem(e, false, null)).toList();
    if (valueGet != null) this.valueGet = valueGet;
    if (initial != -1) {
      this.items[initial].selected = true;
      // valueGet!.value = [this.items[initial].text];
    }
    if (getTitle != null) this.getTitle = getTitle;
  }

  bool multiple;
  List<SelectListItem> items = [];
  String title = "";
  String placeholder = "";
  ValueGet<String> valueGet = ValueGet(initial: "");
  String Function(List<String> list) getTitle =
      (list) => list.isEmpty ? "" : list[0];

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  TextEditingController textEditingController = TextEditingController();
  List<SelectListItem>? items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      items = widget.items;
      textEditingController.text = widget.getTitle(items!
          .where((element) => element.selected)
          .map((e) => e.text)
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        showFullScreenBottomSheet(
            context,
            widget.title,
            _SelectBody(list: items!, onSelect: (selected) {
              if (!widget.multiple) {
                for (var element in items!) {
                  if (element.selected) element.selected = false;
                }
              }
              items![selected].selected = !items![selected].selected;
              widget.valueGet.value = widget.getTitle(items!
                  .where((element) => element.selected)
                  .map((e) => e.text)
                  .toList());
              textEditingController.text = widget.valueGet.value;
              setState(() {});
              return widget.multiple?items:null;
            },showButton: widget.multiple,)
        );
      },
      child: TextInput(
        placeholder: widget.placeholder,
        controller: textEditingController,
        enabled: false,
        nextIcon: SvgPicture.asset(
          "assets/images/next.svg",
          height: 20,
        ),
      ),
    );
  }
}
class _SelectBody extends StatefulWidget {
  _SelectBody({Key? key,required this.list,required this.onSelect,this.showButton=false}) : super(key: key);
  List<SelectListItem> list;
  List<SelectListItem>? Function(int index) onSelect;
  bool showButton;
  @override
  State<_SelectBody> createState() => _SelectBodyState();
}

class _SelectBodyState extends State<_SelectBody> {
  late List<SelectListItem> list;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list=widget.list;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 25, horizontal: 6),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (_, index) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    List<SelectListItem>? list = widget.onSelect(index);
                    if(list!=null){
                      setState(() {
                        this.list=list;
                      });
                    }else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                list[index].fullText,
                                style:
                                defaultTextStyle(Fonts.body, color: DefColor.black),
                              ),
                            ),
                          ),
                          list[index].selected
                              ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child:
                            SvgPicture.asset("assets/images/check_mark.svg"),
                          )
                              : Container()
                        ],
                      ),
                      Divider(
                        color: defaultColor(DefColor.grayLight),
                        thickness: 1,
                      )
                    ],
                  ),
                ),
              )),
        ),
        widget.showButton?CustomButton("Добавить",height: 44,onPress: Navigator.of(context).pop,enabled: list.any((element) => element.selected),):Container()
      ],
    );
  }
}


class SelectListItem {
  SelectListItem(this.text, this.selected,String? fullText){
    this.fullText=fullText??text;
  }

  String text;
  String fullText = "";
  bool selected;
  @override
  String toString() {
    // TODO: implement toString
    return "text:$text; isSelected:$selected";
  }
}