
import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/utils/checks.dart';
import 'package:no_brainer/utils/parser.dart';

Map<String, dynamic> mywidgetsLib = {
  "fittedrcb":{
    "vars":(var tokens){
       var h = parseMap["height"](tokens); //parseMap["height"](tokens);;
       var w = parseMap["width"](tokens);
      var wid = w *(parseMap["right"](tokens) - parseMap["left"](tokens)) /
                100;
      var hei =  h * (parseMap["bottom"](tokens) - parseMap["top"](tokens)) /
                100;
      var minW = tryParse(tokens, ["minw", "minW"])??0.0;
      var maxW = tryParse(tokens, ["maxw", "maxW"])??w;
      var minH = tryParse(tokens, ["minh", "minH"])??0.0;
      var maxH = tryParse(tokens, ["maxh", "maxH"])??h;
      return {
        "left":w * parseMap["left"](tokens) / 100,
        "top":h * parseMap["top"](tokens) / 100,
        "width": (wid<maxW)?wid:maxW,
        "height": (hei<maxH)?hei:maxH,
        "isHidden": (wid<minW || hei<minH)
      };
    },
    "functions": (CustomModel self) => {
      "toStr":()=> (self.vars["isHidden"])?"container()":
      '''positioned(left:${self.vars["left"]}_top:${self.vars["top"]}_width:${self.vars["width"]}_height:${self.vars["height"]})
                  ~rcb(width:${self.vars["width"]}_height:${self.vars["height"]})'''
    }
  
    },

    "fitted":{
    "vars":(var tokens){
       var h = ifIs(tokens, "screenH"); //parseMap["height"](tokens);;
       var w = ifIs(tokens, "screenW");
      var wid = w *(parseMap["right"](tokens) - parseMap["left"](tokens)) /
                100;
      var hei =  h * (parseMap["bottom"](tokens) - parseMap["top"](tokens)) /
                100;
      var minW = tryParse(tokens, ["minw", "minW"])??0.0;
      var maxW = tryParse(tokens, ["maxw", "maxW"])??w;
      var minH = tryParse(tokens, ["minh", "minH"])??0.0;
      var maxH = tryParse(tokens, ["maxh", "maxH"])??h;
      var type = ifIs(tokens, "type");
      bool positioned = (type==null || type=="positioned");

      return {
        "left":w * parseMap["left"](tokens) / 100,
        "top":h * parseMap["top"](tokens) / 100,
        "width": (wid<maxW)?wid:maxW,
        "height": (hei<maxH)?hei:maxH,
        "isHidden": (wid<minW || hei<minH),
        "positioned":positioned
      };
    },
    "functions": (CustomModel self) => {
      "toStr":()=> //(self.vars["isHidden"])?"container()":
      self.vars["positioned"]?'''positioned(left:${self.vars["left"]}_top:${self.vars["top"]}_width:${self.vars["width"]}_height:${self.vars["height"]})'''
      :'''padding(l:${self.vars["left"]}_t:${self.vars["top"]})~container(width:${self.vars["width"]}_height:${self.vars["height"]})'''
    }
    },

  "formatted":{
    "vars":(var tokens){
      return {
        "width": parseMap["width"](tokens)??0.0,
        "height": parseMap["height"](tokens)??0.0,
        "alignment":  parseMap["alignment"](tokens),
        "padding":getPadding(tokens)
      };
    },
    "functions": (CustomModel self) => {
      "lib":()=>{
        "padding":()=>self.vars["padding"],
        "align":()=>self.vars["alignment"]
      },
      "toStr":()=> 
      '''padding(padding:@padding}~align(alignment:@align)~sizedBox(h:${self.vars["height"]}_w:${self.vars["width"]})'''
    }
    },

    "customText":{
    "vars":(var tokens){
      return {
        "text": tokens.containsKey("text")? (tokens["text"] is List)?tokens["text"].join():tokens["text"]:"",
        "token": tokens.containsKey("token")?tokens["token"]:"#",
        "isBold": tokens.containsKey("bold")&&["true", "True", "t"].contains(tokens["bold"])?FontWeight.bold : FontWeight.normal,
        "isHighlighted": tokens.containsKey("highlight")? ["true", "True", "t"].contains(tokens["highlighted"]) : false,
        "isItalic": tokens.containsKey("italic")&& ["true", "True", "t"].contains(tokens["italic"]) ?FontStyle.italic: FontStyle.normal,
        "fontSize":tryParse(tokens, ["fontSize", "size", "fs"])??16.0,
        "color":parseMap["color"](tokens)??Colors.black, 
        "fontWeight": tokens.containsKey("bold")&&["true", "True", "t"].contains(tokens["bold"])?FontWeight.bold : FontWeight.normal,
        "fontFamily":null,
        "fontType":FontStyle.normal
     }; 
    },
    "functions": (CustomModel self) => {
      "toWidget":(){
        return  RichText(text: TextSpan(children: self.calls["toTextSpan"]()));
      },
      
    
      "toTextSpan":({String outStr=""}){
        List v = ["100","200","300","400","500","600","700","800","900" ];
        List<TextSpan> textWidgets=[];
        self.vars["text"].split(self.vars["token"]).forEach((textSeg)
        {
        if(textSeg=="bold") self.vars["isBold"]= FontWeight.bold;
        else if(textSeg=="/bold") self.vars["fontWeight"]=FontWeight.normal;
        else if(textSeg=="normal") self.vars["fontWeight"]=FontWeight.normal;
        else if(textSeg.contains("fw") && v.contains(textSeg.substring(2))) self.vars["fontWeight"]=FontWeight.values[v.indexOf(textSeg.substring(2))];
        else if(textSeg=="italic") self.vars["fontType"]= FontStyle.italic;
        else if(textSeg=="/italic") self.vars["fontType"]= FontStyle.normal;
        else if(textSeg.contains("color")) self.vars["color"] =colorFromString(textSeg.substring("color".length))??Colors.black;
        else if(textSeg.contains("/color")) self.vars["color"]=Colors.black;  // else if(textSeg.contains("highlight")) self.vars["isHighlighted"]= !isHighlighted;
        else if(textSeg.contains("size"))self.vars["fontSize"]=double.tryParse(textSeg.substring("size".length)) ?? 12.0;
        else if(textSeg.contains("/size"))self.vars["fontSize"]=16.0;
        else{
          //if(outStr!="")outStr+=",";
          //outStr+='''textSpan(text:$textSeg)''';//_style:textStyle(fontSize:${self.vars["fontSize"]}_fontWeight:${self.vars["isBold"]}_fontStyle:${self.vars["isItalic"]}))''';
          textWidgets.add(
            TextSpan(
              text: textSeg, 
              style:TextStyle(
                fontSize: self.vars["fontSize"], 
                fontWeight: self.vars["fontWeight"], 
                fontStyle:self.vars["fontType"], 
                color: self.vars["color"])));
             //   backgroundColor: isHighlighted ? Colors.yellowAccent:null)));
        }

      });
      return textWidgets;
      },
      "toStr":(){
        var o = '''richText(
          text:textSpan(text:${self.vars["text"]})
          )''';
      return o;
      }
    }
    },
     "form":{
    "vars":(var tokens){
      return {
        "width": parseMap["width"](tokens)??0.0,
        "height": parseMap["height"](tokens)??0.0,
        "alignment":  parseMap["alignment"](tokens),
        "padding":getPadding(tokens)
      };
    },
    "functions": (CustomModel self) => {
      "lib":()=>{
        "padding":()=>self.vars["padding"],
        "align":()=>self.vars["alignment"]
      },
      "toStr":()=> 
      '''padding(padding:@padding}~align(alignment:@align)~sizedBox(h:${self.vars["height"]}_w:${self.vars["width"]})'''
    }
    },
    
  "pctWide":{
    "vars":(var tokens){
      return {
        "width":  parseMap["width"](tokens) *parseMap["left"](tokens) /100,
        "height":parseMap["height"](tokens)??0.0 * parseMap["left"](tokens)??0.0 *parseMap["ratio"](tokens)??0.0 /100,
        "padding":getPadding(tokens),
        "color" :ifIs(tokens, "color")??"null",  
      };
    },
    "functions": (CustomModel self) => {
      "lib":()=>{
        "padding":()=>self.vars["padding"],
      },
      "toStr":()=> 
      '''sizedBox(w:${self.vars["width"]}_h:${self.vars["height"]})
          ~container(color:${self.vars["color"]})
              ~padding(padding:@padding)'''
    }
    },
  };
  

  
