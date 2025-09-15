enum SalesType {
  omp,
  pos,
}

extension SalesTypeExtension on SalesType {
  String get text {
    switch (this) {
      case SalesType.omp:
        return 'omp';
      case SalesType.pos:
        return 'pos';
    }
  }
}
