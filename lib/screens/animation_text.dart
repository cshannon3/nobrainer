



import 'dart:async';

import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/utils/main_painter.dart';



class AnimationTest extends StatefulWidget {
  @override
  _AnimationTestState createState() => _AnimationTestState();
}

class _AnimationTestState extends State<AnimationTest>  with TickerProviderStateMixin {
  //AnimationController animationController;
  List<CustomModel> animatedLines;
  double offsetCount = 5.0;
  Timer _timer;
  @override
  void initState() {
    animatedLines= [CustomModel.fromLib({
      "name":"animatedLine",
      "vars":{
          "pt1":CustomModel.fromLib({
            "name":"movingPoint", "vars":{
              "origin":Offset(5.0, 200.0),
              "steps":CustomModel().listFromLib([
                "step_r_0_d_10",
                "step_r_0_d_20",
                "step_r_0_d_40",
                "step_r_0_u_10",
                "step_r_0_u_20",
                "step_r_0_u_40",
              ])
              }}) ,// tryParse(tokens, ["p1", "pt2"]),
          "pt2":CustomModel.fromLib({
            "name":"movingPoint", "vars":{
              "origin":Offset(5.0, 100.0),
              "steps":CustomModel().listFromLib([
                "step_r_0_d_0",
                "step_l_0_d_20",
                "step_r_0_d_30",
                "step_r_0_u_0",
                "step_l_0_u_20",
                "step_r_0_u_30",
              ])
              }}),
          "currentStep":0,
      }
    })
    // CustomModel.fromLib({
    //   "name":"animatedLine",
    //   "vars":{
    //       "pt1":CustomModel.fromLib({
    //         "name":"movingPoint", "vars":{
    //           "origin":Offset(350.0, 200.0),
    //           "steps":CustomModel().listFromLib([
    //             "step_r_5_d_40",
    //             "step_r_5_u_10",
    //             "step_r_5_u_20",
    //             "step_l_5_u_40",
    //             "step_l_5_d_10",
    //             "step_l_5_d_20",
    //           ])
    //           }}),// tryParse(tokens, ["p1", "pt2"]),
    //       "pt2":CustomModel.fromLib({
    //         "name":"movingPoint", "vars":{
    //           "origin":Offset(350.0, 100.0),
    //           "steps":CustomModel().listFromLib([
    //             "step_r_0_d_30",
    //             "step_r_3_u_0",
    //             "step_r_5_u_20",
    //             "step_l_2_u_30",
    //             "step_l_3_d_0",
    //             "step_l_3_d_20",
    //           ])
    //           }}),
    //       "currentStep":0,
    //   }
  //  })
    ];
       
    super.initState();
      _timer = Timer.periodic(
        Duration(milliseconds: 100), _update);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _update(Timer t) {
   // print("L");
   offsetCount+=20.0;
   if(offsetCount<1500.0){
   animatedLines.add(CustomModel.fromLib({
      "name":"animatedLine",
      "vars":{
          "pt1":CustomModel.fromLib({
            "name":"movingPoint", "vars":{
              "origin":Offset(offsetCount, 200.0),
              "steps":CustomModel().listFromLib([
                "step_r_0_d_10",
                "step_r_0_d_20",
                "step_r_0_d_40",
                "step_r_0_u_10",
                "step_r_0_u_20",
                "step_r_0_u_40",
              ])
              }}) ,// tryParse(tokens, ["p1", "pt2"]),
          "pt2":CustomModel.fromLib({
            "name":"movingPoint", "vars":{
              "origin":Offset(offsetCount, 100.0),
              "steps":CustomModel().listFromLib([
                "step_r_0_d_0",
                "step_l_0_d_20",
                "step_r_0_d_30",
                "step_r_0_u_0",
                "step_l_0_u_20",
                "step_r_0_u_30",
              ])
              }}),
          "currentStep":0,
      }
    }),);
     animatedLines.add(CustomModel.fromLib({
      "name":"animatedLine",
      "vars":{
          "pt1":CustomModel.fromLib({
            "name":"movingPoint", "vars":{
              "origin":Offset(1200.0-offsetCount, 300.0),
              "steps":CustomModel().listFromLib([
                "step_r_0_u_10",
                "step_r_0_u_20",
                "step_r_0_u_40",
                "step_r_0_d_10",
                "step_r_0_d_20",
                "step_r_0_d_40",
              ])
              }}) ,// tryParse(tokens, ["p1", "pt2"]),
          "pt2":CustomModel.fromLib({
            "name":"movingPoint", "vars":{
              "origin":Offset(1200.0-offsetCount, 200.0),
              "steps":CustomModel().listFromLib([

                "step_r_0_u_0",
                "step_l_0_u_20",
                "step_r_0_u_30",
                "step_r_0_d_0",
                "step_l_0_d_20",
                "step_r_0_d_30",
              ])
              }}),
          "currentStep":0,
      }
    }),);
   }
   else if(animatedLines.length>2){
     animatedLines.removeAt(0);
   }
    animatedLines.forEach(
      (line){
      
        line.calls["update"]();
    //  print(line.vars["point1"].vars["current"].dx);
      }
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
             width: double.infinity,
          height: double.infinity,
          child: ClipRect(
            child: CustomPaint(
              painter:MainPainter(models: animatedLines)
           //   LinePainter3(  animatedLines: animatedLines ),
            ),
          ),
      ),
    );
  }
}
