import 'package:flutter/material.dart';

class ProgressDialog extends StatefulWidget {
  final String? text;

  ProgressDialog({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  ProgressDialogState createState() => ProgressDialogState();
}

class ProgressDialogState extends State<ProgressDialog> {
  final ValueNotifier<double?> _progress = ValueNotifier(0);

  void setValue(double? val) {
    _progress.value = val;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(width: 8.0),
        SizedBox(
          width: 60.0,
          height: 60.0,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: ValueListenableBuilder<double?>(
              valueListenable: _progress,
              builder: (ctx, v, _) => CircularProgressIndicator(value: v),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          widget.text!,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8.0)
      ],
    );
  }
}
