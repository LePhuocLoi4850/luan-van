import 'package:flutter/material.dart';
import '../../../models/career.dart';
import '../../../models/location.dart';
import '../../screens.dart';

class SearchScreenU extends StatefulWidget {
  const SearchScreenU({super.key});

  @override
  State<SearchScreenU> createState() => _SearchScreenUState();
}

class _SearchScreenUState extends State<SearchScreenU> {
  final _searchController = TextEditingController();
  CareerManager careerManager = CareerManager();
  Career? selectedCareer;
  LocationManager locationManager = LocationManager();
  Location? selectedLocation;
  final FocusNode _focusNode = FocusNode();
  List<dynamic> jobList = [];
  List<dynamic> filteredJobList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<dynamic> data = await DatabaseConnection().selectAllJobs();
    setState(() {
      jobList = data;
      filteredJobList = data;
      print(data);
    });
  }

  void _filterJobList() {
    setState(() {
      filteredJobList = jobList.where((job) {
        final nameMatch = removeDiacritics(job[1].toLowerCase())
            .contains(removeDiacritics(_searchController.text.toLowerCase()));

        final careerMatch =
            selectedCareer == null ? true : job[5] == selectedCareer!.name;

        final locationMatch = selectedLocation == null
            ? true
            : removeDiacritics(job[3].toLowerCase()).contains(
                removeDiacritics(selectedLocation!.name.toLowerCase()));
        print(locationMatch);
        print(careerMatch);
        return nameMatch && careerMatch && locationMatch;
      }).toList();
    });
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  void _showCareerListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: careerManager.allCareer.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(careerManager.allCareer[index].name),
              onTap: () {
                setState(() {
                  selectedCareer = careerManager.allCareer[index];
                });
                Navigator.pop(context);
                _filterJobList();
              },
            );
          },
        );
      },
    );
  }

  void _showLocationListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: locationManager.allLocation.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(locationManager.allLocation[index].name),
              onTap: () {
                setState(() {
                  selectedLocation = locationManager.allLocation[index];
                });
                Navigator.pop(context);
                _filterJobList();
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 050,
                  child: TextField(
                    autofocus: false,
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      setState(() {
                        _filterJobList();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Nhập từ khóa tìm kiếm',
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 214, 214, 214),
                            width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  _showCareerListBottomSheet(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius:
                          BorderRadius.circular(10), // Độ cong của góc
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedCareer?.name ?? 'Ngành nghề',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_sharp,
                              color: Colors.black87),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _showLocationListBottomSheet(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedLocation?.name ?? 'Địa điểm',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_sharp,
                              color: Colors.black87),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      selectedCareer = null;
                      selectedLocation = null;
                      _searchController.clear();
                      _unfocus();
                      _filterJobList();
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 255, 255, 255),
                  ),
                  elevation: MaterialStateProperty.all<double>(0),
                ),
                child: const Text(
                  'Clear all',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredJobList.length,
              itemBuilder: (context, index) {
                final job = filteredJobList[index];
                return Container(
                  width: 390,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 200, 200, 200)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailScreen(job[0]),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 200, 200, 200)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/images/imageJ.jpg',
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            job[1],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isFavorite = !isFavorite;
                                            });
                                          },
                                          icon: FaIcon(isFavorite
                                              ? FontAwesomeIcons.solidHeart
                                              : FontAwesomeIcons.heart),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.where_to_vote_rounded,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          job[2],
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Color.fromARGB(
                                                  255, 158, 155, 145)),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        )
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.share_location_outlined,
                                      color: Colors.orange,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text('Địa chỉ: '),
                                    ),
                                    Text(
                                      job[3],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.monetization_on,
                                        color: Colors.orange),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 6.0),
                                      child: Text('Lương: '),
                                    ),
                                    Text('${job[4]}')
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  removeDiacritics(lowerCase) {}
}

// import 'package:flutter/material.dart';
// import '../../../models/career.dart';
// import '../../../models/location.dart';

// class SearchScreenU extends StatefulWidget {
//   const SearchScreenU({super.key});

//   @override
//   State<SearchScreenU> createState() => _SearchScreenUState();
// }

// class _SearchScreenUState extends State<SearchScreenU> {
//   CareerManager careerManager = CareerManager();
//   Career? selectedCareer;
//   LocationManager locationManager = LocationManager();
//   Location? selectedLocation;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _showCareerListBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return ListView.builder(
//           itemCount: careerManager.allCareer.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(careerManager.allCareer[index].name),
//               onTap: () {
//                 setState(() {
//                   selectedCareer = careerManager.allCareer[index];
//                 });
//                 Navigator.pop(context); // Đóng bottom sheet
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showLocationListBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return ListView.builder(
//           itemCount: locationManager.allLocation.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(locationManager.allLocation[index].name),
//               onTap: () {
//                 setState(() {
//                   selectedLocation = locationManager.allLocation[index];
//                 });
//                 Navigator.pop(context); // Đóng bottom sheet
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         flexibleSpace: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: TextField(
//                   autofocus: false,
//                   decoration: InputDecoration(
//                     hintText: 'Nhập từ khóa tìm kiếm',
//                     filled: true,
//                     fillColor: const Color.fromARGB(255, 255, 255, 255),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: const BorderSide(
//                           color: Color.fromARGB(255, 214, 214, 214),
//                           width: 2.0),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           const BorderSide(color: Colors.grey, width: 1.0),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                         vertical: 10, horizontal: 16),
//                     prefixIcon: const Icon(Icons.search),
//                   ),
//                   onSubmitted: (String searchTerm) {},
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               InkWell(
//                 onTap: () {
//                   _showCareerListBottomSheet(context);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: 180,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.grey,
//                         width: 1,
//                       ),
//                       borderRadius:
//                           BorderRadius.circular(10), // Độ cong của góc
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10, right: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               selectedCareer?.name ?? 'Ngành nghề',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Icon(Icons.arrow_drop_down_sharp,
//                               color: Colors.black87),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   _showLocationListBottomSheet(context);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(
//                     width: 180,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.grey,
//                         width: 1,
//                       ),
//                       borderRadius:
//                           BorderRadius.circular(10), // Độ cong của góc
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10, right: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               selectedLocation?.name ?? 'Địa điểm',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const Icon(Icons.arrow_drop_down_sharp,
//                               color: Colors.black87),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     selectedCareer = null;
//                     selectedLocation = null;
//                   });
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                     const Color.fromARGB(255, 255, 255, 255),
//                   ),
//                   elevation: MaterialStateProperty.all<double>(0),
//                 ),
//                 child: const Text(
//                   'Xóa tất cả',
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
