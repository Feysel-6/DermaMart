import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:camera/camera.dart';
import 'app.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Preserve splash until setup finishes
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    // cameras = await availableCameras();

    await Supabase.initialize(
      url: "https://bbcbcjriucpcsixsffza.supabase.co",
      anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJiY2JjanJpdWNwY3NpeHNmZnphIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1MzY0MTcsImV4cCI6MjA3ODExMjQxN30.diln-AT-eQw895a3g5jUlNg7itUJ4obV0OSzxaUs-Jc',
    );

    // Now run the app
    runApp(const App());
  } catch (e) {
    debugPrint("Error during initialization: $e");
  } finally {
    // Remove splash only after everything is done
    FlutterNativeSplash.remove();
  }
}
