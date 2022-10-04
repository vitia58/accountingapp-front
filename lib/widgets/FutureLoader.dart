import 'package:flutter/material.dart';

FutureBuilder loader<T>({Future<T>? future,Widget Function(T value)? loaded}){
  return FutureBuilder(
      future: future,
      builder: (context,snapshot){
        if(snapshot.hasData){
          return loaded!(snapshot.data);
        }
        return Container(color: Colors.white,child: const Center(child: CircularProgressIndicator()),);
      });
}