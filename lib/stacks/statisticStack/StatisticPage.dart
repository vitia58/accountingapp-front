import 'package:buking_test/stacks/statisticStack/settingsScreen/SettingsPage.dart';
import 'package:buking_test/stacks/statisticStack/wigets/chart.dart';
import 'package:buking_test/widgets/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/ValueGet.dart';
import '../../widgets/PeriodHorizontalView.dart';
import 'wigets/StatisticResults.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  PeriodResult periodResult = PeriodResult.byDays(7);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Статистика", context, right: SvgPicture.asset("assets/images/settings.svg",
          alignment: Alignment.topRight), onClick: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsPage(),
          ),
        ).then((value) => {
          debugPrint(value.toString())
        });
      }),
      body: Container(
        padding: const EdgeInsets.only(top: 14),
          color: const Color.fromRGBO(249, 249, 249, 1),
          child: ListView(
            cacheExtent: 10000,
            physics: const BouncingScrollPhysics(),
            children: [
              PeriodHorizontalView(valueGet: ValueGet(initial: periodResult,onChange: (value){
                setState(() {
                  periodResult=value;
                });
              })),
              StatisticResults(period: periodResult),
              ChartWidget(period: periodResult),
            ],
          )),
    );
  }
}
