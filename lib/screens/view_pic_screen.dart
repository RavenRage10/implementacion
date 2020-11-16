import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:provider/provider.dart';
import '../models/picture.dart';
import '../providers/pictures.dart';
import '../widgets/images_grid.dart';

class ViewPicScreen extends StatefulWidget {
  static const routeName = '/take-pic';

  @override
  _ViewPicScreenState createState() => _ViewPicScreenState();
}

class _ViewPicScreenState extends State<ViewPicScreen> {
  File _takenImage;
  Future<void> _getImage() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _takenImage = imageFile;
    });
    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    var _imageToStore = Picture(picName: savedImage);
    _storeImage() {
      Provider.of<Pictures>(context, listen: false).storeImage(_imageToStore);
    }

    _storeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ImagesGrid(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: _getImage,
      ),
    );
  }
}
