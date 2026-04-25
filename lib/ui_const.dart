import 'package:flutter/material.dart';
import 'dart:ui';

Color primaryColor = Color(0xFFa7c957);
Color secondaryColor = Color(0xFF6a994e);
Color tertiaryColor = Color(0xFF386641);
Color backgroundColor = Color(0xFFf2e8cf);
Color accentColor = Color(0xFFbc4749);


backgroundWidget(BuildContext context) {
  return [
    Container(
      child: Image.asset('background.jpg', fit: BoxFit.cover),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    ),
    Center(
      child: Opacity(
        opacity: .2,
        child: Container(
          child: Image.asset('tandagLogo.png'),
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 1.5,
        ),
      ),
    ),
  ];
}