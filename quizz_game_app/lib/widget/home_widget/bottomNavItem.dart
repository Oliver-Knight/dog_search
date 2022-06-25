import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Navigate_bloc/navigatorBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/util/color.dart';

class BotNavItem extends StatefulWidget {
  IconData? ficon;
  String name;
  int index;
  BotNavItem({Key? key, required this.ficon, required this.name,required this.index})
      : super(key: key);

  @override
  State<BotNavItem> createState() => _BotNavItemState();
}

class _BotNavItemState extends State<BotNavItem> {
  late final NavigatorCubit _nav = context.read<NavigatorCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigatorCubit, int>(
      // buildWhen: (previous, current) => current == widget.index,
      builder: (context, state) {
        return InkWell(
          onTap: (){
            _nav.viewPages(widget.index);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                widget.ficon,
                color: state == widget.index ? buttonColor : const Color(0XFFFFFFFF),
              ),
              Text(widget.name,
                    style:  TextStyle(
                    color: state == widget.index ? buttonColor : const Color(0XFFFFFFFF),
                  )),
            ],
          ),
        );
      },
    );
  }
}
