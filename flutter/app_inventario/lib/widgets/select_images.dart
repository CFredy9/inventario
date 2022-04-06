import 'package:app_inventario/constants.dart';
import 'package:app_inventario/widgets/category.dart';
import 'package:app_inventario/widgets/images_category.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int optionSelected = 0;

  void checkOption(int index) {
    setState(() {
      optionSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: SizedBox(
        height: 550,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
            children: <Widget>[
              for (int i = 0; i < images.length; i++)
                CategoryCard(
                  title: images[i]['title'] as String,
                  image: images[i]['image'] as String,
                  press: () {
                    checkOption(i + 1);
                    imagenubi = images[i]['image'] as String;
                  },
                  isSelect: i + 1 == optionSelected,
                )
              /*ImageOption(
                  images[i]['title'] as String,
                  image: images[i]['image'] as String,
                  onTap: () {
                    checkOption(i + 1);
                    imagenubi = images[i]['image'] as String;
                  },
                  selected: i + 1 == optionSelected,
                )*/
            ],
          ),
        ),
      ),
    );
  }
}

class ImageOption extends StatelessWidget {
  const ImageOption(
    this.title, {
    Key? key,
    this.image,
    this.onTap,
    this.selected,
  }) : super(key: key);

  final String? title;
  final String? image;
  final VoidCallback? onTap;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(13),
      child: Ink.image(
        fit: BoxFit.cover,
        image: NetworkImage(image!),
        child: InkWell(
          onTap: onTap,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ?? false ? ColorF : Colors.transparent,
                    width: selected ?? false ? 10 : 0,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: selected ?? false
                        ? Colors.blue.withOpacity(0.8)
                        : Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    title ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 11),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
