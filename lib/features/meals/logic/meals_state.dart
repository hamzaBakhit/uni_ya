part of'meals_bloc.dart';


class MealsState extends Equatable{
  List<Group> groups;
  List<Addition> additions;
  List<Meal> meals;

  MealsState({required this.groups,required this.additions,required this.meals});

  @override
  List<Object?> get props => [];
}

class MealsShow extends MealsState{
  MealsShow({required super.groups, required super.additions, required super.meals});
}
class MealsProcess extends MealsState{
  MealsProcess({required super.groups, required super.additions, required super.meals});
}
