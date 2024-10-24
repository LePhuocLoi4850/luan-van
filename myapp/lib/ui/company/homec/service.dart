import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../ui/screens.dart';

class Service extends StatelessWidget {
  const Service({super.key});

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
                          color: const Color.fromARGB(255, 255, 212, 209)),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.chalkboardUser,
                          size: 28,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Dịch vụ',
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
                            color: const Color.fromARGB(255, 184, 255, 186)),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.wallet,
                            size: 28,
                            color: Color.fromARGB(255, 9, 160, 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Ví của tôi',
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
