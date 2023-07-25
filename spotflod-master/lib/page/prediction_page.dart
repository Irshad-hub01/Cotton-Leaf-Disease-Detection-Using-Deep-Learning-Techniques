import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spotflod/components/fab_widget.dart';
import 'package:spotflod/data/constants.dart';

import '../components/text_widget.dart';
import '../data/diseases.dart';

class PredictionPage extends StatelessWidget {
  const PredictionPage(
      {Key? key,
      this.imagePath,
      this.controlMeasures,
      this.classLabelIndex,
      this.information, this.classLabel})
      : super(key: key);
  static const id = '/predication_page';
  final String? imagePath;
  final List<String>? controlMeasures;
  final int? classLabelIndex;
  final String? information;
  final String? classLabel;
  
  @override
  Widget build(BuildContext context) {
    final dp = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: dp > 2.75 ? 4 : 3,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [image(), diseaseName()])),
            if (classLabelIndex! != 5)
              Expanded(
                flex: 8,
                child: controlMeasures != null
                    ? remedies(dp)
                    : showInformation(dp),
              ),
          ],
        ),
      )),
      floatingActionButton: const FabWidget(),

      resizeToAvoidBottomInset: false,
      bottomNavigationBar: information != null ? controlMeasuresButton(context) : null,
    );
  }

  image() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(imagePath!),
        height: 150,
        width: 150,
      ),
    );
  }

  diseaseName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: TextWidget(
            Constants.classLabels[classLabelIndex!],
            fontSize: 20,
            onBlueBg: false,
          ),
        ),
        if (classLabelIndex! != 5)
          TextWidget(
              controlMeasures != null ? 'Control Measures' : 'Information',
              fontSize: 20,
              onBlueBg: false)
      ],
    );
  }

  remedies(double dp) {
    return Card(
      color: const Color(0XFFe1e4d5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                  controlMeasures!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextWidget(
                      '* ${controlMeasures![index]}',
                      textAlign: TextAlign.left,
                      fontSize: dp > 2.75 ? 18 : 20,
                      onBlueBg: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showInformation(double dp) {
    return Card(
      color: const Color(0XFFe1e4d5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: TextWidget(information!,
              textAlign: TextAlign.left,
              fontSize: dp > 2.75 ? 18 : 20,
              onBlueBg: false),
        ),
      ),
    );
  }

  controlMeasuresButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            List<String> controlMeasures = Diseases.getControlMeasures(classLabel!);

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return PredictionPage(
                imagePath: imagePath!,
                classLabelIndex: classLabelIndex,
                controlMeasures: controlMeasures,
              );
            }));
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextWidget('Show Control Measures',
                fontSize: 22, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}