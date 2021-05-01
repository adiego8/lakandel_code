
import 'package:lakandel/view/lobby.dart';
import 'package:lakandel/view/wait_view.dart';
import 'package:flutter/material.dart';

class MyRouterService {

  static Route<dynamic> generateRoute(RouteSettings settings){
    String title = 'Lakandel';
    switch (settings.name) {
      case WaitView.route:
        return MaterialPageRoute(builder: (_)=>WaitView());        
        break;
      case MyHomePage.route:
        return MaterialPageRoute(builder: (_) => MyHomePage(title: title,));
      default:
        return null;
    }

  }


}