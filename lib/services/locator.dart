import 'package:lakandel/services/auth_service.dart';
import 'package:lakandel/services/firestore_service.dart';
import 'package:lakandel/services/launcher_service.dart';
import 'package:lakandel/services/multi_service.dart';
import 'package:get_it/get_it.dart';

  final GetIt locator = GetIt.instance;

  void setuplocator(){
    locator.registerLazySingleton(() => LauncherService());
    locator.registerLazySingleton(() => FirestoreService());
    locator.registerLazySingleton(() => MySharedPreferences());
    locator.registerLazySingleton(() => ScheduleService());
    locator.registerLazySingleton(() => AuthenticationService());
  }




