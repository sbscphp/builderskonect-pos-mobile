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

    //offline sales database
    await _initializeOfflineSalesDatabase();

    //offline recovery service
    await _initializeOfflineRecoveryService();

    //connectivity monitoring
    await _initializeConnectivityService();

    //sales sync service
    await _initializeSalesSyncService();

    //startup recovery
    await _performStartupRecovery();

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

  Future<void> _initializeOfflineSalesDatabase() async {
    try {
      await OfflineSalesDatabaseService.initialize();
      printty("===> offline sales database initialized...");
    } catch (e) {
      printty(e.toString(), logName: 'Offline Sales Database Init Error');
    }
  }

  Future<void> _initializeConnectivityService() async {
    try {
      await ConnectivityService.instance.initialize();
      printty("===> connectivity service initialized...");
    } catch (e) {
      printty(e.toString(), logName: 'Connectivity Service Init Error');
    }
  }

  Future<void> _initializeOfflineRecoveryService() async {
    try {
      await OfflineRecoveryService.initialize();
      printty("===> offline recovery service initialized...");
    } catch (e) {
      printty(e.toString(), logName: 'Offline Recovery Service Init Error');
    }
  }

  Future<void> _initializeSalesSyncService() async {
    try {
      await SalesSyncService.instance.initialize();
      printty("===> sales sync service initialized...");
    } catch (e) {
      printty(e.toString(), logName: 'Sales Sync Service Init Error');
    }
  }

  Future<void> _performStartupRecovery() async {
    try {
      await OfflineRecoveryService.performStartupRecovery();
      printty("===> startup recovery completed...");
    } catch (e) {
      printty(e.toString(), logName: 'Startup Recovery Error');
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
