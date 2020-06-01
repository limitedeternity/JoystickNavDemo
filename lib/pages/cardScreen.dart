import 'package:flutter/material.dart';
import 'package:animated/animated.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import 'package:joystickNavDemo/widgets/fadePageRoute.dart';

class CardScreen extends StatefulWidget {
  @override
  CardScreenState createState() => CardScreenState();
}

class CardScreenState extends State<CardScreen> {
  int currentIndex = 0;
  int totalCards = 10;

  PageController pageController;
  BehaviorSubject<Icon> willAcceptStream;
  Timer pageSwitchTicker;

  @override
  void initState() {
    super.initState();

    pageController = PageController(
      viewportFraction: 0.7,
    );

    willAcceptStream = BehaviorSubject<Icon>();
    willAcceptStream.add(Icon(Icons.code));
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
        ),
        Expanded(
          child: _buildCarousel(context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 100,
                child: DottedBorder(
                  color: Colors.black,
                  strokeWidth: 1,
                  child: DragTarget(
                    builder: (
                      BuildContext context,
                      List<dynamic> candidateData,
                      List<dynamic> rejectedData,
                    ) {
                      return Container(height: 100);
                    },
                    onAccept: (Object data) {
                      willAcceptStream.add(Icon(Icons.code));
                      pageSwitchTicker.cancel();
                      setState(() {
                        pageSwitchTicker = null;
                      });
                    },
                    onWillAccept: (Object data) {
                      willAcceptStream.add(Icon(Icons.chevron_left));
                      setState(() {
                        pageSwitchTicker = Timer.periodic(
                          Duration(milliseconds: 800),
                          (timer) {
                            pageController.animateToPage(
                              currentIndex - 1 < 0 ? 0 : currentIndex - 1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                        );
                      });

                      return true;
                    },
                    onLeave: (Object data) {
                      willAcceptStream.add(Icon(Icons.code));
                      pageSwitchTicker.cancel();
                      setState(() {
                        pageSwitchTicker = null;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).push(
                  FadePageRoute(
                    page: Scaffold(
                      body: Container(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            "Card ${currentIndex + 1}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                    ),
                  ),
                );
              },
              child: LongPressDraggable(
                hapticFeedbackOnStart: true,
                axis: Axis.horizontal,
                child: FloatingActionButton(
                  child: willAcceptStream.value ?? Icon(Icons.code),
                ),
                feedback: StreamBuilder(
                    initialData: Icon(Icons.code),
                    stream: willAcceptStream,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<Icon> snapshot,
                    ) {
                      return Transform.scale(
                        scale: 1.1,
                        child: FloatingActionButton(
                          elevation: 8,
                          child: snapshot.data,
                        ),
                      );
                    }),
                childWhenDragging: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
            Expanded(
              child: Container(
                height: 100,
                child: DottedBorder(
                  color: Colors.black,
                  strokeWidth: 1,
                  child: DragTarget(
                    builder: (
                      BuildContext context,
                      List<dynamic> candidateData,
                      List<dynamic> rejectedData,
                    ) {
                      return Container(height: 100);
                    },
                    onAccept: (Object data) {
                      willAcceptStream.add(Icon(Icons.code));
                      pageSwitchTicker.cancel();
                      setState(() {
                        pageSwitchTicker = null;
                      });
                    },
                    onWillAccept: (Object data) {
                      willAcceptStream.add(Icon(Icons.chevron_right));
                      setState(() {
                        pageSwitchTicker = Timer.periodic(
                          Duration(milliseconds: 800),
                          (timer) {
                            pageController.animateToPage(
                              currentIndex + 1 > totalCards
                                  ? totalCards
                                  : currentIndex + 1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.fastOutSlowIn,
                            );
                          },
                        );
                      });

                      return true;
                    },
                    onLeave: (Object data) {
                      willAcceptStream.add(Icon(Icons.code));
                      pageSwitchTicker.cancel();
                      setState(() {
                        pageSwitchTicker = null;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
        ),
      ],
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return PageView.builder(
      itemCount: totalCards,
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        return Animated(
          value: index == currentIndex ? 1 : 0.9,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 450),
          builder: (
            BuildContext context,
            Widget child,
            Animation<dynamic> animation,
          ) {
            return Transform.scale(
              scale: animation.value,
              child: child,
            );
          },
          child: Card(
            elevation: 6,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              key: UniqueKey(),
              children: <Widget>[
                Image.network(
                  "https://picsum.photos/1920/1080?idx=$index",
                  fit: BoxFit.cover,
                ),
                Center(
                  child: SizedBox(
                    width: 200.0,
                    height: 48.0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Card ${index + 1}",
                          style: TextStyle(fontSize: 32),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              fit: StackFit.expand,
            ),
          ),
        );
      },
    );
  }
}
