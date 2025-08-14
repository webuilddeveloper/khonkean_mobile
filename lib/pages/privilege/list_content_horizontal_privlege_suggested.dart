import 'package:flutter/material.dart';

import '../../component/sso/list_content_horizontal_loading.dart';

// ignore: must_be_immutable
class ListContentHorizontalPrivilegeSuggested extends StatefulWidget {
  ListContentHorizontalPrivilegeSuggested(
      {super.key,
      this.title,
      this.url,
      this.model,
      this.urlComment,
      this.navigationList,
      this.navigationForm});

  final String? title;
  final String? url;
  final Future<dynamic>? model;
  final String? urlComment;
  final Function()? navigationList;
  final Function(String, dynamic)? navigationForm;

  @override
  _ListContentHorizontalPrivilegeSuggested createState() =>
      _ListContentHorizontalPrivilegeSuggested();
}

class _ListContentHorizontalPrivilegeSuggested
    extends State<ListContentHorizontalPrivilegeSuggested> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.0),
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                widget.title!,
                style: TextStyle(
                  // color: Color(0xFF000070),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.navigationList!();
              },
              child: Container(
                  padding: EdgeInsets.only(right: 10.0),
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    'ดูทั้งหมด',
                    style: TextStyle(fontSize: 12.0, fontFamily: 'Kanit'),
                  )),
            ),
          ],
        ),
        Container(
          height: 300,
          color: Colors.transparent,
          child: renderCard(
            widget.title!,
            widget.url!,
            widget.model!,
            widget.urlComment!,
            widget.navigationForm!,
          ),
        ),
      ],
    );
  }
}

renderCard(String title, String url, Future<dynamic> model, String urlComment,
    Function navigationForm) {
  return FutureBuilder<dynamic>(
    future: model,
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return myCard(index, snapshot.data.length, snapshot.data[index],
                context, navigationForm);
          },
        );
      } else {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListContentHorizontalLoading();
          },
        );
      }
    },
  );
}

myCard(int index, int lastIndex, dynamic model, BuildContext context,
    Function navigationForm) {
  return GestureDetector(
    onTap: () {
      navigationForm(model['code'], model);
    },
    child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          // padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // color: Color(0xFF000000),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                spreadRadius: 0,
                blurRadius: 5,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          margin: index == 0
              ? EdgeInsets.only(left: 10.0, right: 5.0)
              : index == lastIndex - 1
                  ? EdgeInsets.only(left: 10.0, right: 15.0)
                  : EdgeInsets.symmetric(horizontal: 10.0),
          width: 300.0,
          child: Column(
            children: [
              Container(
                child: Image.network(
                  '${model['imageUrl']}',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                height: 55,
                width: 350,
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(10.0),
                    bottomRight: const Radius.circular(10.0),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Kanit',
                          fontSize: 16.0,
                          color: Colors.white),
                    ),
                    Text(
                      '${model['title']}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Kanit',
                          fontSize: 12.0,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
