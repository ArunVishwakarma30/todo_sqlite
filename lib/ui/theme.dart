import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
const Color bluishClr = Color(0xff4e5ae8);
const Color yellowClr = Color(0xffffb746);
const Color pinkClr = Color(0xffff4667);
const Color whiteClr = Colors.white;
const primaryClr = bluishClr;
const dartGreyClr = Color(0xff121212);
const darkHeaderClr = Color(0xff424242);


TextStyle get subHeadingStyle{
  return GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black);
}

TextStyle get headingStyle{
  return GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black);
}

TextStyle get titleStyle{
  return GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black);
}