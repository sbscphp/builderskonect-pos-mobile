import 'package:flutter/widgets.dart';

class ForgotArg {
  ForgotArg({
    this.email,
    this.token,
    this.password,
    this.confirmPassword,
    this.code,
    this.entity,
  });

  final String? token;
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? code;
  final String? entity;

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'password': password,
      'password_confirmation': confirmPassword,
      'code': code,
      'entity': entity,
    };
  }

  ForgotArg copyWith({
    ValueGetter<String?>? token,
    ValueGetter<String?>? password,
    ValueGetter<String?>? confirmPassword,
    ValueGetter<String?>? code,
    ValueGetter<String?>? entity,
  }) {
    return ForgotArg(
      token: token != null ? token() : this.token,
      password: password != null ? password() : this.password,
      confirmPassword:
          confirmPassword != null ? confirmPassword() : this.confirmPassword,
      code: code != null ? code() : this.code,
      entity: entity != null ? entity() : this.entity,
    );
  }
}
