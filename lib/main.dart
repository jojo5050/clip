import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  initialize();
  runApp(const MyApp());
}

void initialize() async {
  var path = Directory.current.path;
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

}

