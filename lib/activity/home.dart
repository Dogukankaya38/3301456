import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital_app/activity/allergy.dart';
import 'package:hospital_app/activity/ambulance.dart';
import 'package:hospital_app/activity/appointment.dart';
import 'package:hospital_app/activity/prescription.dart';
import 'package:hospital_app/activity/reports.dart';
import 'package:hospital_app/entity/AppointmentDto.dart';
import 'package:hospital_app/activity/covid.dart';
import 'package:hospital_app/activity/home_visit.dart';
import 'package:hospital_app/entity/base.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => home();
}

class home extends State<HomePage> {
  String name;
  String blood;
  String eMail;
  String weight;
  String height;
  Future appointmentList;

  Future findAllAppointment() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // Await the http get response, then decode the json-formatted response.
    setState(() {
      name = sharedPreferences.getString("userName");
    });
    var body =
        jsonEncode({'userName': sharedPreferences.getString("userName")});
    var response = await http.post(
        Uri.parse("${Base.baseURL}8081/rest/appointment"),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
          "content-type": "application/json"
        },
        body: body);
    var jsonData = jsonDecode(response.body);
    List<Appointment> lists = [];
    for (var obj in jsonData) {
      Appointment appointment = Appointment(obj["id"], obj["day"], obj["month"],
          obj["time"], obj["department"], obj["doctorName"]);
      lists.add(appointment);
    }
    return lists;
  }

  void apply(BuildContext context, int id) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode({
      'id': id,
      'userName': sharedPreferences.getString("userName"),
    });

    var response = await http.post(
        Uri.parse("${Base.baseURL}8081/rest/appointment/delete"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: body);
    setState(() {
      appointmentList = findAllAppointment();
    });
  }

  void showAlertDialog(BuildContext context, int id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Vazgeç"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('Hastane');
      },
    );
    Widget continueButton = TextButton(
      child: Text("İptal Et"),
      onPressed: () {
        apply(context, id);
        Navigator.of(context, rootNavigator: true).pop('Hastane');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hastane"),
      content: Text("Randevunuzu iptal etmek istediğinizden emin misiniz ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget listItem(BuildContext context, String day, String month, String time,
      String department, String doctorName, int id) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 25, left: 20),
      child: GestureDetector(
        onLongPress: () {
          showAlertDialog(context, id);
        },
        child: Row(
          children: [
            Card(
              color: Colors.blue,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        day,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      month,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    department,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    doctorName,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void getInformationUser() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode({
      'userName': sharedPreferences.getString("userName"),
      'password': sharedPreferences.getString("password")
    });

    var response = await http.post(
        Uri.parse("${Base.baseURL}8080/rest/authentication/user"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: body);
    var jsonData = jsonDecode(response.body);
    eMail = jsonData["email"];
    blood = jsonData["blood"];
    weight = jsonData["weight"];
    height = jsonData["height"];
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Align(
            alignment: Alignment.topRight,
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10))),
              child: Container(
                height: 200,
                margin: EdgeInsets.only(left: 20, top: 7),
                child: Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.supervised_user_circle_sharp,
                              color: Colors.black,
                            ),
                            Text(
                              'Kullanıcı Adı : $name',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 7),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                            Text(
                              'E Mail : $eMail',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 7),
                        child: Row(
                          children: [
                            Icon(
                              Icons.brightness_low_outlined,
                              color: Colors.black,
                            ),
                            Text(
                              'Kan Grubu : $blood',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Roboto",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 7),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.height,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Boy : $height cm',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 7),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.line_weight,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Kilo : $weight kg',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 25, top: 10),
                        child: RaisedButton(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('Barrier');
                          },
                          color: Color.fromARGB(255, 255, 255, 255),
                          child: Text(
                            'Kapat',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "NotoSerif",
                              fontWeight: FontWeight.w700,
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
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      appointmentList = findAllAppointment();
      getInformationUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Card(
            // color: Color.fromARGB(255, 250, 250, 250),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showCustomDialog(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15, right: 15),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          "assets/images/user.png",
                          width: 32,
                          height: 32,
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 15),
                  child: Row(
                    children: <Widget>[
                      const Text(
                        'Merhaba, ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 1, 1, 1),
                          fontSize: 21,
                          fontFamily: "Roboto",
                        ),
                      ),
                      Text(
                        '$name!',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 22,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          'assets/images/covid.jpg',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15, bottom: 5),
                        child: CustomButton(),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Nasıl Yardım Edebiliriz ?',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontFamily: "NotoSerif",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeVisit()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30, left: 30, right: 15),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/doctors.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Ev Ziyareti',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppointmentMain()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30, left: 20),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/hospital.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Hastane Ziyareti',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AmbulanceCall()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30, left: 20, right: 30),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/ambulance.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Ambulans',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Allergy()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30, left: 20, right: 30),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/anaphylaxis.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Alerjilerim',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Report()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30, left: 20, right: 30),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/report.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Raporlarım',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Prescription()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30, left: 20, right: 30),
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/prescription.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Reçetelerim',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Yaklaşan Randevular',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontFamily: "NotoSerif",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FutureBuilder(
                    future: appointmentList,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      } else {
                        return Container(
                          width: double.infinity,
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10.0),
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, i) {
                              return listItem(
                                  context,
                                  snapshot.data[i].day,
                                  snapshot.data[i].month,
                                  snapshot.data[i].time,
                                  snapshot.data[i].department,
                                  snapshot.data[i].doctorName,
                                  snapshot.data[i].ID);
                            },
                          ),
                        );
                      }
                    })
              ],
            ),
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
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Text(
        'Daha Fazla Bilgi Al',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 15,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => covid()));
      },
    );
  }
} // Covid 19 sayfasına gider
