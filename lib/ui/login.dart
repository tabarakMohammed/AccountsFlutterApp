import 'dart:async';
import 'package:flutter/material.dart';
import 'package:key_guardmanager/key_guardmanager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:accounts/ui/home.dart';
import 'package:accounts/library/bioMSinsor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget  {


  @override
  _Login createState()  => new _Login();

}

class _Login extends State<Login>  {


  @override
  void initState() {
    super.initState();
  }

  BioMetric bb = new BioMetric();
  String massige = "";
  String _platformVersion = 'Unknown';


  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await KeyGuardmanager.authStatus;
      if(platformVersion == "true"){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListView1()),
        );
      }
      print(platformVersion);
    } on PlatformException {
      platformVersion = 'Failed to get platform offline Auth.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }


  @override
  Widget build(BuildContext context) {


    return Directionality(
        textDirection: TextDirection.rtl,

        child: Scaffold(
            backgroundColor:Color(0xFFFFcd84f1),

            appBar: AppBar(

              title: Text("حساباتي"),

              backgroundColor: Color(0xFF2c2c54),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.face), onPressed: showMassage,
                ),
              ],
            ),
            body: Center(

              child: Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                   new Text(_responseFromNativeCode.toString()),

                    new Text("للتحقق من هويتك بأستخدام بصمتك المميزة",

                      style:TextStyle(

                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ) ,


                    ),

                    //   padding: EdgeInsets.all(5),
                    new Text("اضغط على زر تسجيل الدخول لطفاً",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ), textAlign: TextAlign.center,
                    ),
                    Text('Running on: $_platformVersion\n'),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child:
                      OutlineButton.icon(onPressed: initPlatformState ,
                          label: new Text("تسجيل الدخول",),
                          icon: Icon(Icons.play_arrow)),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child:
                      OutlineButton.icon(onPressed: checkCheck ,
                          label: new Text("تسجيل الدخول يصمة",),
                          icon: Icon(Icons.play_arrow)),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 50),
                        child: new Text("$massige",
                          style: TextStyle(
                            fontSize: 17,
                            background: Paint(),
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                  ],
                ),
              ) ,

            )



        )


    );


  }






  ///check IF there its Biometrics in device

  Future<void> checkCheck() async {

    bool x  =  await bb.authenticate();
    var localAuth = LocalAuthentication();
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;

    if (canCheckBiometrics == true) {
      if (x == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListView1()),
        );

      } else {

      }

    } else if (canCheckBiometrics == false) {

  //    nativePass();

      setState(() {
        massige = "للأسف هذا الهاتف لا يملك اي نوع من انواع البصمة";
      });

    }


  }







  ///
  Future<void> showMassage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return
          AlertDialog(
            contentPadding: const EdgeInsets.all(5.7),
            shape:RoundedRectangleBorder
              ( side: BorderSide(color:Colors.black,width: 1.5),
                borderRadius: BorderRadius.all( Radius.circular(10.5))
            ),

            content: Container(
              padding: EdgeInsets.all(2),
              child:
              new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    new Text("التطبيق مفتوح المصدر"
                        "\tللدراسة و التطوير",
                      textAlign: TextAlign.center,
                    ),


                    FlatButton(onPressed: _goToUrl, child: Text("myApp/Github.com")
                      ,),

                    new FlatButton(
                        color: Colors.redAccent,
                        child: const Text('خروج من الرسالة'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),

                  ]
              ),
            ),
          );

      },
    );
  }


  _goToUrl() async {

    if (await canLaunch('https://github.com/tabarakMohammed/AccountsFlutterApp')) {
      await launch('https://github.com/tabarakMohammed/AccountsFlutterApp');
    } else {
      throw 'حدث خطأ ما، لا نستطيع الوصول للموقع ';
    }
  }


}


