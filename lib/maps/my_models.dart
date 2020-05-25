import 'dart:math';

import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/utils/mathish.dart';
import 'package:no_brainer/utils/parser.dart';

Map<String, dynamic> mymodelsLib = {
    "blog": {
    "vars": (
      var tokens,) =>
        {
          "name": tokens.containsKey("author")?tokens["author"]:"",
          "author":  tokens.containsKey("author")?tokens["author"]:"",
          "url":  tokens.containsKey("url")?tokens["url"]:"",
          "imgUrl": tokens.containsKey("imgUrl")?tokens["imgUrl"]:""
        },
    "functions": (CustomModel self) => {
          "fromMap": (Map<String, dynamic> map) {
            self.vars["author"] = map.containsKey("author")?map["author"]:"";
            self.vars["name"] =  map.containsKey("name")?map["name"]:"";
            self.vars["imgUrl"] = map.containsKey("imgUrl")?map["imgUrl"]:"";
            self.vars["url"] = map.containsKey("url")?map["url"]:"";
            return;
          },
          "toMap":()=>{
            "name": self.vars["name"],
            "author": self.vars["author"],
            "imgUrl": self.vars["imgUrl"],
            "url": self.vars["url"],
          }
        }
  },
  "book": {
    "vars": (
      var tokens,
    ) {
      //print(tokens);
        return {
          "id": 0,
          "title": tokens.containsKey("title")?tokens["title"]:"",
          "author":tokens.containsKey("author")?tokens["author"]:"",
          "categories": tokens.containsKey("categories")?new List<String>.from(tokens["categories"]):[],
          "year": 1999,//tokens.containsKey("year")?int.tryParse(tokens["year"]):"",
          "imgUrl": tokens.containsKey("imgUrl")?tokens["imgUrl"]:"",
          "reco;mmendedBy": tokens.containsKey("recommendedBy")?tokens["recommendedBy"]:"",
        };
    },
    "functions": (CustomModel self) => {
          "fromMap": (Map<String, dynamic> map) {
            self.vars["id"] = map['Id'];
            //print("HI");
            self.vars["title"] = map['title'];
            self.vars["categories"] = new List<String>.from(map['categories']);
            self.vars["author"] = map['author'];
            self.vars["year"] = map['year'];
            self.vars["imgUrl"] = map['imgUrl'];
            self.vars['recommendedBy'] = map['recommendedBy'];
            return;
          },
          "toMap":()=>{
            "id": self.vars["id"],
            "title": self.vars["title"],
            "author": self.vars["author"],
            "categories": self.vars["categories"],//.join(","),
            "year": self.vars["year"],
            "imgUrl": self.vars["imgUrl"],
            "recommendedBy": self.vars["recommendedBy"],
          },
          "toLabel":(){
            return ListTile(title: Text(self.vars["title"]),trailing:Container(child:Text(self.vars["author"]),));
          }
        }
  },
  "quote": {
    "vars": (
      var tokens,
    ) =>
        {
          "id": 0,
           "text": tokens.containsKey("text")?new List<String>.from(tokens["text"]).join():"",//(tokens["text"] is List)?tokens['text']:
            "author": tokens.containsKey("author")?tokens["author"]:"", 
            "categories": tokens.containsKey("categories")?new List<String>.from(tokens['categories']):[],
             "source":""//tokens.containsKey("source")?tokens["source"]:"",
             },
    "functions": (CustomModel self) => {
          "fromMap": (Map<String, dynamic> map) {
            self.vars["text"] = new List<String>.from(map['text']).join();
            self.vars["categories"] =  List<String>.from(map['categories']);
            self.vars["author"] = map['author'];
            self.vars["source"] = "";
            return;
          },
          "toMap":()=>{
            "id": self.vars["id"],
            "text": self.vars["text"],
            "author": self.vars["author"],
            "categories": self.vars["categories"],//.join(","),
            "source": self.vars["source"],
          },
          "toStr":(){
            self.vars["text"]=self.vars["text"].replaceAll("@@", "#")..replaceAll(":", "");
            var text = "\""+ self.vars["text"]+ "\""+ "#bold##italic##colorblue#\n\n -${self.vars["author"]}";
            return '''customText(text:$text)''';//padding(all:8)~container(all:8_color:green200)~center()~
          },
          "toLabel":(){
            self.vars["text"]=self.vars["text"].replaceAll("@@", "#")..replaceAll(":", "");
            return ExpansionTile(title: Text(self.vars["author"]),children: <Widget>[Text(self.vars["text"])],);
          }
          // "formattedText":() {
          //   //double fontSize=16.0;
          //   self.vars["text"]= "\""+ self.vars["text"]+ "\""+ "#bold##italic##colorblue#\n\n -${self.vars["author"]}";
          //   return "customText(text:${self.vars["text"]})";
          
          // }
        }
  },

  "point": {
    "vars": (
      var tokens,
    ) =>
        {"x": parseMap["x"](tokens) ?? 0.0, "y": parseMap["y"](tokens) ?? 0.0},
    "functions": (CustomModel self) => {
          "toOffset": ({double scale = 1.0}) =>
              Offset(scale * self.vars["x"], scale * self.vars["y"])
              // "#widget#offset_dx_#m_*_^scale_@x_#\m_dy_#m_*_^scale_@y_#\m"
        },
  },
  "fourierLines": {
    "vars": (var tokens) =>
        {
          "lines":[],//tokens.containsKey("lines")?tokens["lines"]:[],
          "stepPerUpdate":2.5, //tryParse(tokens, ["stepsPerUpdate", "stepPerUpdate","spu"])??2.0,
          "thickness": 4.0,//tryParse(tokens, ["thickness", "t"])??4.0,
          "xScale":1.0,
          "traceColor":Colors.blue,//parseMap["color"](tokens)??Colors.blue,
          "trace":[],
          "showYAxis": true, //tokens.containsKey("showYAxis")?tokens["showYAxis"]:true,
          "animationController":null
       },
    "functions": (CustomModel self) => {
          "squareWave":({int numoflines, double line1Len}){
            self.vars["lines"]=[];
            // (loop for x from 0 to ${numofLine} )
            for (int i = 0; i < numoflines; i++) {
                String root = (i==0)?"_root_":"_";
                String data = "line2d_length_${line1Len * (1 / (1.0 + (i * 2)))}_node_$i"+
                root + "freqMult_${1.0 + (i * 2)}_color_random_conNode_${i-1}";
                self.vars["lines"].add(CustomModel.fromLib(data));
              }
          },
          "setWave":({double line1Len, double w1speed=1.0, 
                      double w2speed=3.0, 
                      double w3speed=5.0, 
                      double w4speed=7.0, 
                      double w5speed=9.0, 
                      double w1size=1.0, 
                      double w2size=1.0/3.0, 
                      double w3size=1.0/5, 
                      double w4size=1.0/7, 
                      double w5size=1.0/9
            }){
            self.vars["lines"]=[];
            self.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w1size}_node_0_root_freqMult_${w1speed}_color_random"));
            self.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w2size}_node_1_freqMult_${w2speed}_color_random_conNode_0"));
            self.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w3size}_node_2_freqMult_${w3speed}_color_random_conNode_1"));
            self.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w4size}_node_3_freqMult_${w4speed}_color_random_conNode_2"));
            self.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w5size}_node_4_freqMult_${w5speed}_color_random_conNode_3"));
      
          },
          "animate":({@required TickerProvider vsync, @required Function() setState}){
  
            self.vars["animationController"]=  AnimationController(vsync: vsync, duration: Duration(seconds: 5))
          ..addListener(() {
            setState();
          })
          ..repeat();
          },
          "dispose":(){
            print("DISP");
            self.vars["animationController"].dispose();
            self.vars["animationController"]=null;
          },
          "paint":(Canvas canvas, Size size){
                final tracePaint = Paint()
                ..strokeJoin = StrokeJoin.round
                ..strokeWidth = 2.0
                ..color = self.vars["traceColor"]
                ..style = PaintingStyle.stroke;
                final axisPaint = Paint()
                  ..strokeWidth = 1.0
                  ..color = Colors.orange;
                  var totalLen =0.0;
                  self.vars["lines"].forEach((lineNode) {
                            List<dynamic> nodepoints =lineNode.vars["root"]
                      ? lineNode.calls["setPosition"](
                          startlocation: Offset(size.width / 2, size.height / 4),
                          stepPerUpdate: self.vars["stepPerUpdate"])
                      : lineNode.calls["setPosition"](
                          startlocation: self.vars["lines"]
                              .firstWhere((ls) => ls.vars["node"] == lineNode.vars["conNode"]).vars["endNodeLoc"],
                          stepPerUpdate: self.vars["stepPerUpdate"]) ;
                  Paint p = Paint()
                    ..color = lineNode.vars["color"]
                    ..strokeWidth = self.vars["thickness"]
                    ..strokeCap = StrokeCap.round
                    ..style = PaintingStyle.stroke;
                  canvas.drawLine(nodepoints[0], nodepoints[1], p);
                  totalLen += lineNode.vars["length"];
                  if (lineNode == self.vars["lines"].last) {
                    self.vars["trace"].add((lineNode.vars["endNodeLoc"].dy - (size.height / 4)) / totalLen);
                  }
                  // only start plot if dataset has data
                  int length = self.vars["trace"].length;
                  if (length > 0) {
                    // transform data set to just what we need if bigger than the width(otherwise this would be a memory hog)
                    if (length > size.width) {
                      self.vars["trace"].removeAt(0);
                      length = self.vars["trace"].length;}
                    // Create Path and set Origin to first data point
                    Path tracePath = Path();
                    tracePath.moveTo(
                        0.0, 3 * size.height / 4 + self.vars["trace"][0].toDouble() * size.height / 4);
                    // generate trace path
                    for (int p = 0; p < length; p++) {
                      double plotPoint =
                          3 * size.height / 4 + self.vars["trace"][p].toDouble() * size.height / 4;
                      tracePath.lineTo(p.toDouble() * self.vars["xScale"], plotPoint);
                    }
                    // display the trace
                    canvas.drawPath(tracePath, tracePaint);
                    // if yAxis required draw it here
                    if (self.vars["showYAxis"]) {
                      Offset yStart = Offset(0.0, 3 * size.height / 4);
                      Offset yEnd = Offset(size.width, 3 * size.height / 4);
                      canvas.drawLine(yStart, yEnd, axisPaint);
                    }
            }
          });
        },
  },
  },
   
  "line2d": {
    "vars": (var tokens) => {
          "node": tryParse(tokens, ["node"]) ?? 0,
          "color": parseMap["color"](tokens),
          "conNode": tryParse(tokens, ["conNode"]) ?? -1,
          "length": parseMap["length"](tokens) ?? 0,
          "freqMult": tryParse(tokens, ["freqMult", "fm"]) ?? 0,
          "nodeLoc": tokens.contains("nodeLoc")
              ? Offset(double.parse(tokens[tokens.indexOf("nodeLoc") + 1]),
                  double.parse(tokens[tokens.indexOf("nodeLoc") + 2]))
              : Offset(0.0, 0.0),
          "endNodeLoc": null,
          "absProg": false,
          "root": tokens.contains("root") ? true : false,
          "progress": 0.0
        },
    "functions": (CustomModel self) => {
          "setPosition": ({Offset startlocation, double stepPerUpdate}) {
            if (stepPerUpdate != null)
              self.vars["progress"] += stepPerUpdate * self.vars["freqMult"];
            if (startlocation != null) self.vars["nodeLoc"] = startlocation;
            self.vars["endNodeLoc"] = Offset(
                self.vars["nodeLoc"].dx +
                    Z(self.vars["progress"]) * self.vars["length"],
                self.vars["nodeLoc"].dy +
                    K(self.vars["progress"]) * self.vars["length"]);
            return [self.vars["nodeLoc"], self.vars["endNodeLoc"]];
          },
          "compare": (CustomModel node2) =>
              self.vars["node"].compareTo(node2.vars["node"]),
   }
  },
  "comboWave": {
    "vars": (var tokens) => {
          "waves":tokens["waves"],
          "PPF": tokens.containsKey("ppf")?tokens["ppf"] : 0.012,
          "progress":  0.0,
          "samplingfreq":  tokens.containsKey("samplingfreq")?tokens["samplingfreq"]:-1,
          "color": tokens.containsKey("color")?tokens["color"]:Colors.green,
          "waveVal": CustomModel.fromLib("waveVal"),
          "sampleLocations": [],
          "sampleCounter":0,
          "trace":[],
          "radius":100.0,
        },
    "functions": (CustomModel self) => {
          "update": () {
          self.vars["trace"].add(self.vars["waveVal"]?.vars["k"]);
          self.vars["sampleCounter"] += 1;
          if (self.vars["samplingfreq"] != -1 && (self.vars["sampleCounter"]> self.vars["samplingfreq"])) {
            self.vars["sampleLocations"].add(CustomModel.fromLib("point_x_${self.vars["waveVal"].vars["z"]}_y_${self.vars["waveVal"].vars["k"]}"));//Point(waveVals.z, waveVals.k)
            self.vars["sampleCounter"]= 0;
            if (self.vars["sampleLocations"].length > 1) {
              double x =  (self.vars["sampleLocations"][0].vars["x"] * (self.vars["sampleLocations"].length - 1) +
                          self.vars["sampleLocations"].last.vars["x"]) /
                      self.vars["sampleLocations"].length;
              double y =  0.9*(self.vars["sampleLocations"][0].vars["y"]* (self.vars["sampleLocations"].length - 1) +
                          self.vars["sampleLocations"].last.vars["y"]) /
                      self.vars["sampleLocations"].length;
              self.vars["sampleLocations"][0] = CustomModel.fromLib("point_x_${x}_y_$y");
            }
          }
          self.vars["waveVal"]?.calls["zero"]();
          self.vars["waves"].forEach((w) {
            CustomModel wa = w.calls["updateWave"](self.vars["progress"]);
            self.vars["waveVal"]?.calls["add"](wa);
          });
          self.vars["waveVal"].vars["rot"] = self.vars["waveVal"].vars["rot"] / self.vars["waves"].length;
          self.vars["progress"] += self.vars["PPF"];
      },
      "animate":({@required TickerProvider vsync, @required Function() setState}){
  
            self.vars["animationController"]=  AnimationController(vsync: vsync, duration: Duration(seconds: 5))
          ..addListener(() {
            self.calls["update"]();
            setState();
          })
          ..repeat();
          },
          "dispose":(){
            self.vars["animationController"].dispose();
          },
      // "paint": (Canvas canvas, Size size){
      // },
      "toWidgetList":(var tokens){//var radius = tokens.containsKey("radius")?tokens["radius"]:100.0;
        var widgetList = [self.calls["toWidget"](tokens)];
        self.vars["waves"]?.forEach((w)=>widgetList.add(w.calls["toWidget"](tokens)));
        return widgetList;
      },
      "toWidget":(var tokens){
        
        // "center+transform(transform_@transform)+fractionalTranslation(offset(dx_-0.5_dy_-0.5))+container(h_30_w_10_color_green)
        // var trans = Matrix4.translationValues( radius * self.vars["waveVal"].vars["z"], -radius * self.vars["waveVal"].vars["k"],
                           //   0.0)..rotateZ(  -self.vars["waveVal"].vars["rot"],),
         return Center(child: Transform(
                          transform: Matrix4.translationValues(
                              self.vars["radius"] * self.vars["waveVal"].vars["z"],
                              -self.vars["radius"] * self.vars["waveVal"].vars["k"],
                              0.0)
                            ..rotateZ(
                              -self.vars["waveVal"].vars["rot"],
                            ),
                          child: FractionalTranslation(
                            translation: Offset(-0.5, -0.5),
                            child: Container(
                              height: 30.0,
                              width: 10.0,
                              color:self.vars["color"],
                            ),
                          ),
                        ),
                      );
          }

    }
  },
  "wave": {
    "vars": (var tokens) => {
          "weight": tryParse(tokens, ["weight", "w"]) ?? 0.0,
          "PPF": tryParse(tokens, ["PPF", "progressPerFrame", "ppf"]) ?? 1.0,
          "progress": tryParse(tokens, ["progress", "p"]) ?? 0.0,
          "trace": [],
          "color": parseMap["color"](tokens),
          "waveVals": [],
          "radius": 100.0
        },
    "functions": (CustomModel self) => {
          "z": () => self.vars["weight"] * cos(self.calls["progToRad"]()),
          "k": () => self.vars["weight"] * sin(self.calls["progToRad"]()),
          "progToRad": () => 2 * pi * (self.vars["progress"] * 9 / 10),
          "updateWave": (double newProgress) {
            self.vars["trace"].add(self.calls["k"]());
            self.vars["progress"] = self.vars["PPF"] * newProgress;

            return CustomModel.fromLib(
                "waveVal_k_${self.calls["k"]()}_z_${self.calls["z"]()}_rot_${self.calls["progToRad"]()}");
          },
          "toWidget":(var tokens){
           return Center(
                        child: Transform(
                          transform: Matrix4.translationValues(
                              self.vars["radius"] * self.calls["z"](),
                              -self.vars["radius"] * self.calls["k"](),
                              0.0)
                            ..rotateZ(
                              -self.calls["progToRad"](),
                            ),
                          child: FractionalTranslation(
                            translation: Offset(-0.5, -0.5),
                            child: Container(
                              height: 30.0,
                              width: 10.0,
                              color: self.vars["color"],
                            ),
                          ),
                        ),
                      );
          }
          
        }
  },
  "waveVal": {
    "vars": (var tokens) => {
          "k": tryParse(tokens, ["k"]) ?? 0.0,
          "z": tryParse(tokens, ["z"]) ?? 0.0,
          "rot": tryParse(tokens, ["rot"])??0.0,
        },
    "functions": (CustomModel self) => {
          "zero": () {
            self.vars["k"] = 0.0;
            self.vars["z"] = 0.0;
            self.vars["rot"] = 0.0;
          },
          "add": (CustomModel wv) {
            self.vars["k"] += wv.vars["k"];
            self.vars["z"] += wv.vars["z"];
            self.vars["rot"] += wv.vars["rot"];
          }
        },
  },
  "coloredLine": {
    "vars": (var tokens) => {
          "points": [],//List<Offset>.from([]),
          "color": parseMap["color"](tokens),
          "strokeWidth": tryParse(tokens, ["sw", "strokeWidth"]) ?? 4.0,
          "active": false,
          "shouldRepaint": false,
          "paintLayerIndex": null
        },
    "functions": (CustomModel self) => {
          "fromMap": (Map<String, dynamic> map) {
            self.vars["points"] = new List<Offset>.from(map["points"]);
            self.vars["color"] = map.containsKey("color")
                ? colorFromString(map["color"])
                : Colors.black;
            self.vars["strokeWidth"] = map['strokeWidth'];
            self.vars["active"] =
                map.containsKey("active") ? map["active"] : false;
          },
          "addPt": (Offset pt) {
            self.vars["points"].add(pt);
            self.vars["shouldRepaint"] = true;
          },
          "repaint": () {
            if (self.vars["shouldRepaint"]) {
              self.vars["shouldRepaint"] = false;
              return true;
            }
            return false;
          },
          "getPoints": () =>self.vars["points"] ,
          "paint": (Canvas canvas, Size size){
              Paint paint = Paint()
              ..color = self.vars["color"]
              ..strokeCap = StrokeCap.round
              ..strokeWidth = self.vars["strokeWidth"];
              for (int i = 0; i < self.calls["getPoints"]().length - 1; i++) {
                if (self.calls["getPoints"]()[i] != null &&
                    self.calls["getPoints"]()[i + 1] != null) {
                  canvas.drawLine(self.calls["getPoints"]()[i], self.calls["getPoints"]()[i + 1], paint);
                }
              }
            }
        },
  },
  "polygon": {
    "vars": (var tokens) => {
          "sidelen": tryParse(tokens, ["sidelen"]),
          "sides": tryParse(tokens, ["sides"], type: "int"),
        },
    "functions": (CustomModel self) => {

    },
  },
   "circle": {
    "vars": (var tokens) => {
          "radius": tryParse(tokens, ["radius", "r"]),
        },
    "functions": (CustomModel self) => {},
  },


   "animatedLine": {
    "vars": (var tokens)  {
      return{
          "point1": tokens["pt1"],// tryParse(tokens, ["p1", "pt2"]),
          "point2":  tokens["pt2"],
          "currentStep":0,
      };
        },
    "functions": (CustomModel self) => {
      "update": ({var stepSizeRight=1.0, var stepSizeDown=1.0}){
        self.vars["point1"].calls["update"](self.vars["currentStep"],stepSizeRight,stepSizeDown );
        self.vars["point2"].calls["update"](self.vars["currentStep"],stepSizeRight,stepSizeDown);
        self.vars["currentStep"]=self.vars["currentStep"]+1;
      },
      "paint":(Canvas canvas, Size size){
         Paint p = Paint()
         ..color = Colors.green//RandomColor.next()
        //Colors.green//lineNode.vars["color"]
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
        canvas.drawLine(self.vars["point1"].vars["current"], self.vars["point2"].vars["current"], p);
      }
    },
  },
  "movingPoint":{
    "vars": (var tokens)  {
      return{
          "origin": tokens["origin"] ,//tryParse(tokens, ["origin"]), 
          "current":  tokens["origin"], //tryParse(tokens, ["origin"]),
          "steps": tokens["steps"]
      };
    },
    "functions": (CustomModel self) => {
      "update": (var currentStep, var stepSizeRight, var stepSizeDown){
        if(self.vars["steps"] ==[]) {print("OLOL");
          return;}
        var step = self.vars["steps"][currentStep.remainder(self.vars["steps"].length)];
        self.vars["current"]=self.vars["current"]+ Offset(stepSizeRight*step.vars["right"],stepSizeDown*step.vars["down"]);
      }
    },
  },
  "step":{
    "vars": (var tokens) => {
          "right":  tryParse(tokens, ["right", "r"])??-tryParse(tokens, ["left", "l"])??0.0, //
          "down": tryParse(tokens, ["down", "d"])??-tryParse(tokens, ["up", "u"])??0.0,//??-tryParse(tokens, ["up", "u"])
    },
     "functions": (CustomModel self) => {},
  },

};
