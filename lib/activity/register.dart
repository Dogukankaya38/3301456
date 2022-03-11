import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_app/activity/home.dart';
import 'package:hospital_app/entity/base.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController controllerUserName2 = TextEditingController();
TextEditingController controllerPassword2 = TextEditingController();
TextEditingController controllerEmail2 = TextEditingController();
TextEditingController controllerBloodGroup = TextEditingController();
TextEditingController controllerWeightGroup = TextEditingController();
TextEditingController controllerHeightGroup = TextEditingController();

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Card(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  flex: 60,
                  child: Container(
                    margin: EdgeInsets.only(top: 70),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset('assets/images/register.png'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomTextFieldRegisterUserName(),
                          CustomTextFieldRegisterPassword(),
                          CustomTextFieldRegisterEmail(),
                          CustomTextFieldBloodGroup(),
                          Row(children: [
                            Expanded(child: CustomTextFieldWeightGroup()),
                            Expanded(child: CustomTextFieldHeightGroup())
                          ]),
                          CustomRegister(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} // kayıt olma sayfası

class CustomTextFieldRegisterUserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 17,
      ),
      child: TextField(
        controller: controllerUserName2,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "NotoSerif",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Kullanıcı Adı",
            fillColor: Color.fromARGB(255, 98, 210, 248)),
      ),
    );
  }
}

class CustomTextFieldRegisterPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 17,
      ),
      child: TextField(
        controller: controllerPassword2,
        obscureText: true,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "NotoSerif",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Şifre",
            fillColor: Color.fromARGB(255, 98, 210, 248)),
      ),
    );
  }
}

class CustomTextFieldRegisterEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 17,
      ),
      child: TextField(
        controller: controllerEmail2,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "NotoSerif",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Email",
            fillColor: Color.fromARGB(255, 98, 210, 248)),
      ),
    );
  }
}

class CustomTextFieldBloodGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 17,
      ),
      child: TextField(
        controller: controllerBloodGroup,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "NotoSerif",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Kan Grubu",
            fillColor: Color.fromARGB(255, 98, 210, 248)),
      ),
    );
  }
}

class CustomTextFieldWeightGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 17,
      ),
      child: TextField(
        controller: controllerWeightGroup,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "NotoSerif",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Kilo",
            fillColor: Color.fromARGB(255, 98, 210, 248)),
      ),
    );
  }
}

class CustomTextFieldHeightGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 17,
      ),
      child: TextField(
        controller: controllerHeightGroup,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "NotoSerif",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Boy",
            fillColor: Color.fromARGB(255, 98, 210, 248)),
      ),
    );
  }
}

class CustomRegister extends StatelessWidget {
  void getLogin(BuildContext context) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (controllerUserName2.text == null ||
        controllerUserName2.text.isEmpty ||
        controllerPassword2.text == null ||
        controllerPassword2.text.isEmpty ||
        controllerEmail2.text == null ||
        controllerEmail2.text.isEmpty) {
      return;
    }
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode({
      'userName': controllerUserName2.text,
      'password': controllerPassword2.text,
      'email': controllerEmail2.text,
      'blood': controllerBloodGroup.text,
      'weight': controllerWeightGroup.text,
      'height': controllerHeightGroup.text,
      'grade': "user"
    });

    var response = await http.post(
        Uri.parse("${Base.baseURL}8080/rest/authentication/register"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: body);
    if (response.body == "Recorded.") {
      sharedPreferences.setString("userName", controllerUserName2.text);
      sharedPreferences.setString("password", controllerPassword2.text);
      sharedPreferences.setBool("isTrue", false);
      print("Registration Successful"); // kayıt yapıldı
      Fluttertoast.showToast(
          msg: "Kaydınız Oluşturuldu....",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
        (route) => false,
      );
    } else {
      print(
          "There is already a registered user under this name."); // Bu isimle kayıtlı bir kullanıcı zaten var.
      Fluttertoast.showToast(
          msg: "Bu isimle kayıtlı bir kullanıcı zaten var",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 17, left: 40, right: 40),
      height: 50,
      child: RaisedButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        onPressed: () {
          getLogin(context);
        },
        color: Color.fromARGB(255, 98, 210, 248),
        child: Text(
          'Kaydol',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: "NotoSerif",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
} // kullanıcı kaydını yapar
