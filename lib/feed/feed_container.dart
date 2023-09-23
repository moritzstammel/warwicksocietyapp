import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/event.dart';
import 'event_feed_card.dart';

class FeedContainer extends StatefulWidget {
  final List<Event> events;
  const FeedContainer({Key? key,required this.events}) : super(key: key);

  @override
  State<FeedContainer> createState() => _FeedContainerState();
}

class _FeedContainerState extends State<FeedContainer> {
  final _pageController = PageController();

  void scrollToNextPage(){

    if(_pageController.page == null || _pageController.page!.round() >= widget.events.length) return;
    final int currentPage = _pageController.page!.round();
    _pageController.animateToPage(currentPage +1, duration: Duration(milliseconds: 350), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {

    if(widget.events.isEmpty){
      return const Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(AssetImage('assets/icons/face-sad.png'),size: 132,),
          SizedBox(height: 16,),
          Text("Seems like there is nothing\ngoing on here",style: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: "Inter",
            color: Colors.black,
            fontSize: 16,
          ),textAlign: TextAlign.center,)
        ],
      ),);
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.events.length,
      itemBuilder: (context, index) {

        final event = widget.events[index];
        return EventFeedCard(event: event,scrollToNextPage: scrollToNextPage,);
      },
    );

  }
}
