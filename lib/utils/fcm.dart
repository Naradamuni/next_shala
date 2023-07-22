import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:rxdart/rxdart.dart';

class FCM {
  final _deepLinkFetcher = PublishSubject();
  Stream get deepLinkingObserver => _deepLinkFetcher.stream;
  init(BuildContext context) async {
    // listenFirbase(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // _deepLinkFetcher.sink.add({
      //   "path": initialMessage.data['screen'],
      //   "id": initialMessage.data['id']
      // });

      routeByDeeplink(initialMessage.data['screen'], initialMessage.data['id']);
      // if (initialMessage.data['url'] != null) {
      // add(DidGetDeeplinkEvent(
      //     path: initialMessage.data['screen'], id: initialMessage.data['id']));
      // // }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // _deepLinkFetcher.sink
      //     .add({"path": message.data['screen'], "id": message.data['id']});
      routeByDeeplink(message.data['screen'], message.data['id']);
      // add(DidGetDeeplinkEvent(
      //     path: message.data['screen'], id: message.data['id']));
      // // }
    });
  }

  routeByDeeplink(String screen, String id) {
    String? route;
    switch (screen) {
      case "attendance":
        route = '/attendence';
        break;
      case "home_work":
        route = '/home_work';
        break;
      case "time_table":
        route = '/time_table_week';
        break;
      case "events":
        route = '/events';
    }
    Get.toNamed(route!, arguments: PageRoutingArguments(studentId: id));
  }

  // }
}
