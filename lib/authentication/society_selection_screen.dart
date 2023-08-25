import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Society {
  final String name;
  final String logoUrl;
  bool isSelected;

  Society({required this.name, required this.logoUrl, this.isSelected = false});
}

class SocietySelectionScreen extends StatefulWidget {
  @override
  _SocietySelectionScreenState createState() => _SocietySelectionScreenState();
}

class _SocietySelectionScreenState extends State<SocietySelectionScreen> {
  List<Society> societies = [];
  List<Society> selectedSocieties = []; // To store selected societies

  @override
  void initState() {
    super.initState();
    _loadSocieties();
  }

  Future<void> _loadSocieties() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('universities')
        .doc('university-of-warwick')
        .collection('societies')
        .get();

    List<Society> loadedSocieties = snapshot.docs.map((doc) {
      return Society(
        name: doc['name'],
        logoUrl: doc['logo'],
      );
    }).toList();

    setState(() {
      societies = loadedSocieties;
    });
  }

  void _toggleSocietySelection(int index) {
    setState(() {
      societies[index].isSelected = !societies[index].isSelected;
      if (societies[index].isSelected) {
        selectedSocieties.add(societies[index]);
      } else {
        selectedSocieties.remove(societies[index]);
      }
    });
  }

  void _printSelectedSocieties() {
    for (Society society in selectedSocieties) {
      print(society.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Society Selection"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Search Society",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              // Implement search logic here
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: societies.length,
              itemBuilder: (context, index) {
                Society society = societies[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      _toggleSocietySelection(index);
                    },
                    leading: Image.network(
                      society.logoUrl,
                      fit: BoxFit.fitHeight,
                    ),
                    title: Text(society.name),
                    trailing: society.isSelected
                        ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _printSelectedSocieties();
            },
            child: Text("Continue"),
          ),
        ],
      ),
    );
  }
}
