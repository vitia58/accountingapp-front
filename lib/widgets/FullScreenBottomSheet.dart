import 'package:buking_test/helpers/fontHelper.dart';
import 'package:buking_test/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future showFullScreenBottomSheet(
    BuildContext context, String title, Widget widget,
    {Widget? bottom, Object? Function()? onCloseResult}) {
  return showMaterialModalBottomSheet(
      duration: const Duration(milliseconds: 450),
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: Colors.white),
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context)
                              .pop((onCloseResult ?? () => null)());
                        },
                        child: SizedBox(
                            height: 22,
                            width: 50,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: SvgPicture.asset(
                                    "assets/images/back.svg")))),
                    Expanded(
                        child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style:
                          defaultTextStyle(Fonts.title2, color: DefColor.black),
                    )),
                    const SizedBox(width: 50)
                  ],
                ),
                Expanded(
                  child: widget,
                ),
                bottom ?? Container()
              ],
            ),
          ));
}

void showBottom(BuildContext context, String question,
    {String buttonText = "Удалить", void Function()? onclick}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
            height: 200,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        color: getColor("#F8F8F8D1"),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 10, right: 10, bottom: 10),
                            child: Text(
                              question,
                              style: defaultTextStyle(Fonts.caption1regular,
                                  color: DefColor.gray),
                            ),
                          ),
                          const Divider(
                            height: 0,
                          ),
                          CustomButton(
                            buttonText,
                            transparent: true,
                            textColor: DefColor.red,
                            font: Fonts.body,
                            height: 57,
                            radius: 13,
                            onPress: (){
                              Navigator.of(context)
                                  .pop();
                              onclick!();
                            },
                          ),
                        ],
                      )),
                ),
                CustomButton("Отмена",
                    onPress: () {
                      Navigator.of(context)
                          .pop();
                    },
                    textColor: DefColor.blue,
                    height: 57,
                    font: Fonts.title2,
                    backgroundColor: "#FFFFFF",
                    radius: 13,
                    marginButton:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
              ],
            ),
          ));
}
