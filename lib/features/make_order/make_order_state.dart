part of'make_order_bloc.dart';

class MakeOrderState extends Equatable{
  List<Meal> meals;
  Map<String,List<Addition>> additions;
  Map<String,int> additionCount;
  double totalPrice;

  MakeOrderState({required this.meals,required this.additions,required this.totalPrice,required this.additionCount});

  @override
  List<Object?> get props => [meals,additions];


}
class MakeOrderShow extends MakeOrderState{
  MakeOrderShow({required super.meals, required super.additions,required super.totalPrice,required super.additionCount});
}
class MakeOrderProcess extends MakeOrderState{
  MakeOrderProcess({required super.meals, required super.additions,required super.totalPrice,required super.additionCount});
}
