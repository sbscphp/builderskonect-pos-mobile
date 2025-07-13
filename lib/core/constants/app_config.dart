import 'package:builders_konnect/core/core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static late final Map<String, dynamic> _config;

  static void setEnvironment(EnvironmentType env) {
    switch (env) {
      case EnvironmentType.dev:
        _config = _BaseUrlConfig.devConstants;
        break;
      case EnvironmentType.staging:
        _config = _BaseUrlConfig.stagingConstants;
        break;
      case EnvironmentType.prod:
        _config = _BaseUrlConfig.prodConstants;
        break;
      case EnvironmentType.qa:
        _config = _BaseUrlConfig.qaConstants;
        break;
    }
  }

  static String get baseUrl => _config[_BaseUrlConfig.baseUrl] ?? '';
  static String get payStackKey => _config[_BaseUrlConfig.payStackKey] ?? '';
}

class _BaseUrlConfig {
  static const String baseUrl = 'BaseUrl';
  static const String payStackKey = 'PayStackPublicKey';

  static final Map<String, dynamic> devConstants = {
    baseUrl: dotenv.env['DEV_BASE_URL'] ?? '',
    payStackKey: dotenv.env['DEV_PAY_STACK_KEY'] ?? '',
  };

  static final Map<String, dynamic> stagingConstants = {
    baseUrl: dotenv.env['STAGING_BASE_URL'] ?? '',
    payStackKey: dotenv.env['STAGING_PAY_STACK_KEY'] ?? '',
  };

  static final Map<String, dynamic> qaConstants = {
    baseUrl: dotenv.env['QA_BASE_URL'] ?? '',
    payStackKey: dotenv.env['QA_PAY_STACK_KEY'] ?? '',
  };

  static final Map<String, dynamic> prodConstants = {
    baseUrl: dotenv.env['PROD_BASE_URL'] ?? '',
    payStackKey: dotenv.env['PROD_PAY_STACK_KEY'] ?? '',
  };
}
