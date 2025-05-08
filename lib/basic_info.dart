import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:speak_slowly/record.dart';
import 'package:speak_slowly/utils.dart';
import 'package:speak_slowly/components.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:speak_slowly/text_constants.dart';

class BasicInfoPage extends StatefulWidget {
  const BasicInfoPage({Key? key}) : super(key: key);
  @override
  State<BasicInfoPage> createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  late int age = 0;
  late int questionNum;
  late int answeredCount;

  ValueNotifier<int> answeredCountNotifier = ValueNotifier<int>(0);

  int countAnsweredQuestions(List<QuestionInfo> questions) {
    int answeredCount = 0;
    for (QuestionInfo question in questions) {
      if (question.selectedOptions.isNotEmpty &&
          !question.selectedOptions.contains("")) {
        answeredCount++;
      }
    }

    // Update the notifier
    answeredCountNotifier.value = answeredCount;

    return answeredCount;
  }

  @override
  void initState() {
    super.initState();
    // Reset the questionsInfo
    questionsInfo = List<QuestionInfo>.from(jsonQuestingInfo.keys
        .map((key) => QuestionInfo.fromJson(key, jsonQuestingInfo[key])));
    // Reset the questionnaireResult
    questionnaireResult = {
      "consent": {},
      "basic_info": {},
    };
    questionNum = questionsInfo.length;
    answeredCount = countAnsweredQuestions(questionsInfo);
    // Add 2 empty strings to the selectedOptions of the first question
    questionsInfo[0].selectedOptions.add('');
    questionsInfo[0].selectedOptions.add('');
  }

  // Function to show the AlertDialog with TextField
  void _showTextFieldAlertDialog(BuildContext context, QuestionInfo question) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(AppText.basicInfoDialogTitle),
          content: TextField(
            controller: textController,
            decoration:
                const InputDecoration(hintText: AppText.basicInfoDialogHint),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (textController.text.isNotEmpty) {
                  final enteredValue = '其他：${textController.text}';
                  if (enteredValue.isNotEmpty) {
                    setState(() {
                      question.options
                          .insert(question.options.length - 1, enteredValue);
                      question.selectedOptions.add(enteredValue);
                      // Remove the "無" option if "其他" is selected
                      question.selectedOptions.remove("無");
                    });
                  }
                }
              },
              child: const Text(AppText.basicInfoDialogSubmit),
            ),
          ],
        );
      },
    );
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
              SliverAppBar(
                collapsedHeight: 100,
                expandedHeight: 100,
                flexibleSpace: Container(
                  color: const Color(0xFFF7CE03),
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                          left: 24, top: 0, right: 24, bottom: 0),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: AppText.basicInfoWelcomeMessage01,
                                        style: TextStyle(
                                          color: Color(0xFF653103),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: AppText.basicInfoWelcomeMessage02,
                                        style: TextStyle(
                                          color: Color(0xFF653103),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                  textScaleFactor: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                automaticallyImplyLeading: false,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverHeaderDelegate(
                  maxHeight: 80,
                  minHeight: 80,
                  child: Column(
                    children: [
                      Container(
                        height: 30,
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
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadows: const [
                              BoxShadow(
                                color: Color(0x29000000),
                                blurRadius: 3,
                                offset: Offset(0, 3),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width - 50,
                          height: 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text.rich(
                                TextSpan(
                                  text: AppText.basicInfoProgressbarText,
                                  style: TextStyle(
                                    color: Color(0xFF653103),
                                    fontSize: 16,
                                    fontFamily: 'Noto Sans TC',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1,
                              ),
                              ValueListenableBuilder<int>(
                                valueListenable: answeredCountNotifier,
                                builder: (context, answeredCount, _) {
                                  return LinearPercentIndicator(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    animation: true,
                                    animateFromLastPercent: true,
                                    lineHeight: 20.0,
                                    animationDuration: 500,
                                    percent: answeredCount / questionNum,
                                    center: Text.rich(
                                      TextSpan(
                                        text: "$answeredCount / $questionNum",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Noto Sans TC',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    barRadius: const Radius.circular(16),
                                    progressColor: const Color(0xFF653103),
                                  );
                                },
                              ),
                            ],
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
                    final question = questionsInfo[index];
                    final questionNumber = (index + 1).toString();
                    final formattedQuestion =
                        '$questionNumber. ${question.question}';
                    return ListTile(
                      title: Text.rich(
                        TextSpan(
                          text: formattedQuestion,
                          style: const TextStyle(
                            color: Color(0xFF653103),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        textScaleFactor: 1,
                      ),
                      subtitle: Wrap(
                        spacing: 12.0,
                        children: question.options.map(
                          (option) {
                            if (option == "兒童姓名" || option == "出生日期") {
                              final index = question.options.indexOf(option);
                              final TextEditingController textController =
                                  TextEditingController(
                                text: question.selectedOptions[index],
                              );

                              Widget optionWidget;

                              if (option == "兒童姓名") {
                                optionWidget = SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 50) /
                                              2 -
                                          50,
                                  height: 50.0,
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Color(0xFF5F3405),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                    // Comment out the controller of this TextField
                                    // Only use setState to update the selectedOptions
                                    // controller: textController,
                                    decoration: InputDecoration(
                                      labelText: option,
                                      labelStyle: const TextStyle(
                                        color: Color(0xFFCCCCCC),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      floatingLabelStyle: const TextStyle(
                                        color: Color(0xFF653103),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color: Color(0xFFCCCCCC),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color: Color(0xFF5F3310),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onTapOutside: (event) => {
                                      FocusScope.of(context).unfocus(),
                                      setState(() {})
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        question.selectedOptions[question
                                            .options
                                            .indexOf(option)] = value;
                                        answeredCount = countAnsweredQuestions(
                                            questionsInfo);
                                        if (kDebugMode) {
                                          print(answeredCount);
                                        }
                                      });
                                    },
                                  ),
                                );
                              } else {
                                optionWidget = SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 50) /
                                              2 +
                                          50,
                                  height: 50.0,
                                  child: TextField(
                                    style: const TextStyle(
                                      color: Color(0xFF5F3405),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                    // Editing controller of this TextField
                                    // Do not comment out the controller of this TextField
                                    // Because it will cause the TextField to be uneditable
                                    controller: textController,
                                    decoration: InputDecoration(
                                      labelText: option,
                                      labelStyle: const TextStyle(
                                        color: Color(0xFFCCCCCC),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      floatingLabelStyle: const TextStyle(
                                        color: Color(0xFF653103),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      // Label text of field
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color: Color(0xFFCCCCCC),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 0.50,
                                          color: Color(0xFF5F3310),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      suffixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: Color(0xFF5E3410),
                                      ),
                                    ),
                                    // Set it true, so that user will not able to edit text
                                    readOnly: true,
                                    onTap: () async {
                                      if (Platform.isIOS) {
                                        // Show DatePicker in iOS
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 300,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                initialDateTime: DateTime.now(),
                                                // Set minimum date to 1900-01-01
                                                minimumDate: DateTime(1900),
                                                // Set maximum date to current date
                                                maximumDate: DateTime.now(),
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                                onDateTimeChanged:
                                                    (DateTime newDate) {
                                                  // Handle the selected date here
                                                  String formattedDate =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(newDate);
                                                  // Calculate the age
                                                  age = calculateAge(newDate);
                                                  // Update the selectedOptions and answeredCount
                                                  setState(
                                                    () {
                                                      question.selectedOptions[
                                                              question.options
                                                                  .indexOf(
                                                                      option)] =
                                                          '$formattedDate（$age歲）';
                                                      answeredCount =
                                                          countAnsweredQuestions(
                                                              questionsInfo);
                                                    },
                                                  );
                                                  if (kDebugMode) {
                                                    print(
                                                        'answeredCount: $answeredCount');
                                                    print(
                                                        '$formattedDate（$age歲）');
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        ).then((value) => (!isTooYoung(age))
                                            ? showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text("提醒"),
                                                  content: Text(
                                                      "您的年齡為 $age 歲，小於語音障礙檢測的年齡（3歲），請重新選擇日期。"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          // Reset the age and selectedOptions
                                                          age = 0;
                                                          question.selectedOptions[
                                                              question.options
                                                                  .indexOf(
                                                                      option)] = '';
                                                          answeredCount =
                                                              countAnsweredQuestions(
                                                                  questionsInfo);
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('重新選擇日期'),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : null);
                                      } else {
                                        // Show DatePicker in Android
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          // DateTime.now() - not to allow to choose before today.
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                        );

                                        if (pickedDate != null) {
                                          // PickedDate output format => 2021-03-10 00:00:00.000
                                          if (kDebugMode) {
                                            print(pickedDate);
                                          }
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(pickedDate);
                                          // Calculate the age
                                          int age = calculateAge(pickedDate);
                                          // Update the selectedOptions and answeredCount
                                          setState(
                                            () {
                                              question.selectedOptions[question
                                                      .options
                                                      .indexOf(option)] =
                                                  '$formattedDate（$age歲）';
                                              answeredCount =
                                                  countAnsweredQuestions(
                                                      questionsInfo);
                                              if (!isTooYoung(age)) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text("提醒"),
                                                    content: Text(
                                                        "您的年齡為 $age 歲，小於語音障礙檢測的年齡（3歲），請重新選擇日期。"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            // Reset the age and selectedOptions
                                                            age = 0;
                                                            question.selectedOptions[
                                                                question.options
                                                                    .indexOf(
                                                                        option)] = '';
                                                            answeredCount =
                                                                countAnsweredQuestions(
                                                                    questionsInfo);
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            '重新選擇日期'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          );
                                          if (kDebugMode) {
                                            print(
                                                'answeredCount: $answeredCount');
                                            print('$formattedDate（$age歲）');
                                          }
                                        } else {
                                          if (kDebugMode) {
                                            print("Date is not selected");
                                          }
                                        }
                                      }
                                    },
                                  ),
                                );
                              }
                              return Container(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 12, right: 0, bottom: 12),
                                child: Column(
                                  children: [
                                    optionWidget,
                                  ],
                                ),
                              );
                            } else {
                              return ChoiceChip(
                                label: Text.rich(
                                  TextSpan(text: option),
                                  textScaleFactor: 1,
                                ),
                                labelStyle: TextStyle(
                                  color: question.selectedOptions
                                          .contains(option)
                                      ? Colors
                                          .white // Set the color when selected
                                      : const Color(
                                          0xFF5F3405), // Set the default color
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                ),
                                selectedColor: const Color(0xFF5F3405),
                                backgroundColor: const Color(0xFFDFD5CC),
                                selected:
                                    question.selectedOptions.contains(option),
                                onSelected: (selected) {
                                  setState(
                                    () {
                                      if (option == "其他") {
                                        _showTextFieldAlertDialog(
                                            context, question);
                                      } else {
                                        if (question.multiselect) {
                                          if (selected) {
                                            if (option == "無" ||
                                                option == "良好") {
                                              question.selectedOptions.clear();
                                              question.options.removeWhere(
                                                  (opt) => opt.contains("其他："));
                                            } else if (question.selectedOptions
                                                .contains("無")) {
                                              question.selectedOptions
                                                  .remove("無");
                                            } else if (question.selectedOptions
                                                .contains("良好")) {
                                              question.selectedOptions
                                                  .remove("良好");
                                            }
                                            question.selectedOptions
                                                .add(option);
                                          } else {
                                            question.selectedOptions
                                                .remove(option);
                                            if (option.contains("其他：")) {
                                              final customOption = option;
                                              question.options
                                                  .remove(customOption);
                                            }
                                          }
                                        } else {
                                          question.selectedOptions.clear();
                                          question.selectedOptions.add(option);
                                        }
                                      }
                                      answeredCount =
                                          countAnsweredQuestions(questionsInfo);
                                      if (kDebugMode) {
                                        print(answeredCount);
                                      }
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ).toList(),
                      ),
                    );
                  },
                  childCount: questionsInfo.length,
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
                          const ReturnBtn(title: AppText.returnButton),
                          const SizedBox(width: 16),
                          SubmitBtn(
                            title: AppText.submitButton,
                            onPressedCallback: () {
                              GlobalContextService.navigatorKey.currentState
                                  ?.push(
                                CustomPageRoute(const RecordPage()),
                              );
                              // Append the selected options to the questionnaireResult
                              for (int i = 0; i < questionsInfo.length; i++) {
                                questionnaireResult["basic_info"]
                                    ["${i + 1}"] = {
                                  "question": questionsInfo[i].question,
                                  "answers": questionsInfo[i].selectedOptions
                                };
                              }
                              // Convert questionnaireResult to JSON string
                              String questionnaireEncoded =
                                  json.encode(questionnaireResult);
                              // Save the questionnaireResult to the local storage
                              writeFile(
                                  questionnaireEncoded, "questionnaire.json");

                              if (kDebugMode) {
                                print(questionnaireEncoded);
                              }
                            },
                            disable:
                                answeredCount == questionNum ? false : true,
                          )
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

// Function to check if the age is too young
bool isTooYoung(int age) {
  if (age < 3) {
    return false;
  } else {
    return true;
  }
}
