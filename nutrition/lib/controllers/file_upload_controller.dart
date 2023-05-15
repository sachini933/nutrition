import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

class FileUpladController {
  //---upload picked image file to the firebase storege bucket in the given path

  Future<String> uploadFile(File file, String folderpath) async {
    try {
      //--getting the filename from the file path
      final String fileName = basename(file.path);

      //---defining the firebase storage destination in the firebase storage
      final String destination = "$folderpath/$fileName";

      //--cretaing the firebase storage instance with the destination file location
      final ref = FirebaseStorage.instance.ref(destination);

      // uploading the file
      final UploadTask task = ref.putFile(file);

      //--wait untill the task is completed
      final snapshot = await task.whenComplete(() {});

      //--getting the download url of the uploaded file
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      Logger().e(e);
      return "";
    }
  }
}
