import 'package:flutter/material.dart';
import 'package:spotflod/data/constants.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.text,
      {Key? key,
      this.fontSize = 14,
      this.textAlign = TextAlign.start,
      this.onBlueBg = true})
      : super(key: key);
  final String text;
  final double fontSize;
  final TextAlign textAlign;
  final bool onBlueBg;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color:
            onBlueBg ? Constants.colorScheme.tertiary : const Color(0XFF57624a),
        fontSize: fontSize,
      ),
      textAlign: textAlign,
      textScaleFactor: 1,
    );
  }
}
