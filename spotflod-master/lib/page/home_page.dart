import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotflod/components/text_widget.dart';
import 'package:spotflod/data/constants.dart';
import 'package:spotflod/page/display_image.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const id = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('classifier');

  late ImagePickerAndroid imagePicker;
  String? imageFile;
  final textController = TextEditingController();
  double? dp;

  String modelContent = '';

  @override
  void initState() {
    super.initState();
    initImagePicker();
    postFrameCallBack();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dp = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      body: SafeArea(
        child: spinoImage(),
      ),
      bottomNavigationBar: cameraAndGalleryDock(),
    );
  }

  Future<void> pickImage({bool camera = false}) async {
    try {
      await imagePicker
          .pickImage(
              source: camera == true ? ImageSource.camera : ImageSource.gallery,
              imageQuality: 85)
          .then((image) {
        imageFile = image!.path;
      });
    } on PlatformException catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera is not available.')));
      }
    }
  }

  void lockPortrait() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  spinoImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/spinosaurus.jpg",
              filterQuality: FilterQuality.low,
            ),
          ),
        ),
        Tooltip(
          message: 'About',
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(AboutPage.id),
            child: const Text(
              "-----------",
              style: TextStyle(
                fontSize: 22,
                color: Color(0XFF57624a),
              ),
            ),
          ),
        ),
      ],
    );
  }

  cameraAndGalleryDock() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 100,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          elevation: 8,
          color: const Color(0XFFbbece8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: TextWidget(
                  '  SpotFlod',
                  fontSize: dp! > 3 ? 16 : 22,
                )),
                Expanded(
                  child: InkWell(
                    radius: 16,
                    borderRadius: BorderRadius.circular(32),
                    onTap: () async {
                      await pickImage(camera: true);
                      displayImage();
                    },
                    child: const Tooltip(
                      message: 'Pick image from Camera',
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0XFF386664),
                        foregroundColor: Color(0XFFdbe7c8),
                        child: Icon(Icons.camera_alt_rounded, size: 48),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await pickImage();
                            displayImage();
                          },
                          icon: const Icon(Icons.image_rounded),
                          tooltip: 'Pick image from Gallery',
                        ),
                        IconButton(
                          onPressed: () {
                            loadModelAlertDialog(updateModel: true);
                          },
                          icon: const Icon(Icons.model_training),
                          tooltip: 'Load Model',
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getPaths() async {
    Constants.cachePath = await platform.invokeMethod('cacheDir');
    Constants.modelPath = await platform.invokeMethod('filesDir');
  }

  void postFrameCallBack() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      lockPortrait();
      await getPaths();
      loadModelAlertDialog();
    });
  }

  void loadModelAlertDialog({bool updateModel = false}) {
    modelContent = 'model.tflite is required to classify the cotton leaf.';
    bool modelExists = File('${Constants.modelPath}/model/model.tflite').existsSync();
    if (!modelExists || updateModel) {
      showDialog(
        barrierColor: Colors.black.withOpacity(0.7),
        barrierDismissible: updateModel ? true : false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Load Model'),
              content: Text(modelContent),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      loadModel(context, setState);
                    },
                    child: const Text('Choose File'))
              ],
            );
          });
        },
      );
    }
  }

  void initImagePicker() {
    imagePicker = ImagePickerAndroid();
    imagePicker.useAndroidPhotoPicker = true;
  }

  void loadModel(BuildContext context, StateSetter setState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    String pickedModelPath = result!.files.first.path!;

    if (!pickedModelPath.contains('.tflite')) {
      setState(() {
        modelContent = "Pick file that ends with '.tflite' extension.";
      });
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Model Loaded.')));
        Navigator.of(context).pop();
      });
    } else {
      String path = '${Constants.modelPath}/model';
      if (!Directory(path).existsSync()) {
        Directory(path).createSync(recursive: true);
        File('$path/model.tflite').createSync(recursive: true);
      }
      File(pickedModelPath).copySync('$path/model.tflite');
      FilePicker.platform.clearTemporaryFiles();
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Model Loaded.')));
        Navigator.of(context).pop();
      });
    }
  }

  void displayImage() {
    if (modelExists()) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return DisplayImage(imageFile: imageFile,);
      }));
    }
  }

  bool modelExists() {
    return File('${Constants.modelPath}/model/model.tflite').existsSync();
  }
}
