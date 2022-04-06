import 'package:app_inventario/constants.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:meditation_app/constants.dart';

class CategoryCard extends StatelessWidget {
  final String? image;
  final String? title;
  final bool? isSelect;
  final VoidCallback? press;
  const CategoryCard({
    Key? key,
    this.image,
    this.title,
    this.isSelect,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: ColorF,
            ),
          ],
        ),
        child: Material(
          //color: (isSelect == true) ? ColorF : Colors.transparent,
          child: InkWell(
            focusColor: Colors.red,
            splashColor: ColorF,
            onTap: press,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelect ?? false ? ColorF : Colors.transparent,
                    width: isSelect ?? false ? 2 : 0,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.all(4.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  /*color: isSelect ?? false
                      ? Colors.blue.withOpacity(0.8)
                      : Colors.black54,*/
                  color: isSelect ?? false
                      ? ColorF.withOpacity(0.5)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 55,
                      //child: Image.asset(image!, fit: BoxFit.contain),
                      child: Image.network(image!, fit: BoxFit.contain),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      title ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isSelect ?? false ? Colors.white : Colors.black,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: <Widget>[
                  //Spacer(),
                  /*IconButton(
                          icon: const Icon(
                            Icons.fastfood_rounded,
                            color: ColorF,
                            size: 24,
                          ),
                          onPressed: () {}),*/
                  //SvgPicture.asset(svgSrc),
                  //Spacer(),
                  SizedBox(
                    height: 50,
                    //child: Image.asset(image!, fit: BoxFit.contain),
                    child: Image.network(image!, fit: BoxFit.contain),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: ColorF),
                    /*style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 15),*/
                  )
                ],
              ),
            ),*/
          ),
        ),
      ),
    );
  }
}
