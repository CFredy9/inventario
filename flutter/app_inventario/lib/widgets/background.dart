import 'package:app_inventario/constants.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget? child;
  const Background({
    Key? key,
    @required this.child,
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
            top: -80,
            left: -80,
            child: Image.asset(
              "assets/main_top2.png",
              width: size.width,
              color: ColorF,
            ),
          ),
          Positioned(
            top: size.height * 0.78,
            //bottom: -70,
            right: -30,
            child: Image.asset(
              "assets/login_bottom.png",
              width: size.width * 0.9,
              color: ColorF,
            ),
          ),
          child!,
        ],
      ),
    );
  }
}
