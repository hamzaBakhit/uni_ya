import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/features/meals/logic/meals_bloc.dart';
import 'package:uni_ya/ui/widgets/backgruond.dart';

import '../../features/meals/models/addition.dart';
import '../../features/meals/models/meal.dart';
import '../../features/orders/model/order.dart';
import 'cached_image.dart';

class ControlOrderDetails extends StatefulWidget {
  ControlOrderDetails({required this.order, Key? key}) : super(key: key);
  Order order;

  @override
  State<ControlOrderDetails> createState() => _ControlOrderDetailsState();
}

class _ControlOrderDetailsState extends State<ControlOrderDetails> {
  List<Meal> meals = [];
  List<Addition> additions = [];

  @override
  void initState() {
    meals = Order.setMeals(widget.order.meals);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(TextKeys.orderDetails.tr()),
          backgroundColor: Colors.transparent,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ElementField(
                        contain: Order.showDate(widget.order.sendDate),
                        title: TextKeys.sendDate.tr()),
                    ElementField(
                        contain: Order.showDate(widget.order.orderDate),
                        title: TextKeys.receiveDate.tr()),
                    ElementField(
                        contain: widget.order.id, title: TextKeys.orderId.tr()),
                    ElementField(
                        contain: widget.order.userName,
                        title: TextKeys.userName.tr()),
                    ElementField(
                        contain: widget.order.userEmail,
                        title: TextKeys.userEmail.tr()),
                    ElementField(
                        contain: widget.order.paymentMethod,
                        title: TextKeys.paymentMethod.tr()),
                    if (widget.order.note.isNotEmpty)
                      ElementField(
                          contain: widget.order.note,
                          title: TextKeys.note.tr()),
                    Divider(),
                    ...meals
                        .map((e) => MealItem(
                        meal: e,
                        additions:
                        Order.setAdditions(widget.order.additions)
                            .where((a) => a.keys.first.contains(e.id))
                            .map((e) => e.values.first)
                            .toList()))
                        .toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${TextKeys.totalPrice.tr()} : \$${widget.order.totalPrice.toStringAsFixed(2)}',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          widget.order.paymentMethod,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ElementField extends StatelessWidget {
  ElementField({required this.contain, required this.title, Key? key})
      : super(key: key);
  String contain, title;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: contain);
    return Container(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        enabled: false,
        minLines: 1,
        maxLines: 7,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          label: Text(title),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  MealItem({required this.meal, required this.additions, Key? key})
      : super(key: key);
  Meal meal;
  List<Addition> additions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(meal.title),
          leading: CircleAvatar(backgroundColor: Colors.transparent,child: CachedImage(meal.img)),
          subtitle: Text('${TextKeys.count.tr()} : ${meal.count}'),
          trailing: Text(
            '\$${(meal.count * meal.price).toStringAsFixed(2)}',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        if (additions.isNotEmpty)
          Text(TextKeys.additions.tr(), textAlign: TextAlign.center),
        ...additions.map(
              (e) => ListTile(
            title: Text(e.title),
            leading: CircleAvatar(backgroundColor: Colors.transparent,child: CachedImage(e.img)),
            subtitle: Text('${TextKeys.count.tr()} : ${e.count}'),
            trailing: Text(
              '\$${(e.count * e.price).toStringAsFixed(2)} ',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
