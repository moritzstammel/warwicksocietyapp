import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warwicksocietyapp/authentication/SocietyAuthentication.dart';
import 'package:warwicksocietyapp/chats/chat_details_screen.dart';
import 'package:warwicksocietyapp/chats/user_details_screen.dart';
import 'package:warwicksocietyapp/firebase_helper.dart';
import 'package:warwicksocietyapp/models/event_info.dart';
import '../authentication/FirestoreAuthentication.dart';
import '../models/chat.dart';
import '../models/message.dart';
import 'package:flutter/services.dart';

class ChatOpenedScreen extends StatefulWidget {
  final String chatId;

  ChatOpenedScreen({required this.chatId});

  @override
  _ChatOpenedScreenState createState() => _ChatOpenedScreenState();
}

class _ChatOpenedScreenState extends State<ChatOpenedScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = new ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late Stream<DocumentSnapshot> chatStream;
  late DocumentReference currentAuthor;
  final List<Message> selectedMessages = [];

  static const Map<int, String> _weekdayShortMap = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };
  void _setAuthor(){
    currentAuthor = (SocietyAuthentication.instance.isSociety) ?
        SocietyAuthentication.instance.societyInfo!.ref :
        FirestoreAuthentication.instance.firestoreUser!.ref;
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();


  }

  @override
  void initState() {
    super.initState();
    _setAuthor();

    chatStream = FirebaseFirestore.instance
        .collection("universities")
        .doc("university-of-warwick")
        .collection("chats")
        .doc(widget.chatId)
        .snapshots();

  }




  int daysBetween(DateTime from, DateTime to) {
    final difference = to.difference(from).inDays;
    return difference;
  }
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
  bool isYesterday(DateTime dateToCheck, DateTime referenceDate) {
    final yesterday = referenceDate.subtract(Duration(days: 1));
    return dateToCheck.year == yesterday.year &&
        dateToCheck.month == yesterday.month &&
        dateToCheck.day == yesterday.day;
  }


  String formatTime(DateTime dateTime) {

    DateTime now = DateTime.now();
    int difference = daysBetween(dateTime, now);
    String date = '';

    if(isSameDay(dateTime,now)){
      date = '';
    }
    else if (isYesterday(dateTime,now)) {
      date = 'yesterday, ';
    } else if (difference <= 6) {
      date = '$difference day${difference==1 ? "":"s"} ago, ';
    } else if(difference > 6) {
      date = '${dateTime.day}.${dateTime.month} ';
    }

    // Same day but different times
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    //String period = dateTime.hour < 12 ? 'AM' : 'PM';
    String time = "sent ${date}at $hour:$minute";
    return time;}


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(
      stream: chatStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chat = Chat.fromJson(
            snapshot.data!.data() as Map<String, dynamic>, widget.chatId);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: selectedMessages.isEmpty ? defaultAppBar(chat) : inSelectingMessagesAppBar(chat),
          body: Container(
            padding: EdgeInsets.only(top: 8),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Flexible(


                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,


                        physics: BouncingScrollPhysics(),

                        controller: _scrollController,
                        itemCount: chat.messages.length + (chat.isEventChat ? 1 : 0),
                        itemBuilder: (context, index) {
                          if(chat.isEventChat && index == chat.messages.length) return eventCoreDates(chat.eventInfo!);
                          Message message = chat.messages[chat.messages.length - 1 - index];
                          bool isUserMessage = (message.author == currentAuthor);


                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (selectedMessages.isNotEmpty) ? (){
                             
                                setState(() {
                                  if(selectedMessages.contains(message)){
                                    selectedMessages.remove(message);
                                  }
                                  else{
                                    selectedMessages.add(message);
                                  }
                                  
                                });
                            } : null,
                            onLongPress:  () {
                              setState(() {
                                selectedMessages.add(message);
                              });


                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                              margin: EdgeInsets.symmetric(vertical: 3),
                              color: selectedMessages.contains(message) ? Color(0xFFEEEEEE) : null,

                              child: Row(

                                  mainAxisAlignment: isUserMessage ? MainAxisAlignment
                                      .end : MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (!isUserMessage)
                                      GestureDetector(
                                        onTap: (message.authorIsUser &&  selectedMessages.isEmpty) ? () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserDetailsScreen(userRef: message.author),
                                          ),
                                        ) : null,
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                 message.authorIsSociety? chat.societyInfo.logoUrl : chat.users[message.author.id]!.imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(width: 8,),
                                    Column(
                                      crossAxisAlignment: isUserMessage
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.translucent,

                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: isUserMessage
                                                  ? Colors.black
                                                  : Color(0xFFF7F7F7),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            constraints: BoxConstraints(
                                              maxWidth: 250,
                                            ),
                                            child: Text(
                                              message.isDeleted ? "This message was deleted" : message.content,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 16,
                                                color: isUserMessage
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontStyle: message.isDeleted?FontStyle.italic : FontStyle.normal
                                              ),

                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4,),
                                        Row(
                                          children: [
                                            if (!isUserMessage)
                                              GestureDetector(
                                                onTap: (selectedMessages.isEmpty) ? () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => UserDetailsScreen(userRef: message.author),
                                                  ),
                                                ) : null,
                                                child: Text(
                                                   message.authorIsSociety? chat.societyInfo.name : chat.users[message.author.id]!.fullName, style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                ),),
                                              ),
                                            if (!isUserMessage) SizedBox(width: 2,),
                                            Text(formatTime(
                                                message.createdAt),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xFF888888)
                                              ),)

                                          ],
                                        )
                                      ],
                                    ),
                                  ]
                              ),
                            ),
                          );
                        },
                      ),
                    ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Container(

                          height: 56,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    focusNode: _focusNode,
                                    controller: _messageController,
                                    decoration: InputDecoration(
                                      hintText: "Type your message here...",
                                      hintStyle: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        color: Color(0xFF777777),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () => sendMessage(chat),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: ImageIcon(
                              AssetImage('assets/icons/chats/send.png'),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        );
      },
    );
  }



  void sendMessage(Chat chat) async {
    final content = _messageController.text;
    if (content
        .trim()
        .isEmpty) return;

    Timestamp now = Timestamp.now();

    final chatRef = FirebaseFirestore.instance
        .collection('universities')
        .doc('university-of-warwick')
        .collection('chats')
        .doc(chat.id);

    await chatRef.update({
      'messages': FieldValue.arrayUnion([
        {
          'author': currentAuthor,
          'content': content,
          'is_deleted': false,
          'created_at': now
        }
      ]),
      'time_of_last_message': now
    });

    _messageController.clear();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );

  }

  Widget eventCoreDates(EventInfo event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container( width: 1, height: 20, color: Color(0xFFD9D9D9),),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ImageIcon(
          AssetImage('assets/icons/events/location.png'),
          size: 14,
        ),
          SizedBox(width: 4),
          Text(
            event.location,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Inter',
              color: Color(0xFF333333),
            ),
          )],),
        SizedBox(height: 8,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage('assets/icons/events/clock.png'),
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              '${_weekdayShortMap[event.startTime.weekday]}, ${event.startTime.hour.toString().padLeft(2, '0')}:${event.startTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                color: Color(0xFF333333),
              ),
            ),
            SizedBox(width: 4),
            ImageIcon(
              AssetImage('assets/icons/events/calendar.png'),
              size: 16,
            ),

            SizedBox(width: 4),
            Text(
              '${event.startTime.day.toString().padLeft(2, '0')}.${event.startTime.month.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Inter',
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        SizedBox(height: 8,),
        Container( width: 1, height: 20, color: Color(0xFFD9D9D9),),
        SizedBox(height: 8,),
      ],
    );
  }

  AppBar defaultAppBar(Chat chat) {
    return AppBar(
      elevation: 0.2,
      backgroundColor: Colors.white,
      leading:  IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailsScreen(chat: chat),
              ),
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(chat.societyInfo.logoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.isEventChat ? chat.eventInfo!.title : chat.societyInfo.name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      chat.isEventChat ? chat.societyInfo.name : "Society chat",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
      actions: <Widget>[
      IconButton(
      icon: Icon(Icons.more_vert_rounded,color: Colors.black,),
      onPressed: () {
      // Handle delete action here
      },
      )],
    );
  }

  AppBar inSelectingMessagesAppBar(Chat chat) {
    return AppBar(
      elevation: 0.2,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back,color: Colors.black,),
        onPressed: () {
          setState(() {
            selectedMessages.clear();
          });
        },
      ),
      title: Text("${selectedMessages.length} selected",style: TextStyle(color: Colors.black),),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.content_copy,color: Colors.black,),
          onPressed: () async {
            String text = "";
            if(selectedMessages.length == 1){
              Message message = selectedMessages.first;
              text =  message.isDeleted ? "This message was deleted" : message.content;}
            else{
              List<String> formattedMessages = [];
              for(final message in selectedMessages){
               String name = message.authorIsSociety? chat.societyInfo.name : chat.users[message.author.id]!.fullName;
               String date = formatDateTime(message.createdAt);
               String content =  message.isDeleted ? "This message was deleted" : message.content;
               formattedMessages.add("($date) $name: $content");
              }
              text = formattedMessages.join("\n");

            }

            await Clipboard.setData(ClipboardData(text: text));
            setState(() {
              selectedMessages.clear();
            });

            // copied successfully
          },
        ),
        if(currentAuthor.path.contains("societies") || selectedMessages.every((message) => message.author == currentAuthor))
        IconButton(
          icon: Icon(Icons.delete,color: Colors.black,),
          onPressed: () async {
            await FirestoreHelper.instance.deleteMessages(chat,selectedMessages);
            setState(() {
              selectedMessages.clear();
            });
          },
        ),

      ],

    );


  }
  String formatDateTime(DateTime dateTime) => '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}
