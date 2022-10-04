import 'package:buking_test/helpers/fontHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'OperationCard.dart';

class OperationDateSeparator extends StatelessWidget {
  const OperationDateSeparator(
      {Key? key, required this.last, required this.next, this.isFirst = false})
      : super(key: key);
  final OperationItem last;
  final OperationItem next;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    DateTime lt = DateTime.fromMillisecondsSinceEpoch(last.time);
    DateTime nt = isFirst
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(next.time);
    String text = "";
    if (lt.day == nt.day &&
        lt.month == nt.month &&
        lt.year == nt.year) {
      if(isFirst) {
        text = "Сегодня";
      } else {
        return Container();
      }
    }
    DateTime yt = DateTime.now().subtract(const Duration(days: 1));
    if (lt.day == yt.day &&
        lt.month == yt.month &&
        lt.year == yt.year) {
      text = "Вчера";

    } else if(text!="Сегодня") {
      text = DateFormat("d MMMM yyyy", "ru").format(lt);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Center(
        child: Text(
          text,
          style: defaultTextStyle(Fonts.caption1regular, color: DefColor.gray),
        ),
      ),
    );
  }
}
