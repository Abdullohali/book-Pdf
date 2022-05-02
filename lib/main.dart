import 'package:flutter/material.dart';
import 'package:testbook/screens/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
         designSize: const Size(360, 800),
          minTextAdapt: true,
          splitScreenMode: true,

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(
          pdfAssetPath: 'assets/yoll.pdf',
        ),
      ),
    );
  }
}
