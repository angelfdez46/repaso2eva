import 'package:flutter/material.dart';
import 'package:repaso2eva/app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'repaso2eva',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
