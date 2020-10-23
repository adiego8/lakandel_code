
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;

class LauncherService { 


  ///Launch a phone call using url_launcher
  Future<dynamic> launchPhoneCall(String phoneNumber) async {
    String phoneNumberToCall = 'tel:$phoneNumber';
    if(await canLaunch(phoneNumberToCall)){
      print(phoneNumberToCall);
      await launch(
        phoneNumberToCall,
      );
    }else{
      print(phoneNumberToCall);
      return false;
    }
  }

  ///Launch a text message using url_launcher
  Future<dynamic> launchLaunchSMS(String phoneNumber) async {
    String phoneNumberToSMS = 'sms:$phoneNumber';
    if(await canLaunch(phoneNumberToSMS)){
      print(phoneNumberToSMS);
      await launch(
        phoneNumberToSMS,
      );
    }else{
      return false;
    }
  }


  ///Launch web link using url_launcher
  Future<dynamic> launchLink(String link) async {
    if(await canLaunch(link)){
      await launch(
        link,
      );
    }else{
      return false;
    }
  }


  ///Launch calls using intent package only for Android
  Future<dynamic> launchCallWithIntent(String phoneNumber) async {
    String scheme = 'tel';
    bool result = true;
    try {
      PermissionStatus status = await Permission.phone.request();
      if(status.isGranted){
        android_intent.Intent()
          ..setAction(android_action.Action.ACTION_CALL)
          ..setData(Uri(scheme: scheme, path: phoneNumber))
          ..startActivity().catchError((onError){
        result = false;
      });
      }
      
    return result;
    } on PlatformException catch (e) {
      print('Plaform Exception : ${e.message}');
    }
    
  }


  ///Launch sms using intent package, only for Android
  Future<dynamic> launchSMSWithIntent(String phoneNumber, String text) async {
    String scheme = 'tel';
    bool result = true;
    android_intent.Intent()
      ..setAction(android_action.Action.ACTION_SENDTO)
      ..setData(Uri(scheme: scheme, path: phoneNumber))
      ..startActivity().catchError((onError){
        result = false;
      });
    return result;
  }


}