import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../widgets/Button.dart';

import '../../../../widgets/FullScreenBottomSheet.dart';
import '../../../../widgets/PeriodHorizontalView.dart';

Future showDatePickerScreen(BuildContext context) {
  return showFullScreenBottomSheet(context, "Выбор даты", const _DatePickerScreen());
}

class _DatePickerScreen extends StatefulWidget {
  const _DatePickerScreen({Key? key}) : super(key: key);

  @override
  State<_DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<_DatePickerScreen> {
  String? from;
  String? to;
  bool buttonEnable = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: SfDateRangePicker(
            view: DateRangePickerView.month,
            monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
            selectionMode: DateRangePickerSelectionMode.range,
            onSelectionChanged: (selected){
              var value = selected.value;
              debugPrint(selected.value.toString());
              setState(() {
                if(value.startDate!=null)from=value.startDate.toString().split(" ")[0];
                if(value.endDate!=null)to=value.endDate.toString().split(" ")[0];
              });
            },
          ),
        ),
        Expanded(child: Container()),
        CustomButton(
          "Выбрать",
          height: 44,
          enabled: from!=null&&to!=null,
          onPress: (){
            Navigator.of(context).pop(PeriodResult(from: from!,to: to!));
          },
        )
      ],
    );
  }
}
