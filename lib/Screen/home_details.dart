import 'package:api_call_demo/ApiCalling/api_service.dart';
import 'package:flutter/material.dart';

class HomeDetailsScreen extends StatefulWidget {
  final int id;
  const HomeDetailsScreen({super.key, required this.id});

  @override
  State<HomeDetailsScreen> createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  Map? getDataListId;
  bool isLoading = false;

  profile() async {
    setState(() {
      isLoading = true;
    });
    getDataListId = await ApiService.getListDataById(widget.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    profile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 3,
        centerTitle: true,
        title: const Text(
          "Home Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                tileColor: Colors.yellow.withOpacity(0.3),
                title: Text(getDataListId!["body"]),
              ),
            ),
    );
  }
}
