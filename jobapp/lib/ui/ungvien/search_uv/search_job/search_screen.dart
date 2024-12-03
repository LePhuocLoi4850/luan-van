import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> hotSearch = [
    'Lập trình viên',
    'Nhân viên kinh doanh',
    'Thực tập sinh'
  ];
  List<String> allNameJob = [];
  List<String> filteredHotSearch = [];
  @override
  void initState() {
    super.initState();
    _selectNameJob();
    _searchController.addListener(() {
      setState(() {
        filteredHotSearch = allNameJob.where((item) {
          return removeDiacritics(item.toLowerCase())
              .contains(removeDiacritics(_searchController.text.toLowerCase()));
        }).toList();
      });
    });
  }

  Future<void> _selectNameJob() async {
    try {
      allNameJob = await Database().selectAllNameJob();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: SizedBox(
                width: 400,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back_sharp)),
                    Expanded(
                      child: TextFormField(
                        style: const TextStyle(fontSize: 18),
                        textAlignVertical: TextAlignVertical.center,
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (value) {
                          Get.toNamed('/searchDetail', arguments: {
                            'searchText': _searchController.text
                          });
                        },
                        autofocus: true,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.emailAddress,
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xFFD0DBEA)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue),
                          ),
                          hintText: 'Địa điểm - Công ty - Vị trí - Ngành nghề',
                          hintStyle: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 201, 200, 200)),
                          prefixIcon: const Icon(
                            Icons.search,
                            size: 35,
                            color: Color.fromARGB(255, 190, 190, 190),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          enabled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 600,
              width: 400,
              child: _searchController.text.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15, left: 15),
                          child: Text(
                            'Từ khóa phổ biến',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: hotSearch.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _searchController.text = hotSearch[index];
                                  });
                                },
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(hotSearch[index]),
                                      const Divider()
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15, left: 15),
                          child: Text(
                            'Gợi ý tìm kiếm',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredHotSearch.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(filteredHotSearch[index]),
                                      const Divider()
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
