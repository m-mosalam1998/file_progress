import 'package:file_progress/file_progress.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Progress Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlutterProgress(),
    );
  }
}

class FlutterProgress extends StatefulWidget {
  const FlutterProgress({Key? key}) : super(key: key);

  @override
  State<FlutterProgress> createState() => _FlutterProgressState();
}

class _FlutterProgressState extends State<FlutterProgress> {
  String dateRead = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test File Progress'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FileProgressWidget(
                      progressType: ProgressType.loadDataFromFile,
                      // change this. path
                      filePath: 'C:\\Users\\Mohammed\\help.txt',
                      onChangeProgress: (value) {
                        print(value);
                      },
                      onDoneData: (value) {
                        print(value);
                        setState(() {
                          dateRead = value;
                        });
                      },
                      showProgress: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FileProgressWidget(
                      progressType: ProgressType.saveDataToFile,
                      // change this. path

                      filePath: 'C:\\Users\\Mohammed\\newText.txt',
                      onChangeProgress: (value) {
                        print(value);
                      },
                      dataWrite:
                          // this is text you want to write
                          'Hello Devloper\nthis pacage use to read and write text files with progress.\nYou can show dialog with progress and you can hide dialog .\nThank youe for use my pakage',
                      showProgress: true,
                    ),
                  ),
                ],
              ),
              Text(dateRead),
            ],
          ),
        ),
      ),
    );
  }
}
