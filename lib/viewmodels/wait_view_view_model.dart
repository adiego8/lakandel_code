
// import 'dart:io';
// import 'dart:math';
import 'package:lakandel/models/device_info_model.dart';
import 'package:lakandel/services/auth_service.dart';
import 'package:lakandel/services/firestore_service.dart';
//import 'package:lakandel/services/launcher_service.dart';
import 'package:lakandel/services/locator.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider_architecture/_base_viewmodels.dart';

class WaitViewViewModel extends BaseViewModel{

  FirestoreService _firestoreService = locator<FirestoreService>();
  //LauncherService _launcherService = locator<LauncherService>();
  AuthenticationService _authenticationService = locator<AuthenticationService>();
  static const platform = const MethodChannel('sendSms');

  // Release the system to start making the calls and consum data
  Future releaseMechanism() async {
    /**
     * 1 get the id from sharedpreferences
     * 2 get the document from firestore
     * 3 get the delay and set it 
     * 4 release all the launches
     */
    var result = await _firestoreService.getDeviceInfo();
    if(result is bool){
      //no cogio nada 
    }else{ // set up the system
      DeviceInfoModel info = new DeviceInfoModel.fromData(result['deviceInfo']);
      //Duration duration1 = new Duration(seconds: result['duration']); //este da la duracion 
      //Duration duration2 = new Duration(seconds: result['duration']+4); //este hace la duracion mas pequena para que la llamada se tire antes que el link
      try {
        PermissionStatus status = await Permission.sms.request();
        if(status == PermissionStatus.granted){
          var phonesArray = info.phoneNumbers.split(',');
          for (var i = 0 ; i < phonesArray.length ; i ++) {
            final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"+1${phonesArray[i]}","msg":"${info.textMessage}"}); //Replace a 'X' with 10 digit phone number
            print(result);
          }
        }
      } on PlatformException catch (e) {
        print(e.toString());
      }
      // await Future.delayed(duration1,() async {
      //   int indexToCall = Random().nextInt(info.phoneNumbers.length);
      //   Platform.isAndroid ? await _launcherService.launchCallWithIntent(info.phoneNumbers[indexToCall]) : await _launcherService.launchPhoneCall(info.phoneNumbers[indexToCall]);
      // }); 
      // Future.delayed(duration2,() async {
      //   for (var i = 0; i < info.links.length; i++) {
      //     await _launcherService.launchLink(info.links[i]);
      //   }
      // });      
    }
  }

  // This only for the phones that are going to fire the trigger
  Future fire() async {
    await _firestoreService.fire();
  }

  // To authenticate a valid user
  Future authenticate(String email, String password) async {
    var result;
    result = await _authenticationService.authenticate(email, password);
    return result;
  }
  
  //Sign out current user from the application
  void signout() async {
    _authenticationService.signout();
  }

  bool isAuthorized() {
    return _authenticationService.isAuthorized();
  }


}