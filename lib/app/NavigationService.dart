import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T> navigateToNamedRoute<T>(String routeName, {Object arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<T> clearHistoryAndNavigateToNamedRoute<T>(String routeName, {Object arguments}) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil<void>(routeName, (_) => false, arguments: arguments);
  }

  Future<T> navigateToRoute<T>(Route<T> route) {
    return navigatorKey.currentState.push(route);
  }

  void navigateToHome() => navigatorKey.currentState.popUntil((route) => route.isFirst);

  bool goBack() {
    return navigatorKey.currentState.pop();
  }
}
