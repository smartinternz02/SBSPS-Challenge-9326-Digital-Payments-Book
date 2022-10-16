import 'package:http/http.dart' as http;
import 'dart:convert';

class HTTPRequests {
  String url =
      'https://abkannakubook-lordab-dev.apps.sandbox.x8i5.p1.openshiftapps.com/';

  Future<List<dynamic>> sendBill(String no) async {
    List<dynamic> billDetails = [];
    final response = await http.post(Uri.parse(url),
        body: {"page": "MyShop", "ID": no, "type": "Shop"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);

      billDetails = responseData;
    }
    return billDetails;
  }

//CUSTOMER DUES - BILLS
  Future<List<dynamic>> receiveBills(int customerID, int shopID) async {
    List<dynamic> shopBills = [];
    final response = await http.post(Uri.parse(url), body: {
      "page": "ShopBills",
      "CUST_ID": customerID.toString(),
      "SHOP_ID": shopID.toString(),
      "type": "Shop"
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      shopBills = responseData;
    }
    return shopBills;
  }

//CUSTOMER DUES - PAYMENTS
  Future<List<dynamic>> receivePayments(int customerID, int shopID) async {
    List<dynamic> customerPayments = [];
    final response = await http.post(Uri.parse(url), body: {
      "page": "ShopPayments",
      "CUST_ID": customerID.toString(),
      "SHOP_ID": shopID.toString(),
      "type": "Shop"
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      customerPayments = responseData;
    }
    return customerPayments;
  }

//LOGIN  - mobile number authendication
  Future<bool?> sendMobileNo(String mobileNo) async {
    final response = await http.post(Uri.parse(url),
        body: {"phno": mobileNo, "page": "loginCheck", "type": "Auth"});

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);

      var status = responseData['status'];
      if (status == 0) {
        return false;
      } else {
        return true;
      }
    } else {
      return null;
    }
  }

  //SIGN IN - Mobile no check
  Future<bool?> sendMobileNoSignIn(String mobileNo) async {
    final response = await http.post(Uri.parse(url),
        body: {"phno": mobileNo, "page": "registerCheck", "type": "Auth"});

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);

      var status = responseData['status'];
      if (status == 0) {
        return false;
      } else {
        return true;
      }
    } else {
      return null;
    }
  }

//MY ACCOUNT -  Update Account Details
  Future<bool?> sendAccount(
      String no, String mobileNo, String name, String dateTime) async {
    final response = await http.post(Uri.parse(url), body: {
      "page": "post_update",
      "ID": no,
      "PHONE_NUMBER": mobileNo,
      "NAME": name,
      "DOB": dateTime,
      "type": "both",
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);
      var status = responseData['status'];
      if (status == 0) {
        return false;
      } else {
        return true;
      }
    } else {
      return null;
    }
  }

  //SIGN-IN OTP  - Add Account Details
  Future<int?> sendRegisterData(
      String mobileNo, String name, String dateTime) async {
    final response = await http.post(Uri.parse(url), body: {
      "page": "register",
      "phno": mobileNo,
      "name": name,
      "dateTime": dateTime,
      "type": "Auth"
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);

      var id = responseData['ID'];
      return id;
    } else {
      return null;
    }
  }

//RETAILER NAVGATION DRAWER - Receive retailer details by id
  Future<Map?> sendRes(String id) async {
    final response = await http.post(Uri.parse(url),
        body: {"page": "get_update", "ID": id, "type": "both"});

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);
      return responseData;
    }
    return null;
  }

//OTP - Send mobile number and OTP
  Future<int?> sendOtp(String mobileNo) async {
    final response = await http.post(Uri.parse(url),
        body: {"page": "login", "phno": mobileNo, "type": "Auth"});

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);

      var id = responseData['ID'];
      return id;
    } else {
      return null;
    }
  }

//SCANNER - Send customer ID
  Future<Map?> sendScannedData(String customerID) async {
    final response = await http.post(Uri.parse(url), body: {
      "page": "GetCustDetails",
      "CUST_ID": customerID,
      "type": "Shop"
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);
      return responseData;
    }
    return null;
  }

//ADD CUSTOMER - Send shop ID and customer ID
  Future<Map?> addCustomerData(String customerID, String shopID) async {
    final response = await http.post(Uri.parse(url), body: {
      "page": "AddCustDetails",
      "CUST_ID": customerID,
      "ID": shopID,
      "type": "Shop"
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);
      return responseData;
    }

    return null;
  }

  //ADD BILL - Send shop ID, customer ID, Amount
  Future<bool?> sendNewCustomerData(
      String customerID, String shopID, String amount) async {
    final response = await http.post(Uri.parse(url), body: {
      "page": "AddNewBill",
      "CUST_ID": customerID,
      "ID": shopID,
      "AMOUNT": amount,
      "type": "Shop"
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);
      var status = responseData['status'];
      if (status == 0) {
        return false;
      } else {
        return true;
      }
    } else {
      return null;
    }
  }

//SUPPORT - SEND Query Details
  Future<bool?> sendQuery(
      String no, String shopID, String subject, String query) async {
    final response = await http.post(Uri.parse(url), body: {
      "page": "CustQuery",
      "CUST_ID": no,
      "SHOP_ID": shopID,
      "SUB": subject,
      "QUERY": query,
      "type": "Customer"
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);

      var status = responseData['status'];
      if (status == 0) {
        return false;
      } else {
        return true;
      }
    } else {
      return null;
    }
  }

  //MY CUSTOMER - Send customer details

  Future<List<dynamic>> viewCustomers(String no) async {
    List<dynamic> customerDetails = [];
    final response = await http.post(Uri.parse(url),
        body: {"page": "ViewCustomers", "ID": no, "type": "Shop"});

    if (response.statusCode == 200) {
      final String responseString = response.body;
      List responseData = json.decode(responseString);
      customerDetails = responseData;
    }

    return customerDetails;
  }

  //RETAILER NOTIFICATION - Retailer ID

  Future<List<dynamic>> myNotifications(String no) async {
    List<dynamic> notificationDetails = [];
    final response = await http.post(Uri.parse(url),
        body: {"page": "ShopSupport", "ID": no, "type": "Shop"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      notificationDetails = responseData;
    }
    return notificationDetails;
  }

  //CUSTOMER VIEW SHOPS - send customer id
  Future<List<dynamic>> viewShops(String id) async {
    List<dynamic> customerShopsDetails = [];
    final response = await http.post(Uri.parse(url),
        body: {"page": "ViewShops", "ID": id, "type": "Customer"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      customerShopsDetails = responseData;
    }

    return customerShopsDetails;
  }

//MY PURCHAESES send customer id

  Future<List<dynamic>> myDues(String customerID) async {
    List<dynamic> customerPendingPayments = [];
    final response = await http.post(Uri.parse(url),
        body: {"page": "MyDues", "ID": customerID, "type": "Customer"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      customerPendingPayments = responseData;
    }
    return customerPendingPayments;
  }

  //MY DUES - CUSTOMER PAYMENTS
  Future<List<dynamic>> myDuesReceivePayments(
      int customerID, int shopID) async {
    List<dynamic> customerPayments = [];
    final response = await http.post(Uri.parse(url), body: {
      "page": "CustomerPayments",
      "CUST_ID": customerID.toString(),
      "SHOP_ID": shopID.toString(),
      "type": "Customer"
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      customerPayments = responseData;
    }
    return customerPayments;
  }

  //MY DUES - CUSTOMER BILLS
  Future<List<dynamic>> myDuesReceiveBills(int customerID, int shopID) async {
    List<dynamic> shopBills = [];
    final response = await http.post(Uri.parse(url), body: {
      "page": "CustomerBills",
      "CUST_ID": customerID.toString(),
      "SHOP_ID": shopID.toString(),
      "type": "Customer"
    });

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      shopBills = responseData;
    }
    return shopBills;
  }

//PAYMENT

  void sendPaymentDetails(int customerID, int shopID, String amount) async {
    final response = await http.post(Uri.parse(url), body: {
      "page": "Payment",
      "SHOP_ID": shopID.toString(),
      "CUST_ID": customerID.toString(),
      "AMOUNT": amount,
      "type": "Customer"
    });
  }

// RETAILER VIEW ALL BILLS
  Future<List<dynamic>> retailerViewAllBills(String no) async {
    List<dynamic> retailerViewAllBills = [];
    final response = await http.post(Uri.parse(url),
        body: {"page": "ShopAllBills", "ID": no, "type": "Shop"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      retailerViewAllBills = responseData;
    }
    return retailerViewAllBills;
  }

//RETAILER VIEW ALL PAYMENTS

  Future<List<dynamic>> retailerViewAllPayments(String no) async {
    List<dynamic> retailerViewAllPayments = [];
    final response = await http.post(Uri.parse(url),
        body: {"page": "ShopAllPayments", "ID": no, "type": "Shop"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      retailerViewAllPayments = responseData;
    }
    return retailerViewAllPayments;
  }

  // CUSTOMER VIEW ALL BILLS
  Future<List<dynamic>> customerViewAllBills(String no) async {
    List<dynamic> retailerViewAllBills = [];
    final response = await http.post(Uri.parse(url),
        body: {"page": "CustomerAllBills", "ID": no, "type": "Customer"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      retailerViewAllBills = responseData;
    }
    return retailerViewAllBills;
  }

//Customer VIEW ALL PAYMENTS

  Future<List<dynamic>> customerViewAllPayments(String no) async {
    List<dynamic> retailerViewAllPayments = [];
    final response = await http.post(Uri.parse(url),
        body: {"page": "CustomerAllPayments", "ID": no, "type": "Customer"});

    if (response.statusCode == 200) {
      final String responseString = response.body;

      List<dynamic> responseData = json.decode(responseString);
      retailerViewAllPayments = responseData;
    }
    return retailerViewAllPayments;
  }

//CUSTOMER NAV BAR CHECK IS SHOP NAME IS AVAILBALE
  Future<String?> checkShopName(String customerID) async {
    final response = await http.post(Uri.parse(url),
        body: {"ID": customerID, "page": "checkshop", "type": "Auth"});

    if (response.statusCode == 200) {
      final String responseString = response.body;
      Map responseData = json.decode(responseString);
      String? shopName = responseData['SHOPNAME'];

      return shopName;
    }
    return null;
  }

  void sendShopName(String customerID, String shopName) async {
    final response = await http.post(Uri.parse(url), body: {
      "ID": customerID,
      "page": "regshop",
      "type": "Auth",
      "SHOP": shopName
    });
  }
}
