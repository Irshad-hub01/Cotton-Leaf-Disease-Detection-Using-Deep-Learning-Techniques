import 'package:flutter/material.dart';
import 'package:spotflod/components/fab_widget.dart';
import 'package:spotflod/components/text_widget.dart';
import 'package:spotflod/data/constants.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);
  static const id = '/about_page';

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  double? dp;

  List<String> fetchNames = ['amogh', 'irshad', 'sabeer', 'dp'];
  List<List<String>> projectMembers = [
    ['Amogh N', '3BR19CS008'],
    ['Irshad Ahmed C', '3BR19CS060'],
    ['Mohammed Sabeer', '3BR19CS088'],
    ['Durga Prasad A G', '3BR18CS043']
  ];

  @override
  Widget build(BuildContext context) {
    dp = MediaQuery.of(context).devicePixelRatio;
    print(dp);
    return Scaffold(
      backgroundColor: const Color(0XFFdbe7c8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextWidget('About',
                    fontSize: dp! > 3 ? 24 : 32, onBlueBg: false),
                projectTitleWidget(),
                projectMembersWidget(),
                projectGuideWidget(),
                collegeNameWidget(),
                aboutApp()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: const FabWidget(),
    );
  }

  gridImages() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: dp! > 3 ? 0.78 : 0.9,
      shrinkWrap: true,
      children: List.generate(4, (index) {
        return Card(
          elevation: 0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/project-members/${fetchNames[index]}.jpg",
                    height: dp! > 2.5 ? 100 : 150,
                    width: dp! > 2.5 ? 100 : 150,
                  ),
                ),
              ),
              TextWidget(
                projectMembers[index][0],
                fontSize: dp! > 3 ? 14 : 16,
                textAlign: TextAlign.center,
              ),
              TextWidget(
                projectMembers[index][1],
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      }),
    );
  }

  projectTitleWidget() {
    return const _AboutCardWidget(widgets: [
      _AboutCardTitleWidget(text: 'Cotton Leaf Disease Detection')
    ]);
  }

  projectMembersWidget() {
    return _AboutCardWidget(widgets: [
      const _AboutCardTitleWidget(text: 'Project Members'),
      gridImages()
    ]);
  }

  projectGuideWidget() {
    return _AboutCardWidget(
      widgets: [
        const _AboutCardTitleWidget(text: 'Project Guide'),
        Card(
          elevation: 0,
          color: const Color(0XFFbbece8),
          child: Column(
            children: const [
              TextWidget('Dr. Aradhana D', fontSize: 16),
              TextWidget('Professor - Dept of CS&E.'),
            ],
          ),
        ),
      ],
    );
  }

  collegeNameWidget() {
    return const _AboutCardWidget(widgets: [
      _AboutCardTitleWidget(
          text: 'Ballari Institute of Technology and Management')
    ]);
  }

  copyrightWidget() {
    return const TextWidget(
      'v1.0.0 \n2023 ©️ Bliszkot',
      textAlign: TextAlign.center,
      onBlueBg: false,
    );
  }

  openSourceLicensesWidget() {
    return ElevatedButton(
      onPressed: () {
        showLicensePage(context: context);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              Constants.colorScheme.tertiaryContainer)),
      child: const TextWidget('Open Source Licenses'),
    );
  }

  aboutApp() {
    return _AboutCardWidget(widgets: [
      Card(
        elevation: 0,
        child: Column(
          children: [copyrightWidget(), openSourceLicensesWidget()],
        ),
      )
    ]);
  }
}

class _AboutCardTitleWidget extends StatelessWidget {
  const _AboutCardTitleWidget({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: const Color(0XFFbbece8),
        child: TextWidget(text, fontSize: 22, textAlign: TextAlign.center));
  }
}

class _AboutCardWidget extends StatelessWidget {
  const _AboutCardWidget({Key? key, required this.widgets}) : super(key: key);

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      ),
    );
  }
}
