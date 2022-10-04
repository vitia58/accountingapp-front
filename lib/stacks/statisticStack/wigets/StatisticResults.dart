import 'package:buking_test/helpers/fontHelper.dart';
import 'package:buking_test/helpers/requestHelper.dart';
import 'package:buking_test/widgets/FutureLoader.dart';
import 'package:buking_test/widgets/PeriodHorizontalView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../helpers/otherHelper.dart';

class StatisticResults extends StatefulWidget {
  StatisticResults({Key? key, required this.period}) : super(key: key);
  PeriodResult period;

  @override
  State<StatisticResults> createState() => _StatisticResultsState();
}

class _StatisticResult {
  List<String>? earn;
  List<String>? lose;
  List<String>? dif;
  int? percent;

  _StatisticResult({this.earn, this.lose, this.percent});

  _StatisticResult.fromJson(Map<String, dynamic> json) {
    earn = splitPrice(json['earn'].toDouble());
    lose = splitPrice(json['lose'].toDouble());
    dif = splitPrice(double.parse(json['dif']),true);
    percent = json['percent'];
  }
}

class _StatisticResultsState extends State<StatisticResults> {
  Future<_StatisticResult?> _loadStatistic()=>
      axios.get("statistic/info",widget.period.toJson())
          .getObj(_StatisticResult.fromJson)
          .then((value) => value??_StatisticResult());
  @override
  Widget build(BuildContext context) {
    // String up =
    // splitPrice(item.amount);
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: loader(
        future: _loadStatistic(),
        loaded:(statistic)=>Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/up.svg"),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        "Доход",
                        style: defaultTextStyle(Fonts.body, color: DefColor.gray),
                      )
                    ],
                  ),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF42D336),
                            fontSize: 32,
                            fontFamily: "SFPro",
                          ),
                          children: [
                        TextSpan(text: statistic?.earn?[0]??"₴0"),
                        TextSpan(text: statistic?.earn?[1]??".00", style: const TextStyle(fontSize: 17))
                      ])),
                  // const Text("₴1,000,000.00",style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF42D336),fontSize: 28),textAlign: TextAlign.right,),
                  const Padding(padding: EdgeInsets.only(top: 16)),
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/down.svg"),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        "Расход",
                        style: defaultTextStyle(Fonts.body, color: DefColor.gray),
                      )
                    ],
                  ),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              textBaseline: TextBaseline.alphabetic,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFD63737),
                              fontSize: 32,
                              fontFamily: "SFPro"),
                          children: [
                        TextSpan(text: statistic?.lose?[0]??"₴0"),
                        TextSpan(text: statistic?.lose?[1]??".00", style: const TextStyle(fontSize: 17))
                      ])),
                ],
              ),
            ),
            const Divider(height: 0, color: Color.fromRGBO(227, 227, 227, 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/images/difference.svg"),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        "Разница",
                        style: defaultTextStyle(Fonts.body, color: DefColor.gray),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  textBaseline: TextBaseline.alphabetic,
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF222222),
                                  fontSize: 32),
                              children: [
                            TextSpan(text: statistic?.dif?[0]??"₴0"),
                            TextSpan(text: statistic?.dif?[1]??".00", style: const TextStyle(fontSize: 17))
                          ])),
                      Expanded(
                          child: Text("(${statistic?.percent??0}%)",
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 14, height: 1.66666)))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
