import 'package:buking_test/helpers/fontHelper.dart';
import 'package:buking_test/helpers/requestHelper.dart';
import 'package:buking_test/stacks/authStack/LoginScreen.dart';
import 'package:buking_test/stacks/operationsStack/OperationListScreen/OperationPage.dart';
import 'package:buking_test/stacks/statisticStack/StatisticPage.dart';
import 'package:buking_test/widgets/FutureLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting("ru");
  runApp(const Auth());
}
class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loader(
        future: loadAccessToken().then((accessToken) => accessToken!=null),
        loaded: (value)=>MaterialApp(
          title: "flutter",
          routes: {
            '/':(_)=>const HomePage(),
            '/login':(_)=>const LoginScreen()
          },
          initialRoute: value?'/':'/login',
        ));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    StatisticPage(),
    OperationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: defaultTextStyle(Fonts.caption1regular,color: DefColor.gray),
        unselectedLabelStyle: defaultTextStyle(Fonts.caption1regular,color: DefColor.gray),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/statistic_icon_inactive.svg"),
            activeIcon: SvgPicture.asset("assets/images/statistic_icon_active.svg"),
            label: 'Статистика',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/images/operations_icon_inactive.svg"),
            activeIcon: SvgPicture.asset("assets/images/operations_icon_active.svg"),
            label: 'Операции',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        selectedItemColor: getColor("456BF1"),
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

