import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/home.dart';
import 'package:seller_app/src/screens/myRequests.dart';
import 'package:seller_app/src/screens/request.dart';
import 'package:seller_app/src/screens/requestCategory.dart';

class Categories extends StatelessWidget {
  var currentCategory;
  var currentPage;

  Categories({this.currentCategory,
    this.currentPage
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            currentPage == 'Home' ?
            CategoryButton(
              text: 'All Products',
              currentCategory: currentCategory,
              currentPage: currentPage,
            ) :
            CategoryButton(
              text: 'All Requests',
              currentCategory: currentCategory,
              currentPage: currentPage,
            ),
            CategoryButton(
              text: 'Bags & Wallets',
              currentCategory: currentCategory,
              currentPage: currentPage,
            ),
            CategoryButton(
              text: 'Women\'s Clothes',
              currentCategory: currentCategory,
              currentPage: currentPage,
            ),
            CategoryButton(
              text: 'Men\'s Clothes',
              currentCategory: currentCategory,
              currentPage: currentPage,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CategoryButton(
              text: 'Food & Beverage',
              currentCategory: currentCategory,
              currentPage: currentPage,
            ),
            CategoryButton(
              text: 'Accessories',
              currentCategory: currentCategory,
              currentPage: currentPage,
            ),
            CategoryButton(
              text: 'Toys & Games',
              currentCategory: currentCategory,
              currentPage: currentPage,
            ),
            CategoryButton(
              text: 'Others',
              currentCategory: currentCategory,
              currentPage: currentPage,
            ),
          ],
        ),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  var currentCategory;
  var currentPage;
  var text;

  CategoryButton({this.text, this.currentCategory, this.currentPage});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (text == 'All Products') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => HomeScreen(currentCategory: 'All Products',)));
        } else if (text == 'All Requests' && currentPage == 'Available Requests') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => RequestScreen()));
        } else if (text == 'All Requests' && currentPage == 'My Requests') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => MyRequestsScreen()));
        } else if (currentPage == 'Home') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => HomeScreen(currentCategory: text)));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => RequestCategoryScreen(currentCategory: text, currentPage: currentPage,)));
        }
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Container(
        color: text == currentCategory ? Colors.amber : Colors.orange,
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(
            text == 'Others' ? '   Others   ' : '$text',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
