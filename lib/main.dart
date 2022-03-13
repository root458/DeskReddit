import 'package:deskreddit/view/home_page.dart';
import 'package:fluent_ui/fluent_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'r/DeskReddit',
      theme: ThemeData(
        activeColor: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

