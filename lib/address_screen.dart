import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "My Address",
        isCenterTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FA),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                  ]),
              child: ListTile(
                leading: Icon(
                  Icons.home,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text("Home"),
                subtitle: const Text(
                  "123, ABC, India",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
