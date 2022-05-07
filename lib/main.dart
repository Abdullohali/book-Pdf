import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testbook/cubit/cubit/color_cubit.dart';
import 'package:testbook/screens/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testbook/screens/new_home.dart';
import 'package:testbook/screens/title_screen.dart';

Future<void> main() async {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ColorCubit()),
      ],
      child: const MyApp(),
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      child: BlocBuilder<ColorCubit, ColorState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: context.watch<ColorCubit>().initialColor,
            ),
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            home: const TitleSceen(),
          );
        },
      ),
    );
  }
}
