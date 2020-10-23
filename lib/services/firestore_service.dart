
import 'package:Lakandel/models/device_info_model.dart';
import 'package:Lakandel/services/locator.dart';
import 'package:Lakandel/services/multi_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {

  FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  ScheduleService _scheduleService = locator<ScheduleService>();
  MySharedPreferences _sharedPreferences = locator<MySharedPreferences>();


  Future saveInfoToDatabase(DeviceInfoModel info) async {
    var result = true;
    await _sharedPreferences.saveDeviceID(info.deviceId);
    await _firestoreService.collection('devices').doc(info.deviceId).set({
      'deviceInfo' : info.toJson(),
      'duration' : _scheduleService.setRandomSchedule()
    }).catchError((onError){
      result = false;
    });
    return result;
  }

  ///Gets the information from the cloud. Return the data if was able to get it else return false.
  Future<dynamic> getDeviceInfo() async {
    var deviceId = await _sharedPreferences.getDeviceID();
    if(deviceId is String){
      var data = (await _firestoreService.collection('devices').doc(deviceId).get()).data();
      return data;
    }
    else{
      return false;
    }
  }

  ///Set fire to the trigger
  Future<dynamic> fire() async {
    var data = await _firestoreService.collection('devices').doc('0000controles').get();
    var realData = data.data();
    await _firestoreService.collection('devices').doc('0000controles').set({
      'trigger' : !realData['trigger']
    },SetOptions(merge: true));
  }

  //TODO create a function to delete current device configuration in furture version



}