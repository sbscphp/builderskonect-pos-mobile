enum CustomType {
  online,
  offline, //walk-in
}

extension CustomTypeExtension on CustomType {
  String get title {
    switch (this) {
      case CustomType.online:
        return 'Online';
      case CustomType.offline:
        return 'Offline';
    }
  }

  String get apiValue {
    switch (this) {
      case CustomType.online:
        return 'online';
      case CustomType.offline:
        return 'offline';
    }
  }
}
