import 'package:buking_test/helpers/ValueGet.dart';
import 'package:buking_test/helpers/requestHelper.dart';
import 'package:buking_test/stacks/operationsStack/OperationListScreen/wigets/OperationCard.dart';
import 'package:buking_test/stacks/operationsStack/OperationListScreen/wigets/OperationDateSeparator.dart';
import 'package:buking_test/stacks/operationsStack/OperationListScreen/wigets/OperationHeader.dart';
import 'package:buking_test/stacks/operationsStack/widgets/OperationType.dart';
import 'package:buking_test/widgets/BottomView.dart';
import 'package:buking_test/widgets/Button.dart';
import 'package:buking_test/widgets/FutureLoader.dart';
import 'package:buking_test/widgets/HeaderListView.dart';
import 'package:buking_test/widgets/inputs/Field.dart';
import 'package:buking_test/widgets/inputs/TextInput.dart';
import 'package:buking_test/widgets/inputs/TextInputWithClear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../helpers/fontHelper.dart';
import '../../../widgets/FullScreenBottomSheet.dart';
import '../../../widgets/Header.dart';
import '../../../widgets/PeriodHorizontalView.dart';
import '../../../widgets/Selector.dart';

class AboutOperationPage extends StatefulWidget {
  AboutOperationPage({Key? key, required this.id}) : super(key: key);
  String id;

  @override
  State<AboutOperationPage> createState() => _AboutOperationPageState();
}

class AboutItem {
  String? operationName;
  String? category;
  String? operationType;
  String? sum;
  String? currency;
  String? comment;

  AboutItem(
      {this.operationName,
      this.category,
      this.operationType,
      this.sum,
      this.currency,
      this.comment});

  AboutItem.fromJson(Map<String, dynamic> json) {
    operationName = json['operationName'];
    category = json['category'];
    operationType = json['operationType'];
    sum = json['sum'];
    currency = json['currency'];
    comment = json['comment'];
  }

  @override
  String toString() {
    return "operationName = $operationName;\n"
        "category = $category;\n"
        "operationType = $operationType;\n"
        "price = $sum;\n"
        "currency = $currency;\n"
        "comment = $comment;";
  }
}

class _AboutOperationPageState extends State<AboutOperationPage> {
  Future<AboutItem> _load() => axios
      .get("operations/info/${widget.id}")
      .getObj(AboutItem.fromJson)
      .then((value) => value ?? AboutItem());
  String operationName = "";
  String category = "";
  String operationType = "Доход";
  String sum = "";
  String currency = "₴";
  String comment = "";
  bool buttonEnabled = false;
  bool loaded = false;
  bool clicked = false;
  int hash = 0;
  TextEditingController operationNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _update() async {
    if(!clicked){
      setState(() {
        clicked=true;
      });
      axios
          .post("operations/update/${widget.id}",{
        'operationName':operationName,
        'category':category,
        'operationType':operationType,
        'sum':sum,
        'currency':currency,
        'comment':comment
      })
          .getObj(UpdateOperationResult.fromJson)
          .then((value) {
        if(value?.result != null) {
          Navigator.pop(context,"reload");
        }else {
          setState(() {
            clicked=false;
          });
        }
      });
    }

  }

  int getHash(String operationName, String category, String operationType,
      String price, String currency, String comment) {
    return "$operationName;"
            "$category;"
            "$operationType;"
            "$price;"
            "$currency;"
            "$comment;"
        .hashCode;
  }

  @override
  void initState() {
    super.initState();
  }

  void delete() {
    showBottom(context, "Удалить операцию?", onclick: () {
      axios.delete("operations/${widget.id}").wait().then((value) => Navigator.pop(context,"reload"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Данные об операции", context,
          right: Text("Удалить",
              style: defaultTextStyle(Fonts.title2, color: DefColor.red)),
          onClick: delete),
      body: BottomView(
        height: MediaQuery.of(context).viewInsets.bottom,
        bottom: CustomButton(
          "Сохранить",
          height: 44,
          onPress: _update,
          enabled: (_formKey.currentState?.validate()??false) &&
              operationType.isNotEmpty &&
              category.isNotEmpty &&
              currency.isNotEmpty &&
              getHash(operationName, category, operationType, sum, currency,
                      comment) != hash&&!clicked,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            loader(future: _load(), loaded: getFields)
          ],
        ),
      ),
    );
  }

  Widget getFields(AboutItem item) {
    debugPrint(item.toString());
    if (!loaded) {
      loaded = true;
      operationName = item.operationName!;
      category = item.category!;
      operationType = item.operationType!;
      sum = item.sum!;
      currency = item.currency!;
      comment = item.comment!;
      hash = getHash(
          operationName, category, operationType, sum, currency, comment);
    }
    List<String> categories = [
      "Категория 1",
      "Категория 2",
      "Категория 3",
      "Категория 4",
      "Категория 5",
      "Категория 6"
    ];
    List<String> currencies = ["₴", "\$"];
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Field(
              fieldName: "Имя операции",
              child: TextInput(
                validator: (value) =>
                    value == null || value.isEmpty ? "" : null,
                placeholder: "Имя операции",
                controller: operationNameController,
                valueGet: ValueGet(
                    onChange: (v) {
                      setState(() {
                        operationName = v;
                      });
                    },
                    initial: item.operationName!),
              )),
          Field(
              fieldName: "Категория",
              child: Selector(
                items: categories,
                valueGet: ValueGet(
                    onChange: (v) {
                      setState(() {
                        category = v;
                      });
                    },
                    initial: ""),
                placeholder: "Выбрать категорию",
                title: "Категория",
                initial: categories.indexOf(item.category!),
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
                    initial: item.operationType!),
              )),
          Field(
              fieldName: "Сумма",
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: TextInput(
                        validator: (value) => value == null ||
                                !RegExp(r'^\d+((\.|,)\d{1,2})?$')
                                    .hasMatch(value)
                            ? ""
                            : null,
                        placeholder: "Введите сумму",
                        keyboard: TextInputType.number,
                        controller: priceController,
                        valueGet: ValueGet(
                            onChange: (v) {
                              setState(() {
                                sum = v;
                              });
                            },
                            initial: item.sum!)),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Selector(
                        fullList: [
                          SelectListItem("₴", (item.currency??"₴")=="₴", "Украинская гривна (₴)"),
                          SelectListItem("\$", (item.currency??"₴")=="\$", "Доллар США (\$)")
                        ],
                        initial: currencies.indexOf(item.currency!),
                        valueGet: ValueGet(
                            onChange: (v) {
                              setState(() {
                                currency = v;
                              });
                            },
                            initial: item.currency!),
                        title: "Валюта",
                        placeholder: "₴",
                      ),
                    ),
                  )
                ],
              )),
          Field(
              fieldName: "Комментарий",
              child: TextInput(
                  placeholder: "Ваш комментарий...",
                  controller: commentController,
                  multiline: true,
                  valueGet: ValueGet(
                      onChange: (v) {
                        setState(() {
                          comment = v;
                        });
                      },
                      initial: item.comment!))),
        ],
      ),
    );
  }
}
class UpdateOperationResult {
  String? result;

  UpdateOperationResult({this.result});

  UpdateOperationResult.fromJson(Map<String, dynamic> json) {
    result = json['result'];
  }
  @override
  String toString() {
    return "result: $result";
  }
}