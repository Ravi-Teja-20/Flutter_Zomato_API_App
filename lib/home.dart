import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var list;
  String query;

  @override
  void initState() {
    super.initState();
    getData(query);
  }

  _launchURLApp(String str) async {
    String url = str;
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, enableJavaScript: true, enableDomStorage: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getData(String qr) async {
    Response res = await get(
        'https://developers.zomato.com/api/v2.1/search?q=$qr&lat=17.3850%C2%B0%20N&lon=17.3850%C2%B0%20N&sort=rating&order=desc',
        headers: {
          'user-key': 'c6c6ffb70a8fedf921ef1b158c337a37',
          'content-type': 'application/json'
        });

    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      list = decoded;
    } else {
      throw Exception('Failed to load the data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        centerTitle: true,
        title: Text(
          'Zomato API',
          style: TextStyle(
              color: Colors.red,
              fontSize: 30.0,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.normal),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 45.0,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              padding: EdgeInsets.symmetric(vertical: 2.0),
              decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: TextField(
                textAlign: TextAlign.start,
                onChanged: (value) {
                  String temp = value;
                  setState(() {
                    query = temp;
                    getData(query);
                  });
                },
                cursorColor: Colors.black,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                  disabledBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: 'Search Your Wish List',
                  hintStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                        });
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 30.0,
                      )),
                ),
              ),
            ),
            Card(
              elevation: 5.0,
              color: Colors.cyan[50],
              shadowColor: Colors.blueGrey,
              child: SizedBox(
                height: 40.0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                  child: RichText(
                    text: TextSpan(
                      text: '||', style: TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Find Your Favourite Food In Hyderabad ', style: TextStyle(color: Colors.black, fontSize: 19.0, fontStyle: FontStyle.italic),
                      ),
                      TextSpan(
                        text: '||', style: TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold,),
                      ),
                    ]
                  ),
                ),
              ),
            ),
          ),
            query == null
                ? Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 30.0, left: 40.0, right: 40.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber[50],
                              blurRadius: 20.0,
                            ),
                          ]
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 60.0),
                        child: Image.asset('lib/images/order-food.png'),
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ListView.builder(
                          itemCount: list['restaurants'].length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                String url = list['restaurants'][index]
                                    ['restaurant']['url'];
                                _launchURLApp(url);
                              },
                              child: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[100],
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(5.0, 20.0),
                                          blurRadius: 20.0,
                                          spreadRadius: 3.0,
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 20.0),
                                    height: 200.0,
                                  ),
                                  Positioned(
                                    top: 40,
                                    left: 20,
                                    right: 140,
                                    bottom: 40,
                                    child: Container(
                                      height: 60,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              list['restaurants'][index]
                                                  ['restaurant']['name'],
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Container(
                                            child: Text(
                                              list['restaurants'][index]
                                                      ['restaurant']['location']
                                                  ['locality'],
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    left: 230,
                                    top: 0,
                                    bottom: 20,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 10.0, right: 20.0),
                                      child: list['restaurants'][index]
                                                  ['restaurant']['thumb'] !=
                                              ""
                                          ? Image.network(
                                              list['restaurants'][index]
                                                  ['restaurant']['thumb'],
                                              width: 200.0,
                                              height: 200.0,
                                              fit: BoxFit.contain,
                                            )
                                          : Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 50.0),
                                              padding:
                                                  EdgeInsets.only(top: 20.0),
                                              color: Colors.grey[300],
                                              child: Text(
                                                'IMAGE NOT AVAILABLE',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    top: 180,
                                    right: 200,
                                    left: 5,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue, width: 2.0),
                                        color: Colors.blueGrey[50],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(0.0),
                                            bottomLeft: Radius.circular(0.0),
                                            bottomRight: Radius.circular(10.0)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'No of Reviews : ' +
                                              list['restaurants'][index]
                                                          ['restaurant']
                                                      ['all_reviews_count']
                                                  .toString(),
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 25,
                                    top: 185,
                                    left: 230,
                                    right: 15,
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue, width: 2.0),
                                        color: Colors.blueGrey[50],
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            topRight: Radius.circular(0.0),
                                            bottomLeft: Radius.circular(0.0),
                                            bottomRight: Radius.circular(10.0)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Rating : ' +
                                              list['restaurants'][index]
                                                          ['restaurant']
                                                      ['user_rating']
                                                  ['aggregate_rating'],
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
