import 'package:builders_konnect/core/core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppInitService {
  init() async {
    //screen orientation
    await _screenOrientationInit();

    //hive
    await _initializeHive();

    //firebase
    // await _firebaseInit();

    //request for permission
    // await _requestPushNotificationPermission();

    // Dotenv
    await dotenv.load(fileName: ".env");
    AppConfig.setEnvironment(EnvironmentType.dev);
  }

  // _firebaseInit() async {
  //   try {
  //     await Firebase.initializeApp();
  //     printty("===> firebase initialized...");
  //   } catch (e) {
  //     printty(e.toString(), logName: 'Firebase Error check');
  //   }
  // }

  Future<void> _initializeHive() async {
    try {
      await Hive.initFlutter();
      await Hive.openBox(StorageKey.generalHiveBox);
      printty("===> hive initialized...");
    } catch (e) {
      printty(e.toString(), logName: 'Hive Init Error');
    }
  }

  _screenOrientationInit() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    printty("===> screen orientation initialized...");
  }

  // _requestPushNotificationPermission() async {
  //   final token = await FirebaseMessaging.instance.getToken();
  //   printty(token, logName: 'FireBASE-TOKEN');
  //   //await Firebase.initializeApp();
  //   FirebaseMessaging.instance.requestPermission(
  //       alert: true, badge: true, criticalAlert: true, sound: true);
  //   FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //       alert: true, badge: true, sound: true);
  // }
}
