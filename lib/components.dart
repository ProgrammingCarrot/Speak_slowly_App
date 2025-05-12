import 'package:flutter/material.dart';
import 'package:speak_slowly/utils.dart';
import 'package:speak_slowly/text_constants.dart';

// Start button
class StartBtn extends StatelessWidget {
  const StartBtn({
    Key? key,
    required this.title,
    required this.targetPage,
  }) : super(key: key);
  final String title;
  final Widget targetPage;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF653103),
        disabledBackgroundColor: const Color(0xFF9E846C),
        fixedSize: const Size(180, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        elevation: 5,
        shadowColor: Colors.black,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Noto_Sans_TC',
          fontWeight: FontWeight.w400,
        ),
        // alignment: Alignment.center,
        // padding: EdgeInsets.zero,
      ),
      onPressed: () {
        GlobalContextService.navigatorKey.currentState?.push(
          CustomPageRoute(
            targetPage,
          ),
        );
      },
      child: Text.rich(
        TextSpan(
          text: title,
          style: const TextStyle(
            fontFamily: 'Noto_Sans_TC',
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        textAlign: TextAlign.center,
        textScaler: const TextScaler.linear(1),
      ),
    );
  }
}

// Submit button
class SubmitBtn extends StatelessWidget {
  const SubmitBtn({
    Key? key,
    required this.title,
    required this.onPressedCallback,
    this.disable = false,
  }) : super(key: key);
  final String title;
  final VoidCallback onPressedCallback;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF653103),
        disabledBackgroundColor: const Color(0xFF9E846C),
        fixedSize: const Size(132, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        elevation: 5,
        shadowColor: Colors.black,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Noto_Sans_TC',
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: disable ? null : onPressedCallback,
      child: Text.rich(
        TextSpan(
          text: title,
          style: const TextStyle(
            fontFamily: 'Noto_Sans_TC',
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        textAlign: TextAlign.center,
        textScaler: const TextScaler.linear(1),
      ),
    );
  }
}

// Return button
class ReturnBtn extends StatelessWidget {
  const ReturnBtn({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFF653103),
        backgroundColor: Colors.white,
        disabledForegroundColor: const Color(0xFF653103),
        disabledBackgroundColor: const Color(0xFF9E846C),
        fixedSize: const Size(132, 60),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0xFF653103)),
          borderRadius: BorderRadius.circular(60),
        ),
        elevation: 5,
        shadowColor: Colors.black,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'Noto_Sans_TC',
          fontWeight: FontWeight.w400,
        ),
      ),
      onPressed: () {
        GlobalContextService.navigatorKey.currentState?.pop();
      },
      child: Text.rich(
        TextSpan(
          text: title,
          style: const TextStyle(
            fontFamily: 'Noto_Sans_TC',
            fontWeight: FontWeight.w400,
            height: 1.2,
          ),
        ),
        textAlign: TextAlign.center,
        textScaler: const TextScaler.linear(1),
      ),
    );
  }
}

// AppBar title
PreferredSize appBarTitle() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(45),
    child: AppBar(
      title: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: AppText.mainTitle,
              style: TextStyle(
                color: Color(0xFF653103),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: "－",
              style: TextStyle(
                color: Color(0xFF653103),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: AppText.subTitle,
              style: TextStyle(
                color: Color(0xFF653103),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.left,
      ),
      centerTitle: false,
      titleSpacing: 24.0,
      backgroundColor: const Color(0xFFF7CE03),
      elevation: 0,
      automaticallyImplyLeading: false,
    ),
  );
}
