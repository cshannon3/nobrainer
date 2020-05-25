// Random color from https://github.com/matthew-carroll/fluttery/blob/master/lib/framing.dart
/// Tools for framing out user interfaces quickly.
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RandomColor {
  static final Random _random = new Random();

  /// Returns a random color.
  static Color next() {
    return new Color(0xFF000000 + _random.nextInt(0x00FFFFFF));
  }
}

// from https://github.com/matthew-carroll/fluttery/blob/master/lib/framing.dart

/// Widget that takes up a given [width] and [height] and paints itself with a
/// random color.
///
/// The random color survives through hot reload because [RandomColorBlock] is
/// a [StatefulWidget].  However, the color will be randomized again after a
/// full reload or a full rebuild.
class RandomColorBlock extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final double opacity;

  RandomColorBlock({this.width, this.height, this.child, this.opacity=1.0});

  @override
  _RandomColorBlockState createState() => new _RandomColorBlockState();
}

class _RandomColorBlockState extends State<RandomColorBlock> {
  Color randomColor;

  @override
  void initState() {
    super.initState();
    randomColor = RandomColor.next().withOpacity(widget.opacity);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: widget.width,
      height: widget.height,
      color: randomColor,
      child: widget.child,
      
    );
  }
}
List<Widget> randomBlockList() {
   // List<Widget> out = (widget.child is Widget) ? [widget.child] : [];
   List<Widget> out =[];
    for (int y = 0; y < 10; y++) {
      out.add(
        RandomColorBlock(
            height: 50.0,
            child: Container(
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
              ),
            )),
      );
    }
    
    return out;
  }
