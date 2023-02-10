// flutter
import 'package:flutter/material.dart';

class GifyTextMessage {
  const GifyTextMessage({
    required this.text,
    this.fontSize = 10,
    this.fontColor = Colors.black,
    this.x = 0.0,
    this.y = 0.0,
  });

  final String text;
  final int fontSize;
  final Color fontColor;
  final double x;
  final double y;

  Map<String, dynamic> asMap() {
    return {
      'text': text,
      'fontSize': fontSize,
      'fontColor': '0x${fontColor.toHex()}',
      'x': x,
      'y': y,
    };
  }
}

extension HexColor on Color {
  String _generateAlpha({required int alpha, required bool withAlpha}) {
    if (withAlpha) {
      return alpha.toRadixString(16).padLeft(2, '0');
    } else {
      return '';
    }
  }

  String toHex({String? leadingHashSign, bool withAlpha = false}) =>
      '${leadingHashSign ?? ''}'
              '${_generateAlpha(alpha: alpha, withAlpha: withAlpha)}'
              '${red.toRadixString(16).padLeft(2, '0')}'
              '${green.toRadixString(16).padLeft(2, '0')}'
              '${blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
}
