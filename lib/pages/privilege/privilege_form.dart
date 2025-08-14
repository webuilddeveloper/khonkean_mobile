import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../../component/button_close_back.dart';
import '../../component/gallery_view.dart';
import '../../component/link_url_out.dart';
import '../../shared/api_provider.dart';
import '../../shared/extension.dart';
import '../blank_page/blank_loading.dart';

class PrivilegeForm extends StatefulWidget {
  PrivilegeForm({super.key, @required this.code, this.model});
  final String? code;
  final dynamic model;

  @override
  _PrivilegeDetailPageState createState() => _PrivilegeDetailPageState();
}

class _PrivilegeDetailPageState extends State<PrivilegeForm> {
  // _PrivilegeDetailPageState({});

  Future<dynamic>? _futureModel;
  // String _urlShared = '';
  String? code;
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    code = widget.code;
    _futureModel = post(
        '${privilegeApi}read', {'skip': 0, 'limit': 1, 'code': widget.code});
  }

  Future<dynamic> readGallery() async {
    final result =
        await postObjectData('m/news/gallery/read', {'code': widget.code});

    if (result['status'] == 'S') {
      List data = [];
      List<ImageProvider> dataPro = [];

      for (var item in result['objectData']) {
        data.add(item['imageUrl']);

        dataPro.add(item['imageUrl'] != null
            ? NetworkImage(item['imageUrl'])
            : NetworkImage(""));
      }
      setState(() {
        urlImage = data;
        urlImageProvider = dataPro;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<dynamic>(
        future: _futureModel, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // AsyncSnapshot<Your object type>

          if (snapshot.hasData) {
            print(
                '------------------${snapshot.data.toString()}----------------');
            return myContent(snapshot.data[0]);
          } else {
            if (widget.model != null) {
              return myContent(widget.model);
            } else {
              return BlankLoading();
            }
          }
        },
      ),
    );
  }

  myContent(dynamic model) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      model['imageUrl'] != null
          ? NetworkImage(model['imageUrl'])
          : NetworkImage("")
    ];
    // return Container();
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              Container(
                child: ListView(
                  shrinkWrap: true, // 1st add
                  physics: ClampingScrollPhysics(), // 2nd
                  children: [
                    Container(
                      // width: 500.0,
                      color: Color(0xFFFFFFF),
                      child: GalleryView(
                        imageUrl: [...image, ...urlImage],
                        imageProvider: [...imagePro, ...urlImageProvider],
                      ),
                    ),
                    Container(
                      // color: Colors.green,
                      padding: EdgeInsets.only(
                        right: 10.0,
                        left: 10.0,
                      ),
                      margin: EdgeInsets.only(right: 50.0, top: 10.0),
                      child: Text(
                        '${model['title']}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 10,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: model['imageUrlCreateBy'] !=
                                        null
                                    ? NetworkImage(model['imageUrlCreateBy'])
                                    : null,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model['createBy'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          dateStringToDate(
                                                  model['createDate']) +
                                              ' | ',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          'เข้าชม ' +
                                              '${model['view']}' +
                                              ' ครั้ง',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 10,
                        left: 10,
                      ),
                      child: new Html(
                          data: model['description'],
                          onLinkTap: (url, context, attributes) {
                            // ignore: deprecated_member_use
                            launch(url!);
                          }),

                      // HtmlView(
                      //   data: model['description'],
                      //   scrollable:
                      //       false, //false to use MarksownBody and true to use Marksown
                      // ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Theme.of(context).primaryColor,
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).primaryColorLight,
                                ],
                                stops: [
                                  0.0,
                                  0.8
                                ]),
                          ),
                          child: GestureDetector(
                            // minWidth: MediaQuery.of(context).size.width,
                            onTap: () {
                              launchURL('${model['linkUrl']}');
                            },
                            child: Text(
                              'ดูรายละเอียดเพิ่มเติม',
                              style: TextStyle(
                                // color: Theme.of(context).colorScheme.secondary,
                                color: Colors.white,
                                fontFamily: 'Kanit',
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.9],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: statusBarHeight + 5,
                child: Container(
                  child: buttonCloseBack(context),
                ),
              ),
            ],
            // overflow: Overflow.clip,
          ),
        
        ],
      ),
    );
  }
}
