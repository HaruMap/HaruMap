from unicodedata import name
import xml.etree.ElementTree as ET
import json
from collections import OrderedDict
from glob import glob

def info():
    #info 부분 생성
    info = {
            'description' : 'walking image from aihub',
            'url' : '',
            'version' : '',
            'year' : 2019,
            'contributor' : '',
            'data_created' : '2019-11-20 05:18:19.208334+03:00'
            }
    bohang_json['info'] = info

def licenses():
    #license 부분 생성
    license= {
            'id' : '1',
            'name' : 'aiadmin',
            'url' : 'aiadmin@testworks.co.kr'
            }
    bohang_json['licenses'] = [license]

def images(num,date):
    #image 부분 생성
    for img in tree.findall("image"):
        image_dict = {
                    'id' : num + int(img.get("id")),
                    'file_name' : img.get("name"),
                    'width' : int(img.get("width")),
                    'height' : int(img.get("height")),
                    'date_captured' : date,
                    'license' : 1, 
                    'coco_url' : '',
                    'flickr_url' : ''
                    }
        img_list.append(image_dict)

def annotations(num,id_num):
    #annotation 부분 생성
    for i in range(num,len(img_list)):
        img = img_list[i]
        for j, bbox in enumerate(tree.find("image")):
            bounding_box = [
                float(bbox.attrib.get("xtl")), # 좌상단 x
                float(bbox.attrib.get("ytl")), # 좌상단 y
                abs(float(bbox.attrib.get("xbr")) - float(bbox.attrib.get("xtl"))), # width
                abs(float(bbox.attrib.get("ytl")) - float(bbox.attrib.get("ybr")))  # height
            ]
            annotation_dict =  {
                "segmentation": [],
                "area": bounding_box[2] * bounding_box[3],
                "iscrowd": 0,
                "image_id": img["id"],
                "bbox": bounding_box,
                "category_id": label_dict[bbox.attrib.get("label")],
                "id": id_num
            }
            annotation_list.append(annotation_dict)
            id_num += 1
    return id_num


def categories():
    # category 부분 생성
    for i,label in enumerate(tree.find("meta").getchildren()[0].getchildren()[12].getchildren()):
        category = {}
        category['id'] = i
        name = label.getchildren()[0].text
        category['name'] = name
        category_list.append(category)
        label_dict[name] = i
    
num = 0
img_list = []
annotation_list = []
category_list = []
label_dict = {}
bohang_json = OrderedDict()

xmlpathes = sorted(glob("././walking/train/*/*.xml")) #train 폴더 밑의 Bbox 폴더 안의 xml 파일을 가져와서 train 폴더 전체에 대한 coco형식의 json 파일 생성
'''
폴더 구조
walking(aihub 보행 데이터)
|- train(학습 데이터)
    |-Bbox_~~~~
    |-Bbox_~~~~
    |- ...
|- val(검증 데이터)
    |-Bbox_~~~~
    |-Bbox_~~~~
    |- ...

'''

for i, path in enumerate(xmlpathes):
    filePath = path
    tree = ET.parse(filePath)

    img_len = int(tree.find("meta").getchildren()[0].getchildren()[2].text)
    date = tree.find("meta").getchildren()[0].getchildren()[8].text
    
    if i == 0:
        #info, license, category는 하나의 json 파일에 하나씩 들어가야 함
        info()
        licenses()
        categories()
        images(num,date)
        id_num = annotations(num,0)
    else:
        images(num,date)
        tmp = annotations(num,id_num)
        id_num = tmp
    
    num += img_len

bohang_json['images'] = img_list
bohang_json["annotations"] = annotation_list
bohang_json["categories"] = category_list

#저장 
with open('train.json','w',encoding='utf-8') as f:
    json.dump(bohang_json,f,ensure_ascii=False,indent="\t") 