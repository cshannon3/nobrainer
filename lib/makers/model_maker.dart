


import 'package:flutter/material.dart';
import 'package:no_brainer/maps/my_models.dart';
import 'package:no_brainer/maps/my_widgets.dart';
// custom model from lib


String token = "_";
class CustomModel {
  // final Widget child;
  
  Map<String, dynamic> vars;
  var calls;
  CustomModel({
    this.vars,
    this.calls
  });
  CustomModel.fromLib(var data){
   // print("HEY");
    if (data is String){
      var info = data.contains("_")? data.split("_"): [data];
      vars = mymodelsLib[info[0]]["vars"](info.sublist(1));
      calls = mymodelsLib[info[0]]["functions"](this);
    }
    if (data is Map){
     // print("a");
      //print(data["name"]);
      //CustomModel.fromMap(data)
      vars = mymodelsLib[data["name"]]["vars"](data["vars"]);
 
      calls = mymodelsLib[data["name"]]["functions"](this);
 
    }
  }
    CustomModel.fromWidgetLib(var data){

      vars = mywidgetsLib[data["name"]]["vars"](data["vars"]);
      calls = mywidgetsLib[data["name"]]["functions"](this);
  }
  // CustomModel.fromWidgetLib(var data){
  //     vars = mywidgetsLib[data["name"]]["vars"](data["vars"]);
  //     calls = mywidgetsLib[data["name"]]["functions"](this);
  // }
  CustomModel.fromMap(var data){
      vars = data["vars"]({});
      calls = data["functions"](this);
  }



  // CustomModel.fromAPILib(var data){
  //     vars = mysLib[data["name"]]["vars"](data["vars"]);
  //     calls = mywidgetsLib[data["name"]]["functions"](this);
  // }

  List<CustomModel> listFromLib(var dataList) 
    => List<CustomModel>.generate(dataList.length, (i)=> CustomModel.fromLib(dataList[i]));
    
}
