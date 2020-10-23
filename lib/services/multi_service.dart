
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';


class ScheduleService {

  ///This way we set a random schedule meaning that it will create random times to trigger the launches in the system
  int setRandomSchedule(){
    // initially the scheduler will be manual the random number is the future delay
    return Random().nextInt(20);
  }

  ///Every time the application opens it will be able to fire other 
  ///when the schedule is set at the same time we set a duration value in seconds meaning that when anything is fired it has to
  /// wait that duration until it triggers the launch 

}



class MySharedPreferences {

  Future<SharedPreferences> _sharedFuturePreferences = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  ///Save the id defined in the device so when triggers true it would be able to get the 
  ///device ID.
  Future saveDeviceID(String deviceId) async {
    _sharedPreferences = await _sharedFuturePreferences;
    await _sharedPreferences.setString('deviceId', deviceId);
  }

  /// Gets the id saved in the device.
  /// Returns string is there is a deviceId saved else return false
  Future<dynamic> getDeviceID() async {
    _sharedPreferences = await _sharedFuturePreferences;
    var result = _sharedPreferences.getString('deviceId');
    if(result is String){
      return result;
    }else{
      return false;
    }
  }

}