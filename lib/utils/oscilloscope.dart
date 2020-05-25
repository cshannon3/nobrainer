import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/utils/mathish.dart';
class WaveInfo{
  final double amp;
  final double freq;
  WaveInfo(this.amp, this.freq);
}

class WaveController{
  double freq;
  double amp;
  
  bool isActive = false;
  TextEditingController tecA= TextEditingController();
  TextEditingController tecF= TextEditingController();

  WaveController(this.freq, this.amp){
   // print(amp);
   // print(freq);
    tecF.text=freq.toStringAsPrecision(3);
    tecA.text=amp.toStringAsPrecision(3);
    if(amp!=null && freq!=null &&amp!=0.0){isActive=true;}
  }
  setVals({double newFreq, double newAmp}){
    setFreq(newFreq); setAmp(newAmp);}

  setFreq(double newFreq){
    freq=newFreq;
    tecF.text=freq.toStringAsPrecision(3);
  }
  setAmp(double newAmp){
    amp=newAmp;
    tecA.text=amp.toStringAsPrecision(3);
    if(amp==null || amp==0.0 || freq==null)isActive=false;
    else isActive=true;
  }
  WaveInfo toWaveInfo()=>
    WaveInfo(amp, freq);


  dispose(){
    tecA.dispose();
    tecF.dispose();
  }
  Widget makeRow({Function setState, double height, double width}){
    return Container(
      height: height,
      width: width,
      child: Row(children: [
                          Text("Amp: "),
                          Expanded(
                            child: TextField(
                                  controller: tecA,
                                  onChanged: (text) {
                                    var out = double.tryParse(text); //print(out);
                                    if (out != null)  setAmp(out);
                                    setState();
                                  },
                                ),
                          ),
                              Text("Freq: "),
                                Expanded(
                                  child: TextField(
                                  controller: tecF,
                                  onChanged: (text) {
                                    var out = double.tryParse(text); //print(out);
                                    if (out != null)  setFreq(out);
                                    setState();
                                  },
                              ),
                                ),
                        sinePainter(height: height, width: width) 
                        ]),
    );
  }
    Widget sinePainter({double height=80.0, double width}){
    
    return Container(
        height:height,
        width: width/2,
            child: CustomPaint(
              painter: SinePainter(
                 amplitude: amp,
                 frequency:freq,
                  yRange:height),
            ),
          );
  }
}

/// A Custom Painter used to generate the trace line from the supplied dataset
class SinePainter extends CustomPainter {
  final double amplitude;
  final double frequency;
  final Color traceColor;
  final double yRange;

  SinePainter( 
      {
        this.amplitude, 
        this.frequency,
      this.yRange,
      this.traceColor = Colors.green});

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0
      ..color = traceColor
      ..style = PaintingStyle.stroke;

    double yScale = (size.height / yRange);

    // only start plot if dataset has data

   // double amp = yScale*amplitude;
   // double slope = xScale*frequency;
   // dataSet.length;
   
    Path trace = Path();
   trace.moveTo(0.0, size.height/2);
   //print(size.height);
   for(int i=0; i<size.width;i++){

     trace.lineTo(i.toDouble(), size.height/2+amplitude*size.height*K(i*frequency*2)/2);//
   }

    canvas.drawPath(trace, tracePaint);

      // if yAxis required draw it here
  
  }

  @override
  bool shouldRepaint(SinePainter old) => true;
}

// SOURCE
/// A widget that defines a customisable Oscilloscope type display that can be used to graph out data
///
/// The [dataSet] arguments MUST be a List<double> -  this is the data that is used by the display to generate a trace
///
/// All other arguments are optional as they have preset values
///
/// [showYAxis] this will display a line along the yAxisat 0 if the value is set to true (default is false)
/// [yAxisColor] determines the color of the displayed yAxis (default value is Colors.white)
///
/// [yAxisMin] and [yAxisMax] although optional should be set to reflect the data that is supplied in [dataSet]. These values
/// should be set to the min and max values in the supplied [dataSet].
///
/// For example if the max value in the data set is 2.5 and the min is -3.25  then you should set [yAxisMin] = -3.25 and [yAxisMax] = 2.5
/// This allows the oscilloscope display to scale the generated graph correctly.
///
/// You can modify the background color of the oscilloscope with the [backgroundColor] argument and the color of the trace with [traceColor]
///
/// The [padding] argument allows space to be set around the display (this defaults to 10.0 if not specified)
///
/// NB: This is not a Time Domain trace, the update frequency of the supplied [dataSet] determines the trace speed.
class Oscilloscope extends StatefulWidget {
  final ComboWave comboWave;
  final double yAxisMin;
  final double yAxisMax;
  final double padding;
  final Color backgroundColor;
  final Color yAxisColor;
  final bool showYAxis;

  Oscilloscope(
      {this.backgroundColor = Colors.black,
      this.yAxisColor = Colors.white,
      this.padding = 10.0,
      this.yAxisMax = 1.0,
      this.yAxisMin = 0.0,
      this.showYAxis = false,
      @required this.comboWave});

  @override
  _OscilloscopeState createState() => _OscilloscopeState();
}

class _OscilloscopeState extends State<Oscilloscope> {
  double yRange;
  double yScale;

  @override
  void initState() {
    super.initState();
    yRange = widget.yAxisMax - widget.yAxisMin;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
      Container(
        padding: EdgeInsets.only(right: widget.padding),
        width: double.infinity,
        height: double.infinity,
        // color: widget.backgroundColor,
        child: ClipRect(
          child: CustomPaint(
            painter: TracePainter(
                showYAxis: widget.showYAxis,
                yAxisColor: widget.yAxisColor,
                dataSet: widget.comboWave.trace,
                traceColor: widget.comboWave.waveColor,
                yMin: widget.yAxisMin,
                yRange: yRange),
          ),
        ),
      )
    ]..addAll(List.generate(widget.comboWave.waves.length, (dataNum) {
            return Container(
              padding: EdgeInsets.only(right: widget.padding),
              width: double.infinity,
              height: double.infinity,
              // color: widget.backgroundColor,
              child: ClipRect(
                child: CustomPaint(
                  painter: TracePainter(
                      showYAxis: widget.showYAxis,
                      yAxisColor: widget.yAxisColor,
                      dataSet: widget.comboWave.waves[dataNum].vars["trace"],
                      traceColor: widget.comboWave.waves[dataNum].vars["color"],
                      yMin: widget.yAxisMin,
                      yRange: yRange),
                ),
              ),
            );
          })));
  }
}

/// A Custom Painter used to generate the trace line from the supplied dataset
class TracePainter extends CustomPainter {
  final List dataSet;
  final double xScale;
  final double yMin;
  final Color traceColor;
  final Color yAxisColor;
  final bool showYAxis;
  final double yRange;

  TracePainter(
      {this.showYAxis,
      this.yAxisColor,
      this.yRange,
      this.yMin,
      this.dataSet,
      this.xScale = 1.0,
      this.traceColor = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final tracePaint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.0
      ..color = traceColor
      ..style = PaintingStyle.stroke;

    final axisPaint = Paint()
      ..strokeWidth = 1.0
      ..color = yAxisColor;

    double yScale = (size.height / yRange);

    // only start plot if dataset has data
    int length = dataSet.length;
    if (length > 0) {
      // transform data set to just what we need if bigger than the width(otherwise this would be a memory hog)
      if (length > size.width) {
        dataSet.removeAt(0);
        length = dataSet.length;
      }
      // Create Path and set Origin to first data point
      Path trace = Path();
      trace.moveTo(0.0, size.height - (dataSet[0].toDouble() - yMin) * yScale);
      // generate trace path
      for (int p = 0; p < length; p++) {
        double plotPoint =
            size.height - ((dataSet[p].toDouble() - yMin) * yScale);

        trace.lineTo(p.toDouble() * xScale, plotPoint);
      }
      canvas.drawPath(trace, tracePaint);

      // if yAxis required draw it here
      if (showYAxis) {
        Offset yStart = Offset(0.0, size.height - (0.0 - yMin) * yScale);
        Offset yEnd = Offset(size.width, size.height - (0.0 - yMin) * yScale);
        canvas.drawLine(yStart, yEnd, axisPaint);
      }
    }
  }

  @override
  bool shouldRepaint(TracePainter old) => true;
}




class LinePainter3 extends CustomPainter {
   final List<CustomModel> animatedLines;
  double xRootFromCenter;
  double yRootFromCenter;
  final double thickness;
  LinePainter3({
    @required this.animatedLines,
    this.thickness = 3.0,
    this.xRootFromCenter = 0.0,
    this.yRootFromCenter = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    animatedLines.forEach((lineNode) {
      Paint p = Paint()
         ..color = Colors.green//RandomColor.next()
        //Colors.green//lineNode.vars["color"]
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(lineNode.vars["point1"].vars["current"], lineNode.vars["point2"].vars["current"], p);
    });
    //  Paint p = Paint()
    //     ..color = Colors.blue//lineNode.vars["color"]
    //     ..strokeWidth = 2.0
    //     ..strokeCap = StrokeCap.round
    //     ..style = PaintingStyle.stroke;
    //   canvas.drawCircle(Offset(600.0,300.0),250.0, p);
    //   canvas.drawLine(Offset(350.0,300.0),Offset(850.0,300.0), p);
    //   canvas.drawLine(Offset(600.0, 50.0),Offset(600.0,550.0), p);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
// import 'wave.dart';

class ComboWave {
  List<CustomModel> waves;
  double totalProgressPerCall;
  double tickprogress;
  List<double> trace = [];
  Color waveColor;
  CustomModel waveVals;
  int samplingfreq;
  int sampleCounter;
  List<CustomModel> sampleLocations;

  ComboWave({
    @required this.waves,
    this.waveColor = Colors.green,
    this.totalProgressPerCall = 0.012,
    this.tickprogress = 0.0,
    this.samplingfreq = -1,
  }) {
    sampleLocations = [];
    waveVals = CustomModel.fromLib("waveVal");
    //WaveVals(0.0, 0.0, 0.0);
    sampleCounter = 0;
  }

  update() {
    trace.add(waveVals?.vars["k"]);
    sampleCounter += 1;

    if (samplingfreq != -1 && (sampleCounter > samplingfreq)) {
      sampleLocations.add(CustomModel.fromLib("point_x_${waveVals.vars["z"]}_y_${waveVals.vars["k"]}"));//Point(waveVals.z, waveVals.k)
      sampleCounter = 0;
      if (sampleLocations.length > 1) {
        double x =  (sampleLocations[0].vars["x"] * (sampleLocations.length - 1) +
                    sampleLocations.last.vars["x"]) /
                sampleLocations.length;
        double y =  0.9*(sampleLocations[0].vars["y"]* (sampleLocations.length - 1) +
                    sampleLocations.last.vars["y"]) /
                sampleLocations.length;
        sampleLocations[0] = CustomModel.fromLib("point_x_${x}_y_$y");
           
      }
    }
    waveVals?.calls["zero"]();
    waves.forEach((w) {
      CustomModel wa = w.calls["updateWave"](tickprogress);
      waveVals?.calls["add"](wa);
    });
    waveVals.vars["rot"] = waveVals.vars["rot"] / waves.length;
    tickprogress += totalProgressPerCall;
  }
}
