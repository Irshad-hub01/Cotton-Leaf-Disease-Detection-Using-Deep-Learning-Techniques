import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spotflod/components/fab_widget.dart';
import 'package:spotflod/components/text_widget.dart';
import 'package:spotflod/data/constants.dart';
import 'package:spotflod/page/prediction_page.dart';

import '../data/diseases.dart';

class ConfidencePage extends StatelessWidget {
  const ConfidencePage({Key? key, this.imagePath, this.confidence})
      : super(key: key);
  static const id = '/confidence_page';
  final String? imagePath;
  final List<Object?>? confidence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 8,
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(imagePath!),
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 8, bottom: 8, right: 20),
                  child: Row(
                    children: const [
                      Expanded(child: TextWidget('Disease', fontSize: 26)),
                      Expanded(
                          child: TextWidget('Confidence',
                              fontSize: 26, textAlign: TextAlign.end)),
                    ],
                  ),
                ),
              ),
              confidenceList(context),
              const SizedBox(height: 4),
              const TextWidget(
                'Tap on the disease to show information about the disease.',
                textAlign: TextAlign.center,
                fontSize: 16,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: const FabWidget(),
    );
  }

  confidenceList(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(confidence!.length, (index) {
        Map<Object?, Object?> result =
            confidence![index] as Map<Object?, Object?>;
        final confidenceMain = result['confidence']! as double;
        final label = result['label'] as String;
        final resIndex = result['index'] as int;

        if (confidenceMain > 40.0) {
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                navigate(context: context, label: label, index: resIndex);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 8, bottom: 8, right: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: TextWidget(Constants.classLabels[resIndex],
                            fontSize: 22)),
                    Expanded(
                      child: TextWidget('${result['confidence']}%',
                          fontSize: 22, textAlign: TextAlign.end),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
    );
  }

  navigate(
      {required BuildContext context,
      required String label,
      required int index}) {
    String information = Diseases.getInformation(label);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PredictionPage(
        imagePath: imagePath!,
        classLabelIndex: index,
        information: information,
        classLabel: label
      );
    }));
  }
}
