import 'package:dermamart/routes/app_routes.dart';
import 'package:dermamart/utlis/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'pages/introduction_animation/introduction_animation_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: EAppTheme.lightTheme,
      darkTheme: EAppTheme.darkTheme,
      home: const IntroductionAnimationScreen(),
      getPages: AppRoutes.pages,
    );
  }
}
