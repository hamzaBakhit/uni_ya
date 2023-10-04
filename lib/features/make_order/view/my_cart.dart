import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/constants/routes.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/ui/widgets/cached_image.dart';

import '../../../ui/screens/details_screen/details_screen.dart';
import '../../../ui/widgets/backgruond.dart';
import '../../../ui/widgets/delete_alert.dart';
import '../../../ui/widgets/empty.dart';
import '../../meals/models/addition.dart';
import '../../meals/models/meal.dart';
import '../make_order_bloc.dart';

class MyCart extends StatelessWidget {
  const MyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<MakeOrderBloc, MakeOrderState>(
            builder: (context, state) {
          if (state.meals.isEmpty) {
            return const EmptyScreen();
          }
          return Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                      children: state.meals.map((e) {
                    if (state.additions[e.id] != null) {
                      return MealItem(
                        meal: e,
                        additions: state.additions[e.id]!,
                        counts: state.additionCount,
                      );
                    }
                    return MealItem(
                      meal: e,
                      additions: [],
                      counts: state.additionCount,
                    );
                  }).toList()),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '\$${TextKeys.totalPrice.tr()} : ${state.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state.meals.isEmpty
                            ? null
                            : () async {
                                bool isDone = await showDialog(
                                      context: context,
                                      builder: (context) => DeleteAlert(
                                          actionTitle: TextKeys.clear.tr(),
                                          title: TextKeys.areYouSure.tr(),
                                          description: TextKeys
                                              .clearDialogDescription
                                              .tr(),
                                          actionColor: Colors.redAccent),
                                    ) ??
                                    false;
                                if (isDone) {
                                  context
                                      .read<MakeOrderBloc>()
                                      .add(ClearOrder());
                                }
                              },
                        child: Text(TextKeys.clear.tr()),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.red),
                          foregroundColor:
                              MaterialStatePropertyAll<Color>(Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: state.meals.isEmpty
                            ? null
                            : () async {
                                Navigator.pushNamed(
                                    context, Routes.orderAsking);
                              },
                        child: Text(
                          TextKeys.order.tr(),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black),
                          foregroundColor:
                              MaterialStatePropertyAll<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  MealItem(
      {required this.meal,
      required this.additions,
      required this.counts,
      Key? key})
      : super(key: key);
  Meal meal;
  List<Addition> additions;
  Map<String, int> counts;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Dismissible(
          key: Key(meal.id),
          onDismissed: (_) {
            context.read<MakeOrderBloc>().add(DeleteMeal(meal.id));
          },
          direction: DismissDirection.horizontal,
          background: Container(
            color: Colors.redAccent.withOpacity(0.7),
            alignment: Alignment.center,
            child: Text(
              TextKeys.deleteMeal.tr(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.redAccent.withOpacity(0.7),
            alignment: Alignment.center,
            child: Text(
              TextKeys.deleteMeal.tr(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          child: ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                          meal,
                          isFromCart: true,
                        ))),
            title: Text(meal.title),
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: CachedImage(meal.img),
            ),
            subtitle: Text('${TextKeys.count.tr()} : ${meal.count}'),
            trailing: Text(
              '\$${(meal.count * meal.price).toStringAsFixed(2)}',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        if (additions.isNotEmpty)
          Text(TextKeys.additions.tr(), textAlign: TextAlign.center),
        ...additions.map(
          (e) => Dismissible(
            key: Key(meal.id + e.id),
            onDismissed: (_) {
              context
                  .read<MakeOrderBloc>()
                  .add(DeleteAddition(AdditionId: e.id, mealId: meal.id));
            },
            direction: DismissDirection.horizontal,
            background: Container(
              color: Colors.redAccent.withOpacity(0.7),
              alignment: Alignment.center,
              child: Text(
                TextKeys.deleteAddition.tr(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.redAccent.withOpacity(0.7),
              alignment: Alignment.center,
              child: Text(
                TextKeys.deleteAddition.tr(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            child: ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                            meal,
                            isFromCart: true,
                          ))),
              title: Text(e.title),
              leading: CircleAvatar(backgroundColor: Colors.transparent,child: CachedImage(e.img)),
              subtitle: Text(
                  '${TextKeys.count.tr()} : ${counts[meal.id + '==' + e.id]}'),
              trailing: Text(
                '\$${(counts[meal.id + '==' + e.id]! * e.price).toStringAsFixed(2)}',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
