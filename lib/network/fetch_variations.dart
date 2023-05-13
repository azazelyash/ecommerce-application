
import 'package:abhyukthafoods/network/network_helper.dart';
import 'package:abhyukthafoods/utils/api_key.dart';

import '../models/variations.dart';

Future<List<Variation>> fetchVariations(String productId) async {
  var url =
      '${storeUrl}products/$productId/variations?consumer_key=$consumerKey&consumer_secret=$consumerSecret';

  NetworkHelper networkHelper = NetworkHelper(url);

  var variationData = await networkHelper.getData();
  // log(productsData.toString());

  List<Variation> variations = [];
  variationData.forEach((data) {
    variations.add(Variation.fromJson(data));
  });

  // for (var x in variations) {
  //   log(x.name.toString())
  //   log(x.images[0);
  // }
  return variations;
}
