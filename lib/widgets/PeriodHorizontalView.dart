import 'package:buking_test/helpers/ValueGet.dart';
import 'package:buking_test/widgets/HeaderListView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Button.dart';

DateFormat commonFormat = DateFormat("yyyy-MM-dd");

class PeriodHorizontalView extends StatefulWidget {
  PeriodHorizontalView({Key? key, this.startWidget, this.valueGet})
      : super(key: key);
  Widget? startWidget;
  ValueGet<PeriodResult>? valueGet;

  @override
  State<PeriodHorizontalView> createState() => _PeriodHorizontalViewState();
}

class _PeriodHorizontalViewState extends State<PeriodHorizontalView> {
  int selected = 0;
  List<_DefaultDurations> periods = [
    _DefaultDurations("Неделя","7days", 7),
    _DefaultDurations("Месяц","1month", 0, 1),
    _DefaultDurations("3 месяца","3month", 0, 3),
    _DefaultDurations("6 месяцев","6month", 0, 6),
    _DefaultDurations("год","12month", 0, 12),
  ];
  late ValueGet<PeriodResult> valueGet;

  @override
  void initState() {
    valueGet = widget.valueGet ??
        ValueGet(
            initial: periods[selected].days != 0
                ? PeriodResult.byDays(periods[selected].days)
                : PeriodResult.byMonth(periods[selected].month));
    selected = periods
        .indexWhere((element) => valueGet.value.type == element.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    func(_, index) => CustomButton(
          periods[index].name,
          flex: 0,
          marginButton: const EdgeInsets.symmetric(horizontal: 12),
          paddingButton:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          height: 35,
          transparent: selected != index,
          onPress: () {
            setState(() {
              selected = index;
              valueGet.value = periods[selected].days != 0
                  ? PeriodResult.byDays(periods[selected].days)
                  : PeriodResult.byMonth(periods[selected].month);
            });
          },
        );
    return SizedBox(
      height: 35,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: periods.length,
          itemBuilder: widget.startWidget == null
              ? func
              : listViewWithHeader(func,
                  isColumn: false, header: widget.startWidget)),
    );
  }
}

class _DefaultDurations {
  _DefaultDurations(this.name,this.type, this.days, [this.month = 0]);

  String name;
  String type;
  int days;
  int month;
}

class PeriodResult {
  PeriodResult({required this.from, required this.to, this.type = "custom"});

  static PeriodResult byDays(int days) {
    DateTime time = DateTime.now();
    return PeriodResult(
        from: commonFormat.format(time.subtract(Duration(days: days-1))),
        to: commonFormat.format(time.add(const Duration(days: 1))),
        type: "${days}days");
  }

  static PeriodResult byMonth(int month) {
    DateTime time = DateTime.now();
    return PeriodResult(
        from: commonFormat
            .format(DateTime(time.year, time.month - month, time.day+1)),
        to: commonFormat.format(time.add(const Duration(days: 1))),
        type: "${month}month");
  }

  String from;
  String to;
  String type;

  Map<String, dynamic> toJson() {
    final Map<String, String> data = <String, String>{};
    data['from'] = from;
    data['to'] = to;
    data['type'] = type;
    return data;
  }
}
