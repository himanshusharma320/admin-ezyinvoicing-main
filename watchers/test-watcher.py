import requests
import os
from os import path
import time
import json
import shutil
import time
from watchdog.observers import Observer
from datetime import date
from watchdog.events import FileSystemEventHandler

f = open('config.json')
data = json.load(f)

def getfiles(src_path):
    try:
        if ".pdf" in src_path:
            shutil.copy(src_path, data["second_folder"])
            head, tail = os.path.split(src_path)
            today = date.today()
            d1 = str(today.strftime("%d%m%y%H%M%S"))
            file_path = data["second_folder"].rstrip("/")+"/"+tail
            new_file_path = data["second_folder"].rstrip("/")+"/job-"+d1+tail
            os.rename(file_path, new_file_path)
            invoicefile = {'file': open(new_file_path, 'rb')}
            payload = {
                'is_private': 1,
                'folder': 'Home',
                'doctype': 'invoices',
                'docname': data["company"],
                'fieldname': 'invoice'}
            file_response = requests.post(
                data['host']+"upload_file", files=invoicefile, data=payload, verify=False)
            invoicefile['file'].close()
            invoicefile['file'].close()
            if path.exists(new_file_path):
                os.remove(new_file_path)
    except Exception as e:
        print(e, "am from exception")


class MonitorFolder(FileSystemEventHandler):
    def on_created(self, event):
        getfiles(event.src_path)
    def on_modified(self, event):
        getfiles(event.src_path)

if __name__ == "__main__":
    event_handler=MonitorFolder()
    observer = Observer()
    observer.schedule(event_handler, path=data["opera_folder"], recursive=True)
    print("Monitoring started")
    observer.start()
    try:
        while(True):
           time.sleep(1)   
    except KeyboardInterrupt:
            observer.stop()
            observer.join()
