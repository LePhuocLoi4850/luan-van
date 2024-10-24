import 'package:flutter/material.dart';
import '../../../ui/screens.dart';

class ForYou extends StatelessWidget {
  const ForYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 80,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromARGB(255, 254, 249, 208)),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.medal,
                          size: 28,
                          color: Color.fromARGB(255, 248, 223, 0),
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Tích điểm',
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 80,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color.fromARGB(255, 253, 200, 197)),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.tags,
                            size: 28,
                            color: Color.fromARGB(255, 255, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Ưu đãi',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
