import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oiti_liveness2d_bridge/bridge/call_liveness2d.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late TextEditingController _controller;

  var appKey = '';
  var isProd = false;

  var resultStatus = 'Jornada liveness não iniciada.';
  var resultContent = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Liveness 2D'),
        ),
        body: Center(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
                bottom: 5,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await OitiLiveness2D.startFaceCaptcha(appKey, isProd)
                        .then((result) => _onFaceCaptchaSuccess(result));
                  } on PlatformException catch (error) {
                    _onFaceCaptchaError(error);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("Iniciar FaceCaptcha"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
                bottom: 5,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await OitiLiveness2D.startFaceCaptcha(appKey, isProd)
                        .then((result) => _onFaceCaptchaSuccess(result));
                  } on PlatformException catch (error) {
                    _onFaceCaptchaError(error);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("Iniciar Documentoscopia"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 5,
              ),
              child: Text('Status: $resultStatus'),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
                bottom: 20,
              ),
              child: Text(resultContent),
            ),
            const Spacer(),
            SafeArea(
              child: appKeySection(),
            ),
          ],
        )),
      ),
    );
  }

  Widget appKeySection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'App Key',
        ),
        obscureText: false,
        controller: _controller,
        onSubmitted: (value) => _pasteAppKey(),
      ),
    );
  }

  _pasteAppKey() {
    setState(() => appKey = _controller.text);
    _controller.text = '';
  }

  _onFaceCaptchaSuccess(Object result) {}

  _onFaceCaptchaError(PlatformException error) {}

  _onFaceCaptchaCanceled(PlatformException error) {}

  _onDocumentscopyCompleted(Object result) {}

  _onDocumentscopyError(PlatformException error) {}

  _onDocumentscopyCancelled(PlatformException error) {}
}
