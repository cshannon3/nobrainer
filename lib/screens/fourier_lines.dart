
import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/utils/main_animator.dart';
import 'package:no_brainer/utils/main_painter.dart';
import 'package:no_brainer/utils/oscilloscope.dart';


class FourierLines extends StatelessWidget {
    double line1Len;
    List<WaveInfo> waves;

  FourierLines({ 
  this.line1Len=120.0,
  this.waves
   });
  @override
  Widget build(BuildContext context) {
    
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    CustomModel fourierLines = CustomModel.fromLib(
      {"name":"fourierLines",
      "vars":{
        "stepPerUpdate":2.5,
        "thickness":20.0,
      }
      }
      );
      fourierLines.vars["lines"]=[];
      if(waves!=null && waves!=[]){
        fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *waves[0].amp}_node_0_root_freqMult_${waves[0].freq}_color_random"));
        for (int i=1; i<waves.length; i++)
          fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len*waves[i].amp}_node_${i}_freqMult_${waves[i].freq}_color_random_conNode_${i-1}"));
        
      }
     

    return  Container(
      height: h,
      width: w,
      child: MainAnimator(
            model: fourierLines,
            painted: true,
          ),
    );
  }
}


// class FourierLines extends StatelessWidget {
//     double line1Len;
//   double w1speed;
//  double w2speed;
//   double w3speed;
//  double w4speed;
//  double w5speed;

//    double w1size;
//   double w2size;
//   double w3size;
//   double w4size;
//  double w5size;

//   FourierLines({ 
//   this.line1Len=120.0,
//    this.w1speed,
//    this.w2speed, 
//    this.w3speed, 
//    this.w4speed, 
//    this.w5speed, 
//    this.w1size, 
//    this.w2size, 
//    this.w3size, 
//    this.w4size, 
//    this.w5size
//    });
//   @override
//   Widget build(BuildContext context) {
    
//     double h = MediaQuery.of(context).size.height;
//     double w = MediaQuery.of(context).size.width;
//     CustomModel fourierLines = CustomModel.fromLib(
//       {"name":"fourierLines",
//       "vars":{
//         "stepPerUpdate":2.5,
//         "thickness":20.0,
//       }
//       }
//       );
//       fourierLines.vars["lines"]=[];
//       fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w1size}_node_0_root_freqMult_${w1speed}_color_random"));
//       if(w2size!=null)fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w2size}_node_1_freqMult_${w2speed}_color_random_conNode_0"));
//       if(w3size!=null)fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w3size}_node_2_freqMult_${w3speed}_color_random_conNode_1"));
//       if(w4size!=null)fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w4size}_node_3_freqMult_${w4speed}_color_random_conNode_2"));
//       if(w5size!=null)fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *w5size}_node_4_freqMult_${w5speed}_color_random_conNode_3"));

//     return    Container(
//       height: h,
//       width: w,
//       child: MainAnimator(
//             model: fourierLines,
//             painted: true,
//           ),
//     );
//   }
// }


// class FourierLines extends StatefulWidget {
//   double lineLen;
//   double w1speed;
//  double w2speed;
//   double w3speed;
//  double w4speed;
//  double w5speed;

//    double w1size;
//   double w2size;
//   double w3size;
//   double w4size;
//  double w5size;

//   FourierLines({ 
//   this.lineLen=120.0,
//    this.w1speed,
//    this.w2speed, 
//    this.w3speed, 
//    this.w4speed, 
//    this.w5speed, 
//    this.w1size, 
//    this.w2size, 
//    this.w3size, 
//    this.w4size, 
//    this.w5size
//    });
//   @override
//   FourierLinesState createState() {
//     return new FourierLinesState();
//   }
// }


// class FourierLinesState extends State<FourierLines> with TickerProviderStateMixin {
//   CustomModel fourierLines;
//  // List<CustomModel> segs;
//   AnimationController animationController;


//   @override
//   void initState() {
//     super.initState();
//     print("OH");
//     print(widget.w2speed);
//     double line1Len=widget.lineLen;
//     fourierLines = null;
//     fourierLines = CustomModel.fromLib(
//       {"name":"fourierLines",
//       "vars":{
//         "stepPerUpdate":2.5,
//         "thickness":12.0,
//       }
//       }
//       );
//       fourierLines.vars["lines"]=[];
//       fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *widget.w1size}_node_0_root_freqMult_${widget.w1speed}_color_random"));
//       if(widget.w2size!=null)fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *widget.w2size}_node_1_freqMult_${widget.w2speed}_color_random_conNode_0"));
//       if(widget.w3size!=null)fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *widget.w3size}_node_2_freqMult_${widget.w3speed}_color_random_conNode_1"));
//       if(widget.w4size!=null)fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *widget.w4size}_node_3_freqMult_${widget.w4speed}_color_random_conNode_2"));
//       if(widget.w5size!=null)fourierLines.vars["lines"].add(CustomModel.fromLib("line2d_length_${line1Len *widget.w5size}_node_4_freqMult_${widget.w5speed}_color_random_conNode_3"));

//       //fourierLines.calls["squareWave"](numoflines:5, line1Len:120.0);
//    // segs =_squareWave(5, 70.0); // _triangleWave(10, 70.0); //

//     animationController =
//         AnimationController(vsync: this, duration: Duration(seconds: 5))
//           ..addListener(() {
//             setState(() {
//             });
//           })
//           ..repeat();
//   }
// @override
// void dispose() { 
//   animationController.dispose();
//   fourierLines.calls["dispose"]();
//   super.dispose();
// }


//   @override
//   Widget build(BuildContext context) {
//     double h = MediaQuery.of(context).size.height;
//     double w = MediaQuery.of(context).size.width;
//     //print(fourierLines.vars["lines"]);
//     return Stack(
//       children: <Widget>[
//         MainAnimator(
//           model: fourierLines,
//         )
//         // CustomPaint(
//         //   painter: 
//         //   MainPainter(model: fourierLines),
//         //   child: Container(
//         //     // color: Colors.grey,
//         //     height: h,
//         //     width: w,
//         //   ),
//         // ),
//       ],
//     );
//   }
// }
   
   // BaseLength is the referene length, since the waves lengths(eg amplitudeor radius)
  // are all related to eachother by specific ratios, I can use this variable to tweak
  // the lengths of the overall system
 // double baseLength = 100.0;

 // double lineThickness = 8.0;
 // double stepPerUpdate = 2.5; // How quickly the wave progresses
  // 1.0 means that it will take 100 frames to get a quarter of the circle
  // and 400 frames to make a full rotation(if the line has no multipliers)
  // Flutter usually runs at around 60 frames per second, meaning it updates
  // once every ~ 16ms so to get the time it takes for one rotation
  // do  stepsPerUpdate  x 1 circle over 400 steps x 60frames over second = circles per second
  // the inverse gives seconds per circle which is around 6.5 for 1.0
 // List trace = [];

  // List<CustomModel> _squareWave(int numoflines, double line1Len,
  //     {List<Color> lineColors}) {
  //   // Square Wave is described here https:en.wikipedia.org/wiki/Square_wave
  //   List<CustomModel> lines = [];
  //   for (int i = 0; i < numoflines; i++) {
  //     String root = (i==0)?"_root_":"_";
  //     String data = "line2d_length_${baseLength * (1 / (1.0 + (i * 2)))}_node_$i"+
  //     root + "freqMult_${1.0 + (i * 2)}_color_random_conNode_${i-1}";
  //     lines.add( CustomModel.fromLib(data));
  //   }
  //   return lines;
  // }

// class AnimationTest2 extends StatefulWidget {
//   @override
//   _AnimationTest2State createState() => _AnimationTest2State();
// }

// class _AnimationTest2State extends State<AnimationTest2>  with TickerProviderStateMixin {
//   //AnimationController animationController;
//   List<CustomModel> animatedLines;
//   double offsetCount = 5.0;
//   Timer _timer;
//   @override
//   void initState() {
//     animatedLines= [CustomModel.fromLib({
//       "name":"animatedLine",
//       "vars":{
//           "pt1":CustomModel.fromLib({
//             "name":"movingPoint", "vars":{
//               "origin":Offset(5.0, 20.0),
//               "steps":CustomModel().listFromLib([
//                 "step_r_0_d_1",
//                 // "step_r_0_d_2",
//                 // "step_r_0_d_4",
//                 // "step_r_0_u_1",
//                 // "step_r_0_u_2",
//                 // "step_r_0_u_4",
//               ])
//               }}) ,// tryParse(tokens, ["p1", "pt2"]),
//           "pt2":CustomModel.fromLib({
//             "name":"movingPoint", "vars":{
//               "origin":Offset(5.0, 10.0),
//               "steps":CustomModel().listFromLib([
//                 "step_r_0_d_1",
//                 // "step_l_0_d_1",
//                 // "step_r_0_d_1",
//                 // "step_r_0_u_0",
//                 // "step_l_0_u_1",
//                 // "step_r_0_u_1",
//               ])
//               }}),
//           "currentStep":0,
//       }
//     })
//     ];
       
//     super.initState();
//       _timer = Timer.periodic(
//         Duration(milliseconds: 100), _update);
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   _update(Timer t) {
//    // print("L");
//    offsetCount+=5.0;
//    if(offsetCount<500.0){
//    animatedLines.add(CustomModel.fromLib({
//       "name":"animatedLine",
//       "vars":{
//           "pt1":CustomModel.fromLib({
//             "name":"movingPoint", "vars":{
//               "origin":Offset(offsetCount, 20.0),
//               "steps":CustomModel().listFromLib([
//                 "step_r_0_d_1",
//                 // "step_r_0_d_2",
//                 // "step_r_0_d_4",
//                 // "step_r_0_u_1",
//                 // "step_r_0_u_2",
//                 // "step_r_0_u_4",
//               ])
//               }}) ,// tryParse(tokens, ["p1", "pt2"]),
//           "pt2":CustomModel.fromLib({
//             "name":"movingPoint", "vars":{
//               "origin":Offset(offsetCount, 10.0),
//               "steps":CustomModel().listFromLib([
//                 "step_r_0_d_1",
//                 // "step_l_0_d_2",
//                 // "step_r_0_d_3",
//                 // "step_r_0_u_0",
//                 // "step_l_0_u_2",
//                 // "step_r_0_u_3",
//               ])
//               }}),
//           "currentStep":0,
//       }
//     }),);
//    }
//    else if(animatedLines.length>2){
//      animatedLines.removeAt(0);
//    }
//     animatedLines.forEach(
//       (line){
//         line?.calls["update"]();
//     //  print(line.vars["point1"].vars["current"].dx);
//       }
//     );
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//              width: double.infinity,
//           height: double.infinity,
//           child: ClipRect(
//             child: CustomPaint(
//               painter: LinePainter3(
//                 animatedLines: animatedLines
//                 ),
//             ),
//           ),
//       ),
//     );
//   }
// }

    // ListView(
      
      
    //   )
    
    // CustomWidget().toWidget(
    // dataIn: {
    //   "listView":[
    //     {"container_h_${h}_w_$w":{"row":[
    //       {"expanded":{
    //         "column":[
    //           {"container": Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         children: <Widget>[
    //                         RaisedButton(
    //                           color: is3b1b ? Colors.blue: Colors.grey,
    //                           onPressed: (){setState(() {
    //                            is3b1b=true; 
    //                           });},
    //                           child: Text("3b1b Visual"),
    //                         ),
    //                          RaisedButton(
    //                            color: is3b1b ? Colors.grey:Colors.blue,
    //                           onPressed: (){setState(() {
    //                            is3b1b=false; 
    //                           });},
    //                           child: Text("My Visual"),
    //                         ),
    //                       ],)},
    //        Expanded(child:is3b1b? FourierLines(): Shell(comboWave: comboWave,)),             
    //       ]}},
    //     ]
    //     }}
    //   ]
  //  _update(){
    
  //         animatedLines= [];
  //         for (int o = 0; o<numberExample; o++){
  //           animatedLines.add(
  //           CustomModel.fromLib({
  //     "name":"animatedLine",
  //     "vars":{
  //         "pt1":CustomModel.fromLib({
  //           "name":"movingPoint", "vars":{
  //             "origin":Offset(5.0+o.remainder(200)*5.0, 20.0+ (o/200).floor()*20),
  //             "steps":CustomModel().listFromLib([
  //               "step_r_0_d_1",
               
  //             ])
  //             }}) ,// tryParse(tokens, ["p1", "pt2"]),
  //         "pt2":CustomModel.fromLib({
  //           "name":"movingPoint", "vars":{
  //             "origin":Offset(5.0+o.remainder(200)*5.0, 10.0+ (o/200).floor()*20),
  //             "steps":CustomModel().listFromLib([
  //               "step_r_0_d_1",
  //             ])
  //             }}),
  //         "currentStep":0,
  //     }}));
  //         }
  // }