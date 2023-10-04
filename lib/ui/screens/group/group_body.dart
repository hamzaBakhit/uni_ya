import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/features/meals/logic/meals_bloc.dart';
import 'package:uni_ya/features/meals/models/group.dart';

import '../../../features/meals/models/meal.dart';
import '../../widgets/cached_image.dart';
import '../../widgets/empty.dart';
import '../details_screen/details_screen.dart';

class GroupBody extends StatefulWidget {
  GroupBody(this.group, {this.searchTitle = '', Key? key}) : super(key: key);
  Group group;
  String searchTitle;

  @override
  State<GroupBody> createState() => _GroupBodyState();
}

class _GroupBodyState extends State<GroupBody> {
  List<Meal> meals = [];

  @override
  void initState() {
    meals = context
        .read<MealsCubit>()
        .state
        .meals
        .where((element) => element.groups.contains(widget.group.id))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchTitle.isEmpty) {
      meals = context
          .read<MealsCubit>()
          .state
          .meals
          .where((element) => element.groups.contains(widget.group.id))
          .toList();
    } else {
      meals = context
          .read<MealsCubit>()
          .state
          .meals
          .where((element) => element.title.contains(widget.searchTitle))
          .toList();
    }

    return SingleChildScrollView(
      child: BlocBuilder<MealsCubit, MealsState>(builder: (context, state) {
        if (meals.isEmpty) {
          return EmptyScreen();
        }
        return Row(
          children: [
            Expanded(
              child: 
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.group.title,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ),
                  ...meals
                      .sublist(
                          0,
                          (meals.length.isEven
                                  ? meals.length.floor() / 2
                                  : meals.length.floor() / 2 + 1)
                              .toInt())
                      .map((e) => GroupItem(meal: e)),
                ],
              ),
            ),
            Expanded(
                child: (meals.length <= 1)
                    ? SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: meals
                            .sublist((meals.length.isEven
                                    ? meals.length.floor() / 2
                                    : meals.length.floor() / 2 + 1)
                                .toInt())
                            .map((e) => GroupItem(meal: e))
                            .toList())),
          ],
        );
      }),
    );
  }
}

class GroupItem extends StatelessWidget {
  GroupItem({
    required this.meal,
    Key? key,
  }) : super(key: key);
  Meal meal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      return Container(
        padding: EdgeInsets.all(4),
        height: MediaQuery.of(context).size.width * 4 / 6,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(meal),
              )),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 3 / 6,
                    height: MediaQuery.of(context).size.width * 3 / 6,
                    padding: EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 2,
                                  color: Colors.white.withOpacity(0.5))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  child: Text(meal.title,
                                      maxLines: 3,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                              Row(
                                children: [
                                  Text(
                                    '\$${meal.price.toStringAsFixed(2)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Icon(Icons.star, color: Colors.orangeAccent),
                                  Text(meal.rateScore.toString()),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 2 / 6,
                  height: MediaQuery.of(context).size.width * 2 / 6,
                  child: CachedImage(meal.img),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
