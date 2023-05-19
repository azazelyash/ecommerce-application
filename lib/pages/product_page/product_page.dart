import 'package:abhyukthafoods/comps/product_card.dart';
import 'package:abhyukthafoods/models/products.dart';
import 'package:abhyukthafoods/network/fetch_products.dart';
import 'package:abhyukthafoods/network/fetch_variations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({required this.product, super.key});
  final Product product;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();
  Future<List>? variationData;

  int varIndex = 0;
  late List<bool> isSelected = [];

  void selectButton(int index) {
    setState(() {
      varIndex = index;
      isSelected.fillRange(0, isSelected.length, false);
      isSelected[index] = true;
    });
  }

  String resolvePrice(dynamic product) {
    if (product.price != '') {
      return '₹' + product.price;
    } else if (product.regularPrice != '') {
      return '₹' + product.regularPrice;
    } else if (product.salePrice != '') {
      return '₹' + product.salePrice;
    } else {
      return 'No Price set';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.product.variations!.isEmpty) {
      variationData = Future.value([0]);
    } else {
      variationData = fetchVariations(widget.product.id.toString());
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.product.variations!.isEmpty) return;
    isSelected = [...widget.product.variations!.map((e) => false)];
    isSelected[0] = true;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.product.images!.length);
    var pages = [
      ...widget.product.images!.map((e) => Image(image: NetworkImage(e['src'])))
    ];
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//---------------------------------- Back Button -----------------------------
                  GestureDetector(
                    child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100))),
                        padding: const EdgeInsets.all(10),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

//---------------------------------- Image Widget -----------------------------

                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: FutureBuilder(
                              future: variationData,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                } else {
                                  if (widget.product.variations!.isNotEmpty) {
                                    pages = [
                                      Image(
                                          image: NetworkImage(snapshot
                                              .data![varIndex].imageUrl))
                                    ];
                                  }
                                  return PageView.builder(
                                    controller: pageController,
                                    itemCount: pages.length,
                                    itemBuilder: (context, index) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: pages[index]),
                                  );
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SmoothPageIndicator(
                            controller: pageController, count: 1),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
//
//---------------------------------- Title widget -----------------------------

                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            widget.product.name,
                            style: theme.textTheme.titleMedium,
                          )),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(
                                  color: Colors.white, 'assets/Icons/love.svg'),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

//---------------------------------- Price and Counter -----------------------------

                      FutureBuilder(
                        future: variationData,
                        builder: (context, snapshot) => !snapshot.hasData
                            ? const CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.product.variations!.isEmpty
                                      ? resolvePrice(widget.product)
                                      : resolvePrice(snapshot.data![varIndex])),
                                  const CounterWidget()
                                ],
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

//---------------------------------- Variation selector  -----------------------------

                      FutureBuilder(
                          future: variationData,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            return Wrap(
                              children: List<Widget>.generate(
                                  isSelected.length,
                                  (index) => VariationButton(
                                        label: snapshot.data![index].name,
                                        isSelected: isSelected[index],
                                        selectButtonCallback: () =>
                                            selectButton(index),
                                      )),
                            );
                          }),
// ------------------------------------------------------------------------------------
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Colors.black),
                        child: const Text('Add to Cart'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Buy Now'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Product Description',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(widget.product.shortDescription == ''
                                ? 'No description'
                                : widget.product.shortDescription!),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Suggested Products',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: fetchProducts(),
                        builder: (context, snapshot) => !snapshot.hasData
                            ? const CircularProgressIndicator()
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...snapshot.data!.map(
                                      (e) => Container(
                                        padding: const EdgeInsets.all(10),
                                        height: 300,
                                        width: 200,
                                        child: ProductCard(
                                          product: e,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VariationButton extends StatefulWidget {
  const VariationButton(
      {super.key,
      required this.label,
      required this.selectButtonCallback,
      required this.isSelected});
  final String label;
  final Function selectButtonCallback;
  final bool isSelected;
  @override
  State<VariationButton> createState() => _VariationButtonState();
}

class _VariationButtonState extends State<VariationButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          widget.selectButtonCallback();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: widget.isSelected ? null : Colors.white,
            minimumSize: const Size(80, 100)),
        child: Text(
          widget.label,
          style:
              TextStyle(color: widget.isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => count > 1
              ? setState(() {
                  count--;
                })
              : null,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: Colors.black,
            ),
            height: 30,
            width: 50,
            child: const Center(
              child: Text(
                '-',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0,
            ),
            color: Colors.black,
          ),
          height: 30,
          width: 50,
          child: Center(
            child: Text(
              count.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
        InkWell(
          onTap: () => setState(() {
            count++;
          }),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.black,
            ),
            height: 30,
            width: 50,
            child: const Center(
              child: Text(
                '+',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        )
      ],
    );
  }
}
