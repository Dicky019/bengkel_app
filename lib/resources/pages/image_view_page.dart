import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ImageViewPage extends NyStatefulWidget {
  static const path = '/image_view_page';

  ImageViewPage({super.key}) : super(path, child: _ImagePageState());
}

class _ImagePageState extends NyState<ImageViewPage> {
  late final String imageUrl;
  late final String name;
  // @override
  // init() async {

  // }

  /// Use boot if you need to load data before the [view] is rendered.
  @override
  boot() async {
    // final user = await widget.controller.getUser;
    // if (user != null) {
    //   user.toJson().toString().dump();
    //   // widget.controller.setEventLogin(user);
    // }
    final query = queryParameters();

    if (query['imageUrl'] == null) {
      return await pop(
        result: {"status": "Query Parameters imageUrl NOT FOUND"},
      );
    }

    if (query['name'] == null) {
      return await pop(
        result: {"status": "Query Parameters name NOT FOUND"},
      );
    }

    imageUrl = query['imageUrl'];
    name = query['name'];
  }

  // bool get useSkeletonizer => true;

  @override
  Widget view(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blue,
      ),
      body: InteractiveViewer(
        panEnabled: true, // Enable panning
        // boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.5,
        maxScale: 4,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          height: size.height,
          width: size.width,
        ),
      ),
    );
  }
}
