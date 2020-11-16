import 'package:implementacion/screens/take_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/view_pic_screen.dart';
import './screens/tabs_screen.dart';
import './screens/video_recorder.dart';
import './providers/pictures.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Pictures>(create: (_) => Pictures()),
      ],
      child: Container(
        child: MaterialApp(
          title: 'Camera & Gallery Tutorial',
          theme: ThemeData(
            primarySwatch: Theme.of(context).primaryColor,
            accentColor: Colors.teal,
            fontFamily: 'Lato',
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
          routes: {
            '/': (ctx) => TabsScreen(),
            ViewPicScreen.routeName: (ctx) => ViewPicScreen(),
            TakePicture.routeName: (ctx) => TakePicture(),
            VideoRecorder.routeName: (ctx) => VideoRecorder()
          },
        ),
      ),
    );
  }
}
