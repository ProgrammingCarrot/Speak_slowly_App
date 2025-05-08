import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speak_slowly/resource.dart';
import 'package:speak_slowly/utils.dart';
import 'package:speak_slowly/components.dart';
import 'package:speak_slowly/treatment_map.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:bubble/bubble.dart';

import 'package:speak_slowly/text_constants.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Map<String, dynamic> responseJson;
  late String resultDiagnosisLevel;
  late String resultDiagnosisAdvice;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Check the age of the child, and load the corresponding number of questions
    // While testing the page without loading last page, the list will be null,
    // So use the default value.
    final String birthDate =
        questionnaireResult["basic_info"]?["1"]?["answers"].last ??
            "2020-08-29（3歲）";
    // Extract the age from the birth date
    int age = int.parse(extractAge(birthDate));
    // Extract the responseJson from the route settings
    final settings = ModalRoute.of(context)!.settings;
    responseJson = settings.arguments as Map<String, dynamic>;

    // * Testing code: If you want to test the page without loading last page,
    // responseJson = {
    //   "塞音化": 0.08,
    //   "舌根音化": 0.12,
    //   "聲隨韻母": 0.05,
    //   "擦音化": 0.2,
    //   "塞擦音化": 0.1,
    //   "其他": 0.1,
    //   "子音正確率": 0.21
    // };

    // Assign resultDiagnosisLevel
    // If responseJson["子音正確率"]  is 0.85~1.0, show AppText.resultDiagnosisLevel01
    if (responseJson["子音正確率"] >= 0.85 && responseJson["子音正確率"] <= 1.0) {
      resultDiagnosisLevel = AppText.resultDiagnosisLevel01;
    }
    // 0.65~0.85, show AppText.resultDiagnosisLevel02
    else if (responseJson["子音正確率"] >= 0.65 && responseJson["子音正確率"] < 0.85) {
      resultDiagnosisLevel = AppText.resultDiagnosisLevel02;
    }
    // 0.50~0.65, show AppText.resultDiagnosisLevel03
    else if (responseJson["子音正確率"] >= 0.50 && responseJson["子音正確率"] < 0.65) {
      resultDiagnosisLevel = AppText.resultDiagnosisLevel03;
    }
    // 0.00~0.50, show AppText.resultDiagnosisLevel04
    else if (responseJson["子音正確率"] >= 0.0 && responseJson["子音正確率"] < 0.50) {
      resultDiagnosisLevel = AppText.resultDiagnosisLevel04;
    }

    // Copy responseJson but remove "子音正確率"
    var responseJsonCopy = Map<String, dynamic>.from(responseJson);
    responseJsonCopy.remove("子音正確率");

    // Remove key-value pairs with value 0
    // This map is used to draw the pie chart (without "子音正確率")
    responseJsonCopy.removeWhere((key, value) => value == 0);
    // Mapping the sum of all values to 1
    final sum = responseJsonCopy.values.reduce((a, b) => a + b);
    responseJsonCopy.updateAll((key, value) => value / sum);
    // Sort the map by value
    responseJsonCopy = Map.fromEntries(responseJsonCopy.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));
    // Print the result
    if (kDebugMode) {
      print(responseJsonCopy);
    }

    // Assign resultDiagnosisAdvice
    // If age <= 3 && PCC >= 65% || if age > 3 && PCC >= 85%, set resultDiagnosisAdvice to AppText.resultAdvice01
    if ((age <= 3 && responseJson["子音正確率"] >= 0.65) ||
        (age > 3 && responseJson["子音正確率"] >= 0.85)) {
      resultDiagnosisAdvice = AppText.resultAdvice01;
    }
    // If age <= 3 && PCC < 65% || if age > 3 && PCC < 85%
    else if ((age <= 3 && responseJson["子音正確率"] < 0.65) ||
        (age > 3 && responseJson["子音正確率"] < 0.85)) {
      resultDiagnosisAdvice = AppText.resultAdvice02;
    }

    var colorList = [
      const Color(0xFFF7CE03),
      const Color(0xFFB7A492),
      const Color(0xFFFF715A),
      const Color(0xFFAA6F30),
      const Color(0xFF8CC433),
      const Color(0xFF83B8C4),
    ];

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
                            // Title
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  left: 24,
                                  top: 0,
                                  right: 24,
                                  bottom:
                                      (MediaQuery.of(context).size.width) / 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // If age <= 3, show AppText.resultTitle01
                                        age <= 3
                                            ? Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      // Show all the keys in the map as a string with comma
                                                      text: AppText
                                                          .resultDiagnosePrefix02,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF777777),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      // Show all the keys in the responseJsonCopy as a string with comma
                                                      text: responseJsonCopy
                                                          .keys
                                                          .toList()
                                                          .join("、"),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF777777),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                textScaleFactor: 1,
                                              )
                                            : Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: AppText
                                                          .resultDiagnosePrefix01,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF653103),
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          resultDiagnosisLevel,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF653103),
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const TextSpan(
                                                      // Show all the keys in the map as a string with comma
                                                      text: AppText
                                                          .resultDiagnosePrefix02,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF777777),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      // Show all the keys in the responseJsonCopy as a string with comma
                                                      text: responseJsonCopy
                                                          .keys
                                                          .toList()
                                                          .join("、"),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF777777),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                textScaleFactor: 1,
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Pie chart
                            SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: responseJsonCopy.entries
                                      .map((e) => PieChartSectionData(
                                            color: colorList[responseJsonCopy
                                                .keys
                                                .toList()
                                                .indexOf(e.key)],
                                            value: e.value,
                                            // Set values to precentages with 2 decimal places and add % sign
                                            title:
                                                '${(e.value * 100).toStringAsFixed(1)}%',
                                            radius: (MediaQuery.of(context)
                                                    .size
                                                    .width) /
                                                5,
                                            titleStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ))
                                      .toList(),
                                  centerSpaceRadius:
                                      (MediaQuery.of(context).size.width) / 6,
                                  sectionsSpace: 0,
                                  startDegreeOffset: 0,
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                ),
                              ),
                            ),
                            // Labels and square indicator of pie chart
                            Container(
                              padding: EdgeInsets.only(
                                  left: 48,
                                  top: (MediaQuery.of(context).size.width) / 6,
                                  right: 48,
                                  bottom: 0),
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 12.0,
                                alignment: WrapAlignment.center,
                                children: responseJsonCopy.entries
                                    .map((e) => Wrap(
                                          children: [
                                            Container(
                                              width: 12,
                                              height: 12,
                                              color: colorList[responseJsonCopy
                                                  .keys
                                                  .toList()
                                                  .indexOf(e.key)],
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              e.key,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF777777),
                                                  height: 1),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              ),
                            ),
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
                                    child: Text.rich(
                                      TextSpan(
                                        text: resultDiagnosisAdvice,
                                        style: const TextStyle(
                                            color: Color(0xFF653103),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      textScaleFactor: 1,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 40),
                                  width:
                                      (MediaQuery.of(context).size.width) / 3,
                                  child: SizedBox(
                                    child:
                                        Image.asset('assets/image/主角/阿松舉手.png'),
                                  ),
                                ),
                              ],
                            )
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
                              disabledForegroundColor: const Color(0xFF653103),
                              disabledBackgroundColor: const Color(0xFF9E846C),
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
                          const SizedBox(width: 16),
                          ElevatedButton(
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
                            onPressed: () {
                              GlobalContextService.navigatorKey.currentState
                                  ?.push(
                                CustomPageRoute(const ResourcePage()),
                              );
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: AppText.resourceButton,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
