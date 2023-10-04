import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/features/bottom_navigation_bar/bottom_nav_bar_cubit.dart';
import 'package:uni_ya/features/meals/logic/meals_bloc.dart';

import '../../../constants/routes.dart';
import '../../../features/make_order/make_order_bloc.dart';
import '../../../features/meals/models/addition.dart';
import '../../../features/meals/models/meal.dart';
import '../../widgets/backgruond.dart';
import '../../widgets/cached_image.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen(this.meal, {this.isFromCart=false, Key? key}) : super(key: key);
  Meal meal;
  bool isFromCart;


  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<Addition> additions = [];

  @override
  void initState() {
    additions = List.from(context
        .read<MealsCubit>()
        .state
        .additions
        .where((element) => widget.meal.additions.contains(element.id))
        .toList());

    additions.forEach((element) {
      if (context.read<MakeOrderBloc>().state.additionCount.keys
          .contains(widget.meal.id + '==' + element.id)) {
        element.count =
        context.read<MakeOrderBloc>().state.additionCount[widget.meal.id + "==" + element.id]!;
      }else{
        element.count=0;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BackgroundWidget(
      isBlur: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.meal.title,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: height / 30)),
            ),
            Expanded(
              child: LayoutBuilder(builder: (context, constrains) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: width,
                        height: constrains.maxHeight * 5 / 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(width / 4),
                              topRight: Radius.circular(width / 4)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(width / 4),
                                      topRight: Radius.circular(width / 4)),
                                  border: Border.all(
                                      width: 2,
                                      color: Colors.white.withOpacity(0.5))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: constrains.maxHeight / 6),
                                  Expanded(
                                    child: ListView(
                                      children: [
                                        Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                              BorderRadius.circular(50)),
                                          child: Wrap(
                                              crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => setState(() {
                                                    if (widget.meal.count > 1) {
                                                      widget.meal.setCount(
                                                          widget.meal.count - 1);
                                                    }
                                                  }),
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 4),
                                                    child: Text('  -  ',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 28)),
                                                  ),
                                                ),
                                                CircleAvatar(
                                                    child: Text(widget.meal.count
                                                        .toString()),
                                                    backgroundColor: Colors.white
                                                        .withOpacity(0.9),
                                                    foregroundColor: Colors.black),
                                                GestureDetector(
                                                  onTap: () => setState(() {
                                                    widget.meal.setCount(
                                                        widget.meal.count + 1);
                                                  }),
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 4),
                                                    child: Text('  +  ',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 28)),
                                                  ),
                                                )
                                              ]),
                                        ),
                                      ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(widget.meal.description),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                '\$${widget.meal.price.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24),
                                              ),
                                              const Expanded(child: SizedBox()),
                                              const Icon(Icons.star,
                                                  color: Colors.orangeAccent),
                                              Text(' ${widget.meal.rateScore} '),
                                            ],
                                          ),
                                        ),
                                        ...additions
                                          .map((e) => AdditionalItem(e))
                                          .toList()],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FloatingActionButton.extended(
                                          onPressed: () {
                                            context
                                                .read<MakeOrderBloc>()
                                                .add(AddOrder(
                                              meal: widget.meal,
                                              additionsCount: Map
                                                  .fromIterable(
                                                  additions.where(
                                                          (element) =>
                                                      element
                                                          .count >
                                                          0),
                                                  value: (element) =>
                                                  element.count,
                                                  key: (e) =>
                                                  widget.meal.id +
                                                      '==' +
                                                      e.id),
                                              additions: additions
                                                  .where((element) =>
                                              element.count > 0)
                                                  .toList(),
                                            ));
                                            context.read<BottomNavBarCubit>().emit(1);
                                            Navigator.popUntil(
                                                context, (route) =>route.settings.name==Routes.main,);

                                          },
                                          backgroundColor: Colors.black,
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          label:  Text((widget.isFromCart)?TextKeys.change.tr():TextKeys.add.tr(), style: const TextStyle(color: Colors.white),))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        child: Container(
                            height: constrains.maxHeight / 3,
                            width: constrains.maxHeight / 3,
                            child: CachedImage(widget.meal.img))),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalItem extends StatefulWidget {
  AdditionalItem(this.addition, {Key? key}) : super(key: key);
  Addition addition;

  @override
  State<AdditionalItem> createState() => _AdditionalItemState();
}

class _AdditionalItemState extends State<AdditionalItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.transparent,child: CachedImage(widget.addition.img)),
      title: Text(widget.addition.title),
      subtitle: Text('\$${widget.addition.price.toStringAsFixed(2)}'),
      trailing: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(50)),
        child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
          GestureDetector(
            onTap: () => setState(() {
              if (widget.addition.count > 0) {
                widget.addition.setCount(widget.addition.count - 1);
              }
            }),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(' - ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            ),
          ),
          CircleAvatar(
              child: Text(widget.addition.count.toString()),
              backgroundColor: Colors.white.withOpacity(0.9),
              foregroundColor: Colors.black),
          GestureDetector(
            onTap: () => setState(() {
              widget.addition.count += 1;
            }),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(' + ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            ),
          )
        ]),
      ),
    );
  }
}
