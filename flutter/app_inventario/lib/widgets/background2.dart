import 'package:app_inventario/constants.dart';
import 'package:flutter/material.dart';

class Background2 extends StatelessWidget {
  final Widget child;

  const Background2({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/top1.png",
              width: size.width,
              color: ColorF,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/top2.png",
              width: size.width,
              color: ColorF,
            ),
          ),
          Positioned(
            top: 50,
            right: 30,
            child: Image.asset("assets/logoF.png", width: size.width * 0.25),
          ),
          Positioned(
            top: size.height * 0.72,
            //bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/bottom1.png",
              width: size.width,
              color: ColorF,
            ),
          ),
          Positioned(
            top: size.height * 0.89,
            //bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/bottom2.png",
              width: size.width,
              color: ColorF,
            ),
          ),
          child
        ],
      ),
    );
  }
}
