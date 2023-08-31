
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warwicksocietyapp/models/chat.dart';
import 'package:warwicksocietyapp/models/firestore_user.dart';

import '../authentication/FirestoreAuthentication.dart';
import 'chat_opened_screen.dart';

class ChatCard extends StatelessWidget {
  final FirestoreUser user = FirestoreAuthentication.instance.firestoreUser!;
  final Chat chat;

  ChatCard({required this.chat});



  String formatContent(String content) {
    const lengthLimit = 50;
    if (content.length > lengthLimit) {
      return '${content.substring(0, lengthLimit).trim()}...';
    } else {
      return content;
    }
  }

  String formatTime(DateTime time) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(time);

    if (difference.inDays == 0) {
      // Same day but different times
      String hour = time.hour.toString().padLeft(2, '0');
      String minute = time.minute.toString().padLeft(2, '0');
      String period = time.hour < 12 ? 'AM' : 'PM';
      return '$hour:$minute $period';
    } else if (difference.inDays <= 1) {
      // Yesterday
      return '1 day ago';
    } else if (difference.inDays <= 6) {
      
      return '${difference.inDays} days ago';
      
    } else if (difference.inDays <= 28) {
      // 1-6 weeks ago
      int weeks = (difference.inDays / 7).ceil();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      // More than 6 weeks ago, show months/years
      if (now.year == time.year) {
        // Same year, show month
        int months = now.month - time.month;
        return '$months month${months > 1 ? 's' : ''} ago';
      } else {
        // Different year, show year
        int years = now.year - time.year;
        return '$years year${years > 1 ? 's' : ''} ago';
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatOpenedScreen(chatId: chat.id),
          ),
        );
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(chat.societyInfo.logoUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chat.eventInfo.title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    chat.messages.isNotEmpty ? formatContent("${chat.messages.last.author.name}: ${chat.messages.last.isDeleted ? "(deleted)" : chat.messages.last.content}"): "Be the first to write a message",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Text(
              chat.timeOfLastMessage == null ? "" : formatTime(chat.timeOfLastMessage!),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
