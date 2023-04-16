import 'package:flutter/material.dart';

bool formCheck({required GlobalKey<FormState> formKey}) {
  final form = formKey.currentState;
  if (form!.validate()) {
    return true;
  } else {
    return false;
  }
}
