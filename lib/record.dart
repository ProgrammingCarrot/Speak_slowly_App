import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speak_slowly/result.dart';
import 'package:speak_slowly/utils.dart';
import 'package:speak_slowly/components.dart';
import 'package:percent_indicator/percent_indicator.dart';
// Both packages has the same name, so ignore one of them
import 'package:flutter_sound/flutter_sound.dart' hide PlayerState;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'text_constants.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);
  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  // Threshold value in decibels
  final double thresholdDecibels = 55.0;
  // Questions list for records
  late List<QuestionRecord> questionsRecordTrimmed = [];
  // Recorders list, each question has an independent recorder
  late List<FlutterSoundRecorder> recorders = [];
  // Number of questions
  late int questionNum;
  // Number of answered questions
  late int answeredCount;
  // Check if the recorder is ready
  bool isRecorderReady = false;
  // Audio player for playing the recorded audio
  AudioPlayer audioPlayer = AudioPlayer();
  // To store the index of the currently recording question
  // Only one question can be recorded at a time
  int currentlyRecordingIndex = -1;
  // Status of the page
  String pageStatus = "recording";
  // Toast
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    // Initialize the recorders
    // Check the age of the child, and load the corresponding number of questions
    // While testing the page without loading last page, the list will be null,
    // So use the default value.
    final String birthDate =
        questionnaireResult["basic_info"]?["1"]?["answers"].last ??
            "2020-08-29（3歲）";
    // Extract the age from the birth date
    int age = int.parse(extractAge(birthDate));
    // Load the corresponding number of questions
    if (age <= 3) {
      questionsRecordTrimmed = questionsRecord.sublist(0, 8);
    } else if (age == 4) {
      questionsRecordTrimmed = questionsRecord.sublist(0, 19);
    } else {
      questionsRecordTrimmed = questionsRecord;
    }
    // Get the number of questions
    questionNum = questionsRecordTrimmed.length;
    // Get the number of answered questions
    answeredCount = countAnsweredQuestions(questionsRecordTrimmed);

    // Initialize the recorders for each question
    for (int i = 0; i < questionNum; i++) {
      final recorder = FlutterSoundRecorder();
      recorders.add(recorder);
    }

    // Initialize the recorder
    initRecorder();

    // Initialize the toast
    fToast = FToast();
    fToast.init(context);
  }

  // Close the recorder and audio player
  @override
  void dispose() {
    // Close all the recorders
    for (final recorder in recorders) {
      recorder.closeRecorder();
    }
    audioPlayer.dispose();
    super.dispose();
  }

  // Initialize the recorder
  Future initRecorder() async {
    // Request microphone permission
    final permissionMicrophone = await Permission.microphone.request();
    // Check if the permission is granted
    if (permissionMicrophone != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    // Request storage permission for Android
    if (Platform.isAndroid) {
      // Request storage permission
      final String versionString = await _getOsVersion();
      final int version = int.parse(versionString.split('.')[0]);
      // Check if the Android version is less than 11
      // Convert string to int
      if (version < 13) {
        // Request storage permission
        final permissionStorage = await Permission.storage.request();
        // Check if the permission is granted
        if (permissionStorage != PermissionStatus.granted) {
          throw "Storage permission not granted";
        }
      } else {
        // Request storage permission
        final permissionAudio = await Permission.audio.request();
        // Check if the permission is granted
        if (permissionAudio != PermissionStatus.granted) {
          throw "Storage permission not granted";
        }
      }
    }
    // Open all the recorders
    for (final recorder in recorders) {
      // Open all the recorders
      await recorder.openRecorder();
      // setSubscriptionDuration is required for the onProgress stream to work
      recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    }

    // Configure the audio session
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    // Set isRecorderReady to true
    isRecorderReady = true;
  }

  // Start recording and stop after 3 seconds
  Future startRecord(int index) async {
    // Check if the recorder is ready
    if (!isRecorderReady) return;
    if (currentlyRecordingIndex == -1) {
      // No question is currently recording, start recording for the selected question
      currentlyRecordingIndex = index;
      // Get the recorder by index
      final recorder = recorders[index];
      // Get save path
      final path = await getSavePath(questionsRecordTrimmed[index].transcript);
      // Update the UI to restart the progress bar animation
      setState(() {
        // Update the path and recorded recorded of the question
        questionsRecordTrimmed[index].path = "";
        questionsRecordTrimmed[index].recorded = false;
      });
      // Delay 500 milliseconds to let users prepare
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        // Start recording
        await recorder.startRecorder(
            toFile: path, codec: Codec.pcm16WAV, sampleRate: 44100);
        // Stop the recorder after 3 seconds
        Future.delayed(const Duration(seconds: 3), () async {
          stopRecord(index).then((isSoundLoudEnough) {
            answeredCount = countAnsweredQuestions(questionsRecordTrimmed);
            // Update the UI
            setState(() {
              if (isSoundLoudEnough) {
                _showToast("assets/image/card/打鼓.png", "很棒，聲音音量可以！");
              } else {
                _showToast("assets/image/card/大哭.png", "聲音太小或太短了嗚嗚");
              }
            });
            // Reset currentlyRecordingIndex
            currentlyRecordingIndex = -1;
          });
        });
      });
    }
  }

  // Stop recording and get the path of the recorded audio file
  Future stopRecord(int index) async {
    // Check if the recorder is ready
    if (!isRecorderReady) return;
    // Get the recorder by index
    final recorder = recorders[index];
    // Stop recording and get the path of the recorded audio file
    var path = await recorder.stopRecorder();
    // The path is empty on Android, so get the path from the recorder
    // Still trying to figure out why
    if (path == "") {
      path = await getSavePath(questionsRecordTrimmed[index].transcript);
    }
    if (kDebugMode) {
      print("Recorded file path: $path");
    }
    final audioFile = File(path!);

    // Calculate sound level (decibels)
    final audioBytes = await audioFile.readAsBytes();
    final samples = Int16List.sublistView(Uint8List.fromList(audioBytes));

    // Calculate the sound level
    final soundLevel = samples.fold(0, (previousValue, element) {
          return previousValue + element.abs();
        }) /
        samples.length;

    // Calculate the sound level (decibels)
    final soundLevelDecibels = 20 * log(soundLevel) / log(10);

    if (soundLevelDecibels > thresholdDecibels) {
      // Update the path and recorded recorded of the question
      questionsRecordTrimmed[index].path = path;
      questionsRecordTrimmed[index].recorded = true;
      // Debug
      if (kDebugMode) {
        print(
            'Sound level (decibels): $soundLevelDecibels, greater than the threshold: $thresholdDecibels');
        print(questionsRecordTrimmed[index].toString());
      }
      // Return true if the sound level is greater than the threshold
      return true;
    } else {
      // Update the path and recorded recorded of the question
      questionsRecordTrimmed[index].path = "";
      questionsRecordTrimmed[index].recorded = false;
      // Debug
      if (kDebugMode) {
        print(
            'Sound level (decibels): $soundLevelDecibels, less than the threshold: $thresholdDecibels');
        print(questionsRecordTrimmed[index].toString());
      }
      // Return false if the sound level is less than the threshold
      return false;
    }
  }

  // Play the recorded audio
  Future play(int index) async {
    // Get the path of the audio file and play it
    audioPlayer.setFilePath(questionsRecordTrimmed[index].path);
    audioPlayer.setVolume(1.0);
    // Play the audio
    audioPlayer.play();
    // Update the status and call setState to update the UI
    setState(() {
      // This will set the progress bar to 0%
      questionsRecordTrimmed[index].status = "playing";
    });
    // Update the status after 100 milliseconds
    // It will trigger the progress bar animation to 100%
    Future.delayed(const Duration(milliseconds: 100), () {
      // Update the UI
      setState(() {
        questionsRecordTrimmed[index].status = "idle";
      });
    });
    if (kDebugMode) {
      print(questionsRecordTrimmed[index].toString());
    }
  }

  // Create a ValueNotifier to update the answeredCount in top progress bar
  ValueNotifier<int> answeredCountNotifier = ValueNotifier<int>(0);

  // Count the number of answered questions
  int countAnsweredQuestions(List<QuestionRecord> questions) {
    int answeredCount = 0;
    for (final question in questions) {
      // If the question is recorded and the path is not empty, count it as answered
      if (question.recorded == true && question.path != '') {
        answeredCount++;
      }
    }
    // Update the notifier
    answeredCountNotifier.value = answeredCount;
    // Return the number of answered questions
    return answeredCount;
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
                      // Show progress bar when page status is recording
                      (pageStatus == "recording")
                          ? Transform.translate(
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
                                        text: AppText.recordProgressbarText,
                                        style: TextStyle(
                                          color: Color(0xFF653103),
                                          fontSize: 16,
                                          fontFamily: 'Noto Sans TC',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                      textScaler: TextScaler.linear(1),
                                    ),
                                    ValueListenableBuilder<int>(
                                      valueListenable: answeredCountNotifier,
                                      builder: (context, answeredCount, _) {
                                        return LinearPercentIndicator(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          lineHeight: 20.0,
                                          animationDuration: 500,
                                          percent: answeredCount / questionNum,
                                          center: Text.rich(
                                            TextSpan(
                                              text:
                                                  "$answeredCount / $questionNum",
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
                                          progressColor:
                                              const Color(0xFF653103),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              // Form block
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (pageStatus == "uploading") {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                AppText.recordUploadingWait,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF653103),
                                ),
                              ),
                              // const SizedBox(height: 20),
                              Image.asset(
                                "assets/image/loading.gif",
                                height: 70.0,
                                // width: 90.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (pageStatus == "failed") {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                AppText.recordUploadingFailed,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF653103),
                                ),
                              ),
                              Image.asset(
                                "assets/image/loading.gif",
                                height: 70.0,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.white,
                                  fixedSize: const Size(180, 60),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: Color(0xFF653103),
                                    ),
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onPressed: () async {
                                  await onUploading();
                                },
                                child: const Text(
                                  AppText.recordUploadingAgain,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF653103),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return ListTile(
                        title: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFF653103),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  // If index is less than 9, add a leading zero
                                  index < 9 ? '0${index + 1}' : '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    // fontFamily: 'Noto Sans TC',
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Wrap(
                          children: [
                            // A container that put image in the center, and the word under the image
                            Container(
                              // Padding for next word
                              padding: const EdgeInsets.only(bottom: 36),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Image
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height:
                                        MediaQuery.of(context).size.width - 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            questionsRecordTrimmed[index].img),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  // Word
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      questionsRecordTrimmed[index].word,
                                      style: const TextStyle(
                                        color: Color(0xFF653103),
                                        fontSize: 64,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // If recording pressed, show progress bar for 3 seconds
                                  Container(
                                    height: 45,
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                    4 -
                                                15,
                                        bottom: 24),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // LinearPercentIndicator
                                        Center(
                                          child: LinearPercentIndicator(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            animation: true,
                                            animateFromLastPercent: false,
                                            lineHeight: 10.0,
                                            animationDuration: 3000,
                                            percent: recorders[index]
                                                    .isRecording
                                                ? 1.0
                                                : questionsRecordTrimmed[index]
                                                        .recorded
                                                    ? questionsRecordTrimmed[
                                                                    index]
                                                                .status ==
                                                            "idle"
                                                        ? 1.0
                                                        : 0.0
                                                    : 0,
                                            barRadius:
                                                const Radius.circular(16),
                                            progressColor:
                                                const Color(0xFF653103),
                                          ),
                                        ),
                                        // Check icon
                                        if (questionsRecordTrimmed[index]
                                            .recorded)
                                          Positioned(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: const Icon(
                                              Icons.check_circle,
                                              color: Color(0xFFF7CE03),
                                              size: 20,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Two Elevated buttons for recording and playing
                                  // If recorded, enable the play button, otherwise disable it
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Recording button
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color(0xFF653103),
                                          fixedSize: const Size(90, 60),
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
                                        onPressed: currentlyRecordingIndex != -1
                                            ? null
                                            : () async {
                                                if (currentlyRecordingIndex ==
                                                    -1) {
                                                  // No question is currently recording, start recording
                                                  await startRecord(index);
                                                  setState(() {});
                                                }
                                              },
                                        child: const Icon(
                                          Icons.mic,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Playing button
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          disabledBackgroundColor: Colors.white,
                                          fixedSize: const Size(90, 60),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width:
                                                  questionsRecordTrimmed[index]
                                                          .recorded
                                                      ? 1.0
                                                      : 0.5,
                                              color: const Color(0xFF653103),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          elevation: 5,
                                          shadowColor: Colors.black,
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        onPressed:
                                            !questionsRecordTrimmed[index]
                                                    .recorded
                                                ? null
                                                : () async {
                                                    // Play the recorded audio
                                                    await play(index);
                                                  },
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: questionsRecordTrimmed[index]
                                                  .recorded
                                              ? const Color(0xFF653103)
                                              : const Color(0xFF9E846C),
                                          size: 48,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  childCount: (pageStatus == "recording")
                      ? questionsRecordTrimmed.length
                      : 1,
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: (pageStatus == "recording")
                    ? Container(
                        padding: const EdgeInsets.only(top: 24, bottom: 54),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const ReturnBtn(title: AppText.returnButton),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF653103),
                                    disabledBackgroundColor:
                                        const Color(0xFF9E846C),
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
                                  onPressed: (answeredCount != questionNum)
                                      ? null
                                      : () async {
                                          await onUploading();
                                        },
                                  child: const Text(
                                    AppText.completeButton,
                                    style: TextStyle(
                                      fontFamily: 'Noto_Sans_TC',
                                      fontWeight: FontWeight.w400,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            width:
                                (MediaQuery.of(context).size.width) / 1.5 + 50,
                            height:
                                (MediaQuery.of(context).size.width) / 1.5 + 50,
                            child: SizedBox(
                                child: Image.asset('assets/image/主角/阿松普通.png')),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(String iconPath, String toastText) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: const Color(0xFFF7CE03),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            child: SizedBox(
              child: Image.asset(iconPath),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(toastText),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  Future onUploading() async {
    if (kDebugMode) {
      print("===========================");
      print("         Uploading         ");
      print("===========================");
    }

    // Update the UI
    setState(() {
      pageStatus = "uploading";
    });

    // Update the questionsRecord
    questionsRecord = questionsRecordTrimmed;

    sendInferenceRequest().then(
      (res) {
        // If response is not null, parse res[0] to get statusCode
        if (res[0] != null) {
          // If statusCode is 200, navigate to the ResultPage
          if (res[0] == 200) {
            // Decode res[1] to get responseJson
            final Map<String, dynamic> responseJson = jsonDecode(res[1]);

            // For testing
            // final Map<String, dynamic>
            //     responseJson = {
            //   "塞音化": 0.08,
            //   "舌根音化": 0.12,
            //   "擦音化": 0,
            //   "塞擦音化": 0,
            //   "聲隨韻母": 0,
            //   "其他": 0,
            //   "子音正確率": 0.21
            // };

            if (responseJson.isNotEmpty) {
              // Navigate to the ResultPage and pass the response JSON as an argument
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResultPage(),
                  // Pass the response JSON here
                  settings: RouteSettings(arguments: responseJson),
                ),
              );
            } else {
              // Update the UI
              setState(
                () {
                  pageStatus = "failed";
                },
              );
            }
          } else {
            // Update the UI
            setState(() {
              pageStatus = "failed";
            });
          }
        } else {
          // Update the UI
          setState(() {
            pageStatus = "failed";
          });
        }
      },
    );
  }
}

Future<String> _getOsVersion() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    final info = await deviceInfo.androidInfo;
    return info.version.release;
  }
  if (Platform.isIOS) {
    final info = await deviceInfo.iosInfo;
    return info.systemVersion;
  }
  if (Platform.isMacOS) {
    final info = await deviceInfo.macOsInfo;
    return info.osRelease;
  }
  if (Platform.isLinux) {
    final info = await deviceInfo.linuxInfo;
    return info.version ?? 'Unknown';
  }
  return 'Unknown Version';
}
