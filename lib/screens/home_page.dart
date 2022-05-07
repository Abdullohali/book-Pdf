// import 'dart:async';
// import 'package:draggable_scrollbar/draggable_scrollbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:testbook/core/components/mundarija.dart';
// import 'package:testbook/cubit/cubit/color_cubit.dart';
// import 'package:pdftron_flutter/pdftron_flutter.dart';
// import 'package:pdfx/pdfx.dart';
// import 'package:performance/performance.dart';

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.pdfAssetPath}) : super(key: key);
//   final String pdfAssetPath;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String _version = 'Unknown';

//   static const int _initialPage = 2;
//   int _actualPageNumber = _initialPage, _allPagesCount = 0;
//   bool isSampleDoc = true;
//   late PdfControllerPinch _pdfController;

//   @override
//   void initState() {
//     _pdfController = PdfControllerPinch(
//       document: PdfDocument.openAsset('assets/z.pdf'),
//       initialPage: _initialPage,
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _pdfController.dispose();
//     super.dispose();
//   }

//   // Platform messages are asynchronous, so we initialize via an async method.
//   Future<void> initPlatformState() async {
//     String version;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       PdftronFlutter.initialize();
//       version = await PdftronFlutter.version;
//     } on PlatformException {
//       version = 'Failed to get platform version.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _version = version;
//     });
//   }

//   final Completer<PDFViewController> _pdfViewController =
//       Completer<PDFViewController>();

//   final StreamController<String> _pageCountController =
//       StreamController<String>();

//   ScrollController _controller = ScrollController();
//   final Completer<PDFViewController> _controllerr =
//       Completer<PDFViewController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         toolbarHeight: 50.h,
//         title: RichText(
//           text: const TextSpan(text: """
// ТЕОРЕТИЧЕСКИЕ ОСНОВЫ ОТДЕЛКИ
// ВОЛОКНИСТЫХ МАТЕРИАЛОВ"""),
//         ),
//         actions: [
//           PopupMenuButton(
//               onSelected: (e) async {
//                 if (e == 1) {
//                   showModalBottomSheet<void>(
//                     isScrollControlled: true,
//                     context: context,
//                     builder: (BuildContext context) {
//                       return SizedBox(
//                           height: 400.h,
//                           child: FutureBuilder<PDFViewController>(
//                               future: _pdfViewController.future,
//                               builder: (_,
//                                   AsyncSnapshot<PDFViewController> snapshot) {
//                                 if (snapshot.hasData && snapshot.data != null) {
//                                   return DraggableScrollbar.semicircle(
//                                     controller: _controller,
//                                     child: ListView.builder(
//                                       controller: _controller,
//                                       itemBuilder: (_, __) {
//                                         return ListTile(
//                                           title: Text(
//                                               mundarija[__][0].toString(),
//                                               style: TextStyle(
//                                                   fontWeight:
//                                                       mundarija[__][0][0] == ' '
//                                                           ? FontWeight.bold
//                                                           : FontWeight.w300)),
//                                           trailing: Text(mundarija[__][0][0] ==
//                                                   ' '
//                                               ? ""
//                                               : mundarija[__][1].toString()),
//                                           onTap: () async {
//                                             final PDFViewController
//                                                 pdfController = snapshot.data!;
//                                             int currentPage = mundarija[__][1];
//                                             if (currentPage >= 0) {
//                                               await pdfController
//                                                   .setPage(currentPage - 1);
//                                             }
//                                           },
//                                         );
//                                       },
//                                       itemCount: mundarija.length,
//                                     ),
//                                   );
//                                 }
//                                 return Container();
//                               }));
//                     },
//                   );
//                 } else if (e == 2) {
//                   showDialog(
//                       context: context,
//                       builder: (context) {
//                         return const AlertDialog(
//                           content: Text(
//                             "Bu loyiha Foziljonov Abdulloh tomonidan 2022-yilda ishlab chiqildi",
//                           ),
//                         );
//                       });
//                 } else if (e == 3) {
//                   showModalBottomSheet<void>(
//                     context: context,
//                     isScrollControlled: true,
//                     builder: (BuildContext context) {
//                       return BlocBuilder<ColorCubit, ColorState>(
//                         builder: (context, state) {
//                           return SizedBox(
//                             height: 400.h,
//                             child: ListView.builder(
//                               itemBuilder: (_, __) {
//                                 return ListTile(
//                                   title: Text(
//                                     ranglarim[__][1].toString(),
//                                   ),
//                                   trailing: CircleAvatar(
//                                     radius: 15.r,
//                                     backgroundColor: ranglarim[__][0],
//                                   ),
//                                   onTap: () async {
//                                     context
//                                         .read<ColorCubit>()
//                                         .changeColor(ranglarim[__][0]);
//                                   },
//                                 );
//                               },
//                               itemCount: ranglarim.length,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 }
//               },
//               itemBuilder: (context) => [
//                     const PopupMenuItem(
//                       child: Text("Тема"),
//                       value: 1,
//                     ),
//                     const PopupMenuItem(
//                       child: Text("О проекте"),
//                       value: 2,
//                     ),
//                     const PopupMenuItem(
//                       child: Text("Цвета"),
//                       value: 3,
//                     )
//                   ])
//         ],
//       ),
//       body: CustomPerformanceOverlay(
//         // enabled: true,
//         child: PdfViewPinch(
//           documentLoader: const Center(child: CircularProgressIndicator()),
//           pageLoader: const Center(child: CircularProgressIndicator()),
//           controller: _pdfController,
//           onDocumentLoaded: (document) {
//             setState(() {
//               _allPagesCount = document.pagesCount;
//             });
//           },
//           onPageChanged: (page) {
//             setState(() {
//               _actualPageNumber = page;
//             });
//           },
//         ),
//       ),
//       floatingActionButton: FutureBuilder<PDFViewController>(
//         future: _pdfViewController.future,
//         builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
//           if (snapshot.hasData && snapshot.data != null) {
//             return Scrollbar(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 30.w),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     FloatingActionButton(
//                         backgroundColor: Theme.of(context).primaryColor,
//                         heroTag: '+',
//                         child: const Text('+'),
//                         onPressed: () async {
//                           final PDFViewController pdfController =
//                               snapshot.data!;
//                           final int currentPage =
//                               (await pdfController.getCurrentPage())! + 1;
//                           if (currentPage >= 0) {
//                             await pdfController.setPage(currentPage);
//                           }
//                         }),
//                     Container(
//                       height: 70.h,
//                       width: 70.w,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50.r),
//                           color: Theme.of(context).primaryColor),
//                       child: FloatingActionButton(
//                           backgroundColor: Theme.of(context).primaryColor,
//                           heroTag: '-',
//                           child: StreamBuilder<String>(
//                               stream: _pageCountController.stream,
//                               builder: (_, AsyncSnapshot<String> snapshot) {
//                                 if (snapshot.hasData) {
//                                   return Text(snapshot.data!);
//                                 }
//                                 return const SizedBox();
//                               }),
//                           onPressed: () async {}),
//                     ),
//                     FloatingActionButton(
//                         backgroundColor: Theme.of(context).primaryColor,
//                         heroTag: '-',
//                         child: const Text('-'),
//                         onPressed: () async {
//                           final PDFViewController pdfController =
//                               snapshot.data!;
//                           final int currentPage =
//                               (await pdfController.getCurrentPage())! - 1;
//                           if (currentPage >= 0) {
//                             await pdfController.setPage(currentPage);
//                           }
//                         })
//                   ],
//                 ),
//               ),
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }
