import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/ui/pages/convert/convert_function/TextToQR.dart';

class UrlToQrPage extends StatelessWidget {
  TextEditingController _textEditingController =
      TextEditingController(text: 'http://');
  String _text = '';
  int _textLength = 0;
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Url'),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(
                  left: 10, top: 20, bottom: 20, right: 10),
              alignment: Alignment.bottomLeft,
              icon: const Icon(
                Icons.check,
                size: 24,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          width: 200, // Adjust the width as needed
                          height: 200, // Adjust the height as needed
                          child:
                              QRCodeWidget(data: _textEditingController.text),
                        ),
                        actions: [
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              _textEditingController =
                                  TextEditingController(text: 'http://');
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
                HistoryItem tmp = HistoryItem(
                    type: 'url',
                    datetime: DateTime.now(),
                    content: _textEditingController.text);
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
              },
            )
          ],
        ),
        body: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 20),
            child: Card(
                elevation: 4,
                clipBehavior: Clip.hardEdge,
                child: Container(
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.8,
                    child: Column(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          margin:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                            ),
                            maxLines: null,
                          ),
                        ))
                      ],
                    )))));
  }
}
