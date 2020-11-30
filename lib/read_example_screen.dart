import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class ReadExampleScreen extends StatefulWidget {
  @override
  _ReadExampleScreenState createState() => _ReadExampleScreenState();
}

class _ReadExampleScreenState extends State<ReadExampleScreen> {
  StreamSubscription<NDEFMessage> _stream;

  void _startScanning(context) {
    setState(() {
      _stream = NFC
          .readNDEF(alertMessage: "Custom message with readNDEF#alertMessage")
          .listen((NDEFMessage message) {
        _settingModalBottomSheet(context);
      }, onError: (error) {
        setState(() {
          _stream = null;
        });
        if (error is NFCUserCanceledSessionException) {
          print("user canceled");
        } else if (error is NFCSessionTimeoutException) {
          print("session timed out");
        } else {
          print("error: $error");
        }
      }, onDone: () {
        setState(() {
          _stream = null;
        });
      });
    });
  }

  void _stopScanning() {
    _stream?.cancel();
    setState(() {
      _stream = null;
    });
  }

  void _toggleScan(context) {
    if (_stream == null) {
      _startScanning(context);
    } else {
      _stopScanning();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stopScanning();
  }

  @override
  Widget build(BuildContext context) {
    _startScanning(context);
    Future.delayed(Duration(seconds: 5), () {_settingModalBottomSheet(context);});
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Image.asset('assets/logo.png'), onPressed: () {}),
          title: const Text("ParkAçar"),
          backgroundColor: Colors.red,
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 400.0,
                  //   height: 400.0,
                  //   alignment: Alignment.center,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage('assets/logo.png'),
                  //         fit: BoxFit.fitWidth),
                  //   ),
                  // ),
          Text('Cihaza yaklaştırın',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4),
        ])));
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Center(
                    child: Column(children: [
                  Padding(padding: EdgeInsets.all(10)),
                  Text('Hoş geldiniz!',
                      style: Theme.of(context).textTheme.headline3),
                  Padding(padding: EdgeInsets.all(20)),
                  Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/avatar.jpg'),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Text('Kapınız açılıyor...',
                      style: Theme.of(context).textTheme.headline6),
                  Padding(padding: EdgeInsets.all(10)),
                ]))
              ],
            ),
          );
        });
  }
}
