class Contact {
  dynamic _id;
  String _firstName;
  String _lastName;
  String _email;
  String _gender;
  String _dateOfBirth;
  String _phoneNo;

  Contact(
      {dynamic id,
        String firstName,
        String lastName,
        String email,
        String gender,
        String dateOfBirth,
        String phoneNo}) {
    this._id = id;
    this._firstName = firstName;
    this._lastName = lastName;
    this._email = email;
    this._gender = gender;
    this._dateOfBirth = dateOfBirth;
    this._phoneNo = phoneNo;
  }

  dynamic get id => _id;
  set id(dynamic id) => _id = id;
  String get firstName => _firstName;
  set firstName(String firstName) => _firstName = firstName;
  String get lastName => _lastName;
  set lastName(String lastName) => _lastName = lastName;
  String get email => _email;
  set email(String email) => _email = email;
  String get gender => _gender;
  set gender(String gender) => _gender = gender;
  String get dateOfBirth => _dateOfBirth;
  set dateOfBirth(String dateOfBirth) => _dateOfBirth = dateOfBirth;
  String get phoneNo => _phoneNo;
  set phoneNo(String phoneNo) => _phoneNo = phoneNo;

  Contact.fromMap(Map<String, dynamic> json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _gender = json['gender'];
    _dateOfBirth = json['date_of_birth'];
    _phoneNo = json['phone_no'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['first_name'] = this._firstName;
    data['last_name'] = this._lastName;
    data['email'] = this._email;
    data['gender'] = this._gender;
    data['date_of_birth'] = this._dateOfBirth;
    data['phone_no'] = this._phoneNo;
    return data;
  }
}