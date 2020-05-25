
import 'package:flutter/material.dart';
import 'package:no_brainer/utils/other.dart';

class CustomAnimatedList extends StatefulWidget {
  final List<Widget> widgetList;
  final Rect lrtb;
  final DIREC introDirection;
  //final Size size;
 // final String buttonText;
  final bool onStart;
  final bool hasToggleButton;

  CustomAnimatedList({Key key, this.widgetList, this.lrtb, this.introDirection=DIREC.BTT, this.onStart=false, this.hasToggleButton=true}) : super(key: key);
  @override
  _CustomAnimatedListState createState() => _CustomAnimatedListState();
}

class _CustomAnimatedListState extends State<CustomAnimatedList>
    with TickerProviderStateMixin {
  AnimationController shapesSliderAnimation;
  List<Animation> itemAnimations;
  bool shapesShown = false;
  
  @override
  void initState() {
    super.initState();

    shapesSliderAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    );
    itemAnimations = List.generate((widget.widgetList.length), (i) {
      int index = i;
      double start = index * 0.1;
      double duration = 0.6;
      double end = duration + start;
      if(end>1)end=1.0;
      return new Tween<double>(
        begin:  (widget.introDirection==DIREC.BTT ||widget.introDirection==DIREC.LTR)?800.0:0.0, 
        end:  (widget.introDirection==DIREC.BTT ||widget.introDirection==DIREC.LTR)?0.0:800.0
        ).animate(
          new CurvedAnimation(
              parent: shapesSliderAnimation,
              curve: new Interval(start, end, curve: Curves.decelerate)));
    }).toList();
    if(widget.onStart){
      shapesSliderAnimation.forward();
      shapesShown=true;
    }
  }

  Iterable<Widget> _buildShapes() {
    return widget.widgetList.map((item) {
      int index = widget.widgetList.indexOf(item);
      return
      AnimatedBuilder(
        animation: shapesSliderAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: item
            
        ),
        builder: (context, child) {
         // if(widget.size.height*(widget.lrtb.bottom-widget.lrtb.top)-100< itemAnimations[index].value)return Container();
        return  new Transform.translate(
              offset: (widget.introDirection==DIREC.BTT ||widget.introDirection==DIREC.TTB)?
              Offset(0.0, itemAnimations[index].value):
               Offset( itemAnimations[index].value,0.0),


              child: child,
            );
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
 
   return Positioned.fromRect(
     rect: widget.lrtb,
      child:
            ListView(
            padding: EdgeInsets.symmetric(horizontal: 3.0),
            scrollDirection: (widget.introDirection==DIREC.LTR||widget.introDirection==DIREC.RTL)?Axis.horizontal:Axis.vertical,
            children: <Widget>[
              (widget.hasToggleButton)? MaterialButton(
                  color: Colors.pink,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  onPressed: () {
                     setState(() {
                        !shapesShown
                            ? shapesSliderAnimation.forward()
                            : shapesSliderAnimation.reverse();
                        shapesShown = !shapesShown;
                      });
                  },
                  child: Text(
                    "Menu",
                    style: TextStyle(color: Colors.white),
                  ),
                ):Container(),
   
            ]..addAll(_buildShapes()),
      ),
   // ),
     //  ),
    );
  }
}

 //  Size s = widget.size;//MediaQuery.of(context).size;
     //double h=s.height*(widget.lrtb.bottom-widget.lrtb.top);
  
    // return Positioned(
    //   left: s.width*widget.lrtb.left,
    //   width: s.width*(widget.lrtb.right-widget.lrtb.left),
    //   top: s.height*widget.lrtb.top,
    //   height: h,
    //   child:
// import 'package:flutter/material.dart';
// import 'package:no_brainer/utils/other.dart';

// class CustomAnimatedList extends StatefulWidget {
//   final List<Widget> widgetList;
//   final LRTBsize lrtb;
//   final DIREC introDirection;
//   final Size size;
//  // final String buttonText;
//   final bool onStart;
//   final bool hasToggleButton;

//   CustomAnimatedList({Key key, this.widgetList, this.lrtb, this.introDirection=DIREC.BTT, this.size, this.onStart=false, this.hasToggleButton=true}) : super(key: key);
//   @override
//   _CustomAnimatedListState createState() => _CustomAnimatedListState();
// }

// class _CustomAnimatedListState extends State<CustomAnimatedList>
//     with TickerProviderStateMixin {
//   AnimationController shapesSliderAnimation;
//   List<Animation> itemAnimations;
//   bool shapesShown = false;
  

//   @override
//   void initState() {
//     super.initState();

//     shapesSliderAnimation = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1100),
//     );
//     itemAnimations = List.generate((widget.widgetList.length), (i) {
//       int index = i;
//       double start = index * 0.1;
//       double duration = 0.6;
//       double end = duration + start;
//       if(end>1)end=1.0;
//       return new Tween<double>(
//         begin:  (widget.introDirection==DIREC.BTT ||widget.introDirection==DIREC.LTR)?800.0:0.0, 
//         end:  (widget.introDirection==DIREC.BTT ||widget.introDirection==DIREC.LTR)?0.0:800.0
//         ).animate(
//           new CurvedAnimation(
//               parent: shapesSliderAnimation,
//               curve: new Interval(start, end, curve: Curves.decelerate)));
//     }).toList();
//     if(widget.onStart){
//       shapesSliderAnimation.forward();
//       shapesShown=true;
//     }
//   }

//   Iterable<Widget> _buildShapes(Size screenSize) {
//     return widget.widgetList.map((item) {
//       int index = widget.widgetList.indexOf(item);
//       return
//       AnimatedBuilder(
//         animation: shapesSliderAnimation,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//           child: item
            
//         ),
//         builder: (context, child) {
//          // if(widget.size.height*(widget.lrtb.bottom-widget.lrtb.top)-100< itemAnimations[index].value)return Container();
//         return  new Transform.translate(
//               offset: (widget.introDirection==DIREC.BTT ||widget.introDirection==DIREC.TTB)?
//               Offset(0.0, itemAnimations[index].value):
//                Offset( itemAnimations[index].value,0.0),


//               child: child,
//             );
//         }
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size s = widget.size;//MediaQuery.of(context).size;
//      double h=s.height*(widget.lrtb.bottom-widget.lrtb.top);
  
//     return Positioned(
//       left: s.width*widget.lrtb.left,
//       width: s.width*(widget.lrtb.right-widget.lrtb.left),
//       top: s.height*widget.lrtb.top,
//       height: h,
//       child:// ,
   
//             ListView(
//             padding: EdgeInsets.symmetric(horizontal: 3.0),
//             // crossAxisAlignment: CrossAxisAlignment.end,
//             scrollDirection: (widget.introDirection==DIREC.LTR||widget.introDirection==DIREC.RTL)?Axis.horizontal:Axis.vertical,
//             children: <Widget>[
//               (widget.hasToggleButton)? MaterialButton(
//                   color: Colors.pink,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                   onPressed: () {
//                      setState(() {
//                         !shapesShown
//                             ? shapesSliderAnimation.forward()
//                             : shapesSliderAnimation.reverse();
//                         shapesShown = !shapesShown;
//                       });
//                   },
//                   child: Text(
//                     "Menu",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ):Container(),
   
//             ]..addAll(_buildShapes(s)),
//       ),
//    // ),
//      //  ),
//     );
//   }
// }
