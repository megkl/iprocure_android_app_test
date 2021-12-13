import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iprocure_app/Models/category_model.dart';
import 'package:iprocure_app/Models/product_model.dart';
import 'package:iprocure_app/helper/database_helper.dart';
import 'package:iprocure_app/widgets/constants.dart';
import 'package:iprocure_app/widgets/image_utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  DatabaseHelper dbHelper = DatabaseHelper();
  Category category;
  Product product;

  final _globalkey = GlobalKey<FormState>();
  TextEditingController _productName = TextEditingController();
  TextEditingController _productCode = TextEditingController();
  TextEditingController _productImage = TextEditingController();
  TextEditingController _distributorName = TextEditingController();
  TextEditingController _manufacturerName = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  TextEditingController _quantityTypeName = TextEditingController();
  TextEditingController _categoryName = TextEditingController();
  TextEditingController _retailPrice = TextEditingController();
  TextEditingController _wholesalePrice = TextEditingController();
  TextEditingController _unitCost = TextEditingController();
  TextEditingController _agentPrice = TextEditingController();
  bool _isVatEnabled = true;
  ImagePicker picker = ImagePicker();
  PickedFile _imageFile;
  File _image;
  IconData iconphoto = Icons.image;
  String quantityTypeSelectedValue = 'Kg';
  static var quantityTypeList = ['g', 'Kg', 'Tonnes'];
  String categorySelectedValue = 'Cereal Seeds';
  static var categoryList = ['Cereal Seeds', 'Minerals', 'Equipment'];
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Create new product",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
        leading: InkWell(
          onTap: moveToLastScreen,
          child: Icon(Icons.arrow_back_ios, color: Colors.black)),
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          children: <Widget>[
            productNameTextField(),
            SizedBox(height: 20),
            productCodeTextField(),
            SizedBox(height: 20),
            categoryTextField(),
            SizedBox(height: 20),
            manufacturerTextField(),
            SizedBox(height: 20),
            distributorTextField(),
            SizedBox(height: 20),
           Row(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    Expanded(
      child: new Padding(
        padding: const EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10),
        child: quantityTextField(),
      ),
    ),
    Expanded(
      child: new Padding(
        padding: const EdgeInsets.only(left: 100, right: 10.0),
        child: quantityTypeDropdown(),
      ),
    ),
  ],
),
            SizedBox(height: 20),
            isVatEnabled(),
            SizedBox(height: 20),
            unitCostTextField(),
            SizedBox(height: 20),
            retailPriceTextField(),
            SizedBox(height: 20),
            agentPriceTextField(),
            SizedBox(height: 20),
            wholesalePriceTextField(),
            SizedBox(height: 20),
            productImage(),
            SizedBox(height: 20),
            addButton(),
          ],
        ),
      ),
    );
  }

  Widget productNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Product Name",
          textAlign: TextAlign.left,
          style: headerNotesStyle,),
          SizedBox(height: 10),
          Material(
            child: TextFormField(
              controller: _productName,
              validator: (value) {
                if (value.isEmpty) {
                  return "Product name can't be empty";
                } else if (value.length > 100) {
                  return "Product Name length should be <=100";
                }
                return null;
              },
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: headerColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: headerColor,
                    width: 2,
                  ),
                ),
                labelText: "Add Product Name",
                labelStyle: TextStyle(color: Colors.black12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productCodeTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Product Code",
          textAlign: TextAlign.left,
          style: headerNotesStyle,),
          SizedBox(height: 10),
          TextFormField(
            controller: _productCode,
            validator: (value) {
              if (value.isEmpty) {
                return "Product Code can't be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe46b10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              labelText: "Provide a Product Code for the product",
              labelStyle: TextStyle(color: Colors.black12),
            ),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget categoryTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category",
          textAlign: TextAlign.left,
          style: headerNotesStyle,),
          SizedBox(height: 10),
          DropdownButtonFormField(
            items: categoryList.map((String dropDownStringItem) {
              return new DropdownMenuItem(
                  value: dropDownStringItem,
                  child: Row(
                    children: <Widget>[
                      Text(dropDownStringItem),
                    ],
                  ));
            }).toList(),
            onChanged: (value) {
              // do other stuff with _category
              setState(() => categorySelectedValue = value.toString());
            },
            value: categorySelectedValue,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              filled: true,
              fillColor: Colors.grey[200],
              //hintText: Localization.of(context).category,
            ),
          ),
        ],
      ),
    );
  }

  Widget quantityTextField() {
    return 
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Quantity",
          textAlign: TextAlign.left,
          style: headerNotesStyle,),
          SizedBox(height: 10),
              TextFormField(
                controller: _quantity,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Quantity can't be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffe46b10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 2,
                    ),
                  ),
            labelText: "Product Quantity",
              labelStyle: TextStyle(color: Colors.black12),
                ),
                maxLines: null,
              ),
            ],
          ),
        );
  }

  Widget quantityTypeDropdown(){
      return  Padding(
        padding: const EdgeInsets.only(top: 15),
        child: DropdownButtonFormField(
                items: quantityTypeList.map((String dropDownStringItem) {
                  return new DropdownMenuItem(
                      value: dropDownStringItem,
                      child: Row(
                        children: <Widget>[
                          Text(dropDownStringItem),
                        ],
                      ));
                }).toList(),
                onChanged: (value) {
                  // do other stuff with _category
                  setState(() => quantityTypeSelectedValue = value.toString());
                },
                value: quantityTypeSelectedValue,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  filled: true,
                  fillColor: Colors.grey[200],
                  //hintText: Localization.of(context).category,
                ),
              ),
      );
  }

  Widget manufacturerTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Manufacturer Name",
          textAlign: TextAlign.left,
          style: headerNotesStyle,),
          SizedBox(height: 10),
          TextFormField(
            controller: _manufacturerName,
            validator: (value) {
              if (value.isEmpty) {
                return "Manufacturer name cannot be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe46b10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
               labelText: "Manufacturer Name",
              labelStyle: TextStyle(color: Colors.black12),
            ),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget distributorTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Distributor Name",
          textAlign: TextAlign.left,
          style: headerNotesStyle,),
          SizedBox(height: 10),
          TextFormField(
            controller: _distributorName,
            validator: (value) {
              if (value.isEmpty) {
                return "Distributor Name can't be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe46b10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
               labelText: "Distributor Name",
              labelStyle: TextStyle(color: Colors.black12),
            ),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget isVatEnabled() {
    return SwitchListTile(
      title: const Text('Vat 16%',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black38
      )),
      value: _isVatEnabled,
      onChanged: (bool value) {
        setState(() {
          _isVatEnabled = value;
        });
      },
      activeTrackColor: Colors.orange,
      activeColor: Colors.orangeAccent,
      //secondary: const Icon(Icons.featured_play_list),
    );
  }

  Widget unitCostTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Unit Cost",
          textAlign: TextAlign.left,
          style: headerNotesStyle,),
          SizedBox(height: 10),
          TextFormField(
            controller: _unitCost,
            validator: (value) {
              if (value.isEmpty) {
                return "Unit Cost can't be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe46b10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
               labelText: "Unit Cost",
              labelStyle: TextStyle(color: Colors.black12),
            ),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget retailPriceTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Retail Price",
          textAlign: TextAlign.left,
          style: headerNotesStyle,),
          SizedBox(height: 10),
          TextFormField(
            controller: _retailPrice,
            validator: (value) {
              if (value.isEmpty) {
                return "Retail Price can't be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe46b10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
             labelText: "Retail Price",
              labelStyle: TextStyle(color: Colors.black12),
            ),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget agentPriceTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Agent Price",
          textAlign: TextAlign.left,
          style: headerNotesStyle,),
          SizedBox(height: 10),
          TextFormField(
            controller: _agentPrice,
            validator: (value) {
              if (value.isEmpty) {
                return "Unit Cost can't be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe46b10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              labelText: "Agent Price",
              labelStyle: TextStyle(color: Colors.black12),
            ),
            maxLines: null,
          ),
        ],
      ),
    );
  }

  Widget wholesalePriceTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("WholeSale Price",
          textAlign: TextAlign.left,
          style: headerNotesStyle,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _wholesalePrice,
            validator: (value) {
              if (value.isEmpty) {
                return "Unit Cost can't be empty";
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe46b10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
               labelText: "WholeSale Price",
              labelStyle: TextStyle(color: Colors.black12),
            ),
            maxLines: null,
          ),
        ],
      ),
    );
  }

Widget productImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffe46b10),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: headerColor,
              width: 2,
            ),
          ),
          labelText: "Add Product Image",
          labelStyle: TextStyle(color: headerColor),
          prefixIcon: IconButton(
            icon: Icon(
              iconphoto,
              color: headerColor,
            ),
            onPressed:(){
              getImage(ImageSource.gallery);
            }
          ),

        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
}
  Widget addButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          setState(() {
            Product product = Product(
                productName: _productName.text,
                productCode: _productCode.text,
                productImage: _image.path,
                categoryName: categorySelectedValue,
                quantityTypeName: quantityTypeSelectedValue,
                quantity: int.parse(_quantity.text),
                manufacturerName: _manufacturerName.text,
                distributorName: _distributorName.text,
                retailPrice: double.parse(_retailPrice.text),
                unitCost: double.parse(_unitCost.text),
                agentPrice: double.parse(_agentPrice.text),
                wholesalePrice: double.parse(_wholesalePrice.text),
                vatEnabled: _isVatEnabled ? 1 : 0);
            _save(product);
          });
        },
        child: Center(
          child: Container(
            height: 50,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffe46b10)),
            child: Center(
                child: Text(
              " Save",
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
    );
  }

  void _save(product) async {
    moveToLastScreen();

    //product.date = DateFormat.yMMMd().format(DateTime.now());
    int result;

    if (product.id == null) {
      result = await dbHelper.insertProduct(product);
    } else {
      result = await dbHelper.updateProduct(product);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Product Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'A Problem occurred while saving Product');
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  pickImageFromGallery() {
  ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
    String imgString = ImageUtility.base64String(imgFile.readAsBytesSync());
  });
}
 void getImage(ImageSource imageSource) async {
   PickedFile _imageFile = await picker.getImage(source: imageSource);
    if (_imageFile == null) return;

    File tmpFile = File(_imageFile.path);
    //final appDir = await getApplicationDocumentsDirectory();
    final fileName = _imageFile.path;

    tmpFile = await tmpFile.copy('$fileName');

    setState(() {
      _image = ImageUtility.base64String(tmpFile.readAsBytesSync()) as File;
      iconphoto = Icons.check_box;
    });
  }
}