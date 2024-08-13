import 'package:flutter/material.dart';

class ChatText {
  //dislay
  static Text displayLg(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 56.0,
          height: 4.125,
          fontWeight: FontWeight.bold,
        ),
      );
  static Text displayMd(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 40.0,
          height: 1.25,
          fontWeight: FontWeight.bold,
        ),
      );
  static Text displaySm(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 56.0,
          height: 1.11,
          fontWeight: FontWeight.bold,
        ),
      );

  //headLine
  static Text headLinexLg(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 32.0,
          height: 1.125,
          fontWeight: FontWeight.bold,
        ),
      );
  static Text headLineLg(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 34.0,
          height: 1.12,
          fontWeight: FontWeight.normal,
        ),
      );
  static Text headLineMd(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 28.0,
          height: 1.14,
          fontWeight: FontWeight.normal,
        ),
      );
  static Text headLineSm(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 24.0,
          height: 1.16,
          fontWeight: FontWeight.normal,
        ),
      );
  //Body
  static Text bodyxLg(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 20.0,
          height: 1.2,
          fontWeight: FontWeight.normal,
        ),
      );
  static Text bodyLg(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          height: 1.33,
          fontWeight: FontWeight.bold,
        ),
      );
  static Text bodyMd(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          height: 1.5,
          fontWeight: FontWeight.bold,
        ),
      );
  static Text bodySm(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          height: 1.5,
          fontWeight: FontWeight.normal,
        ),
      );
  static Text bodyxSm(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 14.0,
          height: 1.29,
          fontWeight: FontWeight.normal,
        ),
      );
  //Caption
  static Text captionLg(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          height: 1.22,
          fontWeight: FontWeight.bold,
        ),
      );
  //Button
  static Text buttonLg(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 16.0,
          height: 1.25,
          fontWeight: FontWeight.bold,
        ),
      );
}
