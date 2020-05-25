
import 'package:flutter/widgets.dart';
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/utils/main_painter.dart';

class MainAnimator extends StatefulWidget {
  final bool painted;
  final CustomModel model;
  final List<CustomModel> models;
  MainAnimator({this.model, this.models, this.painted=false});
  @override
  _MainAnimatorState createState() => _MainAnimatorState();
}

class _MainAnimatorState extends State<MainAnimator> with TickerProviderStateMixin  {

  List<Widget> widgets=[];
  @override
  void initState() {
    super.initState();
    if(widget.model!=null && widget.model.calls.containsKey("animate")){
      try{
        widget.model.calls["animate"](vsync:this, setState:()=>setState(() { }));}
      catch (e){
      }
      if(!widget.painted){
        if(widget.model.calls.containsKey("toWidgetList"))widgets.addAll(widget.model.calls["toWidgetList"]());
        else if(widget.model.calls.containsKey("toWidget"))widgets.add(widget.model.calls["toWidget"]());

      }
    }
    if(widget.models!=null && widget.models!=[] ){
      widget.models.forEach((m){
        if(m.calls.containsKey("animate")){
            try{
            m.calls["animate"](vsync:this, setState:()=>setState(() { }));}
          catch (e){
          }
        }
        if(!widget.painted){
          if(m.calls.containsKey("toWidgetList"))widgets.addAll(m.calls["toWidgetList"]());
          else if(m.calls.containsKey("toWidget"))widgets.add(m.calls["toWidget"]());

        }
      });
    }
    
  }
  @override
  void dispose() { 
   try{print("OL");
     widget.model.calls["dispose"]();
     print("OB");}
   catch (e){ }

    try{widget.models.forEach((m){
               try{ m.calls["dispose"]();}catch(e){}
           });
      } catch (e){}
  super.dispose();
}
  
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    //print(h);
    return Stack(
      children: !widget.painted? widgets:<Widget>[
        CustomPaint(
          painter: 
          MainPainter(model: widget.model, models: widget.models),
          child: Container(
            height: h,
            width: w,
          ),
        ),
      ],
    );
  }
}