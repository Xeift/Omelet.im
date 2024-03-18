import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omelet/pages/home_page.dart';


class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
      // 在这里执行页面跳转
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => YourNextPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // 加载指示器
            : ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>const HomePage(title: '',)));
                },
                child: Text('Continue'), // 跳转按钮
              ),
      ),
    );
  }
}