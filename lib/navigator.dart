
import 'package:flutter/material.dart';
import 'package:no_brainer/utils/checks.dart';

class Navigation {
  List<String> currentRoute = ["/"];
  Function refresh;
  Map routes;
  int longestStr;
  Navigation(this.refresh, this.routes){
    longestStr = getLongestStr(routes);
  }

  bool isRoot() => currentRoute.length == 1;

  void goHome() {
    currentRoute = ['/'];
    refresh();
  }

  void goUpLayer() {
    if (currentRoute.length > 1) {
      currentRoute.removeLast();
      currentRoute.last = "/";
    }
    refresh();
  }

  void goDownLayer(String route) {
    currentRoute.last = route;
    if (routes[route] is Map) {
      currentRoute.add("/");
    }
    refresh();
  }

  List<Widget> _getTabHeaders(double width) {
    List<Widget> tabHeaders = [];

    if (isRoot()) {
      int len= routes.length;
      double space=  (width-10.0*len)/len;
      double mainfont= space/longestStr;
      if(mainfont>30.0)mainfont=30.0;
      else if(mainfont<16)mainfont=16;
      routes.keys.forEach((key) {
        if (key != "/")
          tabHeaders
              .add(header(capWord(key.substring(1)), () => goDownLayer(key),width: space , textSize: mainfont, textColor: Colors.white));
      });
    } else {
      var layer = routes;
      for (int i = 0; i < currentRoute.length - 1; i++) {
        layer = layer[currentRoute[i]];
      }
      int len = layer.length;
      double space = (width-10.0*len)/len;
      double mainfont= space/longestStr;
      if(mainfont>30.0)mainfont=30.0;
      else if(mainfont<16)mainfont=16;
     // print(mainfont);
      tabHeaders.add(header(
          capWord(currentRoute[currentRoute.length - 2].substring(1)),
          () => goDownLayer("/"),width: space , textSize: mainfont, textColor: Colors.white));
      
      layer.keys.forEach((key) {
        // if(key!="/") print(capWord(key.substring(1)));
        if (key != "/")
          tabHeaders
              .add(header(capWord(key.substring(1)), () => goDownLayer(key),width: space , textSize: mainfont -2.0));
      });
    }
    return tabHeaders;
  }

  Widget header(String text, Function onPress, {double width=200, double textSize=12.0, Color textColor=Colors.indigo}) => Container(
      width: width,
      child: InkWell(
        onTap: onPress,
        child: Container(
          child: Center(
              child: Text(
            text,
            style: TextStyle(
              color: textColor,
               fontWeight: FontWeight.bold,
               fontSize: textSize
               ),
          )),
        ),
      )); //);

  AppBar getAppBar(double screenWidth) => AppBar(
       // elevation: 2.0,
       // backgroundColor: Colors.amber[200],
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            goHome();
          },
        ),
        title: Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _getTabHeaders(screenWidth- 70*3)),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_upward,
                color: isRoot() ? Colors.grey : Colors.black,
              ),
              onPressed: () {
                isRoot() ? goHome() : goUpLayer();
              }),
          IconButton(
              icon: Icon(
                Icons.account_box,
                color: isRoot() ? Colors.grey : Colors.black,
              ),
              onPressed: () {
                
              }),
        ],
      );
  String getCurrentScreenStr() {
    // timer?.cancel();
    var layer = routes;
    for (int i = 0; i < currentRoute.length - 1; i++) {
      layer = layer[currentRoute[i]];
    }
    return layer[currentRoute.last];
  }
  dynamic getCurrentScreen() {
    // timer?.cancel();
    var layer = routes;
    for (int i = 0; i < currentRoute.length - 1; i++) {
      layer = layer[currentRoute[i]];
    }
    if( layer[currentRoute.last] is String){
      return ()=>Container(color: Colors.blue,);
    }
    try{
      return layer[currentRoute.last];
    }catch(e){
      return ()=>Container(color: Colors.blue,);
    }
  }
  Widget navBar(double screenWidth) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "C5",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30),
            ),
                Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _getTabHeaders(screenWidth- 150*3)),
        
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
                SizedBox(
                  width: 30,
                ),
                // MaterialButton(
                //   color: Colors.pink,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(20.0))),
                //   onPressed: () {},
                //   child: Text(
                //     "Get Started",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
          IconButton(
              icon: Icon(
                Icons.arrow_upward,
                color: isRoot() ? Colors.grey : Colors.white,
              ),
              onPressed: () {
                isRoot() ? goHome() : goUpLayer();
              }),
              ],
            )
          ],
        ),
      ),
    );
       
  }
}
