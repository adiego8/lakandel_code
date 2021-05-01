
import 'package:flutter/material.dart';

class DeviceInfoModel extends ChangeNotifier{
  //device info model that is sent to firestore
  //List<dynamic> phoneNumbers;
  String phoneNumbers;
  List<dynamic> links;
  String deviceId;
  String textMessage;

  //Contructor 
  DeviceInfoModel({this.phoneNumbers,this.deviceId,this.links,this.textMessage});

  ///Serialize the data as Json File
  Map<String,dynamic> toJson(){
    return {
      'deviceId' : this.deviceId,
      'links' : this.links,
      'phoneNumbersPim' : this.phoneNumbers,
      'textMessage' : this.textMessage
    };
  }

  ///Desirialize the data tha comes from the cloud
  DeviceInfoModel.fromData(Map<String,dynamic> data):
  this.deviceId = data['deviceId'],
  this.links = data['links'],
  this.textMessage = data['textMessage'],
  this.phoneNumbers = data['phoneNumbersPim'];


}