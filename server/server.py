from flask import Flask, request, jsonify
import ibm_db
from httpCalls import *

print(1)
conn = ibm_db.connect("DATABASE=bludb;HOSTNAME=815fa4db-dc03-4c70-869a-a9cc13f33084.bs2io90l08kqb1od8lcg.databases.appdomain.cloud;PORT=30367;SECURITY=SSL;SSLServerCertificate=DigiCertGlobalRootCA.crt;UID=jmw91401;PWD=WC3wzEBIkq1s4utU",'','')
print(2)

app = Flask(__name__)


@app.route('/', methods=['GET','POST'])
def hello_world():
    
    if request.method == "POST":
        came = dict(request.form)
        
        #Authorization requests
        if came['type']=='Auth':
            
            #check for register
            if came['page']=='registerCheck':
                return register_check(conn, came)

            #register
            if came['page']=='register':
                return register(conn, came)

            #check for login
            if came['page']=='loginCheck':
                return login_check(conn, came)

            #login
            if came['page']=='login':
                return login(conn, came)

            #check shop name
            if came['page']=='checkshop':
                return checkShop(conn,came['ID'])
            
            #registering shop name
            if came['page']=='regshop':
                return nameTheShop(conn,came['ID'],came['SHOP'])



        if came['type']=='Shop':

            #myshop homepage send pending payments
            if came['page']=='MyShop':
                return getMyShop(conn,came['ID'])

            #shop - view customers
            if came['page']=='ViewCustomers':
                return viewCustomers(conn,came['ID'])
       
            #shop-addcustomer, send customer details
            if came['page']=="GetCustDetails":
                return GetCustDetails(conn,came['CUST_ID'])
            
            #shop-addcustomer, add customer to database
            if came['page']=="AddCustDetails":
                return addCustomer(conn,came['ID'],came['CUST_ID'])
            
            #shop- create a new bill
            if came['page']=='AddNewBill':
                return addNewBill(conn,came["ID"],came["CUST_ID"],came['AMOUNT'])
            
            #shop - Notification support
            if came['page']=='ShopSupport':
                return getQuery(conn,came['ID'])

            # #shop - view all transactions
            # if came['page']=='AllShopTransactions':
            #     return allShopTransactions(conn,came['ID'])

            #Shop - select customers for adding bill
            if came['page']=='SearchCustomers':
                return SearchCustomers(conn,came['ID'])

            #Shop - Return bills for a customer
            if came['page']=='ShopBills':
                return Shop_Bills(conn,came['SHOP_ID'],came['CUST_ID'])

            #Shop - Return payments of a customer
            if came['page']=='ShopPayments':
                return Shop_Payments(conn,came['SHOP_ID'],came['CUST_ID'])
            
            #shop - view all bills
            if came['page']=='ShopAllBills':
                return shopViewAllBills(conn,came['ID'])

            #shop - view all payments
            if came['page']=='ShopAllPayments':
                return shopViewAllPayments(conn,came['ID'])


        if came['type']=='Customer':
            
            #Customer - my purchases homepage
            if came['page']=='MyDues':
                return getMyDues(conn,came['ID'])

            #customer query send
            if came['page']=='CustQuery':
                return postQuery(conn,came)

            #customer - view all transactions
            if came['page']=='AllCustTransactions':
                return allCustTransactions(conn,came['ID'])
            
            #Customer - view shops
            if came['page']=='ViewShops':
                return viewShops(conn,came['ID']) 
            
            #Customer - Return bills of a shop
            if came['page']=='CustomerBills':
                return Customer_Bills(conn,came['SHOP_ID'],came['CUST_ID'])

            #Customer - Return payments for a shop
            if came['page']=='CustomerPayments':
                return Customer_Payments(conn,came['SHOP_ID'],came['CUST_ID'])

            #Payment from customer to shopkeeper
            if came['page']=='Payment':
                return payment(conn,came['SHOP_ID'],came['CUST_ID'],came['AMOUNT'])   

            #customer - view all bills
            if came['page']=='CustomerAllBills':
                return shopViewAllBills(conn,came['ID'])

            #customer - view all payments
            if came['page']=='CustomerAllPayments':
                return shopViewAllPayments(conn,came['ID'])   
        
        else:
            #get_update
            if came['page']=='get_update':
                return getUpdate(conn,came['ID'])
            
            #post_update
            if came['page']=='post_update':
                return postUpdate(conn,came)

        
        

        
    else:
        print("IT is GET")
        return "I am AB"

if __name__ == '__main__':
    app.run(host='0.0.0.0',port=8080)


