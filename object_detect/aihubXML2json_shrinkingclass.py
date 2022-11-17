from unicodedata import name
import xml.etree.ElementTree as ET
import json
from collections import OrderedDict
import argparse
from glob import glob

parser = argparse.ArgumentParser(description='Evaluate label Converting.')
parser.add_argument('--img_path', type=str)
parser.add_argument('--save_path', type=str)

args = parser.parse_args()

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
    for j, img in enumerate(tree.findall("image")):
        for bbox in img:
            bounding_box = [
                float(bbox.attrib.get("xtl")), # 좌상단 x
                float(bbox.attrib.get("ytl")), # 좌상단 y
                abs(float(bbox.attrib.get("xbr")) - float(bbox.attrib.get("xtl"))), # width
                abs(float(bbox.attrib.get("ytl")) - float(bbox.attrib.get("ybr")))  # height
                ]
            cate_label=bbox.attrib.get("label")
            cate_id=90
            if cate_label=='tree_trunk':
                cate_id=0
            elif cate_label=='traffic_sign':
                cate_id=1
            elif cate_label=='traffic_light':
                cate_id=2
            elif cate_label=='traffic_light_controller':
                cate_id=3
            elif cate_label=='table':
                cate_id=4
            elif cate_label=='stop':
                cate_id=5
            elif cate_label=='potted_plant':
                cate_id=6
            elif cate_label=='power_controller':
                cate_id=7
            elif cate_label=='pole':
                cate_id=8
            elif cate_label=='fire_hydrant':
                cate_id=9
            elif cate_label=='chair':
                cate_id=10
            elif cate_label=='bollard':
                cate_id=11
            elif cate_label=='bench':
                cate_id=12
            elif cate_label=='barricade':
                cate_id=13

            if cate_id!=90:
                annotation_dict =  {
                    "segmentation": [],
                    "area": bounding_box[2] * bounding_box[3],
                    "iscrowd": 0,
                    "image_id": num + int(img.get("id")),
                    "bbox": bounding_box,
                    "category_id": cate_id,
                    "id": id_num
                }
                annotation_list.append(annotation_dict)
                id_num += 1
    return id_num


# def categories():
#     # category 부분 생성
#     for i,label in enumerate(tree.find("meta")[0][12]):
#         category = {}
#         category['id'] = i
#         name = label[0].text
#         category['name'] = name
#         category_list.append(category)
#         label_dict[name] = i
    
num = 0
img_list = []
annotation_list = []
category_list = []
label_dict = {}
bohang_json = OrderedDict()
img_path = args.img_path + "/*/*.xml"
xmlpathes = sorted(glob(img_path)) #train 폴더 밑의 Bbox 폴더 안의 xml 파일을 가져와서 train 폴더 전체에 대한 coco형식의 json 파일 생성

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

    img_len = int(tree.find("meta")[0][2].text)
    date = tree.find("meta")[0][8].text
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
bohang_json["categories"] = [{
			"id": 0,
			"name": "tree_trunk"
		},
		{
			"id": 1,
			"name": "traffic_sign"
		},
		{
			"id": 2,
			"name": "traffic_light"
		},
		{
			"id": 3,
			"name": "traffic_light_controller"
		},
		{
			"id": 4,
			"name": "table"
		},
		{
			"id": 5,
			"name": "stop"
		},
		{
			"id": 6,
			"name": "potted_plant"
		},
		{
			"id": 7,
			"name": "power_controller"
		},
		{
			"id": 8,
			"name": "pole"
		},
		{
			"id": 9,
			"name": "fire_hydrant"
		},
		{
			"id": 10,
			"name": "chair"
		},
		{
			"id": 11,
			"name": "bollard"
		},
		{
			"id": 12,
			"name": "bench"
		},
		{
			"id": 13,
			"name": "barricade"
		}]

#저장 
with open(args.save_path,'w',encoding='utf-8') as f:
    json.dump(bohang_json,f,ensure_ascii=False,indent="\t") 