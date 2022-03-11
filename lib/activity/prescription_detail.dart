import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital_app/entity/PrescriptionDetailDto.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/base.dart';

class PrescriptionDetail extends StatefulWidget {
  @override
  _PrescriptionDetail createState() => _PrescriptionDetail();
}

class _PrescriptionDetail extends State<PrescriptionDetail> {
  String hospitalName;
  String department;
  List<PrescriptionDetailDto> medicineList = [];

  getMedicineDetailDto() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode(
        {'prescription': sharedPreferences.getString("prescription")});
    var response = await http.post(
        Uri.parse("${Base.baseURL}8088/rest/prescription/detail/medicine"),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
          "content-type": "application/json"
        },
        body: body);
    var jsonData = jsonDecode(response.body);
    List<PrescriptionDetailDto> lists = [];
    for (var obj in jsonData) {
      PrescriptionDetailDto detailDto = PrescriptionDetailDto(obj["barcode"],
          obj["medicineName"], obj["useType"], obj["period"], obj["dose"]);
      lists.add(detailDto);
    }
    setState(() {
      medicineList = lists;
    });
  }

  getAllPrescriptionDetailDto() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // Await the http get response, then decode the json-formatted response.
    var body = jsonEncode(
        {'prescription': sharedPreferences.getString("prescription")});
    var response = await http.post(
        Uri.parse("${Base.baseURL}8088/rest/prescription/detail"),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
          "content-type": "application/json"
        },
        body: body);
    var jsonData = jsonDecode(response.body);
    setState(() {
      department = jsonData["department"];
      hospitalName = jsonData["hospitalName"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPrescriptionDetailDto();
    getMedicineDetailDto();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 243, 227),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(left: 25, top: 20, right: 25),
                width: double.infinity,
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                        child: Text(
                          'Hastane Adı : $hospitalName',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 15),
                        child: Text(
                          'Klinik : $department',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.all(10.0),
                itemCount: medicineList.length,
                itemBuilder: (context, i) {
                  return listItem2(
                    context,
                    medicineList[i].barcode,
                    medicineList[i].dose,
                    medicineList[i].medicineName,
                    medicineList[i].useType,
                    medicineList[i].period,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItem2(BuildContext context, String barcode, int dose,
      String medicine, String usedType, String period) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5,top: 2),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Text(
                      'Barkod : $barcode',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.only(right: 5, top: 8),
                    child: Text(
                      'Doz : $dose',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 8, right: 40),
              child: Text(
                'İlaç Adı : $medicine',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 8),
              child: Text(
                'Kullanım Şekli  : $usedType',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 15, bottom: 10),
              alignment: Alignment.centerRight,
              child: Text(
                'Periyot  : $period',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
