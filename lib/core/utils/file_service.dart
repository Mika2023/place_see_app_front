import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileService {
  static Future<File?> compressImage(XFile image) async {
    final dir = await getTemporaryDirectory();

    final targetPath = "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final result = await FlutterImageCompress.compressAndGetFile(
        image.path,
        targetPath,
        quality: 70,
      minHeight: 1080,
      minWidth: 1080
    );

    return result != null ? File(result.path) : null;
  }
}