// ignore_for_file: use_key_in_widget_constructors
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:hospital_app/entity/base.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController textEditingDateController = TextEditingController();

class AppointmentMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppointmentHome();
}

class AppointmentHome extends State<AppointmentMain> {
  DateTime _selectedDate;
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedDoctor;
  String dropdownvalueDepartment = 'Bölüm Seç';
  List<String> listsDepartment = ['Bölüm Seç'];

  String dropdownvalueDoctors = 'Doktor Seç';
  List<String> listsDoctors = ['Doktor Seç'];

  void getAllDepartment() async {
    // Await the http get response, then decode the json-formatted response.
    var response = await http
        .post(Uri.parse("${Base.baseURL}8086/rest/department/"), headers: {
      'Accept': 'application/json; charset=UTF-8',
      "content-type": "application/json"
    });
    var jsonData = jsonDecode(response.body);

    for (var obj in jsonData) {
      listsDepartment.add(obj["department"]);
    }
  }

  void getDoctor(String value) async {
    if (value != "Bölüm Seç") {
      var body = jsonEncode({'department': value});

      // Await the http get response, then decode the json-formatted response.
      var response = await http.post(
          Uri.parse("${Base.baseURL}8086/rest/doctor/"),
          headers: {
            'Accept': 'application/json; charset=UTF-8',
            "content-type": "application/json"
          },
          body: body);
      var jsonData = jsonDecode(response.body);
      listsDoctors.clear();
      // ignore: void_checks
      for (var obj in jsonData) {
        listsDoctors.add(obj["name"]);
      }
      dropdownvalueDoctors = listsDoctors[0];
      selectedDoctor = dropdownvalueDoctors;
    }
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(Duration(days: 5));
  }

  @override
  void initState() {
    super.initState();
    getAllDepartment();
    _resetSelectedDate();
    getDoctor(dropdownvalueDepartment);
  }

  String intToMonth(int val) {
    switch (val) {
      case 1:
        return "Ocak";
      case 2:
        return "Şubat";
      case 3:
        return "Mart";
      case 4:
        return "Nisan";
      case 5:
        return "Mayıs";
      case 6:
        return "Haziran";
      case 7:
        return "Temmuz";
      case 8:
        return "Ağustos";
      case 9:
        return "Eylül";
      case 10:
        return "Ekim";
      case 11:
        return "Kasım";
      case 12:
        return "Aralık";
    }
  }

  void apply(BuildContext context) async {
    var sharedPreferences = await SharedPreferences.getInstance();

    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode({
      'day': _selectedDate.day,
      'month': intToMonth(_selectedDate.month), // burası değişecek
      'time': "${selectedTime.hour}:${selectedTime.minute}",
      'department': dropdownvalueDepartment,
      'doctorName': selectedDoctor,
      'userName': sharedPreferences.getString("userName"),
    });
    if (selectedDoctor.isEmpty ||
        selectedDoctor == null ||
        dropdownvalueDepartment.isEmpty ||
        dropdownvalueDepartment == null) {
      Fluttertoast.showToast(
          msg: "Lutfen alanları doldurunuz..",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    var response = await http.post(
        Uri.parse("${Base.baseURL}8081/rest/appointment/add"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: body);
    if (response.body == "successful") {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 147, 152, 158),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Image.asset('assets/images/appointment.jpg'),
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
                ],
              ),
              SizedBox(height: 10),
              CalendarTimeline(
                showYears: true,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                    textEditingDateController.text =
                        "Tarih : ${_selectedDate.toString().split(' 00:00')[0]}   Saat : ${selectedTime.hour}:${selectedTime.minute}";
                  });
                },
                leftMargin: 20,
                monthColor: Colors.white,
                dayColor: Colors.teal[200],
                dayNameColor: Color(0xFF333A47),
                activeDayColor: Colors.white,
                activeBackgroundDayColor: Colors.redAccent[100],
                dotsColor: Color(0xFF333A47),
                selectableDayPredicate: (date) => date.day != 23,
                locale: 'en',
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(flex: 7, child: CustomTextFieldDate()),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      icon: Image.asset('assets/images/time.png'),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 5,
                      ),
                      child: DropdownButtonFormField(
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
                            fillColor: Color.fromARGB(255, 255, 255, 255)),
                        value: dropdownvalueDepartment,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                        ),
                        items: listsDepartment.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownvalueDepartment = newValue;
                            getDoctor(newValue);
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/images/clinic.png'),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 5,
                      ),
                      child: DropdownButtonFormField(
                        value: dropdownvalueDoctors,
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
                            fillColor: Color.fromARGB(255, 255, 255, 255)),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                        ),
                        items: listsDoctors.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String newValue) {
                          selectedDoctor = newValue;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/images/doctor.png'),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 25, right: 25),
                height: 40,
                width: 225,
                child: RaisedButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onPressed: () {
                    apply(context);
                  },
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Text(
                    'Randevu Al',
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
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        textEditingDateController.text =
            "Tarih : ${_selectedDate.toString().split(' 00:00')[0]}   Saat : ${selectedTime.hour}:${selectedTime.minute}";
      });
    }
  }
}

class CustomTextFieldDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 147, 152, 158),
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 5,
      ),
      child: TextField(
        enabled: false,
        controller: textEditingDateController,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 15,
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
            hintText: "Tarih",
            fillColor: Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }
}

// kullanıcı kaydını yapar
