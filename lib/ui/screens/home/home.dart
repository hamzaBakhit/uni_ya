import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/features/bottom_navigation_bar/bottom_nav_bar_cubit.dart';
import 'package:uni_ya/features/make_order/view/my_cart.dart';
import 'package:uni_ya/features/meals/logic/meals_bloc.dart';
import 'package:uni_ya/features/my_drawer/my_drawer_cubit.dart';
import 'package:uni_ya/ui/screens/home/categories_bar.dart';
import 'package:uni_ya/ui/screens/home/offers_bar.dart';
import 'package:uni_ya/ui/screens/group/group_body.dart';
import 'package:uni_ya/ui/widgets/backgruond.dart';

import '../../../constants/texts.dart';
import '../../../features/bottom_navigation_bar/view/bottom_navigation_bar.dart';
import '../../widgets/loading.dart';
import '../active_orders/active_orders.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isBlur: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Color.fromARGB(0, 255, 255, 255),
        appBar: AppBar(
          title: Text([
            '',
            TextKeys.myCart.tr(),
            TextKeys.activeOrders.tr(),
          ][context.watch<BottomNavBarCubit>().state]),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => context.read<MyDrawerCubit>().toggle(),
            icon: Icon(Icons.menu),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: const [
              HomeBody(),
              MyCart(),
              ActiveOrders(),
            ][context.watch<BottomNavBarCubit>().state]),
            BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealsCubit, MealsState>(builder: (context, state) {
      if (state is MealsShow ) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: TextKeys.searchHint.tr(),
                  border: const  UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).textTheme.bodyLarge!.color!)),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            if (_controller.value.text.trim().isEmpty)
              OffersBar(
                  state.groups.where((element) => element.isOffer).toList()),
            if (_controller.value.text.trim().isEmpty)
              CategoriesBar(
                  state.groups.where((element) => !element.isOffer).toList()),
            // if (state.groups
            //     .where((element) =>
            //         element.id == 'popular')
            //     .isNotEmpty)
            //   Expanded(
            //       child: GroupBody(
            //     state.groups
            //         .where((element) =>
            //             element.id == 'popular')
            //         .first,
            //     searchTitle: _controller.value.text.trim(),
            //   )),
          ],
        );
      } else {
        return const LoadingWidget();
      }
    });
  }
}
