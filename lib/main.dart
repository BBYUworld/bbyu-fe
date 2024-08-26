import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'views/home/home_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WebView.platform = AndroidWebView();
  runApp(
    ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: MyApp(),
    ),
  );
}