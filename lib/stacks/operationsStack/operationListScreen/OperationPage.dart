import 'package:buking_test/helpers/requestHelper.dart';
import 'package:buking_test/stacks/operationsStack/OperationListScreen/wigets/OperationCard.dart';
import 'package:buking_test/stacks/operationsStack/OperationListScreen/wigets/OperationDateSeparator.dart';
import 'package:buking_test/stacks/operationsStack/OperationListScreen/wigets/OperationHeader.dart';
import 'package:buking_test/stacks/operationsStack/operationFilterScreen/OperationFilterScreen.dart';
import 'package:buking_test/widgets/HeaderListView.dart';
import 'package:buking_test/widgets/inputs/TextInputWithClear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../widgets/Header.dart';
import '../operationCreateScreen/CreateOperationPage.dart';


class OperationPage extends StatefulWidget {
  const OperationPage({Key? key}) : super(key: key);

  @override
  State<OperationPage> createState() => _OperationPageState();
}

class _OperationPageState extends State<OperationPage> {

  FilterResult? result;
  String? searchText;

  List<OperationItem> operations = [];

  void _filterItems(FilterResult result) {
    // axios.get("operations/list",result.toJson()).getObj((v)=>v);
    setState(() {
      this.result=result;
    });
    _getItems();
  }

  @override
  void initState() {
    // TODO: implement initState
    _getItems();
    super.initState();
  }

  void _search(String text) {
    setState(() {
      searchText=text;
    });
    _getItems();
  }

  void _getItems(){
    Map<String, String> body = result?.toJson()??{};
    if(searchText!=null) body.addAll({"search":searchText!});
    axios.get("operations/list",body).getList(OperationItem.fromJson).then((value) => {
      setState(() {
        operations = value??[];
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Операции", context, right: SvgPicture.asset("assets/images/add.svg",
          alignment: Alignment.topRight),
      onClick: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateOperationPage(),
          ),
        ).then((value) => {
          debugPrint(value.toString()),
          result=null,
          searchText=null,
          if(value=="reload")_getItems()
        });
      }),
      body: Column(
        children: [
          TextInputWithClear(onSubmit: _search,),
          operations.isEmpty?OperationHeader(onChangeFilter:_filterItems):Container(),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              cacheExtent: 10000,
              physics: const BouncingScrollPhysics(),
              itemBuilder: listViewWithHeader((_,int index) => OperationCard(item: operations.elementAt(index),reloadListener:_getItems),
                header: operations.isEmpty?Container():OperationHeader(item: operations.first,onChangeFilter:_filterItems)
              ),
              separatorBuilder: (_, int index) => OperationDateSeparator(last: operations.elementAt(index+1),next: operations.elementAt(index)),
              itemCount: operations.length,
            ),
          ),
        ],
      ),
    );
  }
}
