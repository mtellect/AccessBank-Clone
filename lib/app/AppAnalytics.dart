import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();
FirebaseAnalyticsObserver APP_OBSERVER =
    FirebaseAnalyticsObserver(analytics: analytics);
