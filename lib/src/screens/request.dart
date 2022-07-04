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
  var sort;

  RequestScreen({required this.type, required this.currentCategory, required this.sort});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  String _sellerName = '';
  TextEditingController searchController = TextEditingController();
  List allResults = [];
  List filteredResults = [];
  late Future resultsLoaded;
  final List<String> sortCategories = [
    'Default',
    'Price: high to low',
    'Price: low to high',
    'Deadline: latest to earliest',
    'Deadline: earliest to latest',
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getRequestList();
  }

  onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (searchController.text != '') {
      for (var request in allResults) {
        var title = request['Title'].toString().toLowerCase();

        if (title.contains(searchController.text.toLowerCase())) {
          showResults.add(request);
        }
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() => filteredResults = showResults);
  }

  getRequestList() async {
    await getSellerName();
    var data = widget.type == 'Available Requests' &&
            widget.currentCategory == 'All Requests'
        ? FirebaseFirestore.instance
            .collection('requests')
            .where('Seller Name', isEqualTo: 'null')
            .where('Deleted', isEqualTo: 'false')
        : widget.type == 'My Requests' &&
                widget.currentCategory == 'All Requests'
            ? FirebaseFirestore.instance
                .collection('requests')
                .where('Seller Name', isEqualTo: _sellerName)
                .where('Accepted', isEqualTo: 'true')
                .where('Deleted', isEqualTo: 'false')
            : widget.type == 'Available Requests'
                ? FirebaseFirestore.instance
                    .collection('requests')
                    .where('Category', isEqualTo: widget.currentCategory)
                    .where('Seller Name', isEqualTo: 'null')
                    .where('Deleted', isEqualTo: 'false')
                : FirebaseFirestore.instance
                    .collection('requests')
                    .where('Category', isEqualTo: widget.currentCategory)
                    .where('Seller Name', isEqualTo: _sellerName)
                    .where('Accepted', isEqualTo: 'true')
                    .where('Deleted', isEqualTo: 'false');
    var sortedData = widget.sort == 'Price: high to low'
      ? await data.orderBy('Price Double', descending: true).get()
      : widget.sort == 'Price: low to high'
      ? await data.orderBy('Price Double').get()
      : await data.get();
    setState(() => allResults = sortedData.docs);
    searchResultList();
    return sortedData.docs;
  }

  Future<String> getSellerName() async {
    final uid = AuthService().currentUser?.uid;
    DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection('sellers').doc(uid).get();
    setState(() => _sellerName = ds.get('Name'));
    return _sellerName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CompletedRequestsScreen()));
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
      body: Column(
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
                              sort: 'Default',
                            ),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          widget.type == 'Available Requests'
                              ? Colors.amber
                              : Colors.orange),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Available Requests',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
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
                              sort: 'Default',
                            ),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          widget.type == 'My Requests'
                              ? Colors.amber
                              : Colors.orange),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                    ),
                    child: const Text(
                      'My Requests',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0,),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Requests',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField(
              value: widget.sort,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.sort),
              ),
              items: sortCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text('$category'),
                );
              }).toList(),
              onChanged: (val) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => RequestScreen(
                      type: widget.type,
                      currentCategory: widget.currentCategory,
                      sort: val,
                    ),
                  ),
                );
              }
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: filteredResults.length,
              itemBuilder: (BuildContext context, int index) => SingleRequest(
                buyerName: filteredResults[index]['Buyer Name'],
                buyerID: filteredResults[index]['Buyer ID'],
                sellerName: filteredResults[index]['Seller Name'],
                category: filteredResults[index]['Category'],
                deadline: filteredResults[index]['Deadline'],
                description: filteredResults[index]['Description'],
                price: filteredResults[index]['Price'],
                title: filteredResults[index]['Title'],
                requestID: filteredResults[index]['Request ID'],
                accepted: filteredResults[index]['Accepted'],
                deleted: filteredResults[index]['Deleted'],
              ),
            ),
          ),
          NavigateBar(),
        ],
      ),
    );
  }
}
