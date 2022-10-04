import 'package:buking_test/helpers/otherHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../helpers/fontHelper.dart';
import '../../operationInfoScreen/AboutOperationPage.dart';

class OperationCard extends StatelessWidget {
  const OperationCard({Key? key, required this.item,required this.reloadListener}) : super(key: key);
  final OperationItem item;
  final void Function() reloadListener;

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(item.time);
    String formattedTime = DateFormat('kk:mm').format(time);
    List<String> splited = splitPrice(item.amount);
    debugPrint("${splited[0]};${splited[1]}");
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutOperationPage(id: item.id,),
            ),
          ).then((value) => {
            if(value=="reload")reloadListener()
          });
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: defaultTextStyle(Fonts.title2,color: DefColor.black)),
                  ),
                  Text(
                    formattedTime,
                    style: defaultTextStyle(Fonts.caption2,color: DefColor.gray),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            fontWeight: FontWeight.w500,
                            color:
                                Color(item.amount > 0 ? 0xFF42D336 : 0xFFD63737),
                            fontSize: 17,
                            fontFamily: "SFPro"),
                        children: [
                      TextSpan(text: splited[0]),
                      TextSpan(
                          text: splited[1], style: const TextStyle(fontSize: 12))
                    ])),
              ),
              Text(
                item.comment.isEmpty ? "Комментарий отсутсвует" : item.comment,
                style: defaultTextStyle(Fonts.caption1regular,color: item.comment.isEmpty?DefColor.gray:DefColor.black))
            ],
          ),
        ),
      ),
    );
  }
}

class OperationItem {
  late String id;
  late String name;
  late double amount;
  late String comment;
  late int time;

  OperationItem({this.id="", this.name="", this.amount=0, this.comment="", this.time=0});

  OperationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'].toDouble();
    comment = json['comment'];
    time = json['time'];
  }
}

