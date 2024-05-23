import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';

class ItemChat extends StatelessWidget {
  const ItemChat({
    super.key,
    required this.isSender,
    required this.msg,
    required this.time,
    required this.isFirst,
  });

  final bool isSender;
  final bool isFirst;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isFirst ? 8 : 4,
        horizontal: 16,
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showPopover(
                context: context,
                bodyBuilder: (context) => const ListItems(),
                onPop: () => print('Popover was popped!'),
                direction: PopoverDirection.top,
                // contentDyOffset: 1,
                // contentDxOffset: 1,
                width: 50,
                height: 200,
                arrowHeight: 0,
                arrowWidth: 0,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSender ? Colors.blue.shade500 : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: (isSender
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.grey.withOpacity(0.2)),
                    spreadRadius: 1,
                    blurRadius: 18,
                    offset: const Offset(0, 1.4), // changes position of shadow
                  ),
                ],
                borderRadius: isSender
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
              ),
              padding: const EdgeInsets.all(15),
              child: Text(
                msg,
                style: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(DateFormat.Hm().format(DateTime.parse(time))),
        ],
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry A')),
            ),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(child: Text('Entry B')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[300],
            child: const Center(child: Text('Entry C')),
          ),
        ],
      ),
    );
  }
}
