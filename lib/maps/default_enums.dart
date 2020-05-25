
import 'package:flutter/material.dart';
import 'package:no_brainer/utils/parser.dart';


FontWeight getFontWeight(String fw){
  fw= fw.substring(2);
  List v = ["100","200","300","400","500","600","700","800","900" ];
  if(v.contains(fw))return FontWeight.values[v.indexOf(fw)];
}
  

Map<String, dynamic> defaultEnum = {

  "strokeJoin":{
    "round":StrokeJoin.round,
    "r": StrokeJoin.round,
    "bevel":StrokeJoin.bevel,
    "b":StrokeJoin.bevel
  } ,
  "strokeCap":{
    "b":StrokeCap.butt,
    "butt":StrokeCap.butt,
    "r":StrokeCap.round,
    "round":StrokeCap.round,
    "s":StrokeCap.square,
    "square":StrokeCap.square,
  },
  "paintStyle":{
    "f":PaintingStyle.fill,
    "fill":PaintingStyle.fill,
    "stroke":PaintingStyle.stroke,
    "s":PaintingStyle.stroke
  },
  "alignment":{
    "center": Alignment.center,
    "topLeft": Alignment.topLeft,
    "topRight": Alignment.topRight,
    "bottomLeft": Alignment.bottomLeft,
    "bottomRight": Alignment.bottomRight,
    "topCenter": Alignment.topCenter,
    "bottomCenter": Alignment.bottomCenter,
    "centerRight": Alignment.centerRight,
    "centerLeft": Alignment.centerLeft
  }
};

Map<String, BoxFit> boxFits={
  "fill":BoxFit.fill,
  "width":BoxFit.fitWidth,
  "height":BoxFit.fitHeight,
  "contain":BoxFit.contain,
  "cover":BoxFit.cover
} ;

MainAxisAlignment getMainAlign(tokens){
  var p = tryParse(tokens, ["align", "mainAlign", "al", "mainAlignment"], parseType: false);
  if(p==null)return MainAxisAlignment.start;
  switch (p){
    case "center":
    return MainAxisAlignment.center;
    break;
    case "end":
    return MainAxisAlignment.end;
    break;
    case "start":
    return MainAxisAlignment.start;
    break;
    case "around":
    return MainAxisAlignment.spaceAround;
    break;
    case "evenly":
    return MainAxisAlignment.spaceEvenly;
    break;
    case "between":
    return MainAxisAlignment.spaceBetween;
    break;
    
  }
  return MainAxisAlignment.start;

}