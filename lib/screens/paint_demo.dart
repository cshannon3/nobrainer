import 'dart:math';

import 'package:flutter/material.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/utils/main_painter.dart';
import 'package:no_brainer/utils/mathish.dart';

class PaintDemo extends StatelessWidget {
  PaintDemo({Key key}) : super(key: key);
  
  PaintController paintController;
  ColorList colorList;
  StrokeWidthSlider strokeWidthSlider;
  UndoButtonBar undoButtonBar;
  PaintArea paintArea;
  ShapeTemplatesList shapeTemplatesList;

  final double pieceSize = 30.0;
  @override
  
  @override
  Widget build(BuildContext context) {
    paintController = PaintController();
    colorList = ColorList(
      paintController: paintController,
    );
    strokeWidthSlider = StrokeWidthSlider(
      paintController: paintController,
    );
    // TODO add undo button bar
    undoButtonBar = UndoButtonBar(paintController: paintController);

    paintArea = PaintArea(
      paintController: paintController,
    );
    shapeTemplatesList = ShapeTemplatesList(
      paintController: paintController,
    );

    paintController.initGrid(MediaQuery.of(context).size, pieceSize);
    return Scaffold(
        appBar: AppBar(
            title: PreferredSize(
                preferredSize: Size(MediaQuery.of(context).size.width, 50.0),
                child: colorList)),
        body: Stack(
          children: <Widget>[
            paintArea,
            strokeWidthSlider,
            shapeTemplatesList,
            undoButtonBar,
          ],
        ));
  }
}



class PaintController extends ChangeNotifier {
  //int rows;
  //int columns;
  //double spotSize;
  Color _currentColor;
  double _currentStrokeWidth;
  List<Shape> _shapes;
  //List<ColoredLine> _coloredLines;
  List<CustomModel> _coloredLines;
  //List<PaintLayer> _paintLayers =[];
  //bool _gridOn;
  int _activeShapeIndex;
  // Way for listeners to know which changes affect them
  UpdateStatus updateStatus = UpdateStatus.UpToDate;

  double _piecesize, _verticalPadding, _horizontalPadding;
  Size _screenSize;
  int _rows, _columns;
  bool _gridOn;
  List<int> _gridLocations;

  /* TODO Grid System for location
   Not setup yet but this will make positions of shapes much more
   indexable by limiting possible locations to ~ 150 spots
   shapes will be added to the list by adding 1 to their line index
   //TODO update list when any shapes are removed or different way to index them
   TODO could make lines clickable by basically going through any block they
   paint through and, if empty add them, if filled by line compare points of current
   with the colored line in that position and set the one with the most in that position
   these will be set by multiplying by -1 then subtracting 1 so they are all negative
   Shapes will always override lines for location
  */

  PaintController({
    Color initialColor = Colors.blue,
    double initialStrokeWidth = 4.0,
  }) {
    _currentColor = initialColor;
    _currentStrokeWidth = initialStrokeWidth;
    _shapes = [];
    _coloredLines = [];
  }

  initGrid(Size screenSize, double pieceSize) {
    _piecesize = pieceSize;
    _screenSize = screenSize;
    _rows = (screenSize.height / _piecesize).floor();
    _columns = (screenSize.width / _piecesize).floor();
    _horizontalPadding = (screenSize.width % _piecesize) / 2;
    _verticalPadding = (screenSize.height % _piecesize) / 2;
    _gridOn = true;
    _gridLocations = List.filled(_columns * _rows, 0);
    notifyListeners();
  }

  updateMade({bool resetActiveShapeIndex = false}) {
    assert(updateStatus != UpdateStatus.UpToDate);
    if (resetActiveShapeIndex) _activeShapeIndex = null;
    updateStatus = UpdateStatus.UpToDate;
    notifyListeners();
  }

  updateMadeAdded(bool shape, int paintLayerIndex) {
    assert(updateStatus != UpdateStatus.UpToDate);
    updateStatus = UpdateStatus.UpToDate;
    notifyListeners();
  }

  int get activeShapeIndex => _activeShapeIndex;

  Color get currentColor => _currentColor;

  set currentColor(Color newColor) {
    if (_currentColor != newColor) {
      print("color change");
      _currentColor = newColor;
      updateStatus = UpdateStatus.ColorChange;
      notifyListeners();
    }
  }

  double get currentStrokeWidth => _currentStrokeWidth;

  set currentStrokeWidth(double newThickness) {
    if (_currentStrokeWidth != newThickness) {
      _currentStrokeWidth = newThickness;
      updateStatus = UpdateStatus.StrokeWidthChange;
      notifyListeners();
    }
  }

  /*
  SHAPE FUNCTIONS               SHAPE FUNCTIONS
                 SHAPE FUNCTIONS
 SHAPE FUNCTIONS               SHAPE FUNCTIONS
                 SHAPE FUNCTIONS
 SHAPE FUNCTIONS               SHAPE FUNCTIONS
  */

  /* Anytime a shape is being modified or moved, it will become the active shape
  // and functions will be done in a stateful widget in the [ActivePaintArea] widget
  // Once modifications are complete, it will be 'saved'. Meaning if it was already added
  //  to that area before, it will be updated, otherwise it will be added to [PaintArea]
  */
  List<Shape> get shapes => _shapes;

  Shape getShape(int index) {
    //print(index);
    // assert(isIndexInList(index, _shapes.length));
    return _shapes[index];
  }

  // Undo button removes last shape
  removeLastShape() {
    if (_shapes.length > 0) {
      _shapes.removeLast();
      assert(_activeShapeIndex == null);
      // active shape must be completed before using this button

    }
  }

  /* To move a shape that is already on canvas,
      // Call comes from [ActivePaintArea] widget
      //
      // Will make sure shape exists, then set active shape index
      // When listeners are notified, [PaintArea] will respond by making
      // that shape invisible until new location is set
// This allows for a clean split between stateless and stateful apps
*/
  Shape activateShape(int shapeIndex) {
    // assert(isIndexInList(shapeIndex, _shapes.length));
    _activeShapeIndex = shapeIndex;
    updateStatus = UpdateStatus.ActiveShape;
    notifyListeners();
    return getActiveShape();
  }

  deactivateShape() {
    assert(_activeShapeIndex != null);
    updateStatus = UpdateStatus.ShapeChange;
  }

  Shape getActiveShape() {
    assert(_activeShapeIndex != null);
    return _shapes[_activeShapeIndex];
  }

  Shape getNewestShape() {
    return _shapes.last;
  }

  // TODO Add a Trash Can to remove shapes if they are at specific location
  /* When location is set, [Paint area] will check the shape of the active index
  // that it stored locally and update location
  */
  setShapeToLocation(Offset location) {
    assert(_activeShapeIndex != null);
    assert(_shapes[_activeShapeIndex].location != location);

    _shapes[_activeShapeIndex].location = location;
    updateStatus = UpdateStatus.ShapeChange;

    notifyListeners();
  }

  // When shape is dragged from template and placed down
  // It is added to [PaintArea] when it is placed down
  addNewShapeToCanvas(Shape newShape) {
    //newShape.location = location;
    _shapes.add(newShape);
    // set index of shape to grid location
    //print(getLocation(newShape.location));
    _gridLocations[getLocation(newShape.location)] = _shapes.length - 1;
    // _activeShapeIndex = _shapes.length -1;
    updateStatus = UpdateStatus.ShapeAdded;
    // When listeners are notified, [PaintArea] will check length
    // with shapes length to see if it needs to add last shape
    notifyListeners();
  }

  saveChangesToShape(Shape modifiedShape) {
    assert(_activeShapeIndex != null);
    _shapes[_activeShapeIndex] = modifiedShape;
    updateStatus = UpdateStatus.ShapeChange;

    notifyListeners();
  }

  /*
  COLORED LINE FUNCTIONS                      COLORED LINE FUNCTIONS
                        COLORED LINE FUNCTIONS
  COLORED LINE FUNCTIONS                      COLORED LINE FUNCTIONS
                        COLORED LINE FUNCTIONS
  COLORED LINE FUNCTIONS                      COLORED LINE FUNCTIONS

   */
  // For the initial App, once a line is
  // TODO
 // List<ColoredLine> get coloredLines => _coloredLines;
List<CustomModel> get coloredLines => _coloredLines;

  CustomModel getColoredLine(int index) {
    assert(((index <= 0) && index < _coloredLines.length));
    //  isIndexInList(index, _coloredLines.length));
    return _coloredLines[index];
  }

  addNewColoredLine(var points) {
    CustomModel _cl = createColoredLine();
    _cl.vars["points"] = points;
    _coloredLines.add(_cl);
    //  _paintLayers.add(PaintLayer(_cl));
    updateStatus = UpdateStatus.LineAdded;
    notifyListeners();
  }

  //ColoredLine
  CustomModel getNewestLine() {
    // assert(_coloredLines.length > 0);
    return _coloredLines.last;
  }

  //ColoredLine 
  CustomModel createColoredLine() {
    CustomModel cm=CustomModel.fromLib("coloredLine_sw_$_currentStrokeWidth");
    cm.vars["color"]= _currentColor;
    return cm;//ColoredLine(
        
        //points: [], strokeWidth: _currentStrokeWidth, color: _currentColor);
  }

  /*
  LOCATION/ Grid
  */

  //TODO PARAM THIS
  int getLocation(Offset location, {bool settingSpot = false}) {
    if (_gridOn) {
      int _piececolumn =
          ((location.dx - _horizontalPadding / 2) / (_piecesize + 3.0)).floor();
      int _piecerow =
          ((location.dy - _verticalPadding / 2) / (_piecesize + 3.0)).floor();
      int _pieceSpot = ((_piecerow) * (_columns)) + _piececolumn;
     // print(_pieceSpot);
      return _pieceSpot;
    }
    return null;
  }

  int isSpotFilled(Offset location) {
    return _gridLocations[getLocation(location)];
  }

  //List<PaintLayer> getPaintLayers(){return _paintLayers;}

  clearAll() {
    updateStatus = UpdateStatus.ClearAll;
    _activeShapeIndex = null;
    _shapes.clear();
    _coloredLines.clear();
    notifyListeners();
  }
}

enum UpdateStatus {
  ColorChange,
  StrokeWidthChange,
  ShapeChange,
  ShapeAdded,
  LineAdded,
  ActiveShape,
  ShapeRemoved,
  LineRemoved,
  ClearAll,
  UpToDate,
}

class ColorList extends StatefulWidget {
  final PaintController paintController;

  const ColorList({Key key, @required this.paintController}) : super(key: key);

  @override
  ColorListState createState() {
    return new ColorListState();
  }
}

class ColorListState extends State<ColorList> {
  Color currentColorValue;

  @override
  void initState() {
    // TODO: implement initState
    currentColorValue = widget.paintController.currentColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> colorButtons = List.generate(colorOptions.length, (i) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            color: colorOptions[i],
            height: 40.0,
            width: 40.0,
          ),
        ),
      );
    });
    return InfiniteList(
        onPressed: (selectedindex) {
          if (currentColorValue != colorOptions[selectedindex]) {
            setState(() {
              currentColorValue = colorOptions[selectedindex];
              widget.paintController.currentColor = colorOptions[selectedindex];
            });
          }
        },
        items: colorButtons);
  }
}

class PaintLayerWidget extends StatelessWidget {
  //final ColoredLine coloredLine;
  //final ColoredLine coloredLine;
  final CustomModel coloredLine;
  const PaintLayerWidget({Key key, this.coloredLine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.transparent,
      child: CustomPaint(
        painter: MainPainter(model: coloredLine),//PaintLayer2(coloredLine),
        isComplex: true,
        willChange: false,
      ),
    );
  }
}




List<Color> colorOptions = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.black,
  Colors.amber,
];
final List<Shape> templateShapes = [
  Shape(
    shapeType: ShapeType.circle,
    circle: Circle(radius: 20.0),
  ),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 50.0, sides: 3)),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 40.0, sides: 4)),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 30.0, sides: 5)),
  Shape(
      shapeType: ShapeType.polygon, polygon: Polygon(sidelen: 25.0, sides: 6)),
];



class PaintArea extends StatefulWidget {
  final PaintController paintController;

  PaintArea({Key key, @required this.paintController}) : super(key: key);

  @override
  _PaintAreaState createState() => _PaintAreaState();
}

class _PaintAreaState extends State<PaintArea> {
  PaintController paintController;
  // Paint layers
  List<Widget> paintLayers = [];
  ActivePaintArea activePaintArea;
  // use this to index paintLayers
  List<int> paintLayerOrder = [];
  // shape or line layer is the index of the paint order list
  // and shape or coloredLine index is the actual value,
  // the shape index will be the negative version -1
  // coloredlines will be pos +1 and 0 will be open/placeholder

  // Grid

  // Shapes and Lines have param PaintLayerIndex so that they can be
  // stacked in layers above and below
  @override
  void initState() {
    super.initState();
    paintController = widget.paintController;
    activePaintArea = ActivePaintArea(
      paintController: paintController,
    );

    paintController.addListener(() {
      switch (paintController.updateStatus) {
        case UpdateStatus.LineAdded:
          // Add line to widgets

          paintLayers.add(
              PaintLayerWidget(coloredLine: paintController.getNewestLine()));
          // Add position of Widget in list to paintOrder list
          // the position of the widget and index will be at same place so the index
          // of the paint layer can be found by searching for the index in paint layer order
          paintLayerOrder.add(paintController.coloredLines.length);

          // Send Acknowledgement to Paint Controller
          // Not Sure if this is implemented properly/is necessary yet
          paintController.updateMadeAdded(false, paintLayers.length - 1);
          // rebuild with new widget added to list, will appear on top(below activePaintArea)
          setState(() {});
          break;
        case UpdateStatus.LineRemoved:
          break;

        case UpdateStatus.ShapeAdded:
          paintLayers.add(ShapeCentered(
            shape: paintController.getNewestShape(),
          ));
          final int len = -paintController.shapes.length;
          paintLayerOrder.add(len);
          paintController.updateMade(resetActiveShapeIndex: true);
          setState(() {});
          break;
        case UpdateStatus.ActiveShape:
          // Replace shape replace shape widget with placeholder
          assert(paintController.activeShapeIndex != null);
          paintLayers[paintLayerOrder
              .indexOf(-(paintController.activeShapeIndex + 1))] = SizedBox();
          setState(() {});
          break;

        case UpdateStatus.ShapeChange:
          assert(paintController.activeShapeIndex != null);
          paintLayers[paintLayerOrder.indexOf(
              -(paintController.activeShapeIndex + 1))] = ShapeCentered(
            shape: paintController.getActiveShape(),
          );
          paintController.updateMade(resetActiveShapeIndex: true);
          setState(() {});
          break;

        case UpdateStatus.ShapeRemoved:
          // TODO remove the Layer Widget from list and from Layer Order List
          break;

        case UpdateStatus.ClearAll:
          paintLayers.clear();
          paintLayerOrder.clear();
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Making Grid ..
    Size screenSize = MediaQuery.of(context).size;

    return SizedBox.fromSize(
      size: MediaQuery.of(context).size,
      child: Stack(
        children: [
          //LocationsGridDebug(
          //  boardsize: MediaQuery.of(context).size,
          //  piecesize: 40.0,
          // ),
        ]
          ..addAll(paintLayers)
          ..add(activePaintArea),
      ),
    );
  }
}


class ActivePaintArea extends StatefulWidget {
  final PaintController paintController;

  const ActivePaintArea({Key key, this.paintController}) : super(key: key);

  @override
  _ActivePaintAreaState createState() => _ActivePaintAreaState();
}

// Have Shape Slider here initially
class _ActivePaintAreaState extends State<ActivePaintArea> {
  bool gridOn = false;
  bool shapesShown = false;
  PaintController paintController;

  CustomModel _activeColoredLine;
  Shape _selectedShape;
  int totalLen = 0;

  @override
  void initState() {
    super.initState();
    paintController = widget.paintController;
    _activeColoredLine = paintController.createColoredLine();
    paintController.addListener(() {
      switch (paintController.updateStatus) {
        case UpdateStatus.ColorChange:
          setState(() {
            _activeColoredLine = paintController.createColoredLine();
          });
          break;
        case UpdateStatus.StrokeWidthChange:
          setState(() {
            _activeColoredLine = paintController.createColoredLine();
          });

          break;
        case UpdateStatus.ClearAll:
          setState(() {
            _activeColoredLine = paintController.createColoredLine();
          });
          break;
        case UpdateStatus.UpToDate:
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.transparent,
      child: CustomPaint(
        painter:  MainPainter(model: _activeColoredLine),// PaintLayer2(_activeColoredLine),
      ),
    );
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTapDown: (details) {
            RenderBox box = context.findRenderObject();
            Offset point = box.globalToLocal(details.globalPosition);
            if (paintController.isSpotFilled(point) != 0) {
              setState(() {
                if (_selectedShape == null) {
                  //_selectedShape = paintController
                  _selectedShape = paintController
                      .activateShape(paintController.isSpotFilled(point));
                } else {
                  paintController.saveChangesToShape(_selectedShape);
                  _selectedShape = null;
                }
              });
              // Want a stopwatch to test if long press or pan.. could add long press
              // but don't want to inhibit pan if it is painting instead of selecting
              // an item
              print("Tap down");
            }
          },
          onPanStart: (DragStartDetails details) {
            // TODO if shape is selected move shape instead of create line
            if (_activeColoredLine.vars["points"] != null)
              _activeColoredLine.vars["points"] = [];
          },
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox box = context.findRenderObject();
              Offset point = box.globalToLocal(details.globalPosition);

              _activeColoredLine.calls["addPt"](point);
            });
          },
          onPanEnd: (DragEndDetails details) {
            // print(totalLen);
            // W/ PaintLayer2 Og settings 1349 ponits before red
            // W/ all being rendered every frame 857 points
            // W/ PaintLayer2 should repaint = true ~ 1200 points
            //  W/ PaintLayer2 should repaint true, and this using PaintLayer2, and isComplex: true,
            //        willChange: true, ~ 1300
            //  W/ PaintLayer2 should repaint true, and this using PaintLayer2, and  no extra settings ~ 1300
            _activeColoredLine.vars["points"].add(null);
            var _pts = _activeColoredLine.vars["points"];
            paintController.addNewColoredLine(_pts);
          },
          child: sketchArea,
        ),
       
      ],
    );
  }
}


class UndoButtonBar extends StatelessWidget {
  final PaintController paintController;

  const UndoButtonBar({Key key, @required this.paintController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
   // CustomWidget().toWidget(
  //    dataIn:{ "formatted_alignment_bottomRight_w_50_h_150_r_5_b_10"  : 
      Align(alignment: Alignment.bottomRight,
      child:Padding(padding:EdgeInsets.only(right: 5.0, bottom: 10.0),
      child:Container(
        width:50, height:150, child:
        FloatingActionButton(
          tooltip: 'clear Screen',
          backgroundColor: Colors.grey,
          child: Icon(Icons.undo),
          onPressed: () {
            paintController.clearAll();
          },
        ))),
      //])
  
    );
  }
}


class StrokeWidthSlider extends StatefulWidget {
  final PaintController paintController;

  const StrokeWidthSlider({Key key, @required this.paintController})
      : super(key: key);

  @override
  StrokeWidthSliderState createState() {
    return new StrokeWidthSliderState();
  }
}

class StrokeWidthSliderState extends State<StrokeWidthSlider> {
  double strokeWidthValue = 4.0;

  @override
  void initState() {
    super.initState();
    strokeWidthValue = widget.paintController.currentStrokeWidth;
  }

  @override
  Widget build(BuildContext context) {
    return 
    // CustomWidget().toWidget(
    //   dataIn: {"formatted_align_bottomCenter_w_250_h_50_all_8": 
      Align(alignment: Alignment.bottomCenter,
      child:Padding(padding:EdgeInsets.all(8.0),
      child:Container(
        width:250, height:50, child:
      Slider(
          value: strokeWidthValue,
          min: 1.0,
          max: 10.0,
          divisions: 9,
          label: 'Thickness $strokeWidthValue',
          activeColor: Colors.blue,
          onChanged: (newThickness) {
            if (strokeWidthValue != newThickness) {
              setState(() {
                strokeWidthValue = newThickness;
                widget.paintController.currentStrokeWidth = newThickness;
              });
            }
            
          },
        )
        )));
  }
}

    









//Column(children: <Widget>[
        // FloatingActionButton(
        //   tooltip: 'clear Screen',
        //   backgroundColor: Colors.blue,
        //   child: Icon(Icons.undo),
        //   onPressed: () {},
        // ),
  //  FormattedWidget(
  //     alignment: Alignment.bottomRight,
  //     size: Size(50.0, 150.0),
  //     padding: EdgeInsets.only(right: 5.0, bottom: 10.0),
  //     child: Column(children: <Widget>[
  //       FloatingActionButton(
  //         tooltip: 'clear Screen',
  //         backgroundColor: Colors.blue,
  //         child: Icon(Icons.undo),
  //         onPressed: () {},
  //       ),
  //       FloatingActionButton(
  //         tooltip: 'clear Screen',
  //         backgroundColor: Colors.grey,
  //         child: Icon(Icons.undo),
  //         onPressed: () {
  //           paintController.clearAll();
  //         },
  //       ),
  //     ]),
  //   );

    // FormattedWidget(
    //     padding: EdgeInsets.all(8.0),
    //     alignment: Alignment.bottomCenter,
    //     size: Size(250.0, 50.0),
    //     child:
class ShapeTemplatesList extends StatefulWidget {
  final PaintController paintController;

  const ShapeTemplatesList({Key key, this.paintController}) : super(key: key);
  @override
  _ShapeTemplatesListState createState() => _ShapeTemplatesListState();
}

class _ShapeTemplatesListState extends State<ShapeTemplatesList>
    with TickerProviderStateMixin {
  AnimationController shapesSliderAnimation;
  List<Animation> shapeAnimations;
  PaintController paintController;
  bool shapesShown = false;

  @override
  void initState() {
    super.initState();
    paintController = widget.paintController;
    paintController.addListener(() {
      if (paintController.updateStatus == UpdateStatus.ColorChange) {
        setState(() {});
      }
    });
    shapesSliderAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );
    shapeAnimations = templateShapes.map((sh) {
      int index = templateShapes.indexOf(sh);
      double start = index * 0.1;
      double duration = 0.6;
      double end = duration + start;
      return new Tween<double>(begin: 800.0, end: 0.0).animate(
          new CurvedAnimation(
              parent: shapesSliderAnimation,
              curve: new Interval(start, end, curve: Curves.decelerate)));
    }).toList();
  }

  Iterable<Widget> _buildShapes(Size screenSize) {
    return templateShapes.map((_sh) {
      _sh.color = widget.paintController.currentColor;
      int index = templateShapes.indexOf(_sh);
      return AnimatedBuilder(
        animation: shapesSliderAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: //ShapeCentered(shape: sh)),
              Draggable(
            child: ShapeCentered(
              shape: _sh,
            ),
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                paintController.addNewShapeToCanvas(Shape(
                  shapeType: _sh.shapeType,
                  color: paintController.currentColor,
                  location: offset -
                      Offset(0.0, AppBar().preferredSize.height + 80.0),
                  polygon: _sh.polygon,
                  circle: _sh.circle,
                ));
              });
            },
            feedback: ShapeCentered(
              shape: _sh,
            ),
          ),
        ),
        builder: (context, child) => new Transform.translate(
              offset: Offset(0.0, shapeAnimations[index].value),
              child: child,
            ),
      );
    });
  }
// FormattedWidget(
//       alignment: Alignment.topRight,
//       size: Size(
//           100.0,
//           shapesShown
//               ? 450.0
//               : shapesSliderAnimation.status == AnimationStatus.reverse
//                   ? 50 + 400.0 * (1 - shapesSliderAnimation.value)
//                   : 50.0),
//       child: 
  @override
  Widget build(BuildContext context) {
    double h = shapesShown
              ? 450.0
              : shapesSliderAnimation.status == AnimationStatus.reverse
                  ? 50 + 400.0 * (1 - shapesSliderAnimation.value)
                  : 50.0;
    // return CustomWidget().toWidget(
    //   dataIn: "formatted_align_topRight_w_100_h_$h",
    //   child:
    return Align(
      alignment:Alignment.topRight,
      child:Container(
        height:h,
       width:100,
       child:
      ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
              width: 100.0,
              height: 50.0,
              color: Colors.lightBlue,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    !shapesShown
                        ? shapesSliderAnimation.forward()
                        : shapesSliderAnimation.reverse();
                    shapesShown = !shapesShown;
                  });
                },
                child: Text('SHAPES'),
              )),
        ]..addAll(_buildShapes(MediaQuery.of(context).size)),
      ),
    ));
  }
 }
 

class Polygon {
  final double sidelen;
  final int sides;

  Polygon({
    @required this.sidelen,
    @required this.sides,
  });
}

class Circle {
  final double radius;
  Circle({
    @required this.radius,
  });
}

class Shape {
  final ShapeType shapeType;
  Color color;
  Offset location;
  Circle circle;
  Polygon polygon;
  int paintLayerIndex; // Specific for paint application
  Shape({
    this.shapeType,
    this.color = Colors.blue,
    this.location = const Offset(0.0, 0.0),
    this.polygon,
    this.circle,
  });

  Shape.fromOld(Shape oldShape, {Circle newCircle, Polygon newPolygon})
      : shapeType = oldShape.shapeType,
        location = oldShape.location,
        color = oldShape.color,
        polygon = newPolygon,
        circle = newCircle;
}

enum ShapeType { polygon, circle }


  //  this.location = const Offset(0.0, 0.0),
    //  this.color = Colors.blue
// this.location = const Offset(0.0, 0.0),
    // this.color = Colors.blue

    //Offset location;
  //Color color;

// TODO Add documentation


class PolygonPainter extends CustomPainter {
  final Polygon polygon;
  final Color color;
  double maxheight = 0.0;

  PolygonPainter({@required this.polygon, this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    double angles = 400 / (polygon.sides);
    double currentprogressangle = angles;

    final path = Path();
    path.moveTo(size.width / 2, size.height / 2);
    Point lastPoint = Point(size.width / 2, size.height / 2);

    for (int i = 0; i < polygon.sides; i++) {
      currentprogressangle = (i) * angles;
      double xpoint = lastPoint.x + polygon.sidelen * Z(currentprogressangle);
      double ypoint = lastPoint.y + polygon.sidelen * K(currentprogressangle);
      if (ypoint > maxheight) maxheight = ypoint;
      path.lineTo(xpoint, ypoint);
      lastPoint = Point(xpoint, ypoint);
    }

    path.close();
    canvas.translate(
        -polygon.sidelen / 2, -(maxheight - (size.height / 2)) / 2);

    //canvas.rotate(radians) Need To rotate odd numbers
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ShapeCentered extends StatelessWidget {
  final Shape shape;
  final Size size;

  ShapeCentered(
      {Key key, this.shape, this.size = const Size(100.0, 100.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (shape.shapeType) {
      case ShapeType.polygon:
        //shape.polygon.location = location;
        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: CustomPaint(
              painter:
                  PolygonPainter(polygon: shape.polygon, color: shape.color),
              child: SizedBox.fromSize(
                size: size,
              ) 
              ),
        );
        break;
      case ShapeType.circle:
        //shape.circle.location = location;
        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: SizedBox.fromSize(
            size: size,
            child: Center(
              child: Container(
                height: 2 * shape.circle.radius,
                width: 2 * shape.circle.radius,
                decoration:
                    BoxDecoration(color: shape.color, shape: BoxShape.circle),
              ),
            ),
          ),
        );
      default:
      return Container();
        break;
    }
  }
}

class ShapeCenteredAboutNode extends StatelessWidget {
  final Shape shape;
  final Size size;

  const ShapeCenteredAboutNode(
      {Key key, this.shape, this.size = const Size(100.0, 100.0)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (shape.shapeType) {
      case ShapeType.polygon:
        //shape.polygon.location = location;
        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: FractionalTranslation(
            translation: Offset(-0.5, -0.5),
            child: CustomPaint(
                painter:
                    PolygonPainter(polygon: shape.polygon, color: shape.color),
                child: SizedBox.fromSize(
                  size: size,
                ) 
                ),
          ),
        );
        break;
      case ShapeType.circle:
        //shape.circle.location = location;
        return Transform(
          transform: Matrix4.translationValues(
              shape.location.dx, shape.location.dy, 0.0),
          child: FractionalTranslation(
            translation: Offset(-0.5, -0.5),
            child: SizedBox.fromSize(
              size: size,
              child: Center(
                child: Container(
                  height: 2 * shape.circle.radius,
                  width: 2 * shape.circle.radius,
                  decoration:
                      BoxDecoration(color: shape.color, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        );
      default:
        break;
    }
  }
}

class InfiniteList extends StatefulWidget {
  final int selectedIndex;
  final Function(int index) onPressed;
  final List<Widget> items;
  InfiniteList({
    @required this.items,
    this.selectedIndex = 0,
    this.onPressed,
  });

  @override
  _InfiniteListState createState() => new _InfiniteListState();
}

class _InfiniteListState extends State<InfiniteList> {
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  List<Widget> items;
  int originalLength;

  @override
  void initState() {
    items = widget.items;
    originalLength = items.length;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      setState(() {
        items.addAll(items.sublist(0, originalLength));
        isPerformingRequest = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        Expanded(
          child: Container(
            height: 50.0,

            decoration: BoxDecoration(
              color: Colors.grey[600],
              border: Border(
                left: BorderSide(color: Colors.grey, width: 1.0),
                right: BorderSide(color: Colors.grey, width: 1.0),
                bottom: BorderSide(color: Colors.white24, width: 1.0),
                top: BorderSide(color: Colors.white24, width: 1.0),
              ), // Border
            ), // BoxDecoration
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => widget.onPressed(index % originalLength),
                    child: widget.items[index]);
              },
              controller: _scrollController,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {},
        ),
      ],
    );
  }
}
