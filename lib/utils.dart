import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive_io.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import 'package:speak_slowly/text_constants.dart';

// Load and parse the JSON data
const jsonQuestingInfo = AppText.jsonQuestionInfoString;
const jsonQuestionRecord = AppText.jsonQuestionRecordString;
// Questionnaire result
Map<String, dynamic> questionnaireResult = {
  "consent": {},
  // "basic_info" has keys in the form of "1", "2", "3" as long as the jsonQuestionRecord
  // And the value is a list of selected options
  "basic_info": {},
};

// Questions list for basic information
List<QuestionInfo> questionsInfo = List<QuestionInfo>.from(jsonQuestingInfo.keys
    .map((key) => QuestionInfo.fromJson(key, jsonQuestingInfo[key])));
// Questions list for records
List<QuestionRecord> questionsRecord = jsonQuestionRecord.entries
    .map((entry) => QuestionRecord.fromJson(entry.key, jsonQuestionRecord))
    .toList();

// Question class for basic information
class QuestionInfo {
  final String question;
  final List<String> options;
  final bool multiselect;
  final List<String> selectedOptions;

  QuestionInfo(this.question, this.options, this.multiselect)
      : selectedOptions = <String>[];

  factory QuestionInfo.fromJson(String id, Map<String, dynamic> data) {
    final question = data['question'] as String;
    final options = List<String>.from(data['options'] as List<dynamic>);
    final multiselect = data['multiselect'] as bool;
    return QuestionInfo(question, options, multiselect);
  }

  // Convert Question object to JSON
  @override
  String toString() {
    return 'Question{question: $question, options: $options, selectedOptions: $selectedOptions, multiselect: $multiselect}';
  }
}

// Question class for records
class QuestionRecord {
  final String word;
  final String transcript;
  final String img;
  bool recorded;
  String path;
  String status;

  // Constructor, word and img are required, and recorded, path and status are optional
  QuestionRecord(this.word, this.transcript, this.img)
      : recorded = false,
        path = "",
        // There are idle and playing two status
        status = "idle";

  // Factory constructor to create a Question from JSON data
  factory QuestionRecord.fromJson(String id, Map<String, dynamic> data) {
    final word = data[id]['word'] as String;
    final transcript = data[id]['transcript'] as String;
    final img = data[id]['img'] as String;
    return QuestionRecord(word, transcript, img);
  }

  // Override toString() to print the Question object in a readable format
  @override
  String toString() {
    return 'Question{word: $word, transcript: $transcript, img: $img, recorded: $recorded, path: $path, status: $status}';
  }
}

// A class to create a link buttons in resource page
class LinkButton {
  final String text;
  final String url;

  LinkButton({required this.text, required this.url});

  // Override toString() to print the Question object in a readable format
  @override
  String toString() {
    return 'LinkButton{text: $text, url: $url}';
  }
}

// To access the context any where you want by using the following line of code
// REF: https://stackoverflow.com/a/73349126/6223931
class GlobalContextService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

// Page route with fade transition
// REF: https://stackoverflow.com/a/55340515/6223931
class CustomPageRoute<T> extends PageRoute<T> {
  CustomPageRoute(this.child);
  @override
  Color get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);
}

// Custom sliver header
// REF: https://book.flutterchina.club/chapter6/custom_scrollview.html#_6-10-1-customscrollview
typedef SliverHeaderBuilder = Widget Function(
    BuildContext context, double shrinkOffset, bool overlapsContent);

// To persist the header while scrolling to the top
// Encapsulate SliverPersistentHeaderDelegate it to make easier to use
class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverHeaderDelegate({
    required this.maxHeight,
    this.minHeight = 0,
    // The child widget is the content of the header
    required Widget child,
  })  : builder = ((a, b, c) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  // To make the header fixed height
  SliverHeaderDelegate.fixedHeight({
    required double height,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        maxHeight = height,
        minHeight = height;

  // To customize the header
  SliverHeaderDelegate.builder({
    required this.maxHeight,
    this.minHeight = 0,
    required this.builder,
  });

  final double maxHeight;
  final double minHeight;
  final SliverHeaderBuilder builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    // * Testing code: If in debug mode and the child widget has a key, print log
    assert(() {
      if (child.key != null) {
        if (kDebugMode) {
          print(
              '${child.key}: shrink: $shrinkOffset，overlaps:$overlapsContent');
        }
      }
      return true;
    }());
    // Make the header fill the limited space as much as possible;
    // The width is the Viewport width, and the height changes between [minHeight, maxHeight] as the user slides.
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent;
  }
}

// Funtion to calculate the age
int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

// Function to extract age from the text
String extractAge(String text) {
  RegExp ageRegex = RegExp(r'（(\d+)歲）');
  Match? match = ageRegex.firstMatch(text);
  if (match != null) {
    return match.group(1)!;
  } else {
    return "N/A"; // Return a default value if age is not found
  }
}

// Function to exit the app
void closeApp() {
  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else if (Platform.isIOS) {
    exit(0);
  }
}

// Get the save path for the recorded audio file
Future<String> getSavePath(String transcriptString) async {
  // Get the application documents directory
  final directory = await getApplicationDocumentsDirectory();
  // Specify the subdirectory
  const subdirectory = 'recordings';
  final subDirPath = '${directory.path}/$subdirectory';
  final subDir = Directory(subDirPath);
  // Create the subdirectory if it doesn't exist
  if (!subDir.existsSync()) {
    subDir.createSync();
  }
  // Specify the file name based on the index and platform
  final fileName = '$transcriptString.wav';
  // Debug
  if (kDebugMode) {
    print('${subDir.path}/$fileName');
  }
  // Return the path
  return '${subDir.path}/$fileName';
}

// Function to clear the recorded audio files
Future<void> clearRecordings() async {
  // Get the application documents directory
  final directory = await getApplicationDocumentsDirectory();
  // Specify the subdirectory
  const subdirectory = 'recordings';
  final subDirPath = '${directory.path}/$subdirectory';
  final subDir = Directory(subDirPath);
  // Delete the subdirectory if it exists
  if (subDir.existsSync()) {
    subDir.deleteSync(recursive: true);
  }
}

// Function to write file
writeFile(String text, String filename) async {
  // Usage:
  // writeFile("Hello World", "questionnaire.json");

  // Get the directory for the app
  final Directory directory = await getApplicationDocumentsDirectory();
  // Create the file
  final File file = File('${directory.path}/$filename');
  // Write the file
  await file.writeAsString(text);

  if (kDebugMode) {
    print("File written in ${directory.path}/$filename");
  }
}

// Function to read file
Future<String> readFile(String filename) async {
  // Usage:
  // readFile("questionnaire.json").then((value) {
  //   print(value);
  // });

  String text = "";
  try {
    // Get the directory for the app
    final Directory directory = await getApplicationDocumentsDirectory();
    // Create the file
    final File file = File('${directory.path}/$filename');
    // Read the file
    text = await file.readAsString();
  } catch (e) {
    if (kDebugMode) {
      print("Couldn't read file");
    }
  }
  return text;
}

// Function to compress the files
Future<String> compressFiles() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final encoder = ZipFileEncoder();
  final filename = generateFormattedFileName();
  encoder.create('${directory.path}/$filename');
  // Add files to the zip
  encoder.addFile(File('${directory.path}/questionnaire.json'));
  if (kDebugMode) {
    print("Added file: ${directory.path}/questionnaire.json");
  }
  for (int i = 0; i < questionsRecord.length; i++) {
    encoder.addFile(File(questionsRecord[i].path));
    if (kDebugMode) {
      print("Added file: ${questionsRecord[i].path}");
    }
  }
  encoder.close();

  if (kDebugMode) {
    print("File compressed in ${directory.path}/$filename");
  }

  return filename;
}

// Function to generate the formatted file name using the current time
String generateFormattedFileName() {
  final now = DateTime.now();
  final hashNum = generateHash();
  final formattedTimestamp =
      DateFormat("yyyy.MM.dd.HH.mm.ss_$hashNum").format(now);
  final filename = '$formattedTimestamp.zip';
  return filename;
}

// Generate hash numbers using the current time
String generateHash() {
  final now = DateTime.now();
  final formattedTimestamp = DateFormat("yyyyMMddHHmmss").format(now);
  final hash = formattedTimestamp.hashCode.toRadixString(10);
  return hash;
}

// Function to upload the file to Firebase Storage
Future<String> uploadFile(String filename) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final storePath = "data_0820word/$filename";
  final Reference ref = FirebaseStorage.instance.ref().child(storePath);
  final File file = File('${directory.path}/$filename');
  final UploadTask uploadTask = ref.putFile(file);
  // When the task is completed, print the download URL
  final downloadUrl = await (await uploadTask).ref.getDownloadURL();
  // Debug
  if (kDebugMode) {
    print("File uploaded to $downloadUrl");
  }
  return downloadUrl;
}

// Function to check server url and send inference request
Future sendInferenceRequest() async {
  // Check internet connection
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    if (kDebugMode) {
      print("Internet is connected");
    }
    // Get URL snapshot from Firebase
    final urlSnapshot =
        await FirebaseDatabase.instance.ref().child("URL").get();

    if (urlSnapshot.exists) {
      // Get the url from the snapshot
      final url = urlSnapshot.value;
      // Compress the files to be uploaded
      final String filename = await compressFiles();
      // Upload the file to Firebase Storage
      final downloadUrl = await uploadFile(filename);
      // Check if the url is not empty and starts with https
      if (downloadUrl.contains("https")) {
        // Get the request URL by concatenating the url and filename
        final String requestURL = "$url/inference/$filename";
        // Send the request
        final response = await http.post(Uri.parse(requestURL)).timeout(
            const Duration(seconds: 30),
            onTimeout: () => http.Response("timeout", 408));
        // Return the response
        if (response.statusCode == 200) {
          if (kDebugMode) {
            print(response.body);
          }
          return [response.statusCode, response.body];
        } else {
          if (kDebugMode) {
            print("Request failed with status: ${response.statusCode}.");
          }
          return [response.statusCode, ""];
        }
      } else {
        // Return null if the url is not valid
        return null;
      }
    } else {
      if (kDebugMode) {
        print("Server URL not found");
      }
      // Return null if the url is not found
      return null;
    }
  } else {
    if (kDebugMode) {
      print('Internet is not connected');
    }
    // Return null if the internet is not connected
    return null;
  }
}
