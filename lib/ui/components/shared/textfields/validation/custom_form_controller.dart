import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

// Enhanced Form Controller with better disposal management
class CustomFormController {
  final Map<String, CustomTextFieldState> _fields = {};
  final Map<String, bool> _fieldValidationStates = {};
  final Map<String, TextEditingController> _managedControllers = {};

  void registerField(String fieldId, CustomTextFieldState fieldState) {
    _fields[fieldId] = fieldState;
    _fieldValidationStates[fieldId] = false;

    // Track controllers that we should manage disposal for
    if (fieldState.widget.controller == null) {
      _managedControllers[fieldId] = fieldState.controller;
    }
  }

  void unregisterField(String fieldId) {
    _fields.remove(fieldId);
    _fieldValidationStates.remove(fieldId);
    _managedControllers.remove(fieldId); // Remove from managed controllers
  }

  void updateFieldValidation(String fieldId, bool isValid) {
    _fieldValidationStates[fieldId] = isValid;
  }

  bool validateAllFields() {
    bool allValid = true;
    for (final field in _fields.values) {
      field.validateField();
      if (!field.isValid) {
        allValid = false;
      }
    }
    return allValid;
  }

  bool get isFormValid {
    return _fieldValidationStates.values.every((isValid) => isValid);
  }

  void clearAllValidations() {
    for (final field in _fields.values) {
      field.clearValidation();
    }
  }

  Map<String, String> getFieldValues() {
    final values = <String, String>{};
    for (final entry in _fields.entries) {
      values[entry.key] = entry.value.controller.text;
    }
    return values;
  }

  // Enhanced dispose method
  void dispose() {
    // Dispose all internally managed controllers
    for (final controller in _managedControllers.values) {
      controller.dispose();
    }

    // Clear all maps
    _fields.clear();
    _fieldValidationStates.clear();
    _managedControllers.clear();
  }

  // Optional: Method to dispose specific field controller
  void disposeField(String fieldId) {
    final controller = _managedControllers[fieldId];
    if (controller != null) {
      controller.dispose();
      _managedControllers.remove(fieldId);
    }
    _fields.remove(fieldId);
    _fieldValidationStates.remove(fieldId);
  }
}
