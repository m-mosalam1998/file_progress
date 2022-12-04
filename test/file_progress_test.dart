import 'package:flutter_test/flutter_test.dart';

import 'package:file_progress/file_progress.dart';

void main() {
  test('adds one to input values', () {
    const calculator = FileProgressWidget(
      filePath: '',
      iconOnButton: null,
      progressType: ProgressType.loadDataFromFile,
    );
  });
}
