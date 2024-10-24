import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/cv.dart';
import '../../../ui/screens.dart';

class ProfileGirdTitle extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileGirdTitle(this.userData, {super.key});

  @override
  State<ProfileGirdTitle> createState() => _ProfileGirdTitleState();
}

bool isFavorite = false;

class _ProfileGirdTitleState extends State<ProfileGirdTitle> {
  List<dynamic> application = [];
  String textStatus = 'Ứng tuyển';
  String calculateAge(String birthDateString) {
    final birthDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
        .parse(birthDateString); // Parse the date
    final now = DateTime.now();
    final difference = now.difference(birthDate);

    return (difference.inDays / 365).floor().toString();
  }

  @override
  void initState() {
    super.initState();
    if (widget.userData['status'] == 'withdrawn') {
      textStatus = 'Đã hủy';
    }
  }

  @override
  Widget build(BuildContext context) {
    String age = calculateAge(widget.userData['birthday'].toString());
    // final companyProvider =
    //     Provider.of<CompanyProvider>(context, listen: false);
    // String? emailc = companyProvider.email;
    return GestureDetector(
      onTap: () async {
        // application = await DatabaseConnection().selectApplication(
        //     widget.userData['email'].toString(),
        //     emailc!,
        //     widget.userData['jobId'].toString());
        // print(application[0]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyCV(widget.userData),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/users.png',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              widget.userData['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
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
                            Icons.cake_rounded,
                            color: Colors.amber,
                            size: 23,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 3),
                            child: Text(
                              '$age Tuổi',
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 158, 155, 145)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const FaIcon(
                            FontAwesomeIcons.venusMars,
                            color: Colors.amber,
                            size: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 3),
                            child: Text(
                              widget.userData['gender'],
                              style: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 158, 155, 145)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
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
                      const Icon(Icons.co_present_rounded,
                          color: Colors.orange),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('${widget.userData['career']}'),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.share_location_outlined,
                        color: Colors.orange,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          widget.userData['address'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '$textStatus:',
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        widget.userData['nameJob'],
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
