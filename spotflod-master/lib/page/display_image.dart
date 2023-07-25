import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotflod/components/fab_widget.dart';
import 'package:spotflod/components/text_widget.dart';
import 'package:spotflod/page/confidence_page.dart';

import '../data/constants.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({Key? key, this.imageFile}) : super(key: key);

  static const platform = MethodChannel('classifier');
  static const id = '/display_image';
  final String? imageFile;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        deleteCache();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 8,
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(imageFile!),
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    classifyImage(context);
                  },
                  child: const TextWidget(
                    'Classify Disease',
                    fontSize: 26,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        )),
        floatingActionButton: FabWidget(
          fun: deleteCache,
        ),
      ),
    );
  }

  Future<void> classifyImage(context) async {
    await platform
        .invokeMethod('classifyImage', {"path": imageFile!}).then((response) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ConfidencePage(imagePath: imageFile, confidence: response);
      }));
    });
  }

  void deleteCache() {
    String cachePath = Constants.cachePath;
    if (Directory(cachePath).existsSync()) {
      Directory(cachePath).deleteSync(recursive: true);
    }
  }
}
