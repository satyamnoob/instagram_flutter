import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage({required ImageSource source}) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }

  print("No image selected");
}

showSnackBar({
  required String content,
  required BuildContext context,
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      backgroundColor: isError ? Colors.red : Colors.white,
    ),
  );
}
