import 'package:dart_ping/dart_ping.dart';
import 'package:flutter/material.dart';

class TestPingPage extends StatefulWidget {
  const TestPingPage({super.key});

  @override
  State<TestPingPage> createState() => _TestPingPageState();
}

class _TestPingPageState extends State<TestPingPage> {
  final String _domain = 'omelet.im';
  int _signalStrength = 0;
  String _resString = '';
  bool _isDisposed = false; 

  @override
  void dispose() {
    _isDisposed = true; 
    super.dispose();
  }

  void _doPing() {
    _resString = 'ping $_domain \n\n';
    final ping = Ping(_domain, count: 5);
    ping.stream.listen((event) {
      if (_isDisposed) return; 
      if (event.error != null) {
        setState(() {
          _resString = event.error.toString();
        });
      } else {
        if (event.response != null) {
          setState(() {
            _resString += '${event.response}\n';
          });
          _signalStrength = calculateSignalStrength(
              event.response?.time?.inMilliseconds ?? 0);
        }
        if (event.summary != null) {
          setState(() {
            _resString += '\n${event.summary}\n';
          });
        }
      }
    });
  }

  int calculateSignalStrength(int pingDelay) {
    if (pingDelay < 0) {
      return 0;
    } else if (pingDelay < 100) {
      return 5;
    } else if (pingDelay < 200) {
      return 4;
    } else if (pingDelay < 300) {
      return 3;
    } else if (pingDelay < 500) {
      return 2;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PingTest'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: _doPing,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 251, 120, 27)),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(100, 50),
                  ),
                ),
                child: const Text('Start Ping Test'),
              ),
              Text('訊號強度: $_signalStrength'),
              Text(_resString),
            ],
          ),
        ),
      ),
    );
  }
}
