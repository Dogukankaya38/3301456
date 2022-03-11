import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_app/entity/AllergyDto.dart';
import 'package:hospital_app/entity/base.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Allergy extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Allergy> {
  Future allergyList;
  var listsAllergy = [
    "İlaç Alerjisi",
    "Besin Alerjisi",
    "Böcek Alerjisi",
    "Lateks Alerjisi",
    "Küf Alerjisi",
    "Evcil Hayvan Alerjisi",
    "Polen Alerjisi"
  ];
  var listAllergyExplanation = [
    "İlaçlara karşı gerçek alerjiler yalnızca az sayıda insanda görülür. Çoğu ilaç reaksiyonu alerjik değildir, ancak ilacın özelliklerinin yan etkileridir. İlaç reaksiyonunun nedeninin teşhisi genellikle yalnızca hastanın geçmişine ve semptomlarına dayanır. Bazen ilaç alerjisi için deri testi de yapılır",
    "Gıdalara karşı farklı alerjik reaksiyon türleri vardır. IgE aracılı alerjiler, IgE aracılı olmayan alerjiler ve gıda intoleransları arasında farklılıklar vardır.",
    "Arılar, eşek arıları, yaban arıları, sarı ceketler ve ateş karıncaları, alerjik reaksiyona neden olan en yaygın sokucu böceklerdir.Sokmayan böcekler de alerjik reaksiyonlara neden olabilir. En yaygın olanları hamam böcekleri ve böcek benzeri toz akarlarıdır. Bu iki böceğe karşı alerji, yıl boyunca alerji ve astımın en yaygın nedeni olabilir.",
    "Lateks alerjisi, doğal kauçuk latekse karşı alerjik bir reaksiyondur. Doğal kauçuk lateks eldivenler, balonlar, prezervatifler ve diğer doğal kauçuk ürünler lateks içerir. Lateks alerjisi ciddi bir sağlık riski oluşturabilir.",
    "Küf bir mantardır. Mantarlar hem içeride hem de dışarıda pek çok yerde büyüdüğünden, yıl boyunca alerjik reaksiyonlar meydana gelebilir.",
    "Kürklü evcil hayvanlara alerjiler yaygındır. Alerjisiz (hipoalerjenik) bir köpek veya kedi cinsinin olmadığını bilmeniz önemlidir.",
    "Polen, mevsimsel alerjilerin en yaygın tetikleyicilerinden biridir. Pek çok kişi polen alerjisini “saman nezlesi” olarak bilir, ancak uzmanlar genellikle bunu “mevsimsel alerjik rinit” olarak adlandırır."
  ];
  HashMap<String, String> hashMap = HashMap();
  var dropdownvalueAllergy;

  String selectedAllergy = "13";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hashMap.addAll({
      listsAllergy[0]: listAllergyExplanation[0],
      listsAllergy[1]: listAllergyExplanation[1],
      listsAllergy[2]: listAllergyExplanation[2],
      listsAllergy[3]: listAllergyExplanation[3],
      listsAllergy[4]: listAllergyExplanation[4],
      listsAllergy[5]: listAllergyExplanation[5],
      listsAllergy[6]: listAllergyExplanation[6],
    });
    setState(() {
      allergyList = findAllAppointment();
      selectedAllergy = hashMap[dropdownvalueAllergy];
    });
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Center(
            child: Container(
              height: 285,
              child: Scaffold(
                backgroundColor: Color.fromARGB(255, 255, 243, 227),
                body: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 25, left: 15, right: 15),
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
                        value: dropdownvalueAllergy,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                        ),
                        items: listsAllergy.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (var newValue) {
                          setState(() {
                            dropdownvalueAllergy = newValue;
                            selectedAllergy = hashMap[newValue];
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        '$selectedAllergy',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 25, top: 10),
                      child: RaisedButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          insertAndDelete(context, "add", 0);
                        },
                        color: Color.fromARGB(255, 255, 255, 255),
                        child: Text(
                          'Alerji Ekle',
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
        });
      },
    );
  }

  void insertAndDelete(BuildContext context, String type, int id) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var body;
    if (type == "delete") {
      body = jsonEncode({
        "id": id,
        'userName': sharedPreferences.getString("userName"),
        'typeOfAllergy': dropdownvalueAllergy
      });
    } else {
      body = jsonEncode({
        'userName': sharedPreferences.getString("userName"),
        'typeOfAllergy': dropdownvalueAllergy
      });
    }
    if (dropdownvalueAllergy.isEmpty || dropdownvalueAllergy == null) {
      return;
    }
    var response = await http.post(
        Uri.parse("${Base.baseURL}8085/rest/allergy/$type"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
        body: body);
    if (response.body == "successful") {
      print("apply is  Successful"); // kayıt yapıldı
      Fluttertoast.showToast(
          msg: "Alerji eklendi.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (response.body == "Bad repeat request" ||
        response.body == "bad request") {
      Fluttertoast.showToast(
          msg: "Daha önce bu alerjiyi eklemişsiniz.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      allergyList = findAllAppointment();
    });
  }

  Future findAllAppointment() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    // Await the http get response, then decode the json-formatted response.
    var body =
        jsonEncode({'userName': sharedPreferences.getString("userName")});
    var response = await http.post(
        Uri.parse("${Base.baseURL}8085/rest/allergy"),
        headers: {
          'Accept': 'application/json; charset=UTF-8',
          "content-type": "application/json"
        },
        body: body);
    var jsonData = jsonDecode(response.body);
    List<AllergyDto> lists = [];
    for (var obj in jsonData) {
      AllergyDto allergyDto = AllergyDto(obj["id"], obj["typeOfAllergy"]);
      lists.add(allergyDto);
    }
    return lists;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 243, 227),
          body: Column(
            children: [
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
              Image.asset("assets/images/allergy.jpg"),
              FutureBuilder(
                  future: allergyList,
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
                              snapshot.data[i].typeOfAllergy,
                              snapshot.data[i].ID,
                            );
                          },
                        ),
                      );
                    }
                  }),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 25),
                child: RaisedButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  onPressed: () {
                    showCustomDialog(context);
                  },
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Text(
                    'Alerji Ekle',
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

  Widget listItem(BuildContext context, String typeOfAllergy, int id) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 5, right: 5),
      child: GestureDetector(
        onLongPress: () {
          dropdownvalueAllergy = typeOfAllergy;
          insertAndDelete(context, "delete", id);
        },
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(5),
                  child: allergyToImage(typeOfAllergy)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    typeOfAllergy,
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
        ),
      ),
    );
  }
}

Widget allergyToImage(String allergy) {
  {
    switch (allergy) {
      case "İlaç Alerjisi":
        return Image.asset("assets/icons/medicine.png", width: 44, height: 44);
      case "Besin Alerjisi":
        return Image.asset("assets/icons/food.png", width: 44, height: 44);
      case "Böcek Alerjisi":
        return Image.asset("assets/icons/bug.png", width: 44, height: 44);
      case "Lateks Alerjisi":
        return Image.asset("assets/icons/latex.png", width: 44, height: 44);
      case "Küf Alerjisi":
        return Image.asset("assets/icons/mold.png", width: 44, height: 44);
      case "Evcil Hayvan Alerjisi":
        return Image.asset("assets/icons/dog.png", width: 44, height: 44);
      case "Polen Alerjisi":
        return Image.asset("assets/icons/pollen.png", width: 44, height: 44);
    }
  }
}
