import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:qrcode/constant/static_variables.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:qrcode/qr/view/pages/convert/convert_function/TextToQR.dart';
import 'package:qrcode/qr/view/pages/result/QrText.dart';

class TextToQrPage extends StatefulWidget {
  const TextToQrPage({super.key});

  @override
  State<TextToQrPage> createState() => _TextToQrPageState();
}

class _TextToQrPageState extends State<TextToQrPage> {
  TextEditingController _textEditingController = TextEditingController();
  StreamController<int> _textLengthStream = StreamController<int>();

  @override
  void dispose() {
    _textEditingController.dispose();
    _textLengthStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textLengthStream.sink.add(1000);
    _textEditingController.addListener(() {
      _textLengthStream.sink.add(1000 - _textEditingController.text.length);
    });
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Văn bản'),
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
                HistoryItem tmp = HistoryItem(
                    type: 'văn bản',
                    datetime: DateTime.now(),
                    content: _textEditingController.text);
                StaticVariable.createdController.add(tmp);
                StaticVariable.conn.insertCreated(tmp);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrTextPage(
                            historyItem: tmp,
                          )),
                );
                _textEditingController.clear();
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              StreamBuilder<int>(
                                stream: _textLengthStream.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data.toString());
                                  } else {
                                    return Text('');
                                  }
                                },
                              ),
                            ]),
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
                              hintText: 'Văn bản',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ))
                      ],
                    )))));
  }
}
