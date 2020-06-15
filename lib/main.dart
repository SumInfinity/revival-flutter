import 'package:devotion/CreateEventScreen.dart';
import 'package:devotion/MyProfileScreen.dart';
import 'package:devotion/PlayerScreen.dart';
import 'package:devotion/blocs/authentication.bloc.dart';
import 'package:devotion/events/AuthenticationEvent.dart';
import 'package:devotion/repositories/UserRepository.dart';
import 'package:devotion/states/AuthenticationState.dart';
import 'package:devotion/widgets/CurvedCornerWidget.dart';
import 'package:devotion/LoginScreen.dart';
import 'package:devotion/widgets/ImageAvatarListWidget.dart';
import 'package:devotion/widgets/LoadingIndicator.dart';
import 'package:devotion/widgets/MainNavigationBarWidget.dart';
import 'package:devotion/NotificationScreen.dart';
import 'package:devotion/SplashScreen.dart';
import 'package:devotion/OnBoardingScreen.dart';
import 'package:devotion/ProfileScreen.dart';
import 'package:devotion/FeedsScreen.dart';
import 'package:devotion/SingleEventScreen.dart';
import 'package:devotion/widgets/ScaffoldDesignWidget.dart';
import 'package:devotion/widgets/TrendingWidget.dart';
import 'package:devotion/misc/StyleConstants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:animations/animations.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AuthenticationStarted());
      },
      child: MyApp(userRepository: userRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp({Key key, @required this.userRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return SplashScreen();
          }
          if (state is AuthenticationSuccess) {
            return MainScreen();
          }
          if (state is AuthenticationFailure) {
            return LoginScreen(userRepository: userRepository);
          }
          if (state is AuthenticationInProgress) {
            return LoadingIndicator();
          }
        },
      ),
      title: 'Devotion',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

var appTheme = ThemeData(
  fontFamily: 'Montserrat',
  primaryColor: Color(0xff8a56ac),
  accentColor: Color(0xffd47fa6),
);

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    this._tabController =
        TabController(vsync: this, length: navigationItems.length);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print('width: ');
    print(width.toString());
    return ScaffoldDesignWidget(
      bodyColor: trendingColors[0],
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: TabBarView(controller: _tabController, children: [
          SingleChildScrollView(child: MyProfileScreen()),
          SingleChildScrollView(
            child: this.organiseStack(
              [
                CurvedListItem(
                  title: 'Practice French, English And Chinese',
                  time: 'TUESDAY 5:30 PM',
                  position: 0,
                  icon: Icons.public,
                ),
                CurvedListItem(
                  title: 'Yoga and Meditation for Beginners',
                  time: 'TODAY 5:30 PM',
                  icon: Icons.flight_land,
                  position: 1,
                ),
                CurvedListItem(
                  title: 'Practice French, English And Chinese',
                  time: 'TUESDAY 5:30 PM',
                  icon: Icons.hotel,
                  position: 2,
                ),
                CurvedListItem(
                  title: 'Yoga and Meditation for Beginners',
                  time: 'TODAY 5:30 PM',
                  icon: Icons.flight_land,
                  position: 1,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: this.organiseStack(
              [
                CurvedListItem(
                  title: 'Practice French, English And Chinese',
                  time: 'TUESDAY 5:30 PM',
                  position: 0,
                  icon: Icons.public,
                ),
                CurvedListItem(
                  title: 'Yoga and Meditation for Beginners',
                  time: 'TODAY 5:30 PM',
                  icon: Icons.flight_land,
                  position: 1,
                ),
                CurvedListItem(
                  title: 'Practice French, English And Chinese',
                  time: 'TUESDAY 5:30 PM',
                  icon: Icons.hotel,
                  position: 2,
                ),
                CurvedListItem(
                  title: 'Yoga and Meditation for Beginners',
                  time: 'TODAY 5:30 PM',
                  icon: Icons.flight_land,
                  position: 1,
                ),
              ],
            ),
          ),
          this.organiseStack(
            [
              CurvedListItem(
                title: 'Practice French, English And Chinese',
                time: 'TUESDAY 5:30 PM',
                position: 0,
                icon: Icons.public,
              ),
              CurvedListItem(
                title: 'Yoga and Meditation for Beginners',
                time: 'TODAY 5:30 PM',
                icon: Icons.flight_land,
                position: 1,
              ),
              CurvedListItem(
                title: 'Practice French, English And Chinese',
                time: 'TUESDAY 5:30 PM',
                icon: Icons.hotel,
                position: 2,
              ),
              CurvedListItem(
                title: 'Yoga and Meditation for Beginners',
                time: 'TODAY 5:30 PM',
                icon: Icons.flight_land,
                position: 1,
              ),
            ],
          ),
        ]),
      ),
      customAppBar: MainNavigationBarWidget(
        tabController: _tabController,
      ),
    );
  }

  Widget organiseStack(List<CurvedListItem> items) {
    List<Widget> output = [];
    for (var i = 0; i < items.length; i++) {
      output.insert(
        0,
        Positioned(
          top: 190.0 * i,
          child: CurvedCornerWidget(
            padding: EdgeInsets.only(top: 70),
            color: trendingColors[i % 4],
            child: items[i],
          ),
        ),
      );
    }

    return Container(
      height: 190.0 * items.length + 200,
      child: Stack(
        children: output,
      ),
    );
  }
}

class CurvedListItem extends StatelessWidget {
  final String title;
  final String time;
  final String people;
  final IconData icon;
  final int position;

  CurvedListItem(
      {this.title, this.time, this.icon, this.people, this.position});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SingleEventScreen()),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 32, top: 32),
        child: Stack(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    time,
                    style: TextStyle(
                      color: Color(0x70ffffff),
                      fontSize: 11,
                      letterSpacing: -0.22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      letterSpacing: -0.39,
                      height: 1.25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ImageAvatarListWidget(
                        images: [
                          'images/avatar1.jpg',
                          'images/avatar1.jpg',
                        ],
                        size: 24,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Join Marie, John and 10 others',
                        style: TextStyle(
                          color: Color(0x70ffffff),
                          letterSpacing: -0.24,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ]),
            Positioned(
              right: 40,
              bottom: 50,
              child: Icon(
                icon,
                size: 70,
                color: Color.fromARGB(50, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
