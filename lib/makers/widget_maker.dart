import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/maps/default_widgets.dart';
import 'package:no_brainer/maps/my_widgets.dart';
import 'package:no_brainer/utils/checks.dart';
// import 'package:portfolio3/utils/dynamic_parsers.dart';
// import 'package:portfolio3/utils/random.dart';
// import 'package:portfolio3/utils/utils.dart';

class CustomWidget2 {
  Map<String, dynamic> lib;
  var calls;
  var tempLib={};
  var _screenH;
  var _screenW;
  Function _setState;


  CustomWidget2({
    this.lib, 
    this.calls
  });
    List tokenize(String dataStr){
      if(!dataStr.contains("(") || dataStr[0]=="*")return [dataStr];
      var parIn = [];var parOut =[];
      for (int i=0; i<dataStr.length; i++){
        if (dataStr[i]=="(")parIn.add(i);
        else if (dataStr[i]==")")parOut.add(i);
      }
      var end; // Get list of all tokens  // if only one set of par return list spliting it
      if(parIn.length==1&& parOut.length==1)end = parOut[0];
      else{
        int u =1; // if multiple want to find the end par that matches the first par, do so by iterating par list until parout>parin-1 ()()
        while ((u+1<parIn.length && u<parOut.length) && (parIn[u]<parOut[u-1]))
            u++;
        end = parOut[u-1];
        if(parIn[u]<end)end=parOut.last;
      }
      var name =dataStr.substring(0, parIn[0]);
      var info =dataStr.substring(parIn[0]+1,end);
      var components = [name, info];
      if(dataStr.length>parOut[0]+1)components.add(dataStr.substring(end+1));
      return components;
  }
 
  List<Widget> splitList(String dataStr){
    if(dataStr=="")return[];
    if(dataStr.trim()[0]=="[")
        dataStr = dataStr.substring(dataStr.indexOf("[")+1,dataStr.contains("]")?dataStr.lastIndexOf("]"):dataStr.length);
   var splitAllCommas = trimList(dataStr.split(","));
    var childrenWidgetStrs=[];
    int nestedLayer=0;
    bool inPlainText=false;
    for(int y=0;y<splitAllCommas.length;y++){  // if at highest layer, then it should be split otherwise add
        if(nestedLayer==0 && !inPlainText) childrenWidgetStrs.add(splitAllCommas[y]);//;print(splitAllCommas[y]);}
        else childrenWidgetStrs.last+=","+splitAllCommas[y];
        if(splitAllCommas[y].contains("**"))"**".allMatches(splitAllCommas[y]).forEach((f){inPlainText=!inPlainText;});
        // update layerof next split
        if(splitAllCommas[y].contains("]")) nestedLayer-="]".allMatches(splitAllCommas[y]).length;
        if(splitAllCommas[y].contains("["))  nestedLayer+="[".allMatches(splitAllCommas[y]).length;
    }//print("OUT"); //print(out);
    List<Widget> widg=[];
    childrenWidgetStrs.forEach((widgetDataStr){
      if(widgetDataStr!=""){
        var w= toWidget(dataStr: widgetDataStr);
        if(w is List<Widget>)widg.addAll(w);
        else widg.add(w);
      }
    });
    return widg;
  }



  dynamic tokensToMap(dynamic tok, Map map){
    //print("tok"); [l:75_r:90_t:5_b:100_h:@h(frac:0.5)_w:800]
    // Splits tokens so that no nested tokens get parsed
        var nestedTokensList= tok;
        while(nestedTokensList.last.contains("(")){
          //print("TOK LAST");//l:75_r:90_t:5_b:100_h:@h(frac:0.5)_w:800
          var outerInnerTokens=tokenize(nestedTokensList.last);
          //print("Y"); //[l:75_r:90_t:5_b:100_h:@h, frac:0.5, _w:800]
          nestedTokensList.last=outerInnerTokens[0];//
          if(outerInnerTokens.length>1)nestedTokensList.addAll(outerInnerTokens.sublist(1));
        }
        //end with a list where every other item is an inner layer
        var tokenNameValStrs;
        var i=0;
        try{
          while(nestedTokensList.length>i){
            if(i>0){
              var nameValPair = trimList(tokenNameValStrs.last.split(":"));
              map[nameValPair[0]]+= "("+nestedTokensList[i]+")";
              i++;
            }
            if(nestedTokensList.length>i){
              tokenNameValStrs = trimList(nestedTokensList[i].split("_"));
                for(int r=0; r<tokenNameValStrs.length;r++){
                  var nameValPair = trimList(tokenNameValStrs[r].split(":"),skipEmpty:false);
                  if(nameValPair[0]!=""){
                    if(nameValPair.length<2)nameValPair.add("");
                    map[nameValPair[0]]=nameValPair[1];
                }
              }
            }
            i++;
          }
        }catch(e){}
        return map;
  }

dynamic toWidget(
      {var dataStr, var libIn, var children, var screenH, var screenW, Function setState}) {
        if (setState!=null ) _setState=setState;
        if (screenH!=null ) _screenH=screenH;
        if (screenW!=null ) _screenW=screenW;
        if(lib==null)lib={};
        if(libIn!=null)tempLib=libIn;
        if(calls==null)calls={}; // if(libIn!=null)libIn.forEach((key, val){lib[key]=val;});
        var stems=[];
        Map<String, dynamic> map={"screenH":_screenH, "screenW":_screenW, "setState":setState};
        
    if (dataStr is String) {
        // stems[0] is the widget name, stems[1] is whats inside the paren, stems[2] the child/children data
        stems =tokenize(dataStr);
      //  print(stems);
         // PARSING INSIDE
      if(stems.length>1 && stems[1]!=""){
        map= tokensToMap([stems[1]], map);// print("MAP");// print(map);
        map.forEach((k,v){
          if(v is String && (v.contains("(") || v.contains("@"))&& v[0]!="(" ){// Parsing any widgets inside the map
            map[k]=toWidget(dataStr: v);
          }
        });
      }

      if(children is List<Widget> ||children is List<TextSpan>)map["children"]=children;
      if(children is Widget || children is TextSpan)map["child"]=children;
     
     // PARSING CHILD/ CHILDREN 
     if(stems.length>2 && stems[2].trim()!=""){ 
       stems[2]= stems[2].trim();
       if(stems[2][0]=="["){
         // get children // splitList2(stems[2]);
        map["children"]=splitList(stems[2]);
        children=map["children"];
       }
       else if (stems[2][0]=="~"){
         // get child
         map["child"]=toWidget(dataStr:stems[2].substring(1), children: children);
         children=map["child"];
       }else if(stems[2].contains("(")){
         var possibleChild= stems[2].substring(0,stems[2].indexOf("("));
         if(widgetLib.containsKey(possibleChild) || mywidgetsLib.containsKey(possibleChild)){
            map["child"]=toWidget(dataStr:stems[2], children: children);
            children=map["child"];
         }
       }
     }

      String widgetName = stems[0].trim();
     // print(widgetName);
     if(widgetName[0]=="@"){
       if (lib.containsKey(widgetName.substring(1)))
          return lib[widgetName.substring(1)];
        if (tempLib.containsKey(widgetName.substring(1))){
        //  print(widgetName); // print(widgetName.substring(1));// print(tempLib[widgetName.substring(1)]);
         return tempLib[widgetName.substring(1)];
        }
      if (calls.containsKey(widgetName.substring(1)))
        return calls[widgetName.substring(1)](map);
     }

      if (widgetLib.containsKey(widgetName)) {
          //print(widgetName); print(map);
          return widgetLib[widgetName](map);
        } 
        else if (mywidgetsLib.containsKey(widgetName)) {
         // print(widgetName); print(map);
          CustomModel c = CustomModel.fromWidgetLib(
              {"name": widgetName, "vars": map});
          if(c.calls.containsKey("toWidget"))return c.calls["toWidget"]();
          return toWidget(
            dataStr: c.calls["toStr"](),
            children: children, //libIn: c.calls.containsKey("lib")?c.calls["widgetLib"]:null
          );
        }
    }
    return dataStr;
  }
}
