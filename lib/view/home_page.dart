import 'dart:io';

import 'package:deskreddit/view/windowshome/reddit_browser_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      return const ReddBrowserContainer();
    } else {
      return Container();
    }
  }
}
