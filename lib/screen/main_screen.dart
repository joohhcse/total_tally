import 'package:flutter/material.dart';

import 'package:total_tally/model/Product.dart';
import 'package:total_tally/database/database_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();
  List<Map<String, dynamic>> itemsList = [];  //don't use
  List<Product> _product = [];
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _getProduct();
  }

  Future<void> _getProduct() async {
    final product = await DatabaseService.instance.getAllProduct();
    if(mounted) {
      setState(() => _product = product);
    }
  }

  Future<void> _fetchTotalPrice() async {
    double price = await DatabaseService.instance.getTotalPriceOfAllProducts();
    setState(() {
      totalPrice = price;
    });
  }

  Future<void> _addItem() async {
    setState(() {
      Product newProduct = Product(
        name: itemNameController.text,
        quantity: int.parse(itemQuantityController.text),
        price: double.parse(itemPriceController.text),
      );

      // String name = itemNameController.text;
      // int quantity = int.parse(itemQuantityController.text);
      // double price = double.parse(itemPriceController.text);

      // itemsList.add(Product(id:idx, name: name, price: price, quantity: quantity));
      DatabaseService.instance.insert(newProduct)
          .then((_) => print('제품이 데이터베이스에 추가되었습니다.'))
          .catchError((error) => print('제품 추가 중 오류 발생: $error'));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              '- TOTAL PRICE -',
              style: TextStyle(fontSize: 18),
            ),
            FutureBuilder<double>(
              future: DatabaseService.instance.getTotalPriceOfAllProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // 데이터 로딩 중이면 로딩 표시
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  double totalPrice = snapshot.data ?? 0.0; // 데이터 로딩 완료 후 totalPrice 갱신
                  return Text(
                    '$totalPrice',
                    style: TextStyle(fontSize: 26),
                  );
                }
              },
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: DatabaseService.instance.getAllProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // 데이터 로딩 중이면 로딩 표시
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Product> products = snapshot.data ?? []; // 데이터 로딩 완료 후 데이터 가져오기
                    return ListView.separated(
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        double amount = products[index].price * products[index].quantity;
                        return ListTile(
                          title: Text('${products[index].price} × ${products[index].quantity} = $amount'),
                          subtitle: Text(products[index].name),
                          trailing: GestureDetector(
                            onTap: () async {
                              try {
                                await DatabaseService.instance.deleteProduct(products[index].id!);
                                setState(() {
                                  products.removeAt(index);
                                });
                              } catch (e) {
                                print("An error occurred: $e");
                              }
                            },
                            child: Icon(
                              Icons.delete_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 0.0),
                    );
                  }
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: itemNameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                  ),
                ),
                SizedBox(width: 10), // 각 TextField 사이에 간격을 줍니다.
                Expanded(
                  child: TextField(
                    controller: itemPriceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                SizedBox(width: 10), // 각 TextField 사이에 간격을 줍니다.
                Expanded(
                  child: TextField(
                    controller: itemQuantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addItem().then((_) {
                      // 상태를 갱신하고 데이터를 다시 불러옵니다.
                      setState(() {});
                    });
                  },
                  child: Text('+'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



}
