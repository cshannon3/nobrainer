
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/maps/default_enums.dart';
import 'package:no_brainer/utils/checks.dart';
import 'package:no_brainer/utils/main_animator.dart';
import 'package:no_brainer/utils/main_painter.dart';
import 'package:no_brainer/utils/parser.dart';
import 'package:no_brainer/utils/random.dart';

Map<String, dynamic> widgetLib = {
  "animator":(var tokens) {
    return MainAnimator(
      model: (ifIs(tokens, "model") is CustomModel)?tokens["model"]:null,
      models: (ifIs(tokens, "models") is List<CustomModel>)?tokens["models"]:null,
    );
  },
  "painter":(var tokens) {
    return MainPainter(
      model: (ifIs(tokens, "model") is CustomModel)?tokens["model"]:null,
      models: (ifIs(tokens, "models") is List<CustomModel>)?tokens["models"]:null,
    );
  },
  "editable":(var tokens){

  },
  "stack": (var tokens) {
    return Stack(children: ifIs(tokens, "children") ?? []);
  },
  "align": (var tokens) {
    return Align(
        alignment: ifIs(tokens, "alignment") ?? Alignment.center,
        child: ifIs(tokens, "child"));
  },
  "boxDec": (var tokens) {
    return BoxDecoration(
        color: parseMap["color"](tokens),
        border: Border.all(color: Colors.black, width: 2.0));
  },
  "card": (var tokens) {
    return Card(child: ifIs(tokens, "child"));
  },
  "center": (var tokens) {
    return Center(
      child: ifIs(tokens, "child")??Container(),
    );
  },
  "column": (var tokens) {
    return Column(
      mainAxisAlignment: getMainAlign(tokens),
      children: ifIs(tokens, "children"));
  },
  "container": (var tokens) {
    return Container(
      height: parseMap["height"](tokens),
      width: parseMap["width"](tokens),
      //color: parseMap["color"](tokens),
      child: ifIs(tokens, "child"),
      decoration: BoxDecoration(
        color: parseMap["color"](tokens),
        border: tokens.containsKey("bColor")?
            Border.all(
              color: tryParse(tokens, ["bColor"], type: "color")??Colors.black, 
              width:tryParse(tokens, ["bWidth", "bw"])??1.0
              )
              :null,
        shape: (tokens.containsKey("shape") && tokens["shape"]=="circle")?BoxShape.circle:BoxShape.rectangle,
        borderRadius: tokens.containsKey("bRadius")?new BorderRadius.all(new Radius.circular(parseToken(tokens["bRadius"]))):null,
      )
      //tokens.containsKey("boxDec") ? tokens["boxDec"] : null,
    );
  },
  "dropdown": (var tokens) {
    //print(tokens);
    var str= ifIs(tokens, "items")??[""];
    return DropdownButton<String>(
      value: ifIs(tokens, "value")??"",
     // icon: ifIs(tokens, "icon"),//iconSize: ,elevation: ,
     // style: ifIs(tokens, "style"),//underline: ,
      items: str.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
      onChanged: ifIs(tokens, "onChange")?? (String newVal){},
    );
  },
  
  "expanded": (var tokens) => Expanded(child: ifIs(tokens, "child")),
  "expansionTile": (var tokens) {

    return ExpansionTile(
      title: ifIs(tokens, "title"),
    //  subtitle: ifIs(tokens, "sub"),
      children: ifIs(tokens, "children")??[],
    );
  },
  "floatingActionButton": (var tokens) => FloatingActionButton(
        tooltip: ifIs(tokens, "tip"),
        backgroundColor: parseMap["color"](tokens),
        child: ifIs(tokens, "child"),
        onPressed: tryParse(tokens, ["onTap", "onPress", "onPressed"],
                parseType: false) ??
            () {},
      ),

  "fractionalTranslation": (var tokens) => FractionalTranslation(
      translation: Offset(
        tryParse(tokens, ["top", "up"]) ??
            -tryParse(tokens, ["bottom", "down", "d"]) ??
            0.0,
        tryParse(tokens, ["left", "l"]) ??
            -tryParse(tokens, ["right", "r"]) ??
            0.0,
      ),
      child: ifIs(tokens, "child")),
  //flex:parseMap["flex"](tokens)??1), // checkMultNames(tokens, ["flex", "f"]));

  //flex:parseMap["flex"](tokens)??1), // checkMultNames(tokens, ["flex", "f"]));
  "icon": (var tokens) => Icon(ifIs(tokens, "icon")),
  "inkWell": (var tokens) {
    return InkWell(
      child: ifIs(tokens, "child") ?? Container(),
      onTap: tryParse(tokens, ["onTap", "onPress", "tap"], parseType: false),
    );
  },
  "listView": (var tokens) {
    //print(children);
    return ListView(children: ifIs(tokens, "children"));
  },

  "padding": (var tokens) {
    return Padding(padding: getPadding(tokens), child: ifIs(tokens, "child"));
  },
  "positioned": (var tokens) {
    
    return Positioned(
        left: parseMap["left"](tokens) ?? 0.0,
        top: parseMap["top"](tokens) ?? 0.0,
        width: parseMap["width"](tokens) ?? 0.0,
        height: parseMap["height"](tokens) ?? 0.0,
        child: ifIs(tokens, "child"));
  },
    "text": (var tokens) {
    return Text(
     ifIs(tokens, "text")??"Hello",
    );
  },
  "richText": (var tokens) {
    return RichText(
      text: ifIs(tokens, "text") ?? TextSpan(),
    );
  },
  "tabBar": (var tokens) {
    return TabBar(
     tabs: ifIs(tokens, "tabs")
    );
  },
  "tabBarView": (var tokens) {
    return TabBarView(
      children: ifIs(tokens, "children")
    );
  },
  "textField": (var tokens) {
    return TextField(
      controller:ifIs(tokens, "controller"),
      keyboardType: TextInputType.multiline,
      maxLines: null,
    );
  },
  "textSpan": (var tokens) {
    return TextSpan(
        text: ifIs(tokens, "text") ?? "",
        children: ifIs(tokens, "children"),
        style: // ifIs(tokens, "style"),
            TextStyle(
                fontSize: 16.0, //tryParse(tokens, ["fontSize", "size"])??16.0,
                fontStyle: FontStyle
                    .normal, //(tokens.containsKey("fontStyle")&& (tokens["fontStyle"]=="italic"))?FontStyle.italic:FontStyle.normal,
                fontWeight: FontWeight
                    .normal, //(tryParse(tokens, ["fontWeight", "weight", "fw", "w"], parseType: false)=="bold")?FontWeight.bold:FontWeight.normal,
                color: Colors.black //["color"](tokens),
                ));
  },
  "textStyle": (var tokens) {
    return TextStyle(
        fontSize: 16.0, //tryParse(tokens, ["fontSize", "size"])??16.0,
        fontStyle: FontStyle
            .normal, //(tokens.containsKey("fontStyle")&& (tokens["fontStyle"]=="italic"))?FontStyle.italic:FontStyle.normal,
        fontWeight: FontWeight
            .normal, //(tryParse(tokens, ["fontWeight", "weight", "fw", "w"], parseType: false)=="bold")?FontWeight.bold:FontWeight.normal,
        color: Colors.black //["color"](tokens),
        );
  },

  "row": (var tokens) {
    return Row(
      mainAxisAlignment: getMainAlign(tokens),
      children: ifIs(tokens, "children") ?? []
      );
  },
  "sizedBox": (var tokens) {
    return SizedBox(
        width: parseMap["width"](tokens) ?? 0.0,
        height: parseMap["height"](tokens) ?? 0.0,
        child: ifIs(tokens, "child"));
  },
  "rcb": (var tokens) => RandomColorBlock(
      width: parseMap["width"](tokens),
      height: parseMap["height"](tokens),
      opacity: tryParse(tokens, ["opacity", "o"]) ?? 1.0,
      child: ifIs(tokens, "child") ?? Container()),
  "raisedButton": (var tokens){
   // print(tokens);
    return RaisedButton(
      onPressed:tryParse(tokens, ["onPressed", "onPress", "tap"], parseType: false)??(){},
      child: ifIs(tokens, "child") ?? Container());
  },
  "image":(var tokens){
   // print(tokens);
   //print(tokens);
   var path = ifIs(tokens, "path");
   if(path is String &&!path.contains("images"))path= "assets/images/"+path;
   var url = ifIs(tokens, "url");
   var fit = ifIs(boxFits, ifIs(tokens, "fit"));
    return (path!=null)?
    Image.asset(path, fit: fit,):
    url!=null?
    Image.network(url, fit: fit,):Container();

  },
  

};

