import 'package:flutter/material.dart';
import 'package:hospital_app/activity/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Card(
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Expanded(
                flex: 58,
                child: Container(
                  margin: EdgeInsets.only(top: 70),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/images/mainbackground.jpg'),
                  ),
                ),
              ),
              Expanded(
                flex: 35,
                child: Card(
                  color: Colors.white38,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Sağlık Yardımcın!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: "NotoSerif",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            'Tüm sağlık işlemlerini tek bir uygulamadan hallet.Online randevu alma, sağlık bilgilerine erişmek vb.. tüm özellikler elinin altında.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: "NotoSerif",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                            margin:
                                EdgeInsets.only(top: 25, left: 50, right: 50),
                            width: double.infinity,
                            height: 50,
                            child: CustomButton())
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      onPressed: () {
        /* Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));*/
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
          (route) => false,
        );
      },
      color: Color.fromARGB(255, 137, 196, 192),
      child: Text(
        'Başlayalım',
        style: TextStyle(color: Colors.black, fontSize: 17),
      ),
    );
  }
} // login sayfasına gider
