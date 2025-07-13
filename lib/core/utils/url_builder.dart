class UriBuilder {
  UriBuilder(String baseUrl) : _uri = Uri.parse(baseUrl);

  final Uri _uri;
  final Map<String, List<String>> _queryParameters = {};

  UriBuilder addQueryParameter(String name, String value) {
    if (_queryParameters.containsKey(name)) {
      _queryParameters[name]!.add(value);
    } else {
      _queryParameters[name] = [value];
    }
    return this;
  }

  Uri build() {
    final queryParams = _queryParameters.entries.expand((entry) {
      return entry.value.map((value) =>
          '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(value)}');
    }).join('&');

    final uriString = _uri.toString();
    final separator = uriString.contains('?') ? '&' : '?';
    final finalUriString = '$uriString$separator$queryParams';

    return Uri.parse(finalUriString);
  }

  addQueryParameterIfNotEmpty(String name, String value) {
    if (value.isNotEmpty) {
      addQueryParameter(name, value);
    }
  }
}
