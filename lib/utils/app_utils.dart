import 'package:flutter/material.dart';

class spacer extends StatelessWidget {
  spacer({Key key, this.height, this.width}) : super(key: key);

  double height = 1;
  double width = 1;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}

class MyLoader extends StatelessWidget {
  MyLoader(
      {Key key,
      this.opacity: 0.9,
      this.dismissibles: false,
      this.color: Colors.black,
      this.loadingTxt: 'Loading...'})
      : super(key: key);

  final double opacity;
  final bool dismissibles;
  final Color color;
  final String loadingTxt;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: opacity,
          child: const ModalBarrier(dismissible: false, color: Colors.white),
        ),
        Center(
          child: loadingbar(color: Colors.blue, size: 70),
        ),
      ],
    );
  }
}

Widget loadingbar(
    {Color color = Colors.white,
    double size,
    Color bgColor = Colors.transparent}) {
  return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        backgroundColor: bgColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ));
}
