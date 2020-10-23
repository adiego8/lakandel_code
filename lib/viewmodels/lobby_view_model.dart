
import 'package:Lakandel/models/device_info_model.dart';
import 'package:Lakandel/services/firestore_service.dart';
import 'package:Lakandel/services/locator.dart';
import 'package:provider_architecture/_base_viewmodels.dart';


class LobbyViewModel extends BaseViewModel{
  
  FirestoreService _firestoreService = locator<FirestoreService>();

  ///Send the data to the database
  Future<dynamic> onSchedule(DeviceInfoModel info) async {
    var result = await _firestoreService.saveInfoToDatabase(info);    
    return result;
  }

}