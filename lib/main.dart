import 'package:Lakandel/services/locator.dart';
import 'package:Lakandel/services/providers_service.dart';
import 'package:Lakandel/services/router_service.dart';
import 'package:Lakandel/view/wait_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  setuplocator();
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((_) => runApp(MyApp()));
  //runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final String title = 'Lakandel';  
  //final Future<FirebaseApp> _initialize = Firebase.initializeApp();
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: _initialize,
    //   builder: (context,snapshot) {
    //     if(snapshot.hasError){
    //       return Text('Something worng');
    //     }else{
          return MultiProvider(
            providers: providers,
            child: MaterialApp(
              onGenerateRoute: MyRouterService.generateRoute,
              debugShowCheckedModeBanner: false,
              title: title,
              theme: ThemeData(
                fontFamily: 'SourceCodePro',
                textTheme: TextTheme(
                  headline1: TextStyle(fontSize: 24, color: Colors.white),
                  headline2: TextStyle(fontSize: 18),
                ),
                primaryColor: Colors.blueGrey[800],
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: WaitView(),
            ),
          );
    //     }        
    //   }
    // );
  }

}
