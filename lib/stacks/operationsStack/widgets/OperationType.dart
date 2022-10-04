import 'package:flutter/material.dart';
import 'package:buking_test/helpers/fontHelper.dart';
import 'package:buking_test/widgets/Button.dart';

import '../../../helpers/ValueGet.dart';

class OperationType extends StatefulWidget {
  OperationType({Key? key, this.valueGet}) : super(key: key);
  ValueGet<String>? valueGet;

  @override
  State<OperationType> createState() => _OperationTypeState();
}

class _OperationTypeState extends State<OperationType> {
  ValueGet<String>? valueGet;
  @override
  Widget build(BuildContext context) {
    valueGet ??= widget.valueGet??ValueGet(initial: "Доход");
    return Container(
      decoration: BoxDecoration(
          color: defaultColor(DefColor.white),
          border: Border.all(color: defaultColor(DefColor.grayLight), width: 1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
              child: CustomButton(
            "Доход",
            marginButton: EdgeInsets.all(0),
            font: valueGet!.value == "Доход"
                ? Fonts.caption1semibold
                : Fonts.caption1regular,
            transparent: valueGet!.value != "Доход",
            onPress: () {
              setState(() {
                valueGet!.value = "Доход";
              });
            },
          )),
          Expanded(
              child: CustomButton(
            "Расход",
            marginButton: EdgeInsets.all(0),
            font: valueGet!.value == "Расход"
                ? Fonts.caption1semibold
                : Fonts.caption1regular,
            transparent: valueGet!.value != "Расход",
            onPress: () {
              setState(() {
                valueGet!.value = "Расход";
              });
            },
          )),
        ],
      ),
    );
  }
}
