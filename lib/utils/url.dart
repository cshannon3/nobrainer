  
import 'dart:html' as html;
//import 'package:url_launcher/url_launcher.dart';

bool launch(String url) {
  return html.window.open(url, '') != null;
}
  
   
 
 // const url = 'https://flutter.dev';
  // if (await canLaunch(url)) {
  //   await launch(url);
  //   return true;
  // } else {
    //throw 'Could not launch $url';