import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/material.dart';

toasUrl(BuildContext context) async {
  await showTextToast(
    text: '  Please enter url  ',
    context: context,
  );
}

toasTitle(BuildContext context) async {
  await showTextToast(
    text: ' Please enter title ',
    context: context,
  );
}

toas(BuildContext context, String txt) async {
  await showTextToast(
    text: txt,
    context: context,
  );
}
