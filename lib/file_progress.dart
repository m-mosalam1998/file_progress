library file_progress;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

enum ProgressType {
  saveDataToFile,
  loadDataFromFile,
}

class FileProgressWidget extends StatelessWidget {
  const FileProgressWidget({
    Key? key,
    required this.progressType,
    this.iconOnButton,
    required this.filePath,
    this.textButton,
    this.style,
    this.showProgress = true,
    this.onChangeProgress,
    this.onDoneData,
    this.dataWrite,
  }) : super(key: key);
  final Icon? iconOnButton;
  final Text? textButton;
  final ProgressType progressType;
  final String filePath;
  final ButtonStyle? style;
  final bool showProgress;
  final ValueSetter<double>? onChangeProgress;
  final ValueSetter<String>? onDoneData;
  final String? dataWrite;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: progressType == ProgressType.loadDataFromFile
          ? () => FileProgress().loadDataProgress(
                filePath: filePath,
                onChangeProgress: onChangeProgress,
                showProgress: showProgress,
                context: context,
                onDoneData: onDoneData,
              )
          : () => FileProgress().writeToFile(
              filePath: filePath,
              showProgress: showProgress,
              context: context,
              dataWrite: dataWrite ?? 'No data to write'),
      style: style,
      icon: iconOnButton ??
          (progressType == ProgressType.loadDataFromFile
              ? const Icon(Icons.upload)
              : const Icon(Icons.download)),
      label: textButton ??
          (progressType == ProgressType.loadDataFromFile
              ? const Text('Load File Data')
              : const Text('Write To File')),
    );
  }
}

class DialogLoading extends StatelessWidget {
  const DialogLoading({Key? key, required this.progressValue})
      : super(key: key);
  final double progressValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: progressValue / 100,
            color: const Color.fromARGB(255, 190, 78, 70),
          ),
          Text('Loading ... $progressValue'),
        ],
      ),
    );
  }
}

class FileProgress {
  Future<void> writeToFile({
    required String filePath,
    ValueSetter<double>? onChangeProgress,
    required bool showProgress,
    required BuildContext context,
    required String dataWrite,
  }) async {
    ValueNotifier<double> changeProgressValue = ValueNotifier<double>(0.0);

    if (showProgress) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: ValueListenableBuilder(
              valueListenable: changeProgressValue,
              builder: (context, value, _) {
                double newPercentage = value;
                return DialogLoading(progressValue: newPercentage);
              }),
        ),
      );
    }
    IOSink outputStram = File(filePath).openWrite(mode: FileMode.append);
    final divisionIndex = (dataWrite.length / 200).ceil();
    bool inWrite = true;
    int count = divisionIndex;
    while (inWrite) {
      final String tempString;
      print(count);
      if (count < dataWrite.length - 1) {
        tempString = dataWrite.substring(count - divisionIndex, count);
      } else {
        tempString =
            dataWrite.substring(count - divisionIndex, dataWrite.length);
        inWrite = false;
      }
      print(tempString);
      count += divisionIndex;
      outputStram.add(utf8.encode(tempString));
      changeProgressValue.value = count / dataWrite.length;
      if (onChangeProgress != null) {
        onChangeProgress(count / dataWrite.length);
      }
    }
    if (showProgress) {
      Navigator.pop(context);
    }
    await outputStram.close();
  }

  Future<void> loadDataProgress({
    required String filePath,
    ValueSetter<double>? onChangeProgress,
    required bool showProgress,
    required BuildContext context,
    ValueSetter<String>? onDoneData,
  }) async {
    ValueNotifier<double> changeProgressValue = ValueNotifier<double>(0.0);
    if (showProgress) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: ValueListenableBuilder(
              valueListenable: changeProgressValue,
              builder: (context, value, _) {
                double newPercentage = value;
                return DialogLoading(progressValue: newPercentage);
              }),
        ),
      );
    }
    String dataRead = '';
    int length = await File(filePath).openRead().transform(utf8.decoder).length;
    int counter = 0;
    File(filePath).openRead().transform(utf8.decoder).listen((dataRecive) {
      counter += 1;
      dataRead = dataRead + dataRecive;
      changeProgressValue.value = (counter / length) * 100;
      if (onChangeProgress != null) {
        onChangeProgress(counter / length);
      }
    }, onDone: () {
      if (onDoneData != null) {
        onDoneData(dataRead);
      }
      if (showProgress) {
        Navigator.pop(context);
      }
    }, onError: (e) {
      if (showProgress) {
        Navigator.pop(context);
      }
    });
  }
}
