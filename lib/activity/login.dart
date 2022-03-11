import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital_app/activity/home.dart';
import 'package:hospital_app/activity/register.dart';
import 'package:hospital_app/entity/base.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController controllerUserName = TextEditingController();
TextEditingController controllerPassword = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginHome();
}

class LoginHome extends State<LoginPage> {
  Future<void> autoFill() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      controllerUserName.text = sharedPreferences.getString("userName");
      controllerPassword.text = sharedPreferences.getString("password");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    autoFill();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          resizeToAvoidBottomInset: true,
          body: Card(
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                Expanded(
                  flex: 65,
                  child: Container(
                    margin: EdgeInsets.only(top: 70),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset('assets/images/loginbackground.jpg'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 48,
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomTextFieldUserName(),
                          CustomTextFieldPassword(),
                          CustomLogin(),
                          CustomRegisterRotate()
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
} // login sayfası

class CustomTextFieldUserName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 17,
      ),
      child: TextField(
        controller: controllerUserName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: "NotoSerif",
          fontWeight: FontWeight.w500,
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
            hintStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.all(16),
            hintText: "Kullanıcı Adı",
            fillColor: Color.fromARGB(255, 89, 89, 81)),
      ),
    );
  }
}

class CustomTextFieldPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 17,
      ),
      child: TextField(
        controller: controllerPassword,
        obscureText: true,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: "NotoSerif",
          fontWeight: FontWeight.w500,
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
            hintStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.all(16),
            hintText: "Şifre",
            fillColor: Color.fromARGB(255, 89, 89, 81)),
      ),
    );
  }
}

class CustomLogin extends StatelessWidget {
  void getLogin(BuildContext context) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode({
      'userName': controllerUserName.text,
      'password': controllerPassword.text
    });

    var response = await http.post(
        Uri.parse("${Base.baseURL}8080/rest/authentication/login"),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
          "content-type": "application/json"
        },
        body: body);
    if (response.body != "false") {
      sharedPreferences.setString("userName", controllerUserName.text);
      sharedPreferences.setString("password", controllerPassword.text);
      if (response.body != "user") {
        sharedPreferences.setBool("isTrue", true);
      } else {
        sharedPreferences.setBool("isTrue", false);
      }
      Base().message("Giriş Başarılı");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
        (route) => false,
      );
    } else {
      print("login could not be verified"); // giriş doğrulanmadı
      Base().message("Kullanıcı Adı ve Şifrenizi Kontrol ediniz...");

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
        color: Color.fromARGB(255, 89, 89, 81),
        child: Text(
          'Giriş Yap',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "NotoSerif",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
} // uygulamaya giriş yapar

class CustomRegisterRotate extends StatelessWidget {
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        },
        color: Color.fromARGB(255, 89, 89, 81),
        child: Text(
          'Kaydol',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "NotoSerif",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
} // kullanıcı kayıt sayfasına gider
