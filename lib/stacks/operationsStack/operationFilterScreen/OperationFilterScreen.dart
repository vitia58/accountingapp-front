import 'dart:convert';

import 'package:buking_test/helpers/ValueGet.dart';
import 'package:buking_test/stacks/operationsStack/operationFilterScreen/widgets/DatePickerScreen.dart';
import 'package:buking_test/stacks/operationsStack/widgets/OperationType.dart';
import 'package:buking_test/widgets/BottomView.dart';
import 'package:buking_test/widgets/Button.dart';
import 'package:buking_test/widgets/inputs/Field.dart';
import 'package:buking_test/widgets/inputs/TextInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../widgets/FullScreenBottomSheet.dart';
import '../../../widgets/PeriodHorizontalView.dart';
import '../../../widgets/Selector.dart';

Future<FilterResult?> showFilerScreen(BuildContext context) {
  return showFullScreenBottomSheet(context, "Фильтр", const _FilterOperationPage()).then<FilterResult?>((value) => value);
}

class _FilterOperationPage extends StatefulWidget {
  const _FilterOperationPage({Key? key}) : super(key: key);

  @override
  State<_FilterOperationPage> createState() => _FilterOperationPageState();
}

class _FilterOperationPageState extends State<_FilterOperationPage> {
  String category = "";
  String operationType = "Доход";
  String priceFrom = "";
  String priceTo = "";
  PeriodResult periodResult = PeriodResult.byDays(7);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BottomView(
      height: MediaQuery.of(context).viewInsets.bottom,
      bottom: CustomButton(
        "Сохранить",
        height: 44,
        enabled: (_formKey.currentState==null||_formKey.currentState!.validate()),
        onPress: (){
          Navigator.of(context).pop(FilterResult(periodResult, priceFrom, priceTo, operationType, category));
        },
      ),
      child: Column(
        children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Field(
                        fieldName: "Период",
                        child: PeriodHorizontalView(startWidget: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _showDateScreen,
                          child: Padding(padding: const EdgeInsets.only(right: 14),
                          child: SizedBox(height: 35, child: Center(child: SvgPicture.asset("assets/images/calendar.svg"))),),
                        ),valueGet: ValueGet(initial: periodResult,onChange: (v){periodResult=v;debugPrint("updateDate,$v");}),)),
                    Field(
                        fieldName: "Категория",
                        child: Selector(
                          items: const [
                            "Категория 1",
                            "Категория 2",
                            "Категория 3",
                            "Категория 4",
                            "Категория 5",
                            "Категория 6"
                          ],
                          getTitle: (List<String > list) => list.join(", "),
                          valueGet: ValueGet(
                              onChange: (v) {
                                setState(() {
                                  category = v;
                                });
                              },
                              initial: ""),
                          placeholder: "Выбрать категорию",
                          title: "Категория",
                          multiple: true,
                        )),
                    Field(
                        fieldName: "Тип операции",
                        child: OperationType(
                          valueGet: ValueGet(
                              onChange: (v) {
                                setState(() {
                                  operationType = v;
                                });
                              },
                              initial: "Доход"),
                        )),
                    Field(
                        fieldName: "Сумма",
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextInput(
                                  validator: (value){
                                    debugPrint(value);
                                    if(value=="")return null;
                                    return value==null||!RegExp(r'^\d+((\.|,)\d{1,2})?$')
                                            .hasMatch(value)||
                                        priceTo!=""&&double.parse("0${priceTo.replaceAll(",", ".")}")<=double.parse("0${value.replaceAll(",", ".")}")
                                        ? ""
                                        : null;
                                  },
                                  placeholder: "От",
                                  keyboard: TextInputType.number,
                                  valueGet: ValueGet(
                                      onChange: (v) {
                                        setState(() {
                                          priceFrom = v;
                                        });
                                      },
                                      initial: '')),
                            ),
                            const Padding(padding: EdgeInsets.all(7.5)),
                            Expanded(
                              flex: 1,
                              child: TextInput(
                                  validator: (value) {
                                    if(value=="")return null;
                                    return value==null||!RegExp(r'^\d+((\.|,)\d{1,2})?$')
                                        .hasMatch(value) ||
                                        double.parse(
                                            "0${value.replaceAll(",", ".")}") <=
                                            double.parse(
                                                "0${priceFrom.replaceAll(
                                                    ",", ".")}")
                                        ? ""
                                        : null;
                                  },
                                  placeholder: "До",
                                  keyboard: TextInputType.number,
                                  valueGet: ValueGet(
                                      onChange: (v) {
                                        setState(() {
                                          priceTo = v;
                                        });
                                      },
                                      initial: '')),
                            ),
                          ],
                        )),
                  ],
                ),
              )
        ],
      ),
    );
  }

  void _showDateScreen() {
    showDatePickerScreen(context).then<PeriodResult>((value) => value).then((value) => setState(() {
      periodResult=value;
    }));
  }
}
class FilterResult{
  FilterResult(this.periodResult,this.priceFrom,this.priceTo,this.operationType,this.category);

  PeriodResult periodResult;
  String category;
  String operationType;
  String priceFrom;
  String priceTo;
  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['category'] = category;
    data['operationType'] = operationType;
    data['priceFrom'] = priceFrom;
    data['priceTo'] = priceTo;
    data['periodResult'] = json.encode(periodResult);
    return data;
  }
}