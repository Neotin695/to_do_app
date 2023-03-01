import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_do_app/core/db/db_helper.dart';
import 'package:to_do_app/core/services/theme_services.dart';
import 'package:to_do_app/view/pages/home_page.dart';
import 'package:to_do_app/view/style/main_theme.dart';

import 'package:responsive_framework/responsive_framework.dart';

import 'core/helper/binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.init();
  await GetStorage.init();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Binding(),
      builder: (context, child) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, child!),
        maxWidth: 1200,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
        background: Container(
          color: const Color(0xFFF5F5F5),
        ),
      ),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      themeMode: ThemeServices().theme,
      darkTheme: Themes.darkTheme,
      home: HomeScreen(),
    );
  }
}
