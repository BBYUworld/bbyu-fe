import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'views/home/home_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'storage/user_store.dart';
void main() {
  WebView.platform = AndroidWebView();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => UserStore()),
      ],
      child: MyApp(),
    ),
  );
}