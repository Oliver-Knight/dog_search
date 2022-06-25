import 'package:flutter/material.dart';
import 'package:quizz_game_app/util/home_item_list.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/style.dart';

class HomeView extends StatefulWidget {
  HomeView({ Key? key }) : super(key: key);
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // static final Tween<Offset> _position = Tween(begin: const Offset(1,0), end: const Offset(0,0));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                color: appbarColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    offset: Offset(0, 5)
                  )
                ]
              ),
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                child: const Text("Quiz App Home",style: quizTitleStyle,),
                builder: (_,double _val, Widget? child){
                  return Opacity(
                    opacity: _val,
                    child: child,
                    );
                },
                ),
            ),
            Expanded(
              child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      key: widget.listKey,
                      itemCount : HomeItem.quizCards.length,
                      itemBuilder: (_,index){
                        return TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 500),
                          tween: Tween<double>(begin: 150, end: 0),
                          child: HomeItem.quizCards[index],
                          builder: (_,double _val, Widget? child){
                            return Padding(
                              padding: EdgeInsets.only(top: _val),
                              child: child);
                          },
                          );
                      })
                    ),
            ),
          ],
        ),
      ),
    );
  }
}