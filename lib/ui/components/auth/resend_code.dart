import 'dart:async';

import 'package:builders_konnect/core/core.dart';

class ResendCode extends StatefulWidget {
  const ResendCode({
    super.key,
    required this.onResendCode,
  });

  final Function onResendCode;

  @override
  State<ResendCode> createState() => _ResendCodeState();
}

class _ResendCodeState extends State<ResendCode> {
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _restartTimer() {
    setState(() {
      _secondsRemaining = 60;
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    bool isTimedOut = _secondsRemaining == 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isTimedOut
            ? InkWell(
                onTap: () {
                  _restartTimer();
                  widget.onResendCode();
                },
                child: Text(
                  "Resend OTP",
                  style: textTheme.text16
                      ?.copyWith(color: colorScheme.primaryColor),
                ),
              )
            : RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Resend OTP in ",
                      style: textTheme.text14?.copyWith(
                        color: colorScheme.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: _formatTime(_secondsRemaining),
                      style: textTheme.text14?.medium.copyWith(
                        color: AppColors.red22,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = (minutes < 10) ? '0$minutes' : '$minutes';
    String formattedSeconds =
        (remainingSeconds < 10) ? '0$remainingSeconds' : '$remainingSeconds';
    return '$formattedMinutes:$formattedSeconds';
  }

  // getDurationInMins() {
  //   seconds = (duration % 60).toInt().toString();
  //   min = (duration ~/ 60).toInt().toString();
  // }
}
