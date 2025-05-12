import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speak_slowly/basic_info.dart';
import 'package:speak_slowly/utils.dart';
import 'package:speak_slowly/components.dart';
import 'package:intl/intl.dart';

import 'package:speak_slowly/text_constants.dart';

class ConsentPage extends StatelessWidget {
  const ConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarTitle(),
        body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                collapsedHeight:
                    (MediaQuery.of(context).size.width < 390) ? 280 : 260,
                expandedHeight:
                    (MediaQuery.of(context).size.width < 390) ? 280 : 260,
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
                                        text: AppText.consentWelcomeMessage01,
                                        style: TextStyle(
                                          color: Color(0xFF653103),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: AppText.consentWelcomeMessage02,
                                        style: TextStyle(
                                          color: Color(0xFF653103),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                  textScaler: TextScaler.linear(1),
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
                  maxHeight: 40,
                  minHeight: 40,
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
                      ),
                    ],
                  ),
                ),
              ),
              // Form block
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                          left: 24, top: 16, right: 24, bottom: 0),
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
                                        text: AppText.consentFormMessage,
                                        style: TextStyle(
                                          color: Color(0xFF653103),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textScaler: TextScaler.linear(1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: const EdgeInsets.only(top: 0, bottom: 54),
                  child: const AgreementGroup(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgreementGroup extends StatefulWidget {
  const AgreementGroup({Key? key}) : super(key: key);

  @override
  State<AgreementGroup> createState() => _AgreementGroupState();
}

class _AgreementGroupState extends State<AgreementGroup> {
  bool isCheckboxChecked = false;
  TextEditingController nameinput = TextEditingController();
  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    isCheckboxChecked = false;
    // set the initial value of text fields
    nameinput.text = "";
    dateinput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Center(
              child: Column(
                children: <Widget>[
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.transparent,
                    title: const Text.rich(
                      TextSpan(
                        text: AppText.consentAgreeCheckbox,
                        style: TextStyle(
                          color: Color(0xFF653103),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.16,
                          height: 1.2,
                        ),
                      ),
                      textAlign: TextAlign.justify,
                      textScaler: TextScaler.linear(1),
                    ),
                    value: isCheckboxChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckboxChecked = value!;
                        if (kDebugMode) {
                          print("isCheckboxChecked: $isCheckboxChecked");
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text.rich(
                    TextSpan(
                      text: AppText.consentSignText,
                      style: TextStyle(
                          color: Color(0xFF653103),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1),
                    ),
                    textAlign: TextAlign.justify,
                    textScaler: TextScaler.linear(1),
                  ),
                  SizedBox(
                    width: 120.0,
                    height: 40.0,
                    child: TextFormField(
                      style: const TextStyle(
                        color: Color(0xFF5F3405),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      scrollPadding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 40),
                      controller: nameinput,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return AppText.consentSignWarn;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 160.0,
                    height: 40.0,
                    child: TextField(
                      style: const TextStyle(
                        color: Color(0xFF5F3405),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                      // Editing controller of this TextField
                      controller: dateinput,
                      decoration: InputDecoration(
                        labelText: AppText.consentDateText,
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
                      onTapOutside: (event) =>
                          {FocusScope.of(context).unfocus(), setState(() {})},
                      onTap: () async {
                        if (Platform.isIOS) {
                          // Show DatePicker in iOS
                          await showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 300,
                                color: Colors.white,
                                child: CupertinoDatePicker(
                                  initialDateTime: DateTime.now(),
                                  // Set minimum date to current date
                                  minimumDate: DateTime(2023),
                                  // Set maximum date to current date
                                  maximumDate: DateTime.now(),
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (DateTime newDate) {
                                    // Handle the selected date here
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(newDate);
                                    // Update the selectedOptions and answeredCount
                                    setState(() {
                                      dateinput.text = formattedDate;
                                    });
                                    // Formatted date output using intl package => 2021-03-16
                                    if (kDebugMode) {
                                      print(formattedDate);
                                    }
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          // Show DatePicker in Android
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            // Set minimum date to current date
                            firstDate: DateTime.now(),
                            // Set maximum date to current date
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            // Formatted date output using intl package => 2021-03-16
                            if (kDebugMode) {
                              print(formattedDate);
                            }
                            setState(() {
                              // Set output date to TextField value.
                              dateinput.text = formattedDate;
                            });
                          } else {
                            if (kDebugMode) {
                              print("Date is not selected");
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const ReturnBtn(title: AppText.returnButton),
                    const SizedBox(width: 16),
                    SubmitBtn(
                      title: AppText.submitButton,
                      onPressedCallback: () {
                        GlobalContextService.navigatorKey.currentState?.push(
                          CustomPageRoute(const BasicInfoPage()),
                        );

                        // Update the questionnaireResult
                        // Add name and birthDate to consent section
                        questionnaireResult["consent"]["name"] = nameinput.text;
                        questionnaireResult["consent"]["date"] = dateinput.text;
                        if (kDebugMode) {
                          print(questionnaireResult);
                        }
                      },
                      disable: isCheckboxChecked &&
                              nameinput.text.isNotEmpty &&
                              dateinput.text.isNotEmpty
                          ? false
                          : true,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
