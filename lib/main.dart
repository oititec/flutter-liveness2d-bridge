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

  bool _buttonsDisabled = false;
  bool _usingCertifaceAPI = false;
  String? ticket;
  var appKey = '';
  var isProd = false;
  var _appKeyLabel = 'AppKey vazia';
  var _ticketLabel = 'Ticket indisponível';

  var resultStatus = 'Nenhuma jornada foi iniciada';
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
          title: const Center(
            child: Text('Liveness 2D'),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
                bottom: 5,
              ),
              child: ElevatedButton(
                onPressed: _buttonsDisabled
                    ? null
                    : () async {
                        try {
                          await OitiLiveness2D.startFaceCaptcha(
                            appKey: appKey,
                            isProd: isProd,
                            user: "flutter.app",
                            name: "Flutter App",
                            cpf: "52998850081",
                            birthdate: "01/01/2000",
                            password: "flutter_passwword",
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
                bottom: 15,
              ),
              child: ElevatedButton(
                onPressed: _buttonsDisabled
                    ? null
                    : () async {
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
            const Divider(
              height: 2,
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 5,
              ),
              child: Text(
                'Status: $resultStatus',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 5,
                bottom: 15,
              ),
              child: Text(resultContent),
            ),
            const Divider(
              height: 2,
              thickness: 1,
              color: Colors.grey,
            ),
            sourceSelection(),
            ticketSection(),
            SafeArea(
              child: appKeySection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget sourceSelection() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 20, bottom: 10, top: 5),
      child: Row(children: [
        const Text("Usar Certiface API"),
        const Spacer(),
        Switch(
          value: _usingCertifaceAPI,
          onChanged: (value) {
            setState(() {
              _usingCertifaceAPI = value;
              ticket = value ? '' : null;
              _ticketLabel = value ? 'Ticket vazio' : 'Ticket indisponível';
            });
            _ticketController.text = '';
          },
        ),
      ]),
    );
  }

  Widget ticketSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: _ticketLabel,
        ),
        obscureText: false,
        controller: _ticketController,
        onTap: () => setState(() => _buttonsDisabled = true),
        onSubmitted: (value) => _pasteTicket(value),
        enabled: _usingCertifaceAPI,
      ),
    );
  }

  Widget appKeySection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: _appKeyLabel,
        ),
        obscureText: false,
        controller: _appKeyController,
        onTap: () => setState(() => _buttonsDisabled = true),
        onSubmitted: (value) => _pasteAppKey(value),
      ),
    );
  }

  _pasteAppKey(String appKeyValue) {
    setState(() {
      if (appKeyValue.isEmpty) {
        _appKeyLabel = 'AppKey vazia';
      } else if (appKeyValue.length > 10) {
        _appKeyLabel = 'AppKey: ${appKeyValue.substring(0, 10)}...';
      } else {
        _appKeyLabel = 'AppKey: $appKeyValue';
      }
      appKey = appKeyValue;
      _buttonsDisabled = false;
    });
    _appKeyController.clear();

    if (_ticketController.text.isNotEmpty) {
      _pasteTicket(_ticketController.text);
    }
  }

  _pasteTicket(String ticketValue) {
    setState(() {
      if (ticketValue.isEmpty) {
        _ticketLabel = 'Ticket vazio';
      } else if (ticketValue.length > 10) {
        _ticketLabel = 'Ticket: ${ticketValue.substring(0, 10)}...';
      } else {
        _ticketLabel = 'Ticket: $ticketValue';
      }
      ticket = ticketValue;
      _buttonsDisabled = false;
    });
    _ticketController.clear();

    if (_appKeyController.text.isNotEmpty) {
      _pasteAppKey(_appKeyController.text);
    }
  }

  _onFaceCaptchaSuccess(FaceCaptchaValidateModel result) {
    setState(() {
      resultStatus = 'FaceCaptcha Success';
      resultContent =
          'Valid: ${result.valid}\nCodID: ${result.codId}\nCause: ${result.cause}\nProtocol: ${result.uidProtocol}';
    });
  }

  _onFaceCaptchaError(PlatformException error) {
    setState(() {
      resultStatus = 'FaceCaptcha Error';
      resultContent = 'Code: ${error.code}\nMessage: ${error.message}';
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
      resultContent = 'Code: ${error.code}\nMessage: ${error.message}';
    });
  }
}
