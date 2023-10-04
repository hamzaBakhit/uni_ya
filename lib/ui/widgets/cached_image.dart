import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends StatelessWidget {
   CachedImage(this.url,{this.isOffer=false, Key? key}) : super(key: key);
   String url;
bool isOffer;
  @override
  Widget build(BuildContext context) {
    return Container(
      child:CachedNetworkImage(
        imageUrl: url,
        imageBuilder:(!isOffer)?null: (context, imageProvider) => Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,

                ),
          ),
        ),
        placeholder: (context, url) => SizedBox(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ) ,


    );
  }
}
