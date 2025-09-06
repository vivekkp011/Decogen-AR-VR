// // // import 'package:flutter/material.dart';
// // // import 'package:url_launcher/url_launcher.dart';
// // // import 'dart:convert';
// // // import 'dart:typed_data';
// // // import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// // // import 'package:http/http.dart' as http;
// // //
// // // class AILensScreen extends StatefulWidget {
// // //   final String imagePath;
// // //   final Uint8List? imageBytes;
// // //
// // //   AILensScreen({required this.imagePath, this.imageBytes});
// // //
// // //   @override
// // //   _AILensScreenState createState() => _AILensScreenState();
// // // }
// // //
// // // class _AILensScreenState extends State<AILensScreen> {
// // //   List<Map<String, String>> recommendations = [];
// // //   bool isLoading = true;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     analyzeImage();
// // //   }
// // //
// // //   void analyzeImage() async {
// // //     final labels = await getLabelsFromImage(widget.imageBytes!);
// // //     fetchLiveProductRecommendations(labels);
// // //   }
// // //
// // //   Future<List<String>> getLabelsFromImage(Uint8List imageBytes) async {
// // //     final inputImage = InputImage.fromFilePath(widget.imagePath);
// // //     final imageLabeler = ImageLabeler(options: ImageLabelerOptions());
// // //     final labelsList = await imageLabeler.processImage(inputImage);
// // //     await imageLabeler.close();
// // //
// // //     return labelsList.map((label) => label.label).toList();
// // //   }
// // //
// // //   void fetchLiveProductRecommendations(List<String> labels) async {
// // //     final apiKey = "9f378346ca6c1f6eca9d7e8a2ecccccc7c73ea72bb88f4716f8ae24b3611ef13";
// // //     final query = labels.isNotEmpty ? labels.join("+") : "product";
// // //     final url = Uri.parse("https://serpapi.com/search.json?engine=google_lens&q=$query&api_key=$apiKey");
// // //
// // //     try {
// // //       final response = await http.get(url);
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = jsonDecode(response.body);
// // //         List<Map<String, String>> products = parseSerpAPIResponse(data);
// // //
// // //         setState(() {
// // //           recommendations = products.isNotEmpty ? products : [];
// // //           isLoading = false;
// // //         });
// // //       } else {
// // //         setState(() { isLoading = false; });
// // //       }
// // //     } catch (e) {
// // //       setState(() { isLoading = false; });
// // //     }
// // //   }
// // //
// // //   List<Map<String, String>> parseSerpAPIResponse(Map<String, dynamic> data) {
// // //     List<Map<String, String>> products = [];
// // //     if (data.containsKey("visual_matches")) {
// // //       for (var item in data["visual_matches"]) {
// // //         products.add({
// // //           "name": item["title"] ?? "Unknown Product",
// // //           "price": item["price"] ?? "N/A",
// // //           "link": item["link"] ?? "#",
// // //           "image": item["thumbnail"] ?? "",
// // //         });
// // //       }
// // //     }
// // //     return products;
// // //   }
// // //
// // //   Future<void> _launchURL(String url) async {
// // //     final Uri uri = Uri.parse(url);
// // //     if (await canLaunchUrl(uri)) {
// // //       await launchUrl(uri, mode: LaunchMode.externalApplication);
// // //     } else {
// // //       await launchUrl(uri, mode: LaunchMode.inAppWebView);
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text("AI Lens - Product Recommendations"),
// // //         leading: IconButton(
// // //           icon: Icon(Icons.arrow_back),
// // //           onPressed: () {
// // //             Navigator.pop(context);
// // //           },
// // //         ),
// // //       ),
// // //       body: SingleChildScrollView(
// // //         child: Column(
// // //           children: [
// // //             widget.imageBytes != null
// // //                 ? Image.memory(widget.imageBytes!, height: 250, fit: BoxFit.cover)
// // //                 : Image.asset(widget.imagePath, height: 250, fit: BoxFit.cover),
// // //             SizedBox(height: 10),
// // //             isLoading
// // //                 ? Center(child: CircularProgressIndicator())
// // //                 : recommendations.isNotEmpty
// // //                 ? ListView.builder(
// // //               shrinkWrap: true,
// // //               physics: NeverScrollableScrollPhysics(),
// // //               itemCount: recommendations.length,
// // //               itemBuilder: (context, index) {
// // //                 final product = recommendations[index];
// // //                 return Padding(
// // //                   padding: const EdgeInsets.all(8.0),
// // //                   child: GestureDetector(
// // //                     onTap: () async {
// // //                       await _launchURL(product["link"]!);
// // //                     },
// // //                     child: Card(
// // //                       elevation: 5,
// // //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// // //                       child: ListTile(
// // //                         leading: Image.network(
// // //                           product["image"]!,
// // //                           width: 50,
// // //                           height: 50,
// // //                           fit: BoxFit.cover,
// // //                           errorBuilder: (context, error, stackTrace) {
// // //                             return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
// // //                           },
// // //                         ),
// // //                         title: Text(product["name"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // //                         subtitle: Text(product["price"]!, style: TextStyle(fontSize: 16, color: Colors.green)),
// // //                         trailing: Icon(Icons.arrow_forward_ios),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 );
// // //               },
// // //             )
// // //                 : Text("No products found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// // //             Padding(
// // //               padding: const EdgeInsets.all(8.0),
// // //               child: ElevatedButton(
// // //                 onPressed: () async {
// // //                   final googleLensUrl = "https://lens.google.com/uploadbyurl?url=${widget.imagePath}";
// // //
// // //                   await _launchURL(googleLensUrl);
// // //                 },
// // //                 child: const Text("Find More on Google Lens"),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// //
// //
// // import 'package:flutter/material.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'dart:convert';
// // import 'dart:typed_data';
// // import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:async';
// // import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
// // import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
// //
// // class AILensScreen extends StatefulWidget {
// //   final String imagePath;
// //   final Uint8List? imageBytes;
// //
// //   AILensScreen({required this.imagePath, this.imageBytes});
// //
// //   @override
// //   _AILensScreenState createState() => _AILensScreenState();
// // }
// //
// // class _AILensScreenState extends State<AILensScreen> {
// //   List<Map<String, String>> recommendations = [];
// //   bool isLoading = true;
// //   String errorMessage = "";
// //   ARSessionManager? arSessionManager;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     if (widget.imageBytes != null) {
// //       analyzeImage();
// //     } else {
// //       setState(() {
// //         isLoading = false;
// //         errorMessage = "Invalid image data.";
// //       });
// //     }
// //   }
// //
// //   void analyzeImage() async {
// //     try {
// //       final labels = await compute(getLabelsFromImage, widget.imageBytes!);
// //       if (labels.isEmpty) {
// //         setState(() {
// //           isLoading = false;
// //           errorMessage = "No labels detected. Try again with a clearer image.";
// //         });
// //         return;
// //       }
// //       fetchLiveProductRecommendations(labels);
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //         errorMessage = "Failed to process image.";
// //       });
// //     }
// //   }
// //
// //   static Future<List<String>> getLabelsFromImage(Uint8List imageBytes) async {
// //     final inputImage = InputImage.fromBytes(
// //         bytes: imageBytes,
// //         metadata: InputImageMetadata(
// //             size: Size(224, 224),
// //             rotation: InputImageRotation.rotation0deg,
// //             format: InputImageFormat.nv21,
// //             bytesPerRow: 224));
// //     final imageLabeler = ImageLabeler(options: ImageLabelerOptions());
// //     final labelsList = await imageLabeler.processImage(inputImage);
// //     await imageLabeler.close();
// //
// //     return labelsList.map((label) => label.label).toList();
// //   }
// //
// //   void fetchLiveProductRecommendations(List<String> labels) async {
// //     final query = labels.isNotEmpty ? labels.join("+") : "product";
// //     final googleSearchUrl = "https://www.google.com/search?tbm=shop&q=$query";
// //     _launchURL(googleSearchUrl);
// //
// //     try {
// //       final url = Uri.parse("https://serpapi.com/search.json?engine=google_lens&q=$query&api_key=YOUR_API_KEY");
// //       final response = await http.get(url);
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         setState(() {
// //           recommendations = parseSerpAPIResponse(data);
// //           isLoading = false;
// //         });
// //       } else {
// //         setState(() {
// //           isLoading = false;
// //           errorMessage = "Failed to fetch product recommendations.";
// //         });
// //       }
// //     } catch (e) {
// //       setState(() {
// //         isLoading = false;
// //         errorMessage = "Error fetching recommendations: $e";
// //       });
// //     }
// //   }
// //
// //   List<Map<String, String>> parseSerpAPIResponse(Map<String, dynamic> data) {
// //     List<Map<String, String>> products = [];
// //     if (data.containsKey("visual_matches")) {
// //       for (var item in data["visual_matches"]) {
// //         products.add({
// //           "name": item["title"] ?? "Unknown Product",
// //           "price": item["price"] ?? "N/A",
// //           "link": item["link"] ?? "#",
// //           "image": item["thumbnail"] ?? "",
// //         });
// //       }
// //     }
// //     return products;
// //   }
// //
// //   Future<void> _launchURL(String url) async {
// //     final Uri uri = Uri.parse(url);
// //     if (await canLaunchUrl(uri)) {
// //       await launchUrl(uri, mode: LaunchMode.externalApplication);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("AI Lens - Product Search"),
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back),
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //         ),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             flex: 2,
// //             child: ARView(
// //               onARViewCreated: (ARSessionManager sessionManager) {
// //                 arSessionManager = sessionManager;
// //                 arSessionManager?.onInitialize(
// //                   showFeaturePoints: false,
// //                   showPlanes: true,
// //                   showWorldOrigin: true,
// //                   handleTaps: true,
// //                 );
// //               },
// //             ),
// //           ),
// //           SizedBox(height: 20),
// //           Text("Recommended Products", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
// //           Expanded(
// //             child: isLoading
// //                 ? Center(child: CircularProgressIndicator())
// //                 : errorMessage.isNotEmpty
// //                 ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
// //                 : ListView.builder(
// //               scrollDirection: Axis.horizontal,
// //               itemCount: recommendations.length,
// //               itemBuilder: (context, index) {
// //                 final product = recommendations[index];
// //                 return productCard(product["name"]!, product["image"]!);
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget productCard(String title, String imageUrl) {
// //     return Container(
// //       width: 150,
// //       margin: EdgeInsets.all(8),
// //       child: Column(
// //         children: [
// //           Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(Icons.image)),
// //           Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
// //         ],
// //       ),
// //     );
// //   }
// // }
//

// import 'package:flutter/material.dart';
// import 'package:flutter_project/home/AR_Screen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:typed_data';
//
// class AILensScreen extends StatefulWidget {
//   final String imagePath;
//   final Uint8List? imageBytes;
//
//   AILensScreen({required this.imagePath, this.imageBytes});
//
//   @override
//   _AILensScreenState createState() => _AILensScreenState();
// }
//
// class _AILensScreenState extends State<AILensScreen> {
//   List<Map<String, String>> recommendations = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRecommendations();
//   }
//
//   void fetchRecommendations() async {
//     List<Map<String, String>> products = await getRecommendedProducts(widget.imagePath);
//     setState(() {
//       recommendations = products;
//       isLoading = false;
//     });
//   }
//
//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       print("Could not launch URL: $url");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("AI Lens - Product Recommendations"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 300),
//               child: IconButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const ArScreen()));
//               }, icon: const Icon(Icons.camera_alt)),
//             ),
//             widget.imageBytes != null
//                 ? Image.memory(widget.imageBytes!, height: 250, fit: BoxFit.cover)
//                 : Image.asset(widget.imagePath, height: 250, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
//               return const Icon(Icons.broken_image, size: 250, color: Colors.grey);
//             }),
//             SizedBox(height: 10),
//             Text("Scanning Image...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: recommendations.length,
//               itemBuilder: (context, index) {
//                 final product = recommendations[index];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () async {
//                       await _launchURL(product["link"]!);
//                     },
//                     child: Card(
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       child: ListTile(
//                         leading: Image.network(
//                           product["image"]!,
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
//                           },
//                         ),
//                         title: Text(product["name"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         subtitle: Text(product["price"]!, style: TextStyle(fontSize: 16, color: Colors.green)),
//                         trailing: Icon(Icons.arrow_forward_ios),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final searchUrl = "https://www.google.com/searchbyimage?image_url=${Uri.encodeComponent(widget.imagePath)}";
//                   await _launchURL(searchUrl);
//                 },
//                 child: Text("Find More on Google"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Future<List<Map<String, String>>> getRecommendedProducts(String imagePath) async {
//   await Future.delayed(Duration(seconds: 2));
//
//   return [
//     {
//       "name": "Ergonomic Chair",
//       "price": "\₹199",
//       "link": "https://www.google.com/search?q=Ergonomic+Chair",
//       "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Office_chair.jpg/800px-Office_chair.jpg"
//     },
//     {
//       "name": "Office Chair",
//       "price": "\₹149",
//       "link": "https://www.google.com/search?q=Office+Chair",
//       "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Task_chair.jpg/800px-Task_chair.jpg"
//     },
//     {
//       "name": "Gaming Chair",
//       "price": "\₹249",
//       "link": "https://www.google.com/search?q=Gaming+Chair",
//       "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Gaming_chair.jpg/800px-Gaming_chair.jpg"
//     },
//     {
//       "name": "Executive Chair",
//       "price": "\₹299",
//       "link": "https://www.google.com/search?q=Executive+Chair",
//       "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Leather_executive_chair.jpg/800px-Leather_executive_chair.jpg"
//     },
//   ];
// }
//


// import 'package:flutter/material.dart';


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_project/home/AR_Screen.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
// import 'dart:typed_data';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// import 'home/home_screen.dart';
//
// class AILensScreen extends StatefulWidget {
//   final String imagePath;
//   final Uint8List? imageBytes;
//
//   AILensScreen({required this.imagePath, this.imageBytes});
//
//   @override
//   _AILensScreenState createState() => _AILensScreenState();
// }
//
// class _AILensScreenState extends State<AILensScreen> {
//   Map<String, String>? recommendation;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => loadActualImage());
//   }
//
//   Future<void> loadActualImage() async {
//     try {
//       if (widget.imageBytes == null) {
//         print("No imageBytes provided");
//         setState(() => isLoading = false);
//         return;
//       }
//
//       setState(() => isLoading = true);
//       final result = await getAIRecommendationsMLKit(widget.imageBytes!);
//       setState(() {
//         recommendation = result;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("Error loading actual image: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Could not open the link")),
//       );
//     }
//   }
//
//   Future<void> _launchGoogleLensWithImage() async {
//     if (widget.imagePath.isNotEmpty) {
//       final Uri lensUri = Uri.parse('googleapp://lens?use_camera=0&image_uri=file://${widget.imagePath}');
//       if (await canLaunchUrl(lensUri)) {
//         await launchUrl(lensUri, mode: LaunchMode.externalApplication);
//       } else {
//         await _launchURL("https://lens.google.com/upload");
//       }
//     } else {
//       await _launchURL("https://lens.google.com/upload");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("AI Lens - Product Recommendations"),
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//            Container(
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 300),
//                 child: IconButton(onPressed: () async{
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>ArScreen()));
//                 },
//                   icon: const Icon(Icons.camera_alt_outlined,),alignment: Alignment.topRight,),
//               ),
//             ),
//               // const ModelViewer(
//               //   src: "assets/images/cover_chair.glb",
//               //   ar: true,
//               //   autoRotate: true,
//               //   cameraControls: true,
//               //   disableZoom: false,
//               //   backgroundColor: Colors.transparent,
//               // ),
//           Align(
//             alignment: Alignment.topCenter,
//             child: SizedBox(
//                 height: 200,
//                 width: 450,
//                 child: ModelViewer(src:"assets/images/cover_chair.glb",)
//             ),
//           ),
//           const SizedBox(height: 10,),
//           Expanded(
//             flex: 3,
//             child: Container(
//               padding: EdgeInsets.all(60),
//               decoration: BoxDecoration(
//                 color: Colors.grey[900],
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Recommended Products",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 12),
//                   recommendation == null || recommendation!["name"] == "No match found"
//                       ? Column(
//                     children: [
//                       Icon(Icons.search_off, size: 80, color: Colors.white30),
//                       SizedBox(height: 10),
//                       Text("No recommendations found.",
//                           style: TextStyle(color: Colors.white70)),
//                       Text("Try scanning a clearer or different angle.",
//                           style: TextStyle(color: Colors.white54, fontSize: 12)),
//                       TextButton(
//                         onPressed: _launchGoogleLensWithImage,
//                         child: Text("Try with Google Lens →",
//                             style: TextStyle(color: Colors.blueAccent)),
//                       ),
//                     ],
//                   )
//                       : SizedBox(
//                     height: 180,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: List.generate(4, (index) => RecommendationCard(index: index, onTap: _launchURL)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ]
//       )
//     );
//   }
// }
//
// class RecommendationCard extends StatelessWidget {
//   final int index;
//   final void Function(String url) onTap;
//
//   RecommendationCard({required this.index, required this.onTap});
//
//   final List<Map<String, String>> dummyProducts = const [
//     {
//       "name": "Ergo Highback Chair",
//       "price": "₹9,999",
//       "image": "https://images.unsplash.com/photo-1601933470928-c231b48cdaee",
//       "link": "https://www.google.com/search?q=ergonomic+high+back+chair&tbm=shop",
//     },
//     {
//       "name": "Mesh Task Chair",
//       "price": "₹6,499",
//       "image": "https://images.unsplash.com/photo-1600172454520-008d5563b491",
//       "link": "https://www.google.com/search?q=mesh+task+chair&tbm=shop",
//     },
//     {
//       "name": "Leather Office Chair",
//       "price": "₹12,299",
//       "image": "https://images.unsplash.com/photo-1616627452634-e6ffdcbb4c7b",
//       "link": "https://www.google.com/search?q=leather+office+chair&tbm=shop",
//     },
//     {
//       "name": "Executive Swivel Chair",
//       "price": "₹14,799",
//       "image": "https://images.unsplash.com/photo-1616627452395-58acdee7e5be",
//       "link": "https://www.google.com/search?q=executive+swivel+chair&tbm=shop",
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final product = dummyProducts[index];
//
//     return GestureDetector(
//       onTap: () => onTap(product["link"]!),
//       child: Container(
//         width: 140,
//         margin: EdgeInsets.only(right: 12),
//         decoration: BoxDecoration(
//           color: Colors.grey[850],
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
//               child: Image.network(
//                 product["image"]!,
//                 height: 100,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//               child: Column(
//                 children: [
//                   Text(
//                     product["name"]!,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(height: 2),
//                   Text(
//                     product["price"]!,
//                     style: TextStyle(color: Colors.greenAccent, fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Future<Map<String, String>?> getAIRecommendationsMLKit(Uint8List imageBytes) async {
//
//   final imageLabeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));
//
//   try {
//     final decodedImage = img.decodeImage(imageBytes);
//     if (decodedImage == null) {
//       print("Image decoding failed");
//       return null;
//     }
//
//     final resizedImage = img.copyResize(decodedImage, width: 224, height: 224);
//     final convertedBytes = Uint8List.fromList(img.encodeJpg(resizedImage));
//
//     final metadata = InputImageMetadata(
//       size: Size(resizedImage.width.toDouble(), resizedImage.height.toDouble()),
//       rotation: InputImageRotation.rotation0deg,
//       format: InputImageFormat.bgra8888,
//       bytesPerRow: resizedImage.width * 4,
//     );
//
//     final inputImage = InputImage.fromBytes(
//       bytes: convertedBytes,
//       metadata: metadata,
//     );
//
//     final labels = await imageLabeler.processImage(inputImage);
//     await imageLabeler.close();
//
//     print("Labels found: ${labels.length}");
//     for (var label in labels) {
//       print("Detected: ${label.label}, confidence: ${label.confidence}");
//     }
//
//     if (labels.isEmpty) {
//       return {
//         "name": "No match found",
//         "price": "-",
//         "image": "https://cdn-icons-png.flaticon.com/512/7486/7486793.png",
//         "link": "https://lens.google.com/upload"
//       };
//     }
//
//     final query = Uri.encodeComponent(labels.first.label);
//     final googleUrl = "https://www.google.com/search?q=$query&tbm=shop";
//     final imageUrl = "https://source.unsplash.com/featured/?$query";
//
//     return {
//       "name": labels.first.label,
//       "price": "-",
//       "image": imageUrl,
//       "link": googleUrl,
//     };
//   } catch (e) {
//     print("MLKit error: $e");
//     return null;
//   }
// }





import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';

import 'home/AR_Screen.dart';

class AILensScreen extends StatefulWidget {
  final String imagePath;
  final Uint8List? imageBytes;

  AILensScreen({required this.imagePath, this.imageBytes});

  @override
  _AILensScreenState createState() => _AILensScreenState();
}

class _AILensScreenState extends State<AILensScreen> {
  List<Map<String, String>> recommendations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  void fetchRecommendations() async {
    List<Map<String, String>> products = await getRecommendedProducts(widget.imagePath);
    setState(() {
      recommendations = products;
      isLoading = false;
    });
  }

  Future<void> _launchURL(String query) async {
    final Uri googleAppUri = Uri.parse("google://search?q=${Uri.encodeComponent(query)}");
    final Uri webSearchUri = Uri.parse("https://www.google.com/search?q=${Uri.encodeComponent(query)}");

    if (await canLaunchUrl(googleAppUri)) {
      await launchUrl(googleAppUri);
    } else {
      await launchUrl(webSearchUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("AI Lens - Product Recommendations"),
        backgroundColor: Colors.deepOrangeAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 300),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArScreen()));
                },
                icon: const Icon(Icons.camera_alt_outlined),
                alignment: Alignment.topRight,
              ),
            ),
          ),
          Expanded(

              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: ModelViewer(src: "assets/ar_model/cover_chair.glb"),
)
            ),

          // SizedBox(height: 10),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Text(
                    "Recommended Products",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendations.length,
                      itemBuilder: (context, index) {
                        final product = recommendations[index];
                        return GestureDetector(
                          onTap: () async {
                            await _launchURL(product["link"]!);
                          },
                          child: Center(
                            child: Card(
                              color: Colors.grey[850],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                width: 150,
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.network(
                                      product["image"]!,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.chair_alt, size: 80, color: Colors.white);
                                      },
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      product["name"]!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      product["price"]!,
                                      style: TextStyle(color: Colors.green, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      final searchUrl =
                          "https://lens.google.com/uploadbyurl?url=${Uri.encodeComponent(widget.imagePath)}";
                      await _launchURL(searchUrl);
                    },
                    child: Text("Find More on Google Lens"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🧠 Mock product recommendations
Future<List<Map<String, String>>> getRecommendedProducts(String imagePath) async {
  await Future.delayed(Duration(seconds: 2));
  return [
    {
      "name": "Ergonomic Chair",
      "price": "₹199",
      "link": "Ergonomic Chair",
      "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Modern_office_chair.jpg/800px-Modern_office_chair.jpg"
    },
    {
      "name": "Office Chair",
      "price": "₹149",
      "link": "Office Chair",
      "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Swivel_chair.jpg/800px-Swivel_chair.jpg"
    },
    {
      "name": "Gaming Chair",
      "price": "₹249",
      "link": "Gaming Chair",
      "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Gaming_chair_example.jpg/800px-Gaming_chair_example.jpg"
    },
    {
      "name": "Executive Chair",
      "price": "₹299",
      "link": "Executive Chair",
      "image": "https://www.chennaichairs.com/wp-content/uploads/2020/11/executive-chair.jpg"
    },
  ];
}



// import 'package:flutter/material.dart';
// import 'package:flutter_project/home/AR_Screen.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:typed_data';
//
// class AILensScreen extends StatefulWidget {
//   final String imagePath;
//   final Uint8List? imageBytes;
//
//   AILensScreen({required this.imagePath, this.imageBytes});
//
//   @override
//   _AILensScreenState createState() => _AILensScreenState();
// }
//
// class _AILensScreenState extends State<AILensScreen> {
//   List<Map<String, String>> recommendations = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRecommendations();
//   }
//
//   void fetchRecommendations() async {
//     List<Map<String, String>> products = await getRecommendedProducts(widget.imagePath);
//     setState(() {
//       recommendations = products;
//       isLoading = false;
//     });
//   }
//
//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       print("Could not launch URL: $url");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("AI Lens - Product Recommendations"),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 300),
//               child: IconButton(
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ArScreen()));
//                 },
//                 icon: const Icon(Icons.camera_alt),
//               ),
//             ),
//             widget.imageBytes != null
//                 ? Image.memory(widget.imageBytes!, height: 250, fit: BoxFit.cover)
//                 : Image.asset(widget.imagePath, height: 250, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
//               return const Icon(Icons.broken_image, size: 250, color: Colors.grey);
//             }),
//             SizedBox(height: 10),
//             Text("Scanning Image...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: recommendations.length,
//               itemBuilder: (context, index) {
//                 final product = recommendations[index];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GestureDetector(
//                     onTap: () async {
//                       await _launchURL(product["link"]!);
//                     },
//                     child: Card(
//                       elevation: 5,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                       child: ListTile(
//                         leading: Image.network(
//                           product["image"]!,
//                           width: 50,
//                           height: 50,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
//                           },
//                         ),
//                         title: Text(product["name"]!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         subtitle: Text(product["price"]!, style: TextStyle(fontSize: 16, color: Colors.green)),
//                         trailing: Icon(Icons.arrow_forward_ios),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final searchUrl = "https://www.google.com/searchbyimage?image_url=${Uri.encodeComponent(widget.imagePath)}";
//                   await _launchURL(searchUrl);
//                 },
//                 child: Text("Find More on Google"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Future<List<Map<String, String>>> getRecommendedProducts(String imagePath) async {
//   await Future.delayed(Duration(seconds: 2));
//
//   return [
//     {
//       "name": "Ergonomic Chair",
//       "price": "₹199",
//       "link": "https://www.google.com/search?q=Ergonomic+Chair",
//       "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Office_chair.jpg/800px-Office_chair.jpg"
//     },
//     {
//       "name": "Office Chair",
//       "price": "₹149",
//       "link": "https://www.google.com/search?q=Office+Chair",
//       "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3d/Task_chair.jpg/800px-Task_chair.jpg"
//     },
//     {
//       "name": "Gaming Chair",
//       "price": "₹249",
//       "link": "https://www.google.com/search?q=Gaming+Chair",
//       "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Gaming_chair.jpg/800px-Gaming_chair.jpg"
//     },
//     {
//       "name": "Executive Chair",
//       "price": "₹299",
//       "link": "https://www.google.com/search?q=Executive+Chair",
//       "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Leather_executive_chair.jpg/800px-Leather_executive_chair.jpg"
//     },
//   ];
// }
//
