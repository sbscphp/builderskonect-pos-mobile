
import 'dart:async';
import 'dart:ui';

class Debouncer{

  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 800});

  performAction({required VoidCallback action}){
    ///reset timer if timer is not null
    if(_timer != null) _timer!.cancel();

    ///init timer
    _timer = Timer(Duration(milliseconds: milliseconds), action);

  }


}