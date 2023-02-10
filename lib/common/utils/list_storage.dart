import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:clock_app/common/data/paths.dart';
import 'package:clock_app/common/utils/json_serialize.dart';

List<T> loadList<T extends JsonSerializable>(String key) {
  String appDataDirectory = getAppDataDirectoryPathSync();
  File file = File(path.join(appDataDirectory, '$key.txt'));
  try {
    final String encodedList = file.readAsStringSync();
    return decodeList<T>(encodedList);
  } catch (e) {
    throw Exception('Failed to load list from file: $e');
  }
}

Future<void> saveList<T extends JsonSerializable>(
    String key, List<T> list) async {
  String appDataDirectory = getAppDataDirectoryPathSync();
  File file = File(path.join(appDataDirectory, '$key.txt'));
  if (!file.existsSync()) {
    file.createSync();
  }
  String encodedList = encodeList(list);
  file.writeAsString(encodedList, mode: FileMode.writeOnly);
}
