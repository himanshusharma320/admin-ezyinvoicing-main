import threading
import requests
import glob
import os
from os import path
import time
# def printit():
# 	threading.Timer(5.0, printit).start()
# 	files = glob.glob("/home/caratred/test/*.pdf")
# 	print(files)
# 	for file_path in files:
# 		data = {"company":"EHNDNP-01",
# 							"host":"http://0.0.0.0:8000/api/method/",}
# 		invoicefile = {'file': open(file_path, 'rb')}
# 		payload = {
# 				'is_private': 1,
# 				'folder': 'Home',
# 				'doctype': 'invoices',
# 				'docname': data["company"],
# 				'fieldname': 'invoice'}
# 		file_response = requests.post(data['host']+"upload_file",files=invoicefile, data=payload, verify=False).json()
# 		print(file_response)
# 		if file_response:
# 			if path.exists(file_path):
# 				os.remove(file_path)
# printit()
import json

with open("watcher_config.json",'r') as myfile:
    print(myfile)
    file_data = myfile.read()
obj = json.loads(file_data)
print(obj)
def getfiles():
    try:
        time.sleep(5)
        print("waiting for print")
        files = glob.glob(obj["files_folder"]+"/*.pdf")
        for file_path in files:
            head, tail = os.path.split(file_path)
            file_path = os.rename(file_path, head+"/job-"+tail)
            file_path = head+"/job-"+tail
        # for file_path in files:
            data = {"company":obj["company_code"],"host":obj["host"]}
            invoicefile = {'file': open(file_path, 'rb')}
            payload = {
                'is_private': 1,
                'folder': 'Home',
                'doctype': 'Invoices',
                'docname': data["company"],
                'fieldname': 'invoice'}
            #invoicefile['file'].close()
            headers = {
                'Authorization': "token "+obj["api_key"]+":"+obj["api_secret"],
             }
            print(headers,".........")
            print(payload)
            file_response = requests.post(data['host']+"upload_file",headers=headers,files=invoicefile, data=payload, verify=False)
            invoicefile['file'].close()
            print(file_response)
            invoicefile['file'].close()
            #if file_response:
            if path.exists(file_path):
            #time.sleep(5)
                os.remove(file_path)
    except Exception as e:
        print(e,"am from exception")
        # invoicefile['file'].close()
        # if path.exists(file_path):
        #     os.remove(file_path)
    getfiles()

getfiles()

