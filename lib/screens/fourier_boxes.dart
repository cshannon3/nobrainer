

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/utils/main_painter.dart';
import 'package:no_brainer/utils/oscilloscope.dart';




class FourierBoxes extends StatelessWidget {
    double line1Len;
  double w1speed;
 double w2speed;
  double w3speed;
 double w4speed;
 double w5speed;

   double w1size;
  double w2size;
  double w3size;
  double w4size;
 double w5size;
 ComboWave comboWave;
    int updatesPerSecond = 15;//20
  int secondsPerFullWave = 10;
  bool is3b1b = false;
  List<CustomModel> animatedLines;
  double offsetCount = 5.0;
  int numberExample=100;
 
  int updatesPerFullWave;

  FourierBoxes({ 
  this.line1Len=120.0,
   this.w1speed,
   this.w2speed, 
   this.w3speed, 
   this.w4speed, 
   this.w5speed, 
   this.w1size, 
   this.w2size, 
   this.w3size, 
   this.w4size, 
   this.w5size
   });
  @override
  Widget build(BuildContext context) {
      updatesPerFullWave = updatesPerSecond * secondsPerFullWave;

    List<CustomModel> waves = CustomModel().listFromLib([
        "wave_w_${w1size}_ppf_${w1speed}_c_red",
        "wave_w_${w2size}_ppf_${w2speed}_c_blue",
        "wave_w_${w3size}_ppf_${w3speed}_c_indigo",
        "wave_w_${w4size}_ppf_${w4speed}_c_orange",
        "wave_w_${w5size}_ppf_${w5speed}_c_purple"]);

     // waves.forEach((f){print(f.vars["weight"]);print(f.calls["updateWave"](0.1));});
    
    comboWave = ComboWave(
        waves: waves,
        totalProgressPerCall:
            1.0 / (updatesPerFullWave), // percent of circle progressed per call
        waveColor: Colors.green,
        samplingfreq: 100);
    return   Shell(comboWave: comboWave,);
  }
}

// class FourierBoxes extends StatefulWidget {
//   final double w1speed;
//   final double w2speed;
//   final double w3speed;
//   final double w4speed;
//   final double w5speed;

//   final double w1size;
//   final double w2size;
//   final double w3size;
//   final double w4size;
//   final double w5size;

//   const FourierBoxes({Key key, 
//      this.w1speed,
//    this.w2speed, 
//    this.w3speed, 
//    this.w4speed, 
//    this.w5speed, 
//    this.w1size, 
//    this.w2size, 
//    this.w3size, 
//    this.w4size, 
//    this.w5size
//   // this.w1speed=1.0, 
//   // this.w2speed=3.0, 
//   // this.w3speed=5.0, 
//   // this.w4speed=7.0, 
//   // this.w5speed=9.0, 
//   // this.w1size=1.0, 
//   // this.w2size=1.0/3.0, 
//   // this.w3size=1.0/5, 
//   // this.w4size=1.0/7, 
//   // this.w5size=1.0/9
//   }) : super(key: key);
//   @override
//   _FourierBoxesState createState() => _FourierBoxesState();
// }

// class _FourierBoxesState extends State<FourierBoxes> {
//   ComboWave comboWave;
//     int updatesPerSecond = 15;//20
//   int secondsPerFullWave = 10;
//   bool is3b1b = false;
//   List<CustomModel> animatedLines;
//   double offsetCount = 5.0;
//   int numberExample=100;
 
//   int updatesPerFullWave;
//   final myController = TextEditingController();
  
//   @override
//   void initState() {
//     super.initState();
//     updatesPerFullWave = updatesPerSecond * secondsPerFullWave;

//     List<CustomModel> waves = CustomModel().listFromLib([
//         "wave_w_${1.0}_ppf_${1.0}_c_red",
//         "wave_w_${1.0/3}_ppf_${3.0}_c_blue",
//         "wave_w_${1.0/5}_ppf_${5.0}_c_indigo",
//         "wave_w_${1.0/7}_ppf_${7.0}_c_orange",
//         "wave_w_${1.0/9}_ppf_${9.0}_c_purple"]);

//      // waves.forEach((f){print(f.vars["weight"]);print(f.calls["updateWave"](0.1));});
    
//     comboWave = ComboWave(
//         waves: waves,
//         totalProgressPerCall:
//             1.0 / (updatesPerFullWave), // percent of circle progressed per call
//         waveColor: Colors.green,
//         samplingfreq: 100);

//   }
//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     myController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  Shell(comboWave: comboWave,);
  
//     }
// }

 
class Shell extends StatefulWidget {
   ComboWave comboWave;

   Shell({Key key, this.comboWave});
  @override
  _ShellState createState() => _ShellState();
}

class _ShellState extends State<Shell> with TickerProviderStateMixin {
  Timer _timer;
  double padding = 10.0;
  ComboWave comboWave;
  int updatesPerSecond = 15;//20
  int secondsPerFullWave = 10;
 
  int updatesPerFullWave; //Use this value to determine progress
  // this equates to 75 updates per
  @override
  void initState() {
    super.initState();
    updatesPerFullWave = updatesPerSecond * secondsPerFullWave;
    comboWave = widget.comboWave;

    _timer = Timer.periodic(
        Duration(milliseconds: (1000 / updatesPerSecond).round()), _update);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _update(Timer t) {
    comboWave.update();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double radius = (MediaQuery.of(context).size.width) / 4;
 
    Oscilloscope scopeOne = Oscilloscope(
      showYAxis: true,
      yAxisColor: Colors.orange,
      padding: padding,
      backgroundColor: Colors.transparent,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      comboWave: comboWave,
    );

    // Generate the Scaffold
     return //Scaffold(
  //     backgroundColor: Colors.black,
 //  body:
  Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  //color: Colors.black,
                  child: Stack(
                    children: [Center(
                        child: FractionalTranslation(
                          translation: Offset(-0.25, -0.75),
                          child: Container(
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white)
                                //shape: BoxShape.circle,
                                ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10.0,
                        top: (MediaQuery.of(context).size.height / 4) - 25.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1.0,
                          color: Colors.orange,
                        ),
                      ),
                       Center(
                        child: Transform(
                          transform: Matrix4.translationValues(
                              radius * comboWave.waveVals.vars["z"],
                              -radius * comboWave.waveVals.vars["k"],
                              0.0)
                            ..rotateZ(
                              -comboWave.waveVals.vars["rot"],
                            ),
                          child: FractionalTranslation(
                            translation: Offset(-0.5, -0.5),
                            child: Container(
                              height: 30.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                //shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),]..addAll(List.generate((comboWave.waves.length) ,(wavenum){
                        return Center(
                        child: Transform(
                          transform: Matrix4.translationValues(
                              radius * comboWave.waves[wavenum].calls["z"](),
                              -radius * comboWave.waves[wavenum].calls["k"](),
                              0.0)
                            ..rotateZ(
                              -comboWave.waves[wavenum].calls["progToRad"](),
                            ),
                          child: FractionalTranslation(
                            translation: Offset(-0.5, -0.5),
                            child: Container(
                              height: 30.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                color: comboWave.waves[wavenum].vars["color"],
                                //shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      );
                      }))

                  ),
                )),
            Expanded(
              flex: 1,
              child: scopeOne,
            ),
          ],
      //  ),
    );
  }
}

                     /* ..addAll(List.generate(comboWave.sampleLocations.length,
                          (sample) {
                        return Center(
                          child: Transform(
                            transform: Matrix4.translationValues(
                                radius * comboWave.sampleLocations[sample].vars["x"],
                                -radius * comboWave.sampleLocations[sample].vars["y"],
                                0.0),
                            child: Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: BoxDecoration(
                                  color: sample == 0
                                      ? Colors.purple
                                      : Colors.red,
                                  shape: BoxShape.circle),
                            ),
                          ),
                        );
                      })),*/ 