import 'package:builders_konnect/core/core.dart';

class FormController {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};

  FormController(List<String> fieldNames) {
    for (String field in fieldNames) {
      _controllers[field] = TextEditingController();
      _focusNodes[field] = FocusNode();
    }
  }

  TextEditingController controller(String field) => _controllers[field]!;
  FocusNode focusNode(String field) => _focusNodes[field]!;

  Map<String, String> get data => {
        for (String field in _controllers.keys)
          field: _controllers[field]!.text,
      };

  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
  }
}
