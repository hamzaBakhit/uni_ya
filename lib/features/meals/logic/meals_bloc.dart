import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/features/meals/models/addition.dart';
import 'package:uni_ya/features/meals/models/meal.dart';
import 'package:uni_ya/sevices/remote/meals_service.dart';

import '../models/group.dart';

part 'meals_state.dart';

class MealsCubit extends Cubit<MealsState>{
  MealsCubit():super(MealsProcess(groups: [], additions: [], meals: [])){
    getMeals();

  }
  getMeals()async{
    emit(MealsProcess(groups:state.groups, additions:state.additions, meals:state.meals));
    List<Group> groups=[];
    groups=await MealsRemoteService.get().getGroups();
    List<Meal> meals=[];
    meals=await MealsRemoteService.get().getMeals();
    emit(MealsShow(groups:groups, additions:state.additions, meals:meals));
    emit(MealsProcess(groups:state.groups, additions:state.additions, meals:state.meals));
    List<Addition> additions=[];
    additions=await MealsRemoteService.get().getAdditions();
    emit(MealsShow(groups:state.groups, additions:additions, meals:state.meals));
  }


}