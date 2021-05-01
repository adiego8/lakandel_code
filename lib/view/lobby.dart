

import 'package:Lakandel/models/device_info_model.dart';
import 'package:Lakandel/services/viewstate_service.dart';
import 'package:Lakandel/view/wait_view.dart';
import 'package:Lakandel/viewmodels/lobby_view_model.dart';
import 'package:Lakandel/widgets/text_form_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  static const String route = 'home';
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controllerPhone;
  TextEditingController _controllerLink; 
  TextEditingController _controllerID;
  TextEditingController _controllerTextMessage;
  String infoToUpload = '';
  bool _canMoveForward = false;

  @override
  void initState() {
    super.initState();
    _controllerPhone = new TextEditingController();
    _controllerLink = new TextEditingController();
    _controllerID = new TextEditingController();
    _controllerTextMessage = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,style:Theme.of(context).textTheme.headline1,),
      ),
      body: ViewModelProvider<LobbyViewModel>.withConsumer(
        viewModelBuilder: () => LobbyViewModel(),
        builder:(context,model,child) => Consumer<DeviceInfoModel>(
          builder:(context,info,child) => Padding(
            padding: EdgeInsets.only(top:15.0, right: 10,left: 10,bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormButton( //id
                    labelText: 'Add unique ID for this device',
                    buttonText: 'Add ID',
                    controller: _controllerID,
                    buttonAction: (){
                      setState(() {
                        infoToUpload = infoToUpload+ '\nDevice ID: '+_controllerID.text;
                        info.deviceId =  _controllerID.text.trim();
                        _controllerID.clear();
                      });                       
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormButton( // links
                    labelText: 'Add links separated by comma',
                    buttonText: 'Add Links',
                    controller: _controllerLink,
                    buttonAction: (){
                      setState(() {
                        infoToUpload = infoToUpload+ '\nLinks List: '+_controllerLink.text;
                        info.links = _controllerLink.text.split(',');
                        for (var i = 0; i < info.links.length; i++) {
                          info.links[i].trim();                              
                        }
                        _controllerLink.clear();
                      }); 
                      
                    },
                  ),
                  SizedBox(height: 10,),
                  TextFormButton( // phone
                    labelText: 'Add phone numbers separated by comma',
                    buttonText: 'Add Numbers',
                    buttonAction: (){
                      setState(() {
                        infoToUpload = infoToUpload+ '\nPhone List: '+_controllerPhone.text;
                        info.phoneNumbers = _controllerPhone.text;
                        // info.phoneNumbers = _controllerPhone.text.split(',');
                        // for (var i = 0; i < info.links.length; i++) {
                        //   info.links[i].trim();                              
                        // }
                        _controllerPhone.clear();         
                      });
                    },
                    controller: _controllerPhone,
                  ),
                  TextFormButton( // text message
                    labelText: 'Add Text Message',
                    buttonText: 'Add Message',
                    buttonAction: (){
                      setState(() {
                        infoToUpload = infoToUpload+ '\nText Message: '+_controllerTextMessage.text;
                        info.textMessage = _controllerTextMessage.text.trim();        
                        _controllerTextMessage.clear(); 
                      });
                    },
                    controller: _controllerTextMessage,
                  ),
                  SizedBox(height: 10,),
                  Align( // text info to upload
                    alignment: Alignment.centerLeft,
                    child: Text('Info to Upload',style: Theme.of(context).textTheme.headline2)), // shows the Model that is going to be sent to the database
                  Container( // square where we put the info
                    width: double.maxFinite,
                    child: Text(infoToUpload),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey,width: 3)
                    ),
                  ),
                  FlatButton( // clear button
                    onPressed: () {
                      setState(() {
                        infoToUpload = '';
                      });
                    }, 
                    child: Text('Clear',style: TextStyle(color: Colors.white,fontSize: 16),),
                    color: Colors.red,
                  ),
                  SizedBox(height: 50,),
                  Align( // button to go to set up the scheduler
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:20.0),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      color: !model.busy(ViewState.busy) ? Colors.cyan[900].withOpacity(0.5) : Colors.white,
                      child: !model.busy(ViewState.busy)
                      ?Text(!_canMoveForward ? 'Schedule' : 'Continue',style: Theme.of(context).textTheme.headline1,)
                      :CupertinoActivityIndicator(),
                      onPressed: !_canMoveForward ? () async {
                        // need to add data to all the fields
                        print(infoToUpload);                        
                        if(infoToUpload.contains('Phone')&&infoToUpload.contains('Links')&&infoToUpload.contains('ID')){
                          model.setBusyForObject(ViewState.busy, true);
                          var result = await model.onSchedule(info); //creation of the separated by comma lists                                
                          model.setBusyForObject(ViewState.busy, false);   
                          if(result){
                            setState(() {
                              infoToUpload = 'Set up completed.';
                              _canMoveForward = true;
                            });
                          }else{
                            setState(() {
                              infoToUpload = 'Set up failed!';
                            });
                          }
                        }else{
                          //show dialog to add data to all the fields
                          setState(() {
                            infoToUpload = 'Please add complete set up data!';
                          });
                        }
                      }
                      :(){
                        //Navigate to the wait window
                        setState(() {
                          _canMoveForward = false;
                          infoToUpload = '';
                        });
                        Navigator.pushNamed(context, WaitView.route);                        
                      },
                    ),
                  ),
                )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // //Split the information and put it in the model
  // void _stringToInfo(DeviceInfoModel info){
  //   List<String> stringCut = infoToUpload.split('\n');
  //   for (var i = 0; i < stringCut.length; i++) {
  //     if(stringCut[i] == 'Device ID'){
  //       info.deviceId = stringCut[i].split(':')[1].trim();
  //     }else if(stringCut[i] == 'Links List'){
  //       info.links = stringCut[i].split(':')[1].split(',');
  //       for (var j = 0; j < info.links.length; j++) {
  //         info.links[j].trim();          
  //       }
  //     }else if(stringCut[i] == 'Phone List'){
  //       info.phoneNumbers = stringCut[i].split(':')[1].split(',');
  //       for (var y = 0; y < info.links.length; y++) {
  //         info.phoneNumbers[y].trim();          
  //       }
  //     }
  //   }
  // }

}
