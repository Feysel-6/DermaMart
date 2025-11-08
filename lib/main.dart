import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:camera/camera.dart';
import 'app.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  cameras = await availableCameras();

  await Supabase.initialize(
      url: "https://odewakauccgjwtzwdwkx.supabase.co",
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9kZXdha2F1Y2Nnand0endkd2t4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkxODA4OTEsImV4cCI6MjA3NDc1Njg5MX0.lAp1QWRpHWFcSr6narPi-21rH3jpzlbqxjAG-UUtldU'
  );
  
  runApp(const App());
  
  FlutterNativeSplash.remove();
}