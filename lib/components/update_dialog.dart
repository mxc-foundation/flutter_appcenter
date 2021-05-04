
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateDialog extends StatelessWidget {
  UpdateDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onMiddle,
    this.subTitle,
    this.mandatoryUpdate = false,
    this.confirmButtonText = 'Confirm',
    this.middleButtonText = 'Confirm',
    this.cancelButtonText = 'Postpone',
    this.onCancel,
  });

  final bool? mandatoryUpdate;
  final String title;
  final String? subTitle;
  final String? content;
  final String? confirmButtonText;
  final String? middleButtonText;
  final String? cancelButtonText;
  final Function onConfirm;
  final Function? onMiddle;
  final Function? onCancel;

  @override
  Widget build(BuildContext context) {

    return CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                subTitle!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Text(
              content!,
              textAlign: TextAlign.left,
              style: TextStyle(
                height: 1.5
              ),
            )
          ]
        )
      ),
      actions: [
        Visibility(
          visible: !mandatoryUpdate!,
          child: FlatButton(
            child: Text(
              cancelButtonText!,
              style: TextStyle(
                color: Colors.grey[600]
              ),
            ),
            onPressed: onCancel as void Function()? ?? () => Navigator.pop(context)
          )
        ),
        Visibility(
          visible: middleButtonText!.isNotEmpty,
          child: FlatButton(
            child: Text(
              middleButtonText!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue
              ),
            ),
            onPressed: (){
              Navigator.pop(context);
              if(onMiddle != null) onMiddle!();
            }
          ),
         ),
        FlatButton(
          child: Text(
            confirmButtonText!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue
            ),
          ),
          onPressed: (){
            Navigator.pop(context);
            if(onConfirm != null) onConfirm();
          }
        ),
      ],
    );
  }
}