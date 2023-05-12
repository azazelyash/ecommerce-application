import 'package:abhyukthafoods/comps/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductPage extends StatefulWidget {
  ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final PageController pageController = PageController();

  final pages = [
    Image.asset(fit: BoxFit.contain, 'assets/Rectangle 33.png'),
    Image.asset(fit: BoxFit.contain, 'assets/Rectangle 33.png'),
  ];

  final List<bool> isSelected = [true, false, false];

  void selectButton(int index) {
    return setState(() {
      isSelected.fillRange(0, isSelected.length, false);
      isSelected[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: 2,
                            itemBuilder: (context, index) => Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: pages[index],
                            ),
                          ),
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
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Chicken Pickle',
                            style: theme.textTheme.titleMedium,
                          )),
                          const Spacer(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('₹150.00 - ₹550.00'),
                          CounterWidget()
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: List<Widget>.generate(
                            isSelected.length,
                            (index) => VariationButton(
                                  isSelected: isSelected[index],
                                  selectButtonCallback: () =>
                                      selectButton(index),
                                )),
                      ),
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
                        children: const [
                          Expanded(
                            child: Text(
                              'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available.',
                            ),
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
                      const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ProductCard()),
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
      required this.selectButtonCallback,
      required this.isSelected});
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
          '100Gm',
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
              style: TextStyle(color: Colors.white, fontSize: 15),
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
