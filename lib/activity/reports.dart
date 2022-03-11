import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hospital_app/activity/grade/reportWriteDoctor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/ReportDto.dart';
import '../entity/base.dart';
import 'package:http/http.dart' as http;

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  Future reportList;
  bool isVisible = false;

  Future getAllReports() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isVisible = sharedPreferences.getBool("isTrue");
    });
    // Await the http get response, then decode the json-formatted response.
    var body =
        jsonEncode({'userName': sharedPreferences.getString("userName")});
    var response = await http.post(Uri.parse("${Base.baseURL}8087/rest/report"),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
          "content-type": "application/json"
        },
        body: body);
    var jsonData = jsonDecode(response.body);
    List<ReportDto> lists = [];
    for (var obj in jsonData) {
      ReportDto reportDto = ReportDto(
          obj["id"], obj["title"], obj["createdDate"], obj["explanation"]);
      lists.add(reportDto);
    }
    return lists;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      reportList = getAllReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 243, 227),
          appBar: AppBar(
            title: Text(
              'RAPORLARIM',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[
              Visibility(
                visible: isVisible,
                child: Container(
                  margin: EdgeInsets.only(right: 10, top: 2, bottom: 2),
                  child: RaisedButton(
                    shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black38, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportWriteDoctor()));
                    },
                    color: Color.fromARGB(255, 255, 243, 227),
                    child: Text(
                      'Rapor Yaz',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: "NotoSerif",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            backgroundColor: Color.fromARGB(255, 255, 243, 227),
          ),
          body: FutureBuilder(
              future: reportList,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container();
                } else {
                  return Container(
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10.0),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return listItem(
                          context,
                          snapshot.data[i].title,
                          snapshot.data[i].createdDate,
                          snapshot.data[i].explanation,
                        );
                      },
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget listItem(
      BuildContext context, String title, String date, String explanation) {
    return Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        title,
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
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(right: 10, top: 10),
                      child: Text(
                        date,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Divider(height: 5, color: Colors.black),
              Container(
                margin:
                    EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 15),
                child: Text(
                  explanation,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontFamily: "NotoSerif",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
