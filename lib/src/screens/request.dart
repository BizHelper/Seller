import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/src/screens/completedRequests.dart';
import 'package:seller_app/src/screens/login.dart';
import 'package:seller_app/src/screens/requestChat.dart';
import 'package:seller_app/src/services/authService.dart';
import 'package:seller_app/src/widgets/categories.dart';
import 'package:seller_app/src/widgets/navigateBar.dart';
import 'package:seller_app/src/widgets/singleRequest.dart';

class RequestScreen extends StatefulWidget {
  var type;
  var currentCategory;

  RequestScreen({required this.type, required this.currentCategory});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => RequestChatScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.domain_verification),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CompletedRequestsScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService().auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
        title: const Text(
          'Request',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.type == 'Available Requests' && widget.currentCategory == 'All Requests'?
        FirebaseFirestore.instance.collection('requests')
            .where('Seller Name', isEqualTo: 'null')
            .where('Deleted', isEqualTo: 'false')
            .snapshots() :
        widget.type == 'My Requests' && widget.currentCategory == 'All Requests' ?
        FirebaseFirestore.instance.collection('requests')
            .where('Seller Name', isEqualTo: getName())
            .where('Accepted', isEqualTo: 'true')
            .where('Deleted', isEqualTo: 'false')
            .snapshots() :
        widget.type == 'Available Requests' ?
        FirebaseFirestore.instance.collection('requests')
            .where('Category', isEqualTo: widget.currentCategory)
            .where('Seller Name', isEqualTo: 'null')
            .where('Deleted', isEqualTo: 'false')
            .snapshots() :
        FirebaseFirestore.instance.collection('requests')
            .where('Category', isEqualTo: widget.currentCategory)
            .where('Seller Name', isEqualTo: getName())
            .where('Accepted', isEqualTo: 'true')
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
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.type != 'Available Requests') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => RequestScreen(
                                  type: 'Available Requests',
                                  currentCategory: widget.currentCategory,
                                ),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            widget.type == 'Available Requests'? Colors.amber : Colors.orange
                          ),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Available Requests',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.type != 'My Requests') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => RequestScreen(
                                  type: 'My Requests',
                                  currentCategory: widget.currentCategory,
                                ),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            widget.type == 'My Requests' ? Colors.amber : Colors.orange
                          ),
                          shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                        ),
                        child: const Text(
                          'My Requests',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Categories(
                currentCategory: widget.currentCategory,
                currentPage: widget.type,
              ),
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
              NavigateBar(),
            ],
          );
        }
      ),
    );
  }
}
