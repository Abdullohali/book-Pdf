import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'color_state.dart';

class ColorCubit extends Cubit<ColorState> {
  ColorCubit() : super(ColorInitial());

  Color initialColor = Colors.green;
  void changeColor(Color color) async {
    initialColor = color;
    emit(ColorInitial());
  }
}
