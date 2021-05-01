

import 'package:lakandel/models/device_info_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (context)=>DeviceInfoModel())
]; 