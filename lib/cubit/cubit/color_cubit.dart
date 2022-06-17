import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'color_state.dart';

class ColorCubit extends Cubit<ColorState> {
  ColorCubit() : super(ColorInitial());

  void changeColor(String color) async {
    await Hive.box('color').put('color', color);
    emit(ColorInitial());
  }
}
