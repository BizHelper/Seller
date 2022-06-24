import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/services/authService.dart';
import 'package:seller_app/src/widgets/singleRequest.dart';

class CompletedRequestsScreen extends StatefulWidget {
  const CompletedRequestsScreen({Key? key}) : super(key: key);

  @override
  State<CompletedRequestsScreen> createState() => _CompletedRequestsScreenState();
}

class _CompletedRequestsScreenState extends State<CompletedRequestsScreen> {
  String _sellerName = '';

  Future<String> getSellerName() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    setState(() => _sellerName = ds.get('Name'));
    return _sellerName;
  }

  String getName() {
    getSellerName();
    return _sellerName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        centerTitle: true,
        title: const Text(
          'Completed Requests',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('requests')
            .where('Seller Name', isEqualTo: getName())
            .where('Accepted', isEqualTo: 'completed')
            .where('Deleted', isEqualTo: 'false')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ListView(
                  children: snapshot.data!.docs.map(
                    (requests) {
                      return SingleRequest(
                        buyerName: requests['Buyer Name'],
                        buyerID: requests['Buyer ID'],
                        sellerName: requests['Seller Name'],
                        category: requests['Category'],
                        deadline: requests['Deadline'],
                        description: requests['Description'],
                        price: requests['Price'],
                        title: requests['Title'],
                        requestID: requests['Request ID'],
                        accepted: requests['Accepted'],
                        deleted: requests['Deleted'],
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
