import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/asset/assetloan/LoanMainPage.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'storage/user_store.dart';
void main() {
  WebView.platform = AndroidWebView();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserStore()),
      ],
      child: MyApp(),
    ),
  );
}