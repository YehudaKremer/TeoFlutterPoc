import 'package:csharp_rpc/csharp_rpc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

late CsharpRpc csharpRpc;

Future<void> main() async {
  runApp(const MyApp());

  var pathToCsharpExecutableFile = kReleaseMode
      ? 'csharp/TeoFlutterPoc.exe'
      : "../bin/Debug/net7.0/TeoFlutterPoc.exe";

  csharpRpc = await CsharpRpc(pathToCsharpExecutableFile).start();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EURUSD Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'EURUSD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController(text: "Q2R45TMCYRWTI5GR");

  String _EURUSDquote = "press the button to load the quote";
  String _status = "";

  Future<void> _loadEURUSDquote() async {
    setState(() {
      _status = "loading...";
    });

    var EURUSDquoteResult = await csharpRpc
        .invoke<String>(method: "GetEURUSD", params: [_controller.text]);

    setState(() {
      _status = "";
      _EURUSDquote = EURUSDquoteResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'EURUSD Quote:',
            ),
            Text(
              _EURUSDquote,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              width: 250,
              child: TextField(
                // default value: myApiKey
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Alpha Vantage API KEY',
                ),
              ),
            ),
            Text(
              _status,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadEURUSDquote,
        tooltip: 'Load EURUSD Quote',
        child: const Icon(Icons.http),
      ),
    );
  }
}
