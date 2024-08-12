bool fileNameValidate(String fileName) {
  return fileName.trim().isNotEmpty &&
      RegExp(r'^[A-Za-z0-9_.\-/ ]+$').hasMatch(fileName);
}
