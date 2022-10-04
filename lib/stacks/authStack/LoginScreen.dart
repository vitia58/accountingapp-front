import 'package:buking_test/helpers/ValueGet.dart';
import 'package:buking_test/helpers/requestHelper.dart';
import 'package:buking_test/widgets/Button.dart';
import 'package:buking_test/widgets/inputs/Field.dart';
import 'package:buking_test/widgets/inputs/TextInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/fontHelper.dart';
import '../../helpers/storageHelper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _AuthResult {
  String? password;
  String? accessToken;

  _AuthResult(Map<String, dynamic> json) {
    password = json['password'];
    accessToken = json['access_token'];
  }
  @override
  String toString() {
    // TODO: implement toString
    return "$password;$accessToken";
  }
}
class _LoginScreenState extends State<LoginScreen> {
  String login = "";
  String password = "";
  String? passwordError;
  bool passHide = true;
  int? height;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _saveToStorage(String accessToken) async {
    final prefs = await getPrefs();
    await prefs.setString('login', login);
    await prefs.setString('accessToken', accessToken);
  }

  void auth()async{
    _AuthResult? i = await axios.post("auth/login",{'login':login,'password':password}).getObj(_AuthResult.new);
    if(i==null)return;
    debugPrint(i.toString());
    setState(() {
      passwordError=i.password;
      if(_formKey.currentState?.validate()??false){
        accessToken=i.accessToken;
        _saveToStorage(i.accessToken!).then((value) => Navigator.pushNamedAndRemoveUntil(context,"/",(_)=>false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(height==null)height = MediaQuery.of(context).size.height.round();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: height!-MediaQuery.of(context).viewInsets.bottom.toInt(),
              child: Stack(
            children: [
              Positioned.fill(
                  child: Image.asset(
                "assets/images/loginBackground.png",
                fit: BoxFit.cover,
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    height: 30,
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          color: Colors.white),
                    )),
              )
            ],
          )),
          Expanded(
            flex: height!,
              child: Container(
            color: Colors.white,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      "Вход",
                      style:
                          defaultTextStyle(Fonts.title1, color: DefColor.black),
                    ),
                  ),
                  Field(
                      fieldName: "Логин",
                      child: TextInput(
                        placeholder: "Ваш логин",
                        valueGet: ValueGet(
                            initial: login,
                            onChange: (value) {
                              setState(() {
                                login = value;
                              });
                            }),
                      )),
                  Field(
                      fieldName: "Пароль",
                      bottom: passwordError==null?Container():Text(passwordError??"",style: defaultTextStyle(Fonts.caption1regular,color: DefColor.red),),
                      child: TextInput(
                        placeholder: "Введите пароль",
                        validator: (_)=>passwordError==null?null:"",
                        textVisible: !passHide,
                        nextIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              passHide = !passHide;
                            });
                          },
                          child: SvgPicture.asset(
                            passHide
                                ? "assets/images/eye.svg"
                                : "assets/images/eyeNot.svg",
                          ),
                        ),
                        valueGet: ValueGet(
                            initial: password,
                            onChange: (value) {
                              setState(() {
                                password = value;
                              });
                            }),
                      )),
                  CustomButton("Войти",font: Fonts.title2,height: 44,radius: 12,marginButton: EdgeInsets.symmetric(horizontal: 16),onPress: auth,)
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
