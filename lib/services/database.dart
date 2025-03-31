import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // Modified to return artworkId
  Future<String> addProduct(Map<String, dynamic> userInfoMap,
      String categoryName, String userId) async {
    try {
      // Add the product to Firestore
      DocumentReference artworkRef = await FirebaseFirestore.instance
          .collection(categoryName) // The collection name (e.g., "artworks")
          .add(userInfoMap); // Add the product data to Firestore

      // Get the artworkId (Firestore document ID)
      String artworkId = artworkRef.id;

      // Update the user's uploaded artworks field with the artworkId
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'uploadedArtworks': FieldValue.arrayUnion([artworkId]),
      });

      // Return the artworkId so we can use it in uploadItem
      return artworkId;
    } catch (e) {
      rethrow; // Rethrow error for further handling
    }
  }

  Future<Stream<QuerySnapshot>> getProducts(String category) async {
    return FirebaseFirestore.instance
        .collection(category)
        .where('approved', isEqualTo: true)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getMultipleCollectionsData() async {
    final gPencilArtCollection = FirebaseFirestore.instance
        .collection('Graphite Pencil Portrait')
        .where('approved', isEqualTo: true);
    final cPencilArtCollection = FirebaseFirestore.instance
        .collection('Colour Pencil Portrait')
        .where('approved', isEqualTo: true);
    final chPencilArtCollection = FirebaseFirestore.instance
        .collection('Charcoal Pencil Portrait')
        .where('approved', isEqualTo: true);
    final vectorArtCollection = FirebaseFirestore.instance
        .collection('Vector art')
        .where('approved', isEqualTo: true);
    final watercolorArtCollection = FirebaseFirestore.instance
        .collection('Watercolor')
        .where('approved', isEqualTo: true);
    final penArtCollection = FirebaseFirestore.instance
        .collection('Pen Portrait')
        .where('approved', isEqualTo: true);

    // Fetch data from all collections
    final gPencilArtData = await gPencilArtCollection.limit(2).get();
    final cPencilArtData = await cPencilArtCollection.limit(2).get();
    final chPencilArtData = await chPencilArtCollection.limit(2).get();
    final vectorArtData = await vectorArtCollection.limit(2).get();
    final watercolorArtData = await watercolorArtCollection.limit(1).get();
    final penArtData = await penArtCollection.limit(1).get();

    // Combine data from all collections
    List<Map<String, dynamic>> combinedData = [];

    // Add productId (documentId) to each document's data
    combinedData.addAll(gPencilArtData.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['productId'] = doc.id; // Add productId (doc.id) to the data map
      return data;
    }));

    combinedData.addAll(cPencilArtData.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['productId'] = doc.id; // Add productId (doc.id) to the data map
      return data;
    }));

    combinedData.addAll(chPencilArtData.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['productId'] = doc.id; // Add productId (doc.id) to the data map
      return data;
    }));

    combinedData.addAll(vectorArtData.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['productId'] = doc.id; // Add productId (doc.id) to the data map
      return data;
    }));

    combinedData.addAll(watercolorArtData.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['productId'] = doc.id; // Add productId (doc.id) to the data map
      return data;
    }));

    combinedData.addAll(penArtData.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['productId'] = doc.id; // Add productId (doc.id) to the data map
      return data;
    }));

    // Shuffle the data to mix items from different collections
    combinedData.shuffle(Random());

    // Limit the number of items to 10
    if (combinedData.length > 10) {
      combinedData = combinedData.sublist(0, 10);
    }

    return combinedData;
  }
}
