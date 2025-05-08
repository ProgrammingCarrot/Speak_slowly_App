import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speak_slowly/utils.dart';
import 'package:speak_slowly/components.dart';
import 'package:bubble/bubble.dart';

import 'package:speak_slowly/text_constants.dart';

class TreatmentMapPage extends StatefulWidget {
  const TreatmentMapPage({Key? key}) : super(key: key);

  @override
  State<TreatmentMapPage> createState() => _TreatmentMapPageState();
}

class _TreatmentMapPageState extends State<TreatmentMapPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                        children: [
                                          TextSpan(
                                            text: AppText.mapAdvice,
                                            style: TextStyle(
                                              color: Color(0xFF653103),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
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
                            Wrap(
                              children: [
                                // A container that put image in the center, and the word under the image
                                Container(
                                  // Padding for next word
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 200,
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: const Color(0xFF653103),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12.5),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text.rich(
                                              TextSpan(
                                                text: AppText.mapTaiwan,
                                                style: TextStyle(
                                                  color: Color(0xFF653103),
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              textScaleFactor: 1,
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    const Color(0xFF653103),
                                                disabledBackgroundColor:
                                                    const Color(0xFF9E846C),
                                                fixedSize: const Size(180, 60),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
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
                                                launchUrl(
                                                  Uri.parse(
                                                      'https://likest2016.wordpress.com/2016/06/30/st-map/'),
                                                );
                                              },
                                              child: const Text.rich(
                                                TextSpan(
                                                  text: AppText.mapButton,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    height: 1,
                                                  ),
                                                ),
                                                textScaleFactor: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  // Padding for next word
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 200,
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                            color: const Color(0xFF653103),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12.5),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text.rich(
                                              TextSpan(
                                                text: AppText.mapTaipei,
                                                style: TextStyle(
                                                  color: Color(0xFF653103),
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              textScaleFactor: 1,
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            const Text.rich(
                                              TextSpan(
                                                text: AppText.mapTaipeiHint,
                                                style: TextStyle(
                                                  color: Color(0xFF653103),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              textScaleFactor: 1,
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor:
                                                    const Color(0xFF653103),
                                                disabledBackgroundColor:
                                                    const Color(0xFF9E846C),
                                                fixedSize: const Size(180, 60),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
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
                                                launchUrl(
                                                  Uri.parse(
                                                      'https://www.google.com/maps/d/u/0/viewer?mid=11MPLZZBUpRXS25R_TZcFFIeSN6iuamRI'),
                                                );
                                              },
                                              child: const Text.rich(
                                                TextSpan(
                                                  text: AppText.mapButton,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    height: 1,
                                                  ),
                                                ),
                                                textScaleFactor: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            ReturnBtn(title: AppText.returnButton),
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
