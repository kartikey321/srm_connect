import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Text WriteText(String text, {TextStyle? style}) {
  return Text(
    text,
    style: GoogleFonts.libreFranklin(textStyle: style),
  );
}

Text WriteText1(String text, {TextStyle? style}) {
  return Text(
    text,
    style: GoogleFonts.dmSans(textStyle: style),
  );
}
