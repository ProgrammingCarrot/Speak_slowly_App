import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:speak_slowly/treatment_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speak_slowly/utils.dart';
import 'package:speak_slowly/components.dart';
import 'package:bubble/bubble.dart';

import 'package:speak_slowly/text_constants.dart';

class ResourcePage extends StatefulWidget {
  const ResourcePage({Key? key}) : super(key: key);

  @override
  State<ResourcePage> createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {
  late List<LinkButton> linkButtons = [];
  final Map<String, dynamic> resourceLinks = AppText.resourceLinks;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Clear the list first
    linkButtons = [];
    // Add text and url to the list
    resourceLinks.forEach((key, value) {
      linkButtons.add(LinkButton(
        text: value['text'],
        url: value['url'],
      ));
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: appBarTitle(),
        body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  maxHeight: 40,
                  minHeight: 40,
                  child: Column(
                    children: [
                      Container(
                        height: 20,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFF7CE03),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36),
                            ),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x29000000),
                              blurRadius: 5,
                              offset: Offset(0, 5),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(
                                left: 24, top: 0, right: 24, bottom: 0),
                            child: const Row(
                              children: [],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Form block
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return SizedBox(
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width) / 2 +
                                          40,
                                  child: Bubble(
                                    padding: const BubbleEdges.all(12),
                                    nip: BubbleNip.rightBottom,
                                    nipOffset: 30,
                                    nipWidth: 20,
                                    color: Colors.white,
                                    radius: const Radius.circular(16),
                                    elevation: 5,
                                    borderColor: const Color(0xFF653103),
                                    child: const Text.rich(
                                      TextSpan(
                                        text: AppText.resourceAdvice,
                                        style: TextStyle(
                                            color: Color(0xFF653103),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      textScaleFactor: 1,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width) / 3,
                                  child: SizedBox(
                                    child:
                                        Image.asset('assets/image/主角/阿松舉手.png'),
                                  ),
                                ),
                              ],
                            ),
                            // Spacing
                            const SizedBox(
                              height: 24,
                            ),
                            // Wrap the buttons
                            Wrap(
                              alignment: WrapAlignment.center,
                              runSpacing: 16,
                              children: linkButtons.map((linkButton) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF653103),
                                    disabledBackgroundColor:
                                        const Color(0xFF9E846C),
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width - 100,
                                      (linkButton.text.contains('\n'))
                                          ? 70
                                          : 70,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Noto_Sans_TC',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  onPressed: () {
                                    launchUrl(Uri.parse(linkButton.url));
                                  },
                                  // Add text.rich align to center
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: linkButton.text,
                                          style: TextStyle(
                                            fontFamily: 'Noto_Sans_TC',
                                            fontWeight: FontWeight.w400,
                                            height:
                                                (linkButton.text.contains('\n'))
                                                    ? 1.5
                                                    : 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: 1,
                                  ),
                                );
                              }).toList(),
                            ),
                            // Spacing
                            const SizedBox(
                              height: 24,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF653103),
                                backgroundColor: Colors.white,
                                disabledForegroundColor:
                                    const Color(0xFF653103),
                                disabledBackgroundColor:
                                    const Color(0xFF9E846C),
                                fixedSize: const Size(180, 60),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.50, color: Color(0xFF653103)),
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
                                GlobalContextService.navigatorKey.currentState
                                    ?.push(
                                  CustomPageRoute(const TreatmentMapPage()),
                                );
                              },
                              child: const Text.rich(
                                TextSpan(
                                  text: AppText.mapButton,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                  ),
                                ),
                                textScaleFactor: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
              SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    padding: const EdgeInsets.only(top: 24, bottom: 54),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF653103),
                                backgroundColor: Colors.white,
                                disabledForegroundColor:
                                    const Color(0xFF653103),
                                disabledBackgroundColor:
                                    const Color(0xFF9E846C),
                                fixedSize: const Size(180, 60),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 0.50, color: Color(0xFF653103)),
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text("退出程式"),
                                    content: const Text("您確定要退出程式嗎？"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Clear records
                                          await clearRecordings();
                                          // Close the app
                                          closeApp();
                                        },
                                        child: const Text('確認'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text.rich(
                                TextSpan(
                                  text: AppText.exitButton,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                  ),
                                ),
                                textScaleFactor: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
