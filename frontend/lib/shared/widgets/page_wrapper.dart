import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PageWrapper({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}