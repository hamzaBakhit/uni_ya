

import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Addition extends Equatable{
late String id;
  String title;
  String img;
  double price;
  int count ;

  Addition({required this.title,required this.img,required this.price,this.count=0}){
    id=const Uuid().v4();
  }

  @override
  List<Object?> get props => [id,title,img,price,count];

  setTitle(value)=>title=value;
  setImg(value)=>img=value;
  setPrice(value)=>price=value;
  setId(value)=>id=value;
  setCount(value)=>count=value;

}