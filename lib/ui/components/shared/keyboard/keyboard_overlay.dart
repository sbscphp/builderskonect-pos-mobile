import 'package:flutter/cupertino.dart';
import 'input_done_view.dart';

class KeyboardOverlay {
  static OverlayEntry? _overlayEntry;

  static showOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    OverlayState? overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          // bottom: deviceHeight(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: const InputDoneView());
    });

    overlayState.insert(_overlayEntry!);
  }

  static removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  static addRemoveFocusNode(BuildContext context, FocusNode node) {
    node.addListener(() {
      bool hasFocus = node.hasFocus;
      if (hasFocus) {
        KeyboardOverlay.showOverlay(context);
      } else {
        KeyboardOverlay.removeOverlay();
      }
    });
  }
}
