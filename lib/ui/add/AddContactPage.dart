import 'package:flutter/material.dart';
import 'package:flutter_firstsourceio/data/args/AddContactArgs.dart';
import 'package:flutter_firstsourceio/data/model/Contact.dart';
import 'package:flutter_firstsourceio/db/provider/DatabaseProvider.dart';
import 'package:flutter_firstsourceio/db/repo/ContactsRepositoryImpl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddContactPage extends StatefulWidget {
  AddContactPage({Key key}) : super(key: key);

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  var scaffoldKey = GlobalKey(debugLabel: "parentScaffold");

  final contactsRepo = ContactsRepositoryImpl(DatabaseProvider.get);

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  File _image;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final AddContactArgs arguments = ModalRoute.of(context).settings.arguments;
    final contact = arguments?.contact;

    if (contact != null)
      setState(() {
        _firstNameController.text = contact.firstName;
        _lastNameController.text = contact.lastName;
        _phoneController.text = contact.phoneNo;
      });

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add / Edit contact'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTapUp: (tap) {
                _pickImage();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 96.0, vertical: 24.0),
                child: new AspectRatio(
                  aspectRatio: 1 / 1,
                  child: CircleAvatar(
                    backgroundImage: _image != null
                        ? FileImage(_image)
                        : NetworkImage(
                            'https://www.midlandsderm.com/wp-content/uploads/2019/04/Rachel-R.-Person-760x760.jpg',
                          ),
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: TextFormField(
                      controller: _firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'enter name', labelText: 'First Name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: TextFormField(
                      controller: _lastNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'enter family', labelText: 'Last Name'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: 'enter email', labelText: 'Email'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: TextFormField(
                      controller: _dobController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'enter dob'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter dateOfBirth';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          hintText: 'enter phone', labelText: 'Phone'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter phone';
                        }
                        return null;
                      },
                    ),
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          child: Text('Save'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              print('validated');
                              _saveContact();
                            }
                          },
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    final _firstName = _firstNameController.text;
    final _lastName = _lastNameController.text;
    final _email = _emailController.text;
    final _dateOfBirt = _dobController.text;
    final _phoneNo = _phoneController.text;

    final contact = Contact(
      dateOfBirth: _dateOfBirt,
      firstName: _firstName,
      lastName: _lastName,
      email: _email,
      gender: "Male",
      phoneNo: _phoneNo,
    );

    setState(() {
      _isLoading = true;
    });
    contactsRepo.insertApi(contact).then((insertedRaw) {
      final inserted = Contact.fromMap(insertedRaw);
      setState(() {
        _isLoading = false;
      });

      (scaffoldKey.currentState as ScaffoldState).showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              Expanded(
                child: Text('Contact $_firstName $_lastName inserted'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future _pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
