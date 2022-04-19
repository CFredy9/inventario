import 'package:flutter/material.dart';
import '../../../api/producto.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class SearchBar extends StatelessWidget {
  SearchBar({
    Key? key,
  }) : super(key: key);

  ProductoProvider productoT = ProductoProvider();

  /*searchDjango(value, value2) async {
    ProductoProvider.searchProducto(value2, value).then((responseBody) {
      List<dynamic> data = jsonDecode(responseBody);
      setState(() {
        data.forEach((value) {
          searchResults.add(value);
        });
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    productoT = Provider.of<ProductoProvider>(context);
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.5),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Buscar",
          //icon: SvgPicture.asset("assets/icons/search.svg"),
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
        /*onChanged: (value) {
            productoT.searchProducto('', value);
        },*/
      ),
    );
  }
}
