import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:im_stepper/stepper.dart';
import 'package:uni_ya/constants/routes.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/features/bottom_navigation_bar/bottom_nav_bar_cubit.dart';
import 'package:uni_ya/features/make_order/make_order_bloc.dart';
import 'package:uni_ya/features/orders/logic/orders_bloc.dart';

import 'package:uni_ya/features/user/logic/user_bloc.dart';
import 'package:uni_ya/sevices/connection.dart';
import 'package:uni_ya/ui/widgets/backgruond.dart';
import 'package:uni_ya/ui/widgets/sign_in_first.dart';

import '../../../sevices/remote/orders_service.dart';
import '../model/order.dart';

class AskingOrderScreen extends StatefulWidget {
  const AskingOrderScreen({Key? key}) : super(key: key);

  @override
  State<AskingOrderScreen> createState() => _AskingOrderScreenState();
}

class _AskingOrderScreenState extends State<AskingOrderScreen> {
  int _index = 0;
  String note = '';
  String paymentMethod = PaymentMethod.cash;
  final _controller = TextEditingController();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          if (state is UserSignInState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  IconStepper(
                    activeStepBorderColor: Theme.of(context).primaryColor,
                    activeStepColor: Theme.of(context).primaryColor,
                    stepColor: Theme.of(context).secondaryHeaderColor,
                    icons: [
                      Icon(Icons.note_alt_outlined),
                      Icon(Icons.access_alarm),
                      Icon(Icons.payments_outlined),
                    ],
                    activeStep: _index,
                    onStepReached: (index) {
                      setState(() {
                        _index = index;
                      });
                    },
                  ),
                  Expanded(
                      child: [
                    // note page
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                TextKeys.leaveUsNote.tr(),
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 24,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  hintText: TextKeys.noteDetails.tr(),
                                  label: Text(TextKeys.note.tr()),
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 5,
                                minLines: 3,
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${TextKeys.totalPrice.tr()} : \$${context.read<MakeOrderBloc>().state.totalPrice.toStringAsFixed(2)} ',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: SvgPicture.asset(
                            //       'assets/illustrations/note.svg'),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // choose date page
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      //todo: date picker
                                      DateTime? _date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          // firstDate: DateTime(2023),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              date.add(Duration(days: 30)));
                                      if (_date != null) {
                                        setState(() {
                                          date = DateTime(
                                              _date.year,
                                              _date.month,
                                              _date.day,
                                              date.hour,
                                              date.minute);
                                        });
                                      }
                                    },
                                    child: Text(TextKeys.choseDate.tr())),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                    onPressed: () async {
                                      //
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Grid Dialog'),
                                            content: Container(
                                              width: double.maxFinite,
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  mainAxisSpacing: 10.0,
                                                  crossAxisSpacing: 10.0,
                                                ),
                                                itemCount: times()
                                                    .length, // Change this to the number of buttons you want
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return times()[index];
                                                },
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      //timePicker
                                      // TimeOfDay? _date = await showTimePicker(
                                      //   context: context,
                                      //   initialTime: TimeOfDay.now(),
                                      // );
                                      // if (_date != null) {
                                      //   setState(() {
                                      //     date = DateTime(
                                      //         date.year,
                                      //         date.month,
                                      //         date.day,
                                      //         _date.hour,
                                      //         _date.minute);
                                      //   });
                                      // }
                                    },
                                    child: Text(TextKeys.choseTime.tr())),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Order.showDate(date),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          // Expanded(
                          //   child: SvgPicture.asset(
                          //       'assets/illustrations/date.svg'),
                          // ),
                        ],
                      ),
                    ),
                    // payment method
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Expanded(
                          //     child: SvgPicture.asset(
                          //         'assets/illustrations/payment.svg')),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              TextKeys.chosePaymentMethod.tr(),
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          //cash method
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  paymentMethod = PaymentMethod.cash;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: paymentMethod == PaymentMethod.cash
                                      ? Colors.green.withOpacity(0.7)
                                      : null,
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: ListTile(
                                  title: Text(TextKeys.cash.tr()),
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.green.shade100,
                                      child: Icon(
                                        Icons.payments,
                                        color: Colors.green,
                                      )),
                                ),
                              ),
                            ),
                          ),
                          //   //visa method
                          //   Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: GestureDetector(
                          //       onTap: () {
                          //         setState(() {
                          //           paymentMethod = PaymentMethod.visa;
                          //         });
                          //       },
                          //       child: Container(
                          //         padding: EdgeInsets.all(8),
                          //         decoration: BoxDecoration(
                          //           color: paymentMethod == PaymentMethod.visa
                          //               ? Colors.blueAccent.withOpacity(0.7)
                          //               : null,
                          //           border: Border.all(color: Colors.blueAccent),
                          //           borderRadius: BorderRadius.circular(100),
                          //         ),
                          //         child: ListTile(
                          //           title: Text(TextKeys.visa.tr()),
                          //           leading: CircleAvatar(
                          //               backgroundColor: Colors.blue.shade100,
                          //               child: Icon(
                          //                 Icons.payment,
                          //                 color: Colors.blueAccent,
                          //               )),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          //   //google method
                          //   Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: GestureDetector(
                          //       onTap: () {
                          //         setState(() {
                          //           paymentMethod = PaymentMethod.google;
                          //         });
                          //       },
                          //       child: Container(
                          //         padding: EdgeInsets.all(8),
                          //         decoration: BoxDecoration(
                          //           color: paymentMethod == PaymentMethod.google
                          //               ? Colors.redAccent.withOpacity(0.7)
                          //               : null,
                          //           border: Border.all(color: Colors.redAccent),
                          //           borderRadius: BorderRadius.circular(100),
                          //         ),
                          //         child: ListTile(
                          //           title: Text(TextKeys.googleMethod.tr()),
                          //           leading: CircleAvatar(
                          //             backgroundColor: Colors.red.shade50,
                          //             child: Padding(
                          //               padding: EdgeInsets.all(6),
                          //               child: Image.asset(
                          //                   'assets/images/Google-Logo.png'),
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   )
                        ],
                      ),
                    ),
                  ][_index]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (_index > 0) {
                              _index--;
                            } else {
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: Text((_index > 0)
                            ? TextKeys.previous.tr()
                            : TextKeys.cancel.tr()),
                      )),
                      Expanded(child: SizedBox()),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_index < 2) {
                              setState(() {
                                _index++;
                              });
                            } else {
                              if (await checkConnection(context)) {
                                context.read<MakeOrderBloc>().add(MakeOrder(
                                      paymentMethod: paymentMethod,
                                      note: _controller.value.text ?? "",
                                      date: date,
                                      user: context
                                          .read<UserBloc>()
                                          .state
                                          .user!
                                          .user!,
                                    ));
                                context.read<BottomNavBarCubit>().changePage(2);
                                Navigator.pushNamed(
                                    context, Routes.bill);
                                // print()
                                //todo: goToPill
                               
                              }
                            }
                          },
                          child: Text((_index < 2)
                              ? TextKeys.next.tr()
                              : TextKeys.order.tr()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return SignInFirst();
          }
        }),
      ),
    );
  }

  List<Widget> times() {
    List<String> timesString = [
      "8:30",
      "8:45",
      "9:00",
      "9:15",
      "9:30",
      "9:45",
      "10:00",
      "10:15",
      "10:30",
      "10:45",
      "11:00",
      "11:15",
      "11:30",
      "11:45",
      "12:00",
      "12:15",
      "12:30",
      "12:45",
      "13:00",
      "13:15",
      "13:30",
      "13:45",
      "14:00",
      "14:15",
      "14:30",
      "14:45",
      "15:00",
      "15:15",
      "15:30",
      "15:45",
      "16:00",
      "16:15",
      "16:30",
      "16:45",
      "17:00",
    ];

    return List.generate(
        timesString.length,
        (index) => TextButton(
            onPressed: () {
              //timePicker
              // = await showTimePicker(
              //   context: context,
              //   initialTime: TimeOfDay.now(),
              // );
              List<String> timeParts = timesString[index].split(':');

              if (timeParts.length != 2) {
                throw FormatException('Invalid time format');
              }

              // Parse hours, minutes, and seconds as integers
              int hours = int.parse(timeParts[0]);
              int minutes = int.parse(timeParts[1]);

              TimeOfDay _date = TimeOfDay(hour: hours, minute: minutes);

              setState(() {
                date = DateTime(
                    date.year, date.month, date.day, _date.hour, _date.minute);
              });
              Navigator.pop(context);
            },
            child: Text(timesString[index])));
  }
}
