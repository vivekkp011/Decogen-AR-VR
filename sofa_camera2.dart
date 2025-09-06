import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';

import 'home/AR_Screen.dart';

class SofaAILensScreen2 extends StatefulWidget {
  final String imagePath;
  final Uint8List? imageBytes;

  SofaAILensScreen2({required this.imagePath, this.imageBytes});

  @override
  _AILensScreenState createState() => _AILensScreenState();
}

class _AILensScreenState extends State<SofaAILensScreen2> {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SofaArScreen2()));
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
                child: ModelViewer(src: "assets/ar_model/sofa_web.glb",autoRotate: true,),
              ),
            ),

          // SizedBox(height: 10),
          if (isLoading) Center(child: CircularProgressIndicator()) else Expanded(
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
                  SizedBox(height: 10),
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
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 80,
                                          color: Colors.grey[850],
                                          child: Icon(Icons.chair_rounded, size: 70, color: Colors.white),
                                        );
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


// 🛋️ Mock product recommendations (All sofas)
Future<List<Map<String, String>>> getRecommendedProducts(String imagePath) async {
  await Future.delayed(Duration(seconds: 2));
  return [
    {
      "name": "Modern Sofa (Your Uploaded Model)",
      "price": "₹899",
      "link": "Modern Sofa",
      "image": "https://www.ikea.com/images/a-modern-grey-3-seat-sofa-broedaryd-dark-grey-d315bdd06df569a4242a31f3d6be31a3.jpg"
    },
    {
      "name": "L-Shaped Sectional Sofa",
      "price": "₹1,299",
      "link": "L-Shaped Sectional Sofa",
      "image": "https://www.ulcdn.net/images/products/711576/product/Livorno_3_Seater_Right_L_Shaped_Sofa_Walnut_Finish_Front_Angle_1.jpg"
    },
    {
      "name": "Classic Beige Fabric Sofa",
      "price": "₹749",
      "link": "Classic Beige Sofa",
      "image": "https://5.imimg.com/data5/SELLER/Default/2022/3/VA/OB/HZ/12277077/beige-fabric-sofa-set-500x500.jpg"
    },
    {
      "name": "Velvet Tufted Sofa",
      "price": "₹1,599",
      "link": "Velvet Tufted Sofa",
      "image": "https://www.luxdeco.com/cdn/shop/products/versace-leather-sofa-2-1674749570.jpg"
    },
    {
      "name": "Convertible Sofa Bed",
      "price": "₹999",
      "link": "Convertible Sofa Bed",
      "image": "https://www.hometown.in/assets/images/product/740187371_grey.jpg"
    },
  ];
}

