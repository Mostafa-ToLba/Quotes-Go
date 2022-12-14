
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:statuses_only/adHelper/adHelper.dart';

class BannerListview extends StatefulWidget {
  @override
  _BannerListviewState createState() => _BannerListviewState();
}

class _BannerListviewState extends State<BannerListview> {
  late List<String> datas; // late for null safty

  late List<Object> dataads; // will store both data + banner ads

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datas = [];

    //generate array list of string
    for (int i = 1; i <= 20; i++) {
      datas.add("List Item $i");
    }

    dataads = List.from(datas);

    // insert admob banner object in between the array list
    for (int i = 0; i <= 2; i++) {
      var min = 1;
      var rm = new Random();

      //generate a random number from 2 to 18 (+ 1)
      var rannumpos = min + rm.nextInt(18);

      //and add the banner ad to particular index of arraylist
      dataads.insert(rannumpos, AdmobHelper.getBannerAd()..load());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Banner ads listview"),
      ),
      body: ListView.builder(
          itemCount: dataads.length,
          itemBuilder: (context, index) {
            //id dataads[index] is string show listtile with item in it
            if (dataads[index] is String) {
              return ListTile(
                title: Text(dataads[index].toString()),
                leading: Icon(Icons.exit_to_app),
                trailing: Icon(Icons.camera),
              );
            } else {
              // if dataads[index] is object (ads) then show container with adWidget
              final Container adcontent = Container(
                child: AdWidget(
                  ad: dataads[index] as BannerAd,
                  key: UniqueKey(),
                ),
                height: 50,
              );
              return adcontent;
            }
          }),
    );
  }
}