import 'package:flutter/material.dart';

class RouteObserver<R extends Route<dynamic>> extends NavigatorObserver {
  final List<RouteAware>? listeners;

  RouteObserver({this.listeners});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    for (var listener in listeners!) {
      listener.didPushNext();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    for (var listener in listeners!) {
      listener.didPopNext();
    }
  }
}

abstract class RouteAware {
  void didPushNext();
  void didPopNext();
}
