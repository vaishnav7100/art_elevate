import 'package:flutter/material.dart';
import 'dart:math';


const kcontentColor = Color(0xffF5F5F5);
const kprimaryColor = Color(0xffd3d3d3);

String randomAlphaNumeric(int length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random rand = Random();

  // Generate a random string of the specified length
  String result = '';
  for (int i = 0; i < length; i++) {
    result += chars[rand.nextInt(chars.length)];
  }

  return result;
}

