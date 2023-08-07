import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oiti_liveness2d_bridge/bridge/call_liveness2d.dart';
import 'package:oiti_liveness2d_bridge/bridge/facecaptcha_validate_model.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late TextEditingController _appKeyController;
  late TextEditingController _ticketController;

  bool _usingCertifaceAPI = false;
  String? ticket;
  var appKey = '';
  var isProd = false;

  var resultStatus = 'Jornada liveness não iniciada.';
  var resultContent = '';

  @override
  void initState() {
    super.initState();
    _appKeyController = TextEditingController();
    _ticketController = TextEditingController();
  }

  @override
  void dispose() {
    _appKeyController.dispose();
    _ticketController.dispose();
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
                    await OitiLiveness2D.startFaceCaptcha(
                      appKey: appKey,
                      isProd: isProd,
                    ).then((result) => _onFaceCaptchaSuccess(result));
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
                    await OitiLiveness2D.startDocumentscopy(
                      ticket: ticket,
                      appKey: appKey,
                      isProd: isProd,
                    ).then((_) => _onDocumentscopySuccess());
                  } on PlatformException catch (error) {
                    _onDocumentscopyError(error);
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
            sourceSelection(),
            ticketSection(),
            SafeArea(
              child: appKeySection(),
            ),
          ],
        )),
      ),
    );
  }

  Widget sourceSelection() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 20, bottom: 10),
      child: Row(children: [
        const Text("Usar Certiface API"),
        const Spacer(),
        Switch(
          value: _usingCertifaceAPI,
          onChanged: (value) {
            setState(() {
              _usingCertifaceAPI = value;
              ticket = _usingCertifaceAPI ? '' : null;
            });
          },
        ),
      ]),
    );
  }

  Widget ticketSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Ticket',
        ),
        obscureText: false,
        controller: _ticketController,
        onSubmitted: (value) => _pasteTicket(_ticketController),
        enabled: _usingCertifaceAPI,
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
        controller: _appKeyController,
        onSubmitted: (value) => _pasteAppKey(_appKeyController),
      ),
    );
  }

  _pasteAppKey(TextEditingController controller) {
    setState(() => appKey = controller.text);
    controller.text = '';
  }

  _pasteTicket(TextEditingController controller) {
    setState(() => ticket = controller.text);
    controller.text = '';
  }

  _onFaceCaptchaSuccess(FaceCaptchaValidateModel result) {
    setState(() {
      resultStatus = 'FaceCaptcha Success';
      resultContent =
          'Valid: ${result.valid}\nCodID: ${result.codId}\nCause: ${result.cause}\nProtocol: ${result.uidProtocol}\n';
    });
  }

  _onFaceCaptchaError(PlatformException error) {
    setState(() {
      resultStatus = 'FaceCaptcha Error';
      resultContent = 'Code: ${error.code}\nMessage: ${error.message}\n';
    });
  }

  _onDocumentscopySuccess() {
    setState(() {
      resultStatus = 'Documentscopy Success';
      resultContent = '';
    });
  }

  _onDocumentscopyError(PlatformException error) {
    setState(() {
      resultStatus = 'Documentscopy Error';
      resultContent = 'Code: ${error.code}\nMessage: ${error.message}\n';
    });
  }
}
