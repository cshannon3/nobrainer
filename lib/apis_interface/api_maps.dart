
import 'package:no_brainer/makers/model_maker.dart';
import 'package:no_brainer/my_secrets.dart';
import 'package:no_brainer/utils/checks.dart';

Map<String, dynamic> simpleApiMap={

    "crypto":{
          "type":"api",
              "vars":(var tokens)=>{
                "name":"crypto", 
                "key": "", 
                "url": "https://api.coinmarketcap.com/v1/ticker/",
                "endpoints":["coin"],
                "currentEndpoint":"coin",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}"
              }
        },
    "weather":{
      "type":"api",
              "vars":(var tokens)=>{
                "name":"weather", 
                "key": secrets["weatherAPI"], 
                "url": "http://api.openweathermap.org/data/2.5/",
                "endpoints":["weather", "forcast"],
                "currentEndpoint":"weather",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}${self.vars["currentEndpoint"]}?id=524901&APPID=${self.vars["key"]}"
              }
        },
    "trivia":{
      "type":"api",
       "vars":(var tokens)=>{
                "name":"trivia", 
                "key": "",
                "url": "https://opentdb.com/api.php",
                "amount":10,
                "category":18,
                "endpoints":["questions"],
                "currentEndpoint":"questions",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}?amount=${self.vars["amount"]}&category=${self.vars["category"]}"
              }
      },
    "pixabay":{
      "type":"api",
       "vars":(var tokens)=>{
                "name":"pixabay", 
                "key": secrets["pixabayAPI"],
                "url": "https://pixabay.com/api/",
                "count":10,
                "endpoints":["images"],
                "currentEndpoint":"images",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}?key=${self.vars["key"]}&editors_choice=true&per_page=${self.vars["count"]}&orientation=vertical"
              }
      },
    "news":{
      "type":"api",
             "vars":(var tokens)=>{
                "name":"news", 
                "key": secrets["newsAPI"],
                "url": "https://newsapi.org/v2/",
                "endpoints":["everything", "top-headlines", "sources"],
                "currentEndpoint":"everything",
              },
              "functions":(CustomModel self)=>{
                "getUrl":(){
                   var url = "${self.vars["url"]}${self.vars["currentEndpoint"]}?apiKey=${self.vars["key"]}";
                   if(self.vars["currentEndpoint"]=="everything")url+="&pageSize=10&q=us";
                   else if (self.vars["currentEndpoint"]=="top-headlines")url+="&country=US";
                   return url;
                }
              }
  
      },
    "giphy":{
      "type":"api",
       "vars":(var tokens)=>{
                "name":"weather", 
                "key": secrets["Giphy"],
                "url": "https://api.giphy.com/v1/gifs/",
                "endpoints":["random"],
                "currentEndpoint":"random",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=>"${self.vars["url"]}${self.vars["currentEndpoint"]}?apiKey=${self.vars["key"]}&tag=&rating=G"
              }
    },
    "musixmatch":{
      "type":"api",
        "vars":(var tokens)=>{
                "name":"weather", 
                "key": secrets["musixmatch"],
                "url": "https://newsapi.org/v2/",
                "endpoints":["everything"],
                "currentEndpoint":"weather",
              },
              "functions":(CustomModel self)=>{
                "getUrl":()=> "${self.vars["url"]}${self.vars["currentEndpoint"]}?apiKey=9d206d9be4174155bf59edb914ce4101&pageSize=10&q=us?id=524901&APPID=${self.vars["key"]}"
              }
      },

  };