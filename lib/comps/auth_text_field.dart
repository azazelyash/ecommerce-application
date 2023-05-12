import 'package:flutter/material.dart';

InputDecoration authTextFieldDecoration(String hintText) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(13),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(13),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.circular(13),
    ),
    fillColor: Colors.transparent,
    filled: true,
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.white),
  );
}
