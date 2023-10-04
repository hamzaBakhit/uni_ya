import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uni_ya/ui/screens/group/group_screen.dart';

import '../../../features/meals/models/group.dart';
import '../../widgets/cached_image.dart';

class CategoriesBar extends StatelessWidget {
  CategoriesBar(this.groups, {Key? key}) : super(key: key);
  List<Group> groups;

  @override
  Widget build(BuildContext context) {
    return groups.isNotEmpty?Expanded(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Adjust the number of columns as needed
        ),
        children: groups
            .map(
              (e) => CategoryItem(
                img: e.img,
                title: e.title,
                color: e.color,
                function: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupScreen(e))),
              ),
            )
            .toList() ,
      ),
    ):Container();
  }
}

class CategoryItem extends StatelessWidget {
  CategoryItem(
      {required this.img,
      required this.title,
      required this.color,
      required this.function,
      Key? key})
      : super(key: key);
  String title, img;
  Color color;
  Function function;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => function(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: color.withOpacity(0.1))),
              child: GestureDetector(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: color.withOpacity(0.4),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: CachedImage(img),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(title,
                    overflow: TextOverflow.ellipsis, // Handles overflow with ellipsis (...)
              maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
