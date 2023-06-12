from distutils.command.config import config
from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler, RegexMatchingEventHandler
from watchdog.observers.polling import PollingObserver


import requests
import glob
import os
from os import path
import time
import json
import datetime
import shutil
import random
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

f = open('config.json')
data = json.load(f)
now = datetime.datetime.now()


def getfiles(file_path):
    try:
        # files = glob.glob(data["second_folder"]+"/*.pdf")
        # for file_path in files:
        head, tail = os.path.split(file_path)
        print(head, tail, "tail")
        ran_str = random.randint(0,9999999999999)
        os.rename(file_path, head+"/job-"+str(ran_str)+tail)
        file_path = head+"/job-"+str(ran_str)+tail
        print(file_path, "file path")
        invoicefile = {'file': open(file_path, 'rb')}
        payload = {
            'is_private': 1,
            'folder': 'Home',
            'doctype': 'Invoices',
            'docname': data["company"],
            'fieldname': 'invoice',
            # 'filename': "job-"+tail,
            # 'file_url': "/private/files/job-"+tail
        }
        headers = {
                'Authorization': "token "+data["api_key"]+":"+data["api_secret"],
		#'Authorization': "token "+"API Key"+":"+"Save API Secret",
            }
        # invoicefile['file'].close()
        file_response = requests.post(
            data['host']+"upload_file",headers=headers, files=invoicefile, data=payload, verify=False)
        invoicefile['file'].close()

        # print(file_path)
        # if file_response:
        if path.exists(file_path):
            # time.sleep(1)
            print(file_path)
            os.remove(file_path)

        # files = glob.glob(data["second_folder"]+"/*")
        # for f in files:
        #     print(f)
        #     os.remove(f)
    except Exception as e:
        print(e, "am from exception")


class Watcher:
    def __init__(self, path):
        self.observer = Observer()
        self.path = path
        self.previous_file_name = ''

    def run(self):
        try:
            regexes = ['.*\\.(pdf)']
            my_event_handler = RegexMatchingEventHandler(regexes=regexes)

            def on_created(event):
                try:
                    print("hello")
                    if data["pattern"] in event.src_path:
                        if True:
                            # if self.previous_file_name != event.src_path.split('/')[-1]:
                            shutil.copy(event.src_path,
                                        data["second_folder"])
                            getfiles(data["second_folder"] +
                                        "/"+event.src_path.split('/')[-1])
                            self.previous_file_name = event.src_path.split(
                                '/')[-1]

                            if path.exists(event.src_path):
                                print(event.src_path,"removing")
                                os.remove(event.src_path)
                                
                                
                        else:
                            shutil.copy(event.src_path, data["second_folder"])
                            getfiles(data["second_folder"]+"/" +
                                     event.src_path.split('/')[-1])
                            self.previous_file_name = event.src_path.split(
                                '/')[-1]

                        

                except Exception as e:
                    print(e, "error in on_created")

            my_event_handler.on_created = on_created

            self.observer = PollingObserver()
            self.observer.schedule(my_event_handler, self.path, recursive=True)
            self.observer.start()
            try:
                while True:
                    time.sleep(1)
            except Exception as e:
                print("Error", e)
                self.observer.stop()
                print("Error", e)

            self.observer.join()
        except Exception as e:
            print(e, "error in run")


# class Handler(FileSystemEventHandler):
#     @staticmethod
#     def on_any_event(event):
#         if event.event_type == "created":
#             if event.src_path.endswith(".pdf"):
#                 try:
#                     shutil.copy(event.src_path, data["second_folder"])
#                 except shutil.SameFileError:
#                     print("same file error")

#                 # print("[{}] noticed: [{}] on: [{}] ".format(
#                 #     time.asctime(), event.event_type, event.src_path))
#                 getfiles()


if __name__ == "__main__":
    print(data["opera_folder"])
    w = Watcher(data["opera_folder"])
    w.run()
