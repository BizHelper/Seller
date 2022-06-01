import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListingForm extends StatefulWidget {
  const ListingForm({Key? key}) : super(key: key);

  @override
  State<ListingForm> createState() => _ListingFormState();
}

class _ListingFormState extends State<ListingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> categories = [
    'Bags & Wallets',
    'Female Clothing',
    'Male Clothing',
    'Food & Beverage',
    'Accessories',
    'Toys & Games',
    'Others'
  ];

  final textInputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.pink,
        width: 2.0,
      ),
    ),
  );

  String _currentName = '';
  String _currentURL = '';
  String _currentPrice = '';
  String _currentCategory = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Add Listing',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Shop Name'),
            validator: (val) => val!.isEmpty ? 'Please enter a name' : null,
            onChanged: (val) => setState(() => _currentName = val),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Image URL'),
            validator: (val) => val!.isEmpty ? 'Please insert image URL' : null,
            onChanged: (val) => setState(() => _currentURL = val),
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Price'),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
            validator: (val) => val!.isEmpty ? 'Please enter a price' : null,
            onChanged: (val) => setState(() => _currentPrice = double.parse(val).toStringAsFixed(2)),
          ),
          SizedBox(
            height: 20.0,
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(hintText: 'Category'),
            validator: (val) => val == null ? 'Please select category' : null,
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text('$category'),
              );
            }).toList(),
            onChanged: (val) => setState(() => _currentCategory = val.toString()),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange[600])),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                print(_currentName);
                print(_currentURL);
                print(_currentPrice);
                print(_currentCategory);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
