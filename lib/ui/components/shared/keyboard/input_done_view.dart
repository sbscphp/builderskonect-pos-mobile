import 'package:builders_konnect/core/core.dart';
import 'package:flutter/cupertino.dart';

class InputDoneView extends StatelessWidget {
  const InputDoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Sizer.height(44),
      color: AppColors.grey,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 6.0),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text(
              "Done",
              style: TextStyle(
                fontSize: Sizer.text(16),
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
