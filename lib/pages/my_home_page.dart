import 'package:flutter/material.dart';
import 'package:toi_invite/media_query/layout_build_resp.dart';
import 'package:toi_invite/pages/admin_panel.dart';
import 'package:toi_invite/pages/mobile_screen_layout.dart';
import 'package:toi_invite/pages/tablet_screen_layout.dart';
import 'package:toi_invite/pages/web_screen_layout.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final Uri uri = Uri.base;

    if (uri.path == '/xfdsfdslkjlIjvbvEtgsqwE') {
      return AdminPanel();
    } else {
      return LayoutBuilderResp(
        mobileScreenLayout: const MobileScreenLayout(),
        tabletScreenLayout: const TabletScreenLayout(),
        webScreenLayout: const WebScreenLayout(),
      );
    }
  }
}
