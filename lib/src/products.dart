import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var product_list = [
    {
      "name": "Wallet",
      "picture": "images/wallet.jpg",
      "shop_name": "Modern Times",
      "price": 50,
    },
    {
      "name": "Dress",
      "picture": "images/dress.jpg",
      "shop_name": "Modern Times",
      "price": 85,
    },
    {
      "name": "Shoes",
      "picture": "images/shoes.jpg",
      "shop_name": "Modern Times",
      "price": 120,
    },
    {
      "name": "Handbag",
      "picture": "images/handbag.jpg",
      "shop_name": "Modern Times",
      "price": 70,
    },
    {
      "name": "Watch",
      "picture": "images/watch.jpg",
      "shop_name": "Modern Times",
      "price": 60,
    },
    {
      "name": "Jeans",
      "picture": "images/jeans.jpg",
      "shop_name": "Modern Times",
      "price": 40,
    },
    {
      "name": "Necklace",
      "picture": "images/necklace.jpg",
      "shop_name": "Modern Times",
      "price": 30,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: product_list.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return Single_prod(
          prod_name: product_list[index]['name'],
          prod_picture: product_list[index]['picture'],
          prod_shop_name: product_list[index]['shop_name'],
          prod_price: product_list[index]['price'],
        );
      },
    );
  }
}

class Single_prod extends StatelessWidget {
  //const Single_prod({Key? key}) : super(key: key);

  final prod_name;
  final prod_picture;
  final prod_shop_name;
  final prod_price;

  Single_prod(
      {this.prod_name,
      this.prod_picture,
      this.prod_shop_name,
      this.prod_price});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: prod_name,
        child: Material(
          child: InkWell(
            onTap: () {},
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
                          child: Text(
                            '$prod_name',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
                          child: Text(
                            '\$$prod_price',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 4.0, bottom: 4.0),
                      child: Text('$prod_shop_name'),
                    ),
                  ],
                ),
              ),
              child: Image.asset(
                prod_picture,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
