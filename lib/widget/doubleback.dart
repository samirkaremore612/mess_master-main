import 'package:flutter/material.dart';

class DoubleBackExit extends StatefulWidget {
  final Widget child;

  DoubleBackExit({required this.child});

  @override
  _DoubleBackExitState createState() => _DoubleBackExitState();
}

class _DoubleBackExitState extends State<DoubleBackExit> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.child,
    );
  }

  Future<bool> _onWillPop() async {
    DateTime? _currentPressedAt = DateTime.now();
    if (_lastPressedAt == null ||
        _currentPressedAt.difference(_lastPressedAt!) > Duration(seconds: 1)) {
      _lastPressedAt = _currentPressedAt;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Press back again to exit')),
      );
      return false;
    }
    return true;
  }
}