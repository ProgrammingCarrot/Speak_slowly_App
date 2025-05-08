import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:speak_slowly/utils.dart';
import 'package:speak_slowly/components.dart';
import 'package:speak_slowly/consent.dart';

import 'package:speak_slowly/text_constants.dart';

void main() async {
  // Initialize Firebase before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Set orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const SpeakSlowly()));
}

class SpeakSlowly extends StatelessWidget {
  const SpeakSlowly({super.key});

  // The root widget of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: GlobalContextService.navigatorKey,
      theme: ThemeData(
        fontFamily: 'Noto_Sans_TC',
        // Custom checkbox theme
        checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
            checkColor:
                MaterialStateProperty.all<Color>(const Color(0xFF653103)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // Add border when checkbox is active
            side: MaterialStateBorderSide.resolveWith(
              (states) =>
                  const BorderSide(width: 1.5, color: Color(0xFF653103)),
            ),
            splashRadius: 0),
      ),
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        // Set background color to 0xFFF7CE03
        // REF: https://www.flutterbeads.com/change-background-color-screen-scaffold-flutter/?expand_article=1
        backgroundColor: const Color(0xFFF7CE03),
        body: Center(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 250),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title section
                    Container(
                      padding: const EdgeInsets.only(
                          left: 32, right: 32, bottom: 12),
                      child: const Text.rich(
                        TextSpan(
                          text: AppText.mainTitle,
                          style: TextStyle(
                            color: Color(0xFF653103),
                            fontSize: 60,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        textAlign: TextAlign.left,
                        textScaleFactor: 1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 32, right: 32, bottom: 24),
                      child: const Text.rich(
                        TextSpan(
                          text: AppText.subTitle,
                          style: TextStyle(
                            color: Color(0xFF653103),
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        textAlign: TextAlign.left,
                        textScaleFactor: 1,
                      ),
                    ),
                    // titleSection,
                    // Start button
                    Container(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: const StartBtn(
                          title: AppText.startButton,
                          targetPage: ConsentPage(),
                        )),
                  ],
                ),
              ),
              Positioned(
                right: 10,
                bottom: 30,
                width: (MediaQuery.of(context).size.width) / 1.5 + 50,
                height: (MediaQuery.of(context).size.width) / 1.5 + 50,
                child: Image.asset('assets/image/主角/阿松普通.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget to display title of the app
Widget titleSection = Container(
  padding: const EdgeInsets.only(left: 32, top: 32, right: 32, bottom: 0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Title 01
      Container(
        padding: const EdgeInsets.only(bottom: 32),
        child: SvgPicture.asset('assets/image/title_svg/Speak-title.svg',
            colorFilter:
                const ColorFilter.mode(Color(0xFF653103), BlendMode.srcIn),
            semanticsLabel: 'Title'),
      ),
      // Title 02
      Container(
        padding: const EdgeInsets.only(bottom: 32),
        child: SvgPicture.asset('assets/image/title_svg/Speak-subtitle.svg',
            colorFilter:
                const ColorFilter.mode(Color(0xFF653103), BlendMode.srcIn),
            semanticsLabel: 'Title'),
      ),
    ],
  ),
);
