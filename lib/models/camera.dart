import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class Camera with ChangeNotifier {
  final CameraDescription camera;

  Camera({
    @required this.camera,
  });
}
