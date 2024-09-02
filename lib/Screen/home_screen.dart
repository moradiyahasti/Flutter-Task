
import 'package:api_call_demo/Screen/home_details.dart';
import 'package:flutter/material.dart';
import 'package:api_call_demo/ApiCalling/api_service.dart';
import 'package:api_call_demo/Model/home_data_model.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GetApiList>? getData;
  bool isLoading = false;

  Map<int, bool> readItems = {};
  Map<int, int> timers = {};
  Map<int, Timer?> activeTimers = {};
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    fetchLocalData(); // Load data from local storage first
    fetchData(); // Fetch latest data from API
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // When scrolling starts, pause all active timers
    if (_scrollController.position.isScrollingNotifier.value) {
      pauseAllTimers();
    }
  }

  fetchLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    final String? readItemsString = prefs.getString('readItems');
    final String? timersString = prefs.getString('timers');
    final String? getDataString = prefs.getString('getData');

    setState(() {
      readItems = readItemsString != null
          ? Map<int, bool>.from(jsonDecode(readItemsString))
          : {};

      timers = timersString != null
          ? Map<int, int>.from(jsonDecode(timersString))
          : {};

      getData = getDataString != null
          ? (jsonDecode(getDataString) as List)
          .map((data) => GetApiList.fromJson(data))
          .toList()
          : [];
    });
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });

    final apiData = await ApiService.getListData();

    if (apiData != null) {
      getData = apiData;
      for (var item in getData!) {
        if (!timers.containsKey(item.id)) {
          timers[item.id] = Random().nextInt(16) + 10;
        }
        if (!readItems.containsKey(item.id)) {
          readItems[item.id] = false;
        }
      }
      saveLocalData();
    }

    setState(() {
      isLoading = false;
    });
  }

  saveLocalData() async {
    final prefs = await SharedPreferences.getInstance();

    String readItemsString = jsonEncode(readItems);
    String timersString = jsonEncode(timers);
    String getDataString = jsonEncode(getData!.map((e) => e.toJson()).toList());

    await prefs.setString('readItems', readItemsString);
    await prefs.setString('timers', timersString);
    await prefs.setString('getData', getDataString);
  }

  startTimer(int id) {
    if (activeTimers[id] != null) return;

    activeTimers[id] = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timers[id]! > 0) {
        setState(() {
          timers[id] = timers[id]! - 1;
        });
      } else {
        timer.cancel();
      }
    });
  }

  pauseTimer(int id) {
    activeTimers[id]?.cancel();
    activeTimers[id] = null;
  }

  pauseAllTimers() {
    activeTimers.forEach((id, timer) {
      timer?.cancel();
      activeTimers[id] = null;
    });
  }

  resumeTimer(int id) {
    if (timers[id]! > 0) {
      startTimer(id); // Resume timer from the current value
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 3,
        title: const Center(
          child: Text(
            "Home Screen",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : getData == null || getData!.isEmpty
          ? const Center(child: Text('No data available'))
          : ListView.builder(
        controller: _scrollController,
        itemCount: getData!.length,
        itemBuilder: (context, index) {
          final item = getData![index];
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: ListTile(
              onTap: () {
                setState(() {
                  readItems[item.id] = true;
                });
                pauseTimer(item.id); // Pause timer when navigating
                saveLocalData();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeDetailsScreen(id: item.id),
                  ),
                ).then((value) {
                  resumeTimer(item.id); // Resume the timer on return
                });
              },
              tileColor: readItems[item.id] == true
                  ? Colors.white
                  : Colors.yellow.withOpacity(0.3),
              title: Text(item.title),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${timers[item.id]}s"),
                  IconButton(
                    icon: const Icon(Icons.timer),
                    onPressed: () {
                      if (activeTimers[item.id] == null) {
                        startTimer(item.id);
                      } else {
                        pauseTimer(item.id);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

