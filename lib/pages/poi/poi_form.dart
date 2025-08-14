import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../component/button_close_back.dart';
import '../../component/comment.dart';
import '../../component/contentPoi.dart';
import '../../shared/api_provider.dart';

// ignore: must_be_immutable
class PoiForm extends StatefulWidget {
  PoiForm({
    super.key,
    this.url,
    this.code,
    this.model,
    this.urlComment,
    this.urlGallery,
  });

  final String? url;
  final String? code;
  final dynamic model;
  final String? urlComment;
  final String? urlGallery;

  @override
  _PoiForm createState() => _PoiForm();
}

class _PoiForm extends State<PoiForm> {
  Comment? comment;
  int? _limit;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    setState(() {
      _limit = _limit! + 10;

      comment = Comment(
        code: widget.code,
        url: poiCommentApi,
        model: post('${poiCommentApi}read',
            {'skip': 0, 'limit': _limit, 'code': widget.code}),
        limit: _limit,
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });

    comment = Comment(
      code: widget.code,
      url: poiCommentApi,
      model: post('${poiCommentApi}read',
          {'skip': 0, 'limit': _limit, 'code': widget.code}),
      limit: _limit,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: Stack(
          children: [
            SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              footer: ClassicFooter(
                loadingText: ' ',
                canLoadingText: ' ',
                idleText: ' ',
                idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
              ),
              controller: _refreshController,
              onLoading: _onLoading,
              child: ListView(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  ContentPoi(
                    pathShare: 'content/poi/',
                    code: widget.code,
                    url: '${poiApi}read',
                    model: widget.model,
                    urlGallery: widget.urlGallery,
                  ),
                  widget.urlComment != '' ? comment! : Container(),
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
        ),
      ),
    );
  }
}
