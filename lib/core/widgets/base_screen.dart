import 'package:flutter/material.dart';

import 'app_drawer.dart';
import 'exit_confirmation.dart';

class BaseScreen extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? appBarActions;
  final VoidCallback? onFabPressed;
  final IconData fabIcon;

  const BaseScreen({
    required this.title,
    required this.body,
    Key? key,
    this.onFabPressed,
    this.appBarActions,
    this.fabIcon = Icons.add,
  }) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        actions: widget.appBarActions,
      ),
      drawer: AppDrawer(),
      body: widget.body,
      floatingActionButton:
          widget.onFabPressed != null
              ? Transform.translate(
                offset: Offset(0, -40), // Shift 20 pixels upwards
                child: FloatingActionButton(
                  onPressed: widget.onFabPressed,
                  backgroundColor: Colors.teal,
                  child: Icon(widget.fabIcon, color: Colors.white),
                ),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
