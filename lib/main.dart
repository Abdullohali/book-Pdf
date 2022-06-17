import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testbook/cubit/cubit/color_cubit.dart';
import 'package:testbook/screens/title_screen.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('color');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ColorCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorCubit, ColorState>(
      builder: (context, state) {
        return MaterialApp(
          theme: ThemeData(
            primaryColor: Hive.box('color').get('color') != null
                ? Color(int.parse(Hive.box('color').get('color').toString()))
                : Color(0xFF228c22),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: const TitleSceen(
            assetPath: "assets/json/book.json",
          ),
        );
      },
    );
  }
}
