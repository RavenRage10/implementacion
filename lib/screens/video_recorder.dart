import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoRecorder extends StatefulWidget {
  static const routeName = '/video-recorder';

  @override
  _VideoRecorderState createState() => _VideoRecorderState();
}

class _VideoRecorderState extends State<VideoRecorder> {
  File _cameraVideo;

  VideoPlayerController _cameraVideoPlayerController;

  // This funcion will helps you to pick a Video File from Camera
  _pickVideoFromCamera() async {
    // ignore: deprecated_member_use
    File video = await ImagePicker.pickVideo(source: ImageSource.camera);
    _cameraVideo = video;
    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)
      ..initialize().then((_) {
        setState(() {});
        _cameraVideoPlayerController.play();
        _cameraVideoPlayerController.setLooping(true);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APP FOTO Y VIDEO"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                if (_cameraVideo != null)
                  _cameraVideoPlayerController.value.initialized
                      ? AspectRatio(
                          aspectRatio:
                              _cameraVideoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_cameraVideoPlayerController),
                        )
                      : Container(),
                Padding(padding: const EdgeInsets.all(5.0)),
                FloatingActionButton(
                  onPressed: () {
                    _pickVideoFromCamera();
                  },
                  child: Icon(Icons.videocam),
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
