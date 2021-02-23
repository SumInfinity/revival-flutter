import 'dart:developer';

import 'package:devotion/misc/StyleConstants.dart';
import 'package:devotion/models/Devotional.dart';
import 'package:devotion/util/NetworkingClass.dart';
import 'package:devotion/util/TimeHandler.dart';
import 'package:devotion/widgets/ChurchWidget.dart';
import 'package:devotion/widgets/DottedTabBarWidget.dart';
import 'package:devotion/widgets/ErrorNotification.dart';
import 'package:devotion/widgets/ImageAvatarListWidget.dart';
import 'package:devotion/widgets/CurvedCornerWidget.dart';
import 'package:devotion/widgets/AppScaffoldWidget.dart';
import 'package:devotion/widgets/ImageAvatarWidget.dart';
import 'package:devotion/widgets/LinearProgressWidget.dart';
import 'package:devotion/widgets/MapWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:devotion/models/Event.dart';

import 'models/Address.dart';
import 'models/User.dart';

var smallTextSyle = TextStyle(color: Colors.grey, fontSize: 12);
var largeWhiteTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
  letterSpacing: -0.14,
);
var smallWhiteTextStyle = TextStyle(
  color: Color(0xff998fa2),
  fontSize: 12,
  fontWeight: FontWeight.w500,
  letterSpacing: -0.19,
);
TextStyle italicStyle = const TextStyle(
  color: Color(0x70ffffff),
  letterSpacing: -0.24,
  fontSize: 12,
  fontWeight: FontWeight.w500,
  fontStyle: FontStyle.italic,
);

class SingleEventScreen extends StatefulWidget {
  @required
  final Event event;
  SingleEventScreen(this.event);
  @override
  _SingleEventScreenState createState() => _SingleEventScreenState();
}

class _SingleEventScreenState extends State<SingleEventScreen> {
  Event event;
  bool isLoading = true;
  @override
  void initState() {
    event = widget.event;
    super.initState();
    getEvent();
  }

  void getEvent() async {
    try {
      Map<String, dynamic> eventResponse =
          await NetworkingClass().get('/events/' + widget.event.id.toString());
      event = Event.fromJson(eventResponse['data']);
      setState(() {
        isLoading = false;
      });
    } catch (_) {
      log(_.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: EventAppBarWidget(event: event, isLoading: isLoading),
      paddingTop: 55,
      body: SingleEvent(event: event),
      bodyColor: trendingColors[2],
    );
  }
}

class SingleEvent extends StatelessWidget {
  final Event event;
  SingleEvent({
    this.event,
  });

  String getEventTimes() {
    String times = '';
    if (this.event.startingAt != null) {
      times += event.startingAt.hour.toString() +
          ':' +
          event.startingAt.minute.toString();
    }
    if (this.event.endingAt != null) {
      times += ' - ' +
          event.endingAt.hour.toString() +
          ':' +
          event.endingAt.minute.toString();
    }
    return times;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: <Widget>[
          CurvedCornerWidget(
            padding: EdgeInsets.only(top: 214),
            color: Colors.white,
            child: Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 22),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                    child: Container(
                      height: 240,
                      width: size.width,
                      child: Image.asset(
                        'images/avatar1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 21),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 18),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          event.poster?.images != null &&
                                  event.poster.images.isNotEmpty
                              ? event.poster.images[0].medium
                              : 'images/avatar1.jpg',
                          height: 35,
                          width: 35,
                        ),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Container(
                        width: size.width - 70 - 67,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              event.poster != null
                                  ? event.poster.name
                                  : event.user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.14,
                              ),
                            ),
                            event.poster != null
                                ? Text(
                                    event.posterType.toUpperCase(),
                                    style: TextStyle(
                                      color: Color(0x7A403249),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: -0.19,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  AreYouGoing(isGoing: event.attending, event: event),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 23, top: 20, right: 40),
            color: trendingColors[2],
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          getRelativeTime(event.startingAt),
                          style: largeWhiteTextStyle,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          getEventTimes(),
                          style: smallWhiteTextStyle,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'SINGLE OCCURENCE EVENT',
                          style: smallWhiteTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 29,
                ),
                for (var address in event.addresses ?? [])
                  AddressWidget(address: address),
                for (var church in event.churches ?? [])
                  ChurchWidget(church: church),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.person_outline,
                      color: Color(0xff757575),
                      size: 20,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(
                        'Hosted By ${event.user.name}',
                        style: largeWhiteTextStyle,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: event.description != null ? 30 : 0,
                ),
                Text(
                  event.description != null ? event.description : '',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xff998fa2),
                    letterSpacing: -0.14,
                  ),
                ),
                SizedBox(
                  height: 29,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xff757575),
                      size: 20,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Live Chats',
                            style: largeWhiteTextStyle,
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          event.attendees != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 30,
//                                    width: 200,
                                        child: ImageAvatarListWidget(
                                          images: event.attendees
                                              .take(7)
                                              .map((User e) => e.avatar)
                                              .toList(),
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        event.attendeesCount > 7
                                            ? '& ${event.attendeesCount} others'
                                            : ' Group chat',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xB0ffffff),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ],
                                )
                              : Container(
                                  child: Text('be the first to attend')),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressWidget extends StatelessWidget {
  const AddressWidget({
    Key key,
    @required this.address,
  }) : super(key: key);

  final Address address;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.location_on,
          color: Colors.white,
          size: 20,
        ),
        SizedBox(
          width: 20,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                address.address1,
                style: largeWhiteTextStyle,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${address.address2} ${address.city}, ${address.state} ${address.country}',
                style: smallWhiteTextStyle,
              ),
              SizedBox(
                height: 18,
              ),
              MapWidget(
                address: address != null ? address : null,
              ),
              SizedBox(height: 29),
            ],
          ),
        ),
      ],
    );
  }
}

class AreYouGoing extends StatefulWidget {
  final int isGoing;
  final Event event;
  const AreYouGoing({Key key, this.isGoing, @required this.event})
      : super(key: key);

  @override
  _AreYouGoingState createState() => _AreYouGoingState();
}

class _AreYouGoingState extends State<AreYouGoing> {
  bool isGoing;
  attendEvent() async {
    setState(() {
      this.isGoing = true;
    });
    Map<String, dynamic> liked = await NetworkingClass()
        .post('/events/' + widget.event.id.toString(), {'val': true});
    var res = liked['data'];
    if (res == true) {
      //already set
    } else {
      setState(() {
        this.isGoing = false;
      });
      //handle liking error
    }
  }

  absentEvent() async {
    setState(() {
      this.isGoing = false;
    });
    Map<String, dynamic> liked = await NetworkingClass()
        .post('/events/' + widget.event.id.toString(), {'value': false});
    var res = liked['data'];
    if (res == false) {
      //already done
    } else {
      setState(() {
        this.isGoing = true;
      });
    }
  }

  @override
  initState() {
    isGoing = widget.isGoing == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 27, top: 14, right: 5, bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: isGoing ? null : Border.all(color: Color(0xffE7E4E9)),
        color: isGoing ? Color(0xff352641) : Colors.white,
      ),
      child: Row(
        children: <Widget>[
          InkWell(
            child: Icon(
              Icons.open_in_browser,
              size: 24,
              color: isGoing ? Color(0xff998fa2) : Color(0xff757575),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                isGoing ? 'You are going' : 'Are you going?',
                style: TextStyle(
                  color: isGoing ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.14,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'Edit',
                style: smallTextSyle,
              )
            ],
          ),
          Spacer(),
          isGoing
              ? GestureDetector(
                  onTap: absentEvent,
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xff594f62),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
          GestureDetector(
            onTap: attendEvent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isGoing ? Color(0xff594f62) : Color(0xff58B2BE),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventAppBarWidget extends StatelessWidget {
  const EventAppBarWidget({
    Key key,
    @required this.event,
    @required this.isLoading,
  }) : super(key: key);

  final Event event;
  final bool isLoading;

  factory EventAppBarWidget.fromDevotional(
      {Devotional devotional, bool isLoading}) {
    Event event = Event();
    event.name = devotional.title;
    event.attendees = devotional.devotees;
    event.attendeesCount = devotional.devoteesCount;
    return EventAppBarWidget(event: event, isLoading: isLoading);
  }

  @override
  Widget build(BuildContext context) {
    return CurvedCornerWidget(
      height: 248,
      color: trendingColors[0],
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: <Widget>[
          isLoading ? LinearProgressWidget() : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.file_upload,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 56, right: 4),
            child: Column(
              children: [
                Text(
                  (event.name != null) ? event.name : '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.39,
                  ),
                ),
                SizedBox(height: 21),
                event.attendees != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ImageAvatarListWidget(
                            images: event.attendees
                                .take(7)
                                .map((User e) => e.avatar)
                                .toList(),
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              'Join ${event.attendees.take(2).map((e) => e.name).join(", ")} and ${event.attendeesCount} others',
                              style: italicStyle,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          ImageAvatarWidget(
                            imageURL:
                                event.user?.avatar ?? 'images/avatar1.jpg',
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Text(
                            '...Be the first to join?',
                            style: italicStyle,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
