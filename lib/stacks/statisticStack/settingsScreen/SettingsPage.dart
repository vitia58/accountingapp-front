import 'package:buking_test/helpers/requestHelper.dart';
import 'package:buking_test/widgets/Header.dart';
import 'package:buking_test/widgets/inputs/Field.dart';
import 'package:flutter/material.dart';

import '../../../helpers/ValueGet.dart';
import '../../../helpers/fontHelper.dart';
import '../../../helpers/storageHelper.dart';
import '../../../widgets/Button.dart';
import '../../../widgets/FullScreenBottomSheet.dart';
import '../../../widgets/Selector.dart';
import '../../../widgets/inputs/TextInput.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String login="";
  String language="";
  TextEditingController loginController = TextEditingController();
  int initHash=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await getPrefs();
    setState(() {
      login = (prefs.getString('login') ?? login);
      language = (prefs.getString('language') ?? language);
      debugPrint("$login $language");
      initHash="$login;$language".hashCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Настройки", context,
          right: Text("Удалить аккаунт",
              style: defaultTextStyle(Fonts.title2, color: DefColor.red)),
          onClick: delete),
      body: initHash==0?Container():Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Field(
              fieldName: "Логин",
              child:TextInput(
                // validator: (value) =>
                // value == null || value.isEmpty ? "" : null,
                enabled: false,
                controller: loginController,
                placeholder: "Логин",
                valueGet: ValueGet(
                    onChange: (v) {
                      setState(() {
                        login = v;
                      });
                    },
                    initial: login),
              )
          ),
          Field(
              fieldName: "Язык",
              child:Selector(items: const [
                "Руский",],valueGet: ValueGet(onChange: (v){
                setState(() {
                  language=v;
                });
              },initial: language),placeholder: "Выбирете язык",title: "Язык",initial: 0,)
          ),
          Expanded(child: Container()),
          CustomButton(
            "Сохранить",
            height: 44,
            enabled: login.isNotEmpty&&language.isNotEmpty&&"$login;$language".hashCode!=initHash,
            onPress: _save,
          )
        ],
      ),
    );
  }

  void delete() {
    showBottom(context, "Удалить аккаунт?", onclick: () {
      debugPrint("Delete account");
      getPrefs()
          .then((prefs)=>prefs.remove("accessToken"))
          .then((value) => axios.post("auth/logout").wait())
          .then((value) => Navigator.pushNamedAndRemoveUntil(context,"/login",(_)=>false));
    });
  }

  void _save() {
    Future.wait([_saveToStorage()]).then((value) => Navigator.of(context).pop());
  }
  Future<void> _saveToStorage() async {
    final prefs = await getPrefs();
    await prefs.setString('language', language);
  }
}
