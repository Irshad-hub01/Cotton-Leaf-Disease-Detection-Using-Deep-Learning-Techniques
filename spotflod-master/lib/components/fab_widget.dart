import 'package:flutter/material.dart';

class FabWidget extends StatelessWidget {
  const FabWidget({Key? key, this.fun}) : super(key: key);
  final Function? fun;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () async {
        if (fun != null){
          await fun!();
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      backgroundColor: Colors.white24,
      elevation: 0,
      tooltip: 'Back',
      child: const Icon(Icons.arrow_back, color: Colors.black38),
    );
  }
}
