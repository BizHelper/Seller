import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/requestDescription.dart';

class SingleRequest extends StatelessWidget {
  var buyerName;
  var buyerID;
  var sellerName;
  var category;
  var deadline;
  var description;
  var price;
  var title;
  var requestID;
  var accepted;
  var deleted;

  SingleRequest({
    this.buyerName,
    this.buyerID,
    this.sellerName,
    this.category,
    this.deadline,
    this.description,
    this.price,
    this.title,
    this.requestID,
    this.accepted,
    this.deleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'By: ' + buyerName,
            ),
            Text(
              'Price: \$' + price,
            ),
            Text(
              'Deadline: ' + deadline,
            ),
          ],
        ),
        trailing: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestDescriptionScreen(
              buyerName: buyerName,
              buyerID: buyerID,
              sellerName: sellerName,
              category: category,
              deadline: deadline,
              description: description,
              price: price,
              title: title,
              requestID: requestID,
              accepted: accepted,
              iconButton: true,
              deleted: deleted,
            )));
          },
          child: Column(
            children: [
              Icon(
                Icons.info,
                size: 28.0,
                color: Colors.brown[500]
              ),
              Text(
                'Find out more!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
