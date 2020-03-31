import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

//open camera and gallery
Future<File> getImage(var source) async {
  var image = await ImagePicker.pickImage(source: source);

  File croppedImage = await cropPickedImage(image);

  // fileList.add(image1);
  // return croppedImage;
  return croppedImage ?? image;
}

//crop image
Future<File> cropPickedImage(var image) async {
  File croppedImage = await ImageCropper.cropImage(
    sourcePath: image.path,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.redAccent,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false),
    iosUiSettings: IOSUiSettings(
      minimumAspectRatio: 1.0,
    ),
  );

  return croppedImage;
  //setting the image state
  //  setState(()=> _image=croppedImage);
}
