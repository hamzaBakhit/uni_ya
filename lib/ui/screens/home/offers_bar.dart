import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:uni_ya/ui/screens/group/group_screen.dart';

import '../../../features/meals/models/group.dart';
import '../../widgets/cached_image.dart';

class OffersBar extends StatelessWidget {
  OffersBar(this.groups, {Key? key}) : super(key: key);
  List<Group> groups;

  @override
  Widget build(BuildContext context) {
    return groups.isNotEmpty? CarouselSlider(
      items: groups.where((element) => element.id!='popular')
          .map(
            (e) => CarousalItem(
              img: e.img,
              function: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupScreen(e)),
            ),
          ))
          .toList(),
      options: CarouselOptions(
        aspectRatio: 8 / 3,
        viewportFraction: 0.75,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
    ):const SizedBox();
  }
}

class CarousalItem extends StatelessWidget {
  CarousalItem({required this.function, required this.img, Key? key})
      : super(key: key);
  String img;
  Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Container(
        child: CachedImage(img,isOffer: true,),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
