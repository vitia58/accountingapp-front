import 'package:buking_test/helpers/ValueGet.dart';
import 'package:buking_test/helpers/requestHelper.dart';
import 'package:buking_test/stacks/operationsStack/widgets/OperationType.dart';
import 'package:buking_test/widgets/BottomView.dart';
import 'package:buking_test/widgets/Button.dart';
import 'package:buking_test/widgets/inputs/Field.dart';
import 'package:buking_test/widgets/inputs/TextInput.dart';
import 'package:flutter/material.dart';

import '../../../widgets/Header.dart';
import '../../../widgets/Selector.dart';


class CreateOperationPage extends StatefulWidget {
  const CreateOperationPage({Key? key}) : super(key: key);

  @override
  State<CreateOperationPage> createState() => _CreateOperationPageState();
}

class _CreateOperationPageState extends State<CreateOperationPage> {

  String operationName = "";
  String category = "";
  String operationType = "Доход";
  String sum = "";
  String currency = "₴";
  String comment = "";
  bool buttonEnabled = false;
  bool clicked = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    debugPrint("setState");
    bool valid =  _formKey.currentState!.validate();
    valid = valid && operationType.isNotEmpty;
    valid = valid && category.isNotEmpty;
    valid = valid && currency.isNotEmpty;
    super.setState(() {
      buttonEnabled=valid;
    });
  }

  void _create() async {
    if(!clicked){
      setState(() {
        clicked=true;
      });
    axios
        .post("operations/create",{
              'operationName':operationName,
              'category':category,
              'operationType':operationType,
              'sum':sum,
              'currency':currency,
              'comment':comment
            })
        .getObj(CreateOperationResult.fromJson)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Создать операцию", context),
      body: BottomView(
        height: MediaQuery.of(context).viewInsets.bottom,
        bottom: CustomButton("Сохранить",height: 44,
          enabled: (_formKey.currentState?.validate()??false) &&
            operationType.isNotEmpty &&
            category.isNotEmpty &&
            currency.isNotEmpty &&
            !clicked,
          onPress: _create,),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Field(fieldName: "Имя операции", child: TextInput(
                    validator: (value)=>value == null || value.isEmpty?"":null,
                    placeholder: "Имя операции",
                    valueGet: ValueGet(onChange: (v){
                      setState(() {
                        operationName=v;
                      });
                    }, initial: ''),
                  )),
                  Field(fieldName: "Категория", child: Selector(items: const [
                    "Категория 1",
                    "Категория 2",
                    "Категория 3",
                    "Категория 4",
                    "Категория 5",
                    "Категория 6"],valueGet: ValueGet(onChange: (v){
                    setState(() {
                      category=v;
                    });
                  },initial: ""),placeholder: "Выбрать категорию",title: "Категория",)),
                  Field(fieldName: "Тип операции", child: OperationType(valueGet: ValueGet(onChange: (v){
                    setState(() {
                      operationType=v;
                    });
                  },initial: "Доход"),)),
                  Field(fieldName: "Сумма", child: Row(
                    children: [
                      Expanded(flex: 10,child: TextInput(
                          validator: (value)=>value == null || !RegExp(r'^\d+((\.|,)\d{1,2})?$').hasMatch(value)?"":null,
                          placeholder: "Введите сумму",
                          keyboard: TextInputType.number,
                          valueGet: ValueGet(onChange: (v){
                            setState(() {
                              sum=v.replaceAll(",", ".");
                            });
                          }, initial: '')
                      ),),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Selector(fullList: [
                            SelectListItem("₴",true,"Украинская гривна (₴)"),
                            SelectListItem("\$",false,"Доллар США (\$)")],valueGet: ValueGet(onChange: (v){
                            setState(() {
                              currency=v;
                            });
                          },initial: "₴"),title: "Валюта",placeholder: "₴",),
                        ),
                      )
                    ],
                  )),
                  Field(fieldName: "Комментарий", child: TextInput(
                      placeholder: "Ваш комментарий...",
                      multiline: true,
                      valueGet: ValueGet(onChange: (v){
                        setState(() {
                          comment=v;
                        });
                      }, initial: '')
                  )),
                ],
              ),
            )],
        ),
      ),
    );
  }
}
class CreateOperationResult {
  String? result;
  String? id;

  CreateOperationResult({this.result, this.id});

  CreateOperationResult.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    id = json['id'];
  }
  @override
  String toString() {
    // TODO: implement toString
    return "id: $id; result: $result";
  }
}
