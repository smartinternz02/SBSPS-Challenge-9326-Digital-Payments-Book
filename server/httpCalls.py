
import ibm_db
from flask import jsonify
from datetime import datetime as dt


defaultKPoints=1000
KBuffer = 500


def register_check(conn,data):
    phno = data["phno"]
    sql = "select * from Account_table where phone_number=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,phno)
    ibm_db.execute(stmt)
    found=ibm_db.fetch_assoc(stmt)
    if found :
        send = {"status":0}
    else:
        send = {"status":1}

    return jsonify(send)

def login_check(conn,data):
    phno = data["phno"]
    sql = "select * from Account_table where phone_number=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,phno)
    ibm_db.execute(stmt)
    found=ibm_db.fetch_assoc(stmt)
    if found :
        send = {"status":1}
    else:
        send = {"status":0}

    return jsonify(send)

def register(conn, data):
    name = data['name']
    phno = data['phno']
    dob = data['dateTime']
    
    time = dt.now().strftime("%Y-%m-%d %H:%M:%S")
    sql = "select Count(*) from Account_table"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.execute(stmt)
    id = ibm_db.fetch_assoc(stmt)['1']
    id+=1

    sql = "insert into Account_table (name, id, phone_number, dob,account_created,kpoints) values (?,?,?,?,?,?)"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,name)
    ibm_db.bind_param(stmt,2,id)
    ibm_db.bind_param(stmt,3,phno)
    ibm_db.bind_param(stmt,4,dob)
    ibm_db.bind_param(stmt,5,time)
    ibm_db.bind_param(stmt,6,defaultKPoints)
    ibm_db.execute(stmt)

    send={'ID':id}
    time = dt.now().strftime("%Y-%m-%d %H:%M:%S")
    sql = "insert into login_time values (?,?)"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.bind_param(stmt,2,time)
    ibm_db.execute(stmt)

    return jsonify(send)

def login(conn, data):
    phno = data['phno']

    sql = "select id from Account_table where phone_number=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,phno)
    ibm_db.execute(stmt)
    id=ibm_db.fetch_assoc(stmt)["ID"]
    send={'ID':id}
    time = dt.now().strftime("%Y-%m-%d %H:%M:%S")
    sql = "insert into login_time values (?,?)"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.bind_param(stmt,2,time)
    ibm_db.execute(stmt)

    return jsonify(send)

def getUpdate(conn, id):
    sql = "select id,name,phone_number,dob,kpoints from Account_table where id=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.execute(stmt)
    data=ibm_db.fetch_assoc(stmt)
    return jsonify(data)

def postUpdate(conn,data):
    sql = "update account_table set name=? where id=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,data["NAME"])
    ibm_db.bind_param(stmt,2,int(data["ID"])) 
    ibm_db.execute(stmt)
    
    return jsonify({"status": 1})

def getMyShop(conn,shopid):
    send=[]    
    sql = "select account_table.id as cust_id, account_table.name as cust_name, account_table.phone_number, account_table.kpoints, shop_cust.dues from shop_cust,account_table where account_table.id=shop_cust.cust_id and shop_cust.shop_id = ? and dues>0"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.execute(stmt)
    bill=ibm_db.fetch_assoc(stmt)

    while bill:
        send.append(bill)
        bill=ibm_db.fetch_assoc(stmt)

    return jsonify(send)



def postQuery(conn,data):
    custID = data['CUST_ID']
    shopID = data['SHOP_ID']
    sql = "select Count(*) from Queries"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.execute(stmt)
    id = ibm_db.fetch_assoc(stmt)['1']
    id+=1

    time = dt.now().strftime("%Y-%m-%d %H:%M:%S")
    sql = "insert into queries values(?,?,?,?,?,?)"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.bind_param(stmt,2,custID)
    ibm_db.bind_param(stmt,3,shopID)
    ibm_db.bind_param(stmt,4,time)
    ibm_db.bind_param(stmt,5,data["SUB"])
    ibm_db.bind_param(stmt,6,data["QUERY"])
    ibm_db.execute(stmt)
    
    return jsonify({"status":1})

def getQuery(conn,id):
    send = []
    sql = "select queries.query_id, queries.cust_id, queries.shop_id, queries.time, queries.subject, queries.query,account_table.name as cust_name from queries inner join account_table on queries.cust_id=account_table.id where shop_id=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.execute(stmt)
    q=ibm_db.fetch_assoc(stmt)

    while q:
        send.append(q)
        q=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def GetCustDetails(conn,id):
    sql = "select id,name,phone_number,kpoints from Account_table where id=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.execute(stmt)
    data=ibm_db.fetch_assoc(stmt)
    return jsonify(data)
    
def addCustomer(conn,shopid,custid):
    sql = "select * from shop_cust where shop_id=? and cust_id=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.bind_param(stmt,2,custid)
    ibm_db.execute(stmt)
    found=ibm_db.fetch_assoc(stmt)
    if found :
        send = {"status":0}
    else:
        send = {"status":1}

        
        sql = "insert into shop_cust values (?,?,0)"
        stmt = ibm_db.prepare(conn,sql)
        ibm_db.bind_param(stmt,1,shopid)
        ibm_db.bind_param(stmt,2,custid)
        ibm_db.execute(stmt)


    return jsonify(send)

def addNewBill(conn,shopid,custid,amount):
    time = dt.now().strftime("%Y-%m-%d %H:%M:%S")
    sql = "select Count(*) from Issue_Bills"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.execute(stmt)
    id = ibm_db.fetch_assoc(stmt)['1']
    id+=1

    sql = "insert into Issue_Bills values (?,?,?,?,?)"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.bind_param(stmt,2,custid)
    ibm_db.bind_param(stmt,3,shopid)
    ibm_db.bind_param(stmt,4,float(amount))
    ibm_db.bind_param(stmt,5,time)
    ibm_db.execute(stmt)

    sql = "update shop_cust set dues=dues+? where shop_id = ? and cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,float(amount))
    ibm_db.bind_param(stmt,2,shopid)
    ibm_db.bind_param(stmt,3,custid)
    ibm_db.execute(stmt)

    sql = "select dues from shop_cust where shop_id = ? and cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.bind_param(stmt,2,custid)
    ibm_db.execute(stmt)
    dues = ibm_db.fetch_assoc(stmt)['DUES']

    if dues>KBuffer:
        sql = "update account_table set kdate = case when col2 is null then ? else kdate end where id=?"
        stmt = ibm_db.prepare(conn,sql)
        ibm_db.bind_param(stmt,1,time)
        ibm_db.bind_param(stmt,2,custid)
        ibm_db.execute(stmt)


    return jsonify({'status':1})

def viewCustomers(conn,id):
    send = []
    sql = "select shop_cust.cust_id, shop_cust.dues, account_table.name as cust_name,account_table.kpoints from shop_cust inner join account_table on shop_cust.cust_id=account_table.id where shop_id=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def getMyDues(conn,id):
    send = []
    sql = "select shop_cust.shop_id, shop_cust.dues, account_table.shopname from shop_cust inner join account_table on shop_cust.shop_id=account_table.id where cust_id=? and dues>0"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.execute(stmt)
    bill=ibm_db.fetch_assoc(stmt)

    while bill:
        send.append(bill)
        bill=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def allCustTransactions(conn,id):
    send = []
    sql = "select bill.bill_id, bill.cust_id, bill.billamt,bill.issue_date,bill.paid_date,bill.dueamt, bill.status,account_table.shopname from bill inner join account_table on bill.shop_id=account_table.id where cust_id=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.execute(stmt)
    bill=ibm_db.fetch_assoc(stmt)

    while bill:
        send.append(bill)
        bill=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def viewShops(conn,id):
    send = []
    sql = "select shop_cust.shop_id, shop_cust.dues, account_table.shopname from shop_cust inner join account_table on shop_cust.shop_id=account_table.id where cust_id=?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def SearchCustomers(conn,id):
    send=[]
    sql = "select account_table.name,account_table.id from shop_cust inner join account_table on cust_id=id where shop_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def Shop_Bills(conn,shopid,custid):
    send=[]
    sql = "select bill_id, billamt, issue_date from issue_bills where shop_id = ? and cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.bind_param(stmt,2,custid)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def Shop_Payments(conn,shopid,custid):
    send=[]
    sql = "select bill_id, billamt, paid_date from paid_bills where shop_id = ? and cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.bind_param(stmt,2,custid)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def Customer_Bills(conn,shopid,custid):
    send=[]
    sql = "select bill_id, billamt, issue_date from issue_bills where shop_id = ? and cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.bind_param(stmt,2,custid)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)
    
    return jsonify(send)

def Customer_Payments(conn,shopid,custid):
    send=[]
    sql = "select bill_id, billamt, paid_date from paid_bills where shop_id = ? and cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.bind_param(stmt,2,custid)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def payment(conn,shopid,custid,amount):
    time = dt.now().strftime("%Y-%m-%d %H:%M:%S")
    sql = "select Count(*) from Paid_Bills"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.execute(stmt)
    id = ibm_db.fetch_assoc(stmt)['1']
    id+=1

    sql = "insert into paid_bills values (?,?,?,?,?)"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.bind_param(stmt,2,custid)
    ibm_db.bind_param(stmt,3,shopid)
    ibm_db.bind_param(stmt,4,float(amount))
    ibm_db.bind_param(stmt,5,time)
    ibm_db.execute(stmt)

    sql = "update shop_cust set dues=dues-? where shop_id = ? and cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,float(amount))
    ibm_db.bind_param(stmt,2,shopid)
    ibm_db.bind_param(stmt,3,custid)
    ibm_db.execute(stmt)

    sql = "select dues from shop_cust where shop_id = ? and cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.bind_param(stmt,2,custid)
    ibm_db.execute(stmt)
    dues = ibm_db.fetch_assoc(stmt)['DUES']

    if dues<=KBuffer:
        sql = "select kdate from account_table where id = ?"
        stmt = ibm_db.prepare(conn,sql)
        ibm_db.bind_param(stmt,1,custid)
        ibm_db.execute(stmt)
        kdate = ibm_db.fetch_assoc(stmt)['KDATE']
        kdays = (kdate -time).days

        if kdays<=10:
            kpoints = 3
        elif kdays<=20:
            kpoints = 2
        elif kdays<=30:
            kpoints = 1
        else:
            kpoints = -10

        sql = "update account_table set dues=dues-? where shop_id = ? and cust_id = ?"
        stmt = ibm_db.prepare(conn,sql)
        ibm_db.bind_param(stmt,1,float(amount))
        ibm_db.bind_param(stmt,2,shopid)
        ibm_db.bind_param(stmt,3,custid)
        ibm_db.execute(stmt)

        


        sql = "update account_table set kdate = null, kpoints = kpoints+? where id=?"
        stmt = ibm_db.prepare(conn,sql)
        ibm_db.bind_param(stmt,1,kpoints)
        ibm_db.bind_param(stmt,2,custid)
        ibm_db.execute(stmt)


    return jsonify({'status':1})

def shopViewAllBills(conn,shopid):
    send=[]
    
    sql = "select issue_bills.bill_id, issue_bills.billamt, issue_bills.issue_date, account_table.name as cust_name from issue_bills inner join account_table on issue_bills.cust_id=account_table.id where shop_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)
    
    return jsonify(send)

def shopViewAllPayments(conn,shopid):
    send=[]
    sql = "select paid_bills.bill_id, paid_bills.billamt, paid_bills.paid_date, account_table.name as cust_name from paid_bills inner join account_table on paid_bills.cust_id=account_table.id where shop_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopid)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)

    return jsonify(send)

def CustViewAllBills(conn,custid):
    send=[]
    
    sql = "select issue_bills.bill_id, issue_bills.billamt, issue_bills.issue_date, account_table.shopname from issue_bills inner join account_table on issue_bills.shop_id=account_table.id where cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,custid)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)
    
    return jsonify(send)

def CustViewAllPayments(conn,custid):
    send=[]
    sql = "select paid_bills.bill_id, paid_bills.billamt, paid_bills.paid_date, account_table.shopname from paid_bills inner join account_table on paid_bills.shop_id=account_table.id where cust_id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,custid)
    ibm_db.execute(stmt)
    cust=ibm_db.fetch_assoc(stmt)

    while cust:
        send.append(cust)
        cust=ibm_db.fetch_assoc(stmt)
    
    return jsonify(send)


def nameTheShop(conn,id,shopname):
    sql = "update account_table set shopname = ? where id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,shopname)
    ibm_db.bind_param(stmt,2,id)
    ibm_db.execute(stmt)
    
    return jsonify({'status':1})

def checkShop(conn,id):
    sql = "select shopname from account_table where id = ?"
    stmt = ibm_db.prepare(conn,sql)
    ibm_db.bind_param(stmt,1,id)
    ibm_db.execute(stmt)
    shop=ibm_db.fetch_assoc(stmt)
    return jsonify(shop)