import 'package:flutter/material.dart';
import '../../../ui/screens.dart';

class JobGirdTitle extends StatefulWidget {
  final Map<String, dynamic> jobData;

  const JobGirdTitle(this.jobData, {super.key});

  @override
  State<JobGirdTitle> createState() => _JobGirdTitleState();
}

bool isFavorite = false;

class _JobGirdTitleState extends State<JobGirdTitle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(widget.jobData['id']),
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
                          color: const Color.fromARGB(255, 200, 200, 200)),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              widget.jobData['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
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
                            widget.jobData['email'],
                            style: const TextStyle(
                                fontSize: 17,
                                color: Color.fromARGB(255, 158, 155, 145)),
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
                        widget.jobData['address'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.orange),
                      const Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Text('Lương: '),
                      ),
                      Text('${widget.jobData['salary']}')
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
