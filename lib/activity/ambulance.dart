import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_app/entity/base.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController textEditingIDController = TextEditingController();
TextEditingController textEditingPhoneNumberController =
    TextEditingController();
TextEditingController textEditingAddressController = TextEditingController();
TextEditingController textEditingSpecialCaseController =
    TextEditingController();

class AmbulanceCall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Base().rotateHome(context);
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: Image.asset("assets/icons/previous.png",
                      width: 32, height: 32),
                ),
              ),
              Image.asset('assets/images/ambulancecall.jpg'),
              Container(
                margin: EdgeInsets.only(left: 7, right: 7, top: 15),
                child: Text(
                  '112 Acil Çağrı Merkezlerini, adres sorma, telefon deneme, sipariş verme gibi nedenlerle gereksiz yere meşgul eden ve asılsız ihbarda bulunan 167 kişiye 250  TL idari para cezası uygulandı. Ayrıca yapılan kanuni değişikliklerle bundan sonra 112 Acil Çağrı Merkezlerini gereksiz meşgul edenlere ve asılsız çağrıda bulunanlara idari para cezasının etkin uygulanması talimatı verildi.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontFamily: "NotoSerif",
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              CustomTextFieldIDNo(),
              CustomTextFieldPhoneNumber(),
              CustomTextFieldAddress(),
              CustomTextFieldSpecialCase(),
              CustomApplyButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldIDNo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 15,
      ),
      child: TextField(
        controller: textEditingIDController,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Türkiye Cumhuriyeti Kimlik Numarası",
            fillColor: Colors.blueGrey),
      ),
    );
  }
}

class CustomTextFieldPhoneNumber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 5,
      ),
      child: TextField(
        controller: textEditingPhoneNumberController,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Telefon Numarası",
            fillColor: Colors.blueGrey),
      ),
    );
  }
}

class CustomTextFieldAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 5,
      ),
      child: TextField(
        controller: textEditingAddressController,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Ev Adresi",
            fillColor: Colors.blueGrey),
      ),
    );
  }
}

class CustomTextFieldSpecialCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Color.fromARGB(255, 255, 255, 255),
      margin: const EdgeInsets.only(
        left: 30,
        right: 30,
        top: 5,
      ),
      child: TextField(
        controller: textEditingSpecialCaseController,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.black87),
            contentPadding: EdgeInsets.all(16),
            hintText: "Aciliyet Durumu",
            fillColor: Colors.blueGrey),
      ),
    );
  }
}

class CustomApplyButton extends StatelessWidget {
  void apply(BuildContext context) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode({
      'id': textEditingIDController.text,
      'userName': sharedPreferences.getString("userName"), // burası değişecek
      'phoneNumber': textEditingPhoneNumberController.text,
      'address': textEditingAddressController.text,
      'specialCase': textEditingSpecialCaseController.text,
    });
    if (textEditingIDController.text.isEmpty ||
        textEditingIDController.text == null ||
        textEditingPhoneNumberController.text.isEmpty ||
        textEditingPhoneNumberController.text == null ||
        textEditingAddressController.text.isEmpty ||
        textEditingAddressController.text == null) {
      Fluttertoast.showToast(
          msg: "Lutfen alanları doldurunuz..",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    var response = await http.post(
        Uri.parse("${Base.baseURL}8084/rest/ambulance/call"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: body);
    if (response.body == "Successful") {
      print("apply is  Successful"); // kayıt yapıldı
      Fluttertoast.showToast(
          msg: "Başvurunuz Oluşturuldu....",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print(
          "There is already a registered user under this name."); // Bu isimle kayıtlı bir kullanıcı zaten var.
      Fluttertoast.showToast(
          msg: "Şuanda devam eden bir başvurunuz bulunmaktadır..",
          toastLength: Toast.LENGTH_LONG,
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
      margin: EdgeInsets.only(top: 15, left: 25, right: 25),
      height: 40,
      width: 225,
      child: RaisedButton(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        onPressed: () {
          apply(context);
        },
        color: Colors.blueGrey,
        child: Text(
          'Cağır',
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
