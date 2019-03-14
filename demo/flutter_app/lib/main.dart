import 'package:flutter/material.dart';
import 'package:flutter_input_effects/flutter_input_effects.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.black12,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            ListTile(title: Text("Makiko")),
            MakikoInput(
              label: "Comment",
              defaultText: "Hello",
              styles: const InputStyles(
                color: Color(0xffb4b4ab),
                textStyle: TextStyle(color: Color(0xffdb786d)),
                iconColor: Colors.white,
                icon: Icons.mode_comment,
                inputPadding: const EdgeInsets.all(16),
                height: 50.0,
                margin: const EdgeInsets.only(bottom: 16.0),
                backgroundColor: Colors.tealAccent,
                cursorColor: Colors.black
              ),
            ),

            MakikoInput(
              label: "Comment",
              obscureText: true,
              styles: const InputStyles(
                color: Colors.lightBlueAccent,
                iconColor: Colors.white,
                icon: Icons.mode_comment,
                autoSuffix: true,
                inputPadding: const EdgeInsets.all(16),
                border: 0.2
              ),
              //child: Text("A"),
            ),

            ListTile(title: Text("Basic")),

            BasicInput(
              label: "User Name",
              styles: const InputStyles(
                  color: Color(0xffb4b4ab),
                  iconColor: Colors.black38,
                  icon: Icons.account_circle,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  cursorWidth: 1.0,
                  cursorColor: Colors.black,
              ),
            ),

            BasicInput(
              label: "Password",
              obscureText: true,
              styles: const InputStyles(
                color: Color(0xffb4b4ab),
                iconColor: Colors.black38,
                icon: Icons.lock,
                margin: const EdgeInsets.only(bottom: 16.0),
                cursorWidth: 1.0,
                cursorColor: Colors.black,
              ),
            ),

            ListTile(title: Text("Static Basic")),

            BasicInput(
              label: "User Name",
              isStatic: true,
              styles: const InputStyles(
                prefixIcon: Icons.account_circle,
                margin: const EdgeInsets.only(bottom: 16.0),
                cursorWidth: 1.0,
                cursorColor: Colors.black,
                backgroundColor: Colors.white30,
              ),
            ),

          ],


        ),
      ),
    );
  }
}
