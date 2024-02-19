import 'package:flutter/material.dart';
import 'package:qrcode/model/history_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isMusicSwitched = true;
  bool _isVibrationSwitched = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('QrCode'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Chung",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.volume_down),
                    title: const Text("Âm thanh"),
                    trailing: Switch(
                      value: _isMusicSwitched,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          _isMusicSwitched = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.vibration),
                    title: const Text("Rung"),
                    trailing: Switch(
                      value: _isVibrationSwitched,
                      activeColor: Colors.green,
                      onChanged: (value) {
                        setState(() {
                          _isVibrationSwitched = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  "Nhà phát triển",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Card(
              child: Column(
                children: [
                  InkWell(
                    child: ListTile(
                      leading: const Icon(Icons.mail),
                      title: const Text("Phản hồi"),
                    ),
                    onTap: () {
                      TextEditingController _nameController =
                          TextEditingController(text: "abcd@gmail.com");
                      TextEditingController _descriptionEditingController =
                          TextEditingController(text: "Phản hồi về qrcode");
                      TextEditingController _textEditingController =
                          TextEditingController();
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 0.9 * MediaQuery.of(context).size.height,
                              child: Scaffold(
                                appBar: AppBar(
                                    title: const Text('Phản hồi'),
                                    actions: [
                                      IconButton(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            top: 20,
                                            bottom: 20,
                                            right: 10),
                                        alignment: Alignment.bottomLeft,
                                        icon: const Icon(
                                          Icons.send,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          var data =
                                              'mailto:${_nameController.text}?subject=${Uri.encodeQueryComponent(_descriptionEditingController.text)}&body=${Uri.encodeQueryComponent(_textEditingController.text)}';
                                          _textEditingController.clear();
                                          Navigator.pop(context);
                                          launchUrl(Uri.parse(data));
                                        },
                                      )
                                    ]),
                                body: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              enabled: false,
                                              controller: _nameController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                hintText: 'Đến',
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                border: InputBorder.none,
                                              ),
                                              maxLines: null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: TextField(
                                        enabled: false,
                                        controller:
                                            _descriptionEditingController,
                                        decoration: const InputDecoration(
                                          hintText: 'Chủ đề',
                                          contentPadding: EdgeInsets.all(10),
                                          border: InputBorder.none,
                                        ),
                                        maxLines: null,
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: TextField(
                                        controller: _textEditingController,
                                        decoration: const InputDecoration(
                                          hintText: 'Văn bản',
                                          contentPadding: EdgeInsets.all(10),
                                          border: InputBorder.none,
                                        ),
                                        maxLines: null,
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
