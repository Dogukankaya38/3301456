import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entity/base.dart';

class covid extends StatefulWidget {
  State<StatefulWidget> createState() => homeCovid();
}

class homeCovid extends State<covid> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 254, 254, 254),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.topLeft,
                  children: <Widget>[
                    Image.asset('assets/images/covidsymptom.jpg'),
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
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(
                    'Belirtiler',
                    style: TextStyle(
                      color: Color.fromARGB(255, 12, 54, 156),
                      fontSize: 20,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 20),
                  child: Text(
                    'COVID-19, farklı kişileri farklı şekillerde etkilemektedir. Enfekte kişilerin çoğu, hafif ila orta düzeyde semptomlar geliştirmekte ve hastaneye kaldırılmadan iyileşmektedir.',
                    style: TextStyle(
                      color:  Colors.black87,
                      fontSize: 16,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 30),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'En yaygın semptomlar:',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '- Ateş\n- Öksürük\n- Yorgunluk\n- Tat alma veya koku duyusunun kaybı',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Daha seyrek görülen semptomlar:',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '- Boğaz ağrısı\n- Baş ağrısı\n- Ağrı ve sızı\n- İshal\n- Ciltte döküntü ya da el veya ayak parmaklarında renk değişimi\n- Gözlerde kızarıklık veya tahriş',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 15),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ciddi semptomlar:',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '- Solunum güçlüğü veya nefes darlığı\n- Konuşma ya da hareket kaybı veya bilinç bulanıklığı\n- Göğüs ağrısı',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 20,bottom: 15),
                  child: Text(
                    'Ciddi semptomlar gösteriyorsanız derhal tıbbi yardım alın. Doktorunuzu veya sağlık tesisini ziyaret etmeden önce mutlaka telefonla arayın.\n\nHafif semptomlar gösteren ve başka bir sağlık sorunu olmayan kişiler, tedavi sürecini evde geçirmelidir.\nVirüsle enfekte olan kişinin semptomları göstermesi ortalama 5-6 gün sürse de semptomların görülmesi 14 günü bulabilir.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
