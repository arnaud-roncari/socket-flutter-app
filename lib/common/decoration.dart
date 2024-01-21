import 'package:flutter/material.dart';

const kPrimary = Color.fromRGBO(255, 185, 1, 1);
const kSecondary = Color.fromRGBO(254, 230, 160, 1);
const kLightGrey = Color.fromRGBO(246, 246, 246, 1);
const kGrey = Color.fromRGBO(198, 198, 198, 1);
const kWhite = Color.fromRGBO(255, 255, 255, 1);
const kBlack = Color.fromRGBO(0, 0, 0, 1);

const TextStyle kRegular10 = TextStyle(fontFamily: "SpaceGrotesk", fontSize: 10, fontWeight: FontWeight.w400);
const TextStyle kRegular12 = TextStyle(fontFamily: "SpaceGrotesk", fontSize: 12, fontWeight: FontWeight.w400);
const TextStyle kRegular14 = TextStyle(fontFamily: "SpaceGrotesk", fontSize: 14, fontWeight: FontWeight.w400);
const TextStyle kRegular18 = TextStyle(fontFamily: "SpaceGrotesk", fontSize: 18, fontWeight: FontWeight.w400);
const TextStyle kRegular20 = TextStyle(fontFamily: "SpaceGrotesk", fontSize: 20, fontWeight: FontWeight.w400);

const TextStyle kBold12 = TextStyle(fontFamily: "SpaceGrotesk", fontSize: 12, fontWeight: FontWeight.w700);
const TextStyle kBold14 = TextStyle(fontFamily: "SpaceGrotesk", fontSize: 14, fontWeight: FontWeight.w700);
const TextStyle kBold18 = TextStyle(fontFamily: "SpaceGrotesk", fontSize: 18, fontWeight: FontWeight.w700);
const TextStyle kBold40 = TextStyle(fontFamily: "SpaceGrotesk", fontSize: 40, fontWeight: FontWeight.w700);

final kTfDecoration = InputDecoration(
  filled: true,
  fillColor: kLightGrey,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: const BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  ),
  hintStyle: kRegular18.copyWith(color: kGrey),
);
