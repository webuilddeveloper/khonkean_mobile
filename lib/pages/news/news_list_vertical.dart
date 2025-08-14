import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../blank_page/blank_loading.dart';
import 'news_form.dart';

class NewsListVertical extends StatefulWidget {
  NewsListVertical({
    super.key,
    this.site,
    this.model,
    this.title,
    this.url,
    this.urlComment,
    this.urlGallery,
  });

  final String? site;
  final Future<dynamic>? model;
  final String? title;
  final String? url;
  final String? urlComment;
  final String? urlGallery;

  @override
  _NewsListVertical createState() => _NewsListVertical();
}

class _NewsListVertical extends State<NewsListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  checkImageAvatar(String img) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      backgroundImage: NetworkImage(
        img,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: const Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsForm(
                            url: widget.url,
                            code: snapshot.data[index]['code'],
                            model: snapshot.data[index],
                            urlComment: widget.urlComment,
                            urlGallery: widget.urlGallery,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.only(bottom: 5.0),
                              // height: 334,
                              width: 600,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        minHeight: 200,
                                        maxHeight: 200,
                                        minWidth: double.infinity,
                                      ),
                                      child: snapshot.data[index]['imageUrl'] !=
                                              null
                                          ? Image.network(
                                              '${snapshot.data[index]['imageUrl']}',
                                              fit: BoxFit.cover,
                                            )
                                          : BlankLoading(
                                              height: 200,
                                            ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    padding: const EdgeInsets.all(5.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${snapshot.data[index]['title']}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                  // SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        } else {
          // print('2');
          // print(snapshot.data);
          return Container();
        }
      },
    );
  }

  Future<dynamic> downloadData() async {
    var body = json.encode({
      "permission": "all",
      "skip": 0,
      "limit": 10 // integer value type
    });
    var response = await http.post(Uri.parse(''), body: body, headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });

    var data = json.decode(response.body);

    return Future.value(data['objectData']);
  }

  Future<dynamic> postData() async {
    var body = json.encode({
      "permission": "all",
      "skip": 0,
      "limit": 2 // integer value type
    });

    var client = new http.Client();
    client.post(
        Uri.parse("http://hwpolice.we-builds.com/hwpolice-api/privilege/read"),
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }).then((response) {
      client.close();
      var data = json.decode(response.body);

      if (data.length > 0) {
        sleep(const Duration(seconds: 10));
        setState(() {
          Future.value(data['objectData']);
        });
      } else {}
    }).catchError((onError) {
      client.close();
    });
  }
}
