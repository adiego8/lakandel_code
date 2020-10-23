
import 'package:Lakandel/view/lobby.dart';
import 'package:Lakandel/viewmodels/wait_view_view_model.dart';
import 'package:Lakandel/widgets/text_form_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class WaitView extends StatefulWidget {
  WaitView({Key key}) : super(key: key);
  static const String route = 'wait';
  @override
  _WaitViewState createState() => _WaitViewState();
}

class _WaitViewState extends State<WaitView> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  @override
  void initState() {
    super.initState();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
  }
  @override
  Widget build(BuildContext context) {    
    return ViewModelProvider<WaitViewViewModel>.withConsumer(
      viewModelBuilder:()=>WaitViewViewModel(),
      builder:(context,model,child) => Scaffold(
        appBar: AppBar(
          title: Text('Wait here'),
          actions: [
            FlatButton(
              onPressed:(){
                Navigator.pushNamed(context, MyHomePage.route);
              }, 
              child: Text('Set Up', style: TextStyle(color: Colors.white,fontSize: 16),)
            ),
            FlatButton.icon( //button to fire the trigger 
              onPressed: () async {
                await model.fire();
              }, 
              icon: Icon(Icons.fireplace,color: Colors.white,),
              label: Text(''))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email',style: Theme.of(context).textTheme.headline2,),           
                Center(
                  child: TextFormField(
                    maxLines: null,
                    controller: _emailController,            
                  ),
                ),
                TextFormButton(
                  labelText: 'Password',
                  controller: _passwordController,
                  buttonText: 'Authenticate',
                  buttonAction: () async {
                    if(_emailController.value.text != null && _passwordController.value.text != null){
                      var result;
                      result = await model.authenticate(_emailController.text,_passwordController.text);
                      if(result){
                        setState(() {
                          _emailController.clear();
                          _passwordController.clear();
                        });
                      }else{
                        //do nothing
                      }
                    }
                  },
                ),
                FlatButton(
                  child: Text('Sign out',style: TextStyle(color: Colors.white,fontSize: 16),),
                  color: Colors.grey[850],
                  onPressed: () async {
                    model.signout();
                  }
                ),                
                SizedBox(height: 160,),
                _isAuthorized(model)
                ?StreamBuilder<DocumentSnapshot>( // stream builder is waiting for the trigger to shoot
                  stream: FirebaseFirestore.instance.collection('devices').doc('0000controles').snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
                     if(snapshot.hasData){
                       var myData = snapshot.data.data();
                       bool trigger = myData['trigger'] ?? false;
                       if(trigger){
                         //release mechanism
                         model.releaseMechanism();
                         return Center(child: Text('Running',style: Theme.of(context).textTheme.headline2,));
                       }else{
                         return Center(child: CupertinoActivityIndicator(radius: 20,));
                       }
                     }else{
                       return Text('Nothing running');
                     }           
                   },
                )
                :Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isAuthorized(WaitViewViewModel model) {
    var result = model.isAuthorized();   
    return result;
  }
}