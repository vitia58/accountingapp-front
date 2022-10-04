import 'dart:core';

List<String> splitPrice(double price,[bool isPlus=false]){
  List<String> splited = price.abs().toString().split(".");
  splited[0] =
  "${isPlus&&price!=0?price>0?"+":"-":""}₴${splited[0].replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ",")}";
  splited[1] = splited[1].length == 1 ? ".${splited[1]}0" : ".${splited[1]}";
  return splited;
}