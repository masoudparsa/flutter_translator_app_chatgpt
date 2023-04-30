import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Translator app with chat-gpt'),
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
  TextEditingController textController = TextEditingController();
  String translatedText = "";
  final openAI = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
      isLog: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'input text for translate'),
                ),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        translatedText = "";
                        translateToGerman();
                      },
                      child: const Text("translate to german",
                          style: TextStyle(fontSize: 20))),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        translatedText = "";
                        translateToFrench();
                      },
                      child: const Text("translate to french",
                          style: TextStyle(fontSize: 20))),
                ),
                const SizedBox(
                  height: 50,
                ),
                Card(
                    elevation: 3,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(16),
                      child: Text(translatedText,
                          softWrap: true, style: const TextStyle(fontSize: 20)),
                    ))
              ],
            )),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void translateToFrench() {
    final request = CompleteText(
        prompt: "translate into to french : ${textController.text}",
        maxTokens: 200,
        model: Model.textDavinci3);
    openAI.onCompletionSSE(request: request).listen((it) {
      setState(() {
        translatedText += it.choices.last.text;
      });
    });
  }

  void translateToGerman() {
    final request = CompleteText(
        prompt: "translate into to german : ${textController.text}",
        maxTokens: 200,
        model: Model.textDavinci3);
    openAI.onCompletionSSE(request: request).listen((it) {
      setState(() {
        translatedText += it.choices.last.text;
      });
    });
  }
}
