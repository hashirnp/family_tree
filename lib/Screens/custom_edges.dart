import 'dart:developer';
import 'dart:io';

import 'package:family_tree/Service/dbname_provider.dart';
import 'package:family_tree/Service/tree_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphite/graphite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

final presetComplex = TreeService().convertToString();

class CustomEdgesPage extends StatefulWidget {
  // final Widget Function(BuildContext context) bottomBar;

  const CustomEdgesPage({
    Key? key,
    //required this.bottomBar
  }) : super(key: key);
  @override
  CustomEdgesPageState createState() {
    return CustomEdgesPageState();
  }
}

class CustomEdgesPageState extends State<CustomEdgesPage> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  List<NodeInput> list = nodeInputFromJson(TreeService().convertToString());
  Map<String, bool> selected = {};
  void _onItemSelected(String nodeId) {
    setState(() {
      selected[nodeId] =
          selected[nodeId] == null || !selected[nodeId]! ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final familyProvider = Provider.of<DbNameProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  screenshotController
                      .captureFromLongWidget(
                    InheritedTheme.captureAll(
                      context,
                      SizedBox(height: 2500, width: 2500, child: treeWidget()),
                    ),
                    delay: const Duration(milliseconds: 100),
                    context: context,
                  )
                      .then((image) async {
                    final directory = await getExternalStorageDirectory();
                    final imagePath =
                        await File('${directory!.path}/image.png').create();
                    await imagePath.writeAsBytes(image);

                    /// Share Plugin
                    await Share.shareXFiles([XFile(imagePath.path)]);
                    // Handle captured image
                  });

                  
                },
                icon: const Icon(Icons.camera))
          ],
          leading: const Icon(Icons.view_comfy),
          title: Text(familyProvider.argument)),
      body: Screenshot(
        controller: screenshotController,
        child: Container(color: Colors.white, child: treeWidget()),
      ),

      // bottomNavigationBar: widget.bottomBar(context),
    );
  }

  InteractiveViewer treeWidget() {
    return InteractiveViewer(
      constrained: false,
      child: DirectGraph(
        list: list,
        defaultCellSize: const Size(104.0, 104.0),
        cellPadding: const EdgeInsets.all(14),
        contactEdgesDistance: 5.0,
        orientation: MatrixOrientation.Vertical,
        pathBuilder: customEdgePathBuilder,
        centered: true,
        onEdgeTapDown: (details, edge) {
          log("${edge.from.id}->${edge.to.id}");
        },
        nodeBuilder: (ctx, node) {
          return Container(
            height: 50,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(
                  10,
                )),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                node.id,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: selected[node.id] ?? false
                    ? GoogleFonts.montserrat(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)
                    : GoogleFonts.montserrat(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
              ),
            ),
          );
        },
        paintBuilder: (edge) {
          var p = Paint()
            ..color = Colors.blueGrey
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..strokeWidth = 2;
          if ((selected[edge.from.id] ?? false) &&
              (selected[edge.to.id] ?? false)) {
            p.color = Colors.red;
          }
          return p;
        },
        onNodeTapDown: (_, node, __) {
          _onItemSelected(node.id);
        },
      ),
    );
  }
}

Path customEdgePathBuilder(NodeInput from, NodeInput to,
    List<List<double>> points, EdgeArrowType arrowType) {
  var path = Path();
  path.moveTo(points[0][0], points[0][1]);
  points.sublist(1).forEach((p) {
    path.lineTo(p[0], p[1]);
  });
  return path;
}
