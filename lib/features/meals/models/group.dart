
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Group extends Equatable{

  String title,img;
  bool isOffer;
  Color color;
  late String id;

  Group({required this.title,required this.img,required this.isOffer,this.color=Colors.white}){
    id=const Uuid().v4();
  }
  @override
  List<Object?> get props => [id,title,img,isOffer];


  int getColor()=>color.value;
  void setColor(int value)=>color=Color(value);
  void setTitle(value)=>title=value;
  void setImg(value)=>img=value;
  void setId(value)=>id=value;

}