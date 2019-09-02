import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:async';

class FileHandler {
  String _filename;

  set filename(String value) {
    _filename = value;
  }

  FileHandler(this._filename);

  Future<bool> writeData(String Data) async {
    try {
      File file = await _localFile();
      print(file.path);
      file.writeAsString(Data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<File> _localFile() async {
    final path = await _localPath;
    return File('$path/$_filename');
  }

  Future<String> readData() async {
    String data;
    try {
      File file = await _localFile();
      data = await file.readAsString();
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
