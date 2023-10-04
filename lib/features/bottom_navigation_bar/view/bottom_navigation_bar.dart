import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/features/bottom_navigation_bar/bottom_nav_bar_cubit.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 20),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              backgroundColor: (context.watch<BottomNavBarCubit>().state == 0)
                  ? Colors.white.withOpacity(0.25)
                  : Colors.transparent,
              child: IconButton(
                  onPressed: () {
                    context.read<BottomNavBarCubit>().changePage(0);
                  },
                  icon: Icon(
                    Icons.home,
                    color: Colors.white70,
                  )),
            ),
            CircleAvatar(
              backgroundColor: (context.watch<BottomNavBarCubit>().state == 1)
                  ? Colors.white.withOpacity(0.25)
                  : Colors.transparent,
              child: IconButton(
                  onPressed: () {
                    context.read<BottomNavBarCubit>().changePage(1);
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white70,
                  )),
            ),
            CircleAvatar(
              backgroundColor: (context.watch<BottomNavBarCubit>().state == 2)
                  ? Colors.white.withOpacity(0.25)
                  : Colors.transparent,
              child: IconButton(
                  onPressed: () {
                    context.read<BottomNavBarCubit>().changePage(2);
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.white70,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
