import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, this.appbar, this.body, this.backgroundColor});

  final Widget? appbar;
  final Widget? body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: backgroundColor ?? Colors.white,
        appBar: appbar == null ? null : PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: appbar!),
        body: body ?? const SizedBox.shrink(),
      ),
    );
  }
}
