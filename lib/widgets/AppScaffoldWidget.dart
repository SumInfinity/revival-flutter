import 'package:devotion/CreateEventScreen.dart';
import 'package:devotion/widgets/AppButtonWidget.dart';
import 'package:devotion/widgets/ImageAvatarWidget.dart';
import 'package:flutter/material.dart';

class AppScaffoldWidget extends StatelessWidget {
  final Widget body;
  final Color bodyColor;
  final Widget appBar;
  final double paddingTop;
  final IconData floatingButtonIcon;
  final bool showFloatingButton;
  final Function floatingButtonTap;
  final Widget fixedWidget;
  final Widget error;

  final scaffoldKey;

  AppScaffoldWidget({
    Key key,
    this.body,
    this.bodyColor = Colors.white,
    this.appBar,
    this.scaffoldKey,
    this.floatingButtonIcon = Icons.add,
    this.showFloatingButton,
    this.paddingTop = 73,
    this.floatingButtonTap,
    this.fixedWidget,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 325,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topRight: Radius.circular(80)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(80),
                  bottomLeft: Radius.circular(80),
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      'images/photo.png',
                      width: 325,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 250,
                      width: 325,
                      color: Color(0x9e241332),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 60, left: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageAvatarWidget(
                            size: 64,
                            borderColor: Colors.transparent,
                            imageURL: 'images/avatar2.jpg',
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Ekene Madunagu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            '@ekenemadunagu',
                            style: TextStyle(
                              color: Color(0x8fffffff),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 40, left: 27),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DrawerLink(title: 'Home'),
                  DrawerLink(title: 'Meetups'),
                  DrawerLink(title: 'Events', active: true),
                  DrawerLink(title: 'About Us'),
                  DrawerLink(title: 'Contact Us'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            height: size.height,
            width: size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ClampingScrollPhysics(),
              child: Container(
                width: size.width,
                color: bodyColor,
                padding: EdgeInsets.only(top: this.paddingTop),
                //here use navigation - radius as padding
                child: body,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            width: size.width,
            child: (appBar != null) ? appBar : Container(),
          ),
          Positioned(
            bottom: 56,
            right: 16,
            width: 56,
            height: 56,
            child: this.showFloatingButton == true
                ? InkWell(
                    onTap: floatingButtonTap
                    // () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => CreateEventScreen(),
                    //     ),
                    //   );
                    // }
                    ,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(25, 0, 0, 0),
                            blurRadius: 4,
                          )
                        ],
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Icon(floatingButtonIcon),
                    ),
                  )
                : Container(),
          ),
          (fixedWidget != null) ? fixedWidget : Container(),
          Positioned(
            top: 0,
            width: size.width,
            height: size.height,
            child:(error!=null)? Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.center,
              color: Color(0xa4998FA2),
              child: error,
            ): Container(),
          )
        ],
      ),
    );
  }
}

class DrawerLink extends StatelessWidget {
  final String title;
  final bool active;
  DrawerLink({
    this.title,
    this.active = false,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Container(
        decoration: active
            ? BoxDecoration(
                color: Color(0xff8A56AC),
                borderRadius: BorderRadius.circular(30),
              )
            : null,
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.only(left: 13, top: 9, bottom: 9, right: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.home, color: active ? Colors.white : Color(0xff817889)),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: active ? Colors.white : Color(0xff241332),
              ),
            )
          ],
        ),
      ),
    );
  }
}
