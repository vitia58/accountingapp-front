import 'package:buking_test/stacks/operationsStack/operationFilterScreen/OperationFilterScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../widgets/Button.dart';
import 'OperationCard.dart';
import 'OperationDateSeparator.dart';

class OperationHeader extends StatefulWidget {
  const OperationHeader({Key? key, this.item, required this.onChangeFilter}) : super(key: key);
  final OperationItem? item;
  final void Function(FilterResult result) onChangeFilter;

  @override
  State<OperationHeader> createState() => _OperationHeaderState();
}

class _OperationHeaderState extends State<OperationHeader> {
  bool selectedFilter=false;
  @override
  Widget build(BuildContext context) {
    OperationItem defItem = OperationItem(name:"",amount:0,comment: "",time:DateTime.now().millisecondsSinceEpoch);
    return Column(
      children: [
        CustomButton(
          "Фильтр${selectedFilter?" (3)":""}",
          icon: SvgPicture.asset("assets/images/filter_icon.svg"),
          // paddingText: const EdgeInsets.symmetric(horizontal: 8),
          onPress: () {
            showFilerScreen(context).then((FilterResult? result) => {
              selectedFilter = true,
              if(result!=null){
                widget.onChangeFilter(result)
              }
            });
          },
          marginButton: const EdgeInsets.all(16),
        ),
        OperationDateSeparator(last: widget.item??defItem, next: defItem,isFirst: true,)
      ],
    );
  }
}
