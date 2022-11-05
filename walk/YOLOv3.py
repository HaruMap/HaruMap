import cv2
import numpy as np
import matplotlib.pyplot as plt
import requests
import os

min_confidence = 0.5  #detection으로 인정할 최소 확률(신뢰도)

config_file = "./yolov3.cfg"
weight_file = "./yolov3.weights"
net = cv2.dnn.readNetFromDarknet(config_file, weight_file)
classes = []  #detection할 object list 배열 정의
with open("./coco.names", "r") as f:
  classes = [line.strip() for line in f.readlines()]
layer_names = net.getLayerNames()
output_layers = [layer_names[i - 1] for i in net.getUnconnectedOutLayers()]

#object 마다 컬러 다르게 지정
colors = np.random.uniform(0, 255, size = (len(classes), 3))

def Yolo(url):
  image_nparray = np.asarray(bytearray(requests.get(url).content), dtype=np.uint8)
  img = cv2.imdecode(image_nparray, cv2.IMREAD_COLOR)
  img = cv2.resize(img, None, fx=0.7, fy=0.7)
  height, width, channels = img.shape
  blob = cv2.dnn.blobFromImage(img, 0.00392, (416,416), (0, 0, 0), True, crop=False)

  net.setInput(blob)
  outs = net.forward(output_layers)

  class_ids = []
  confidences = []
  boxes = []

  for out in outs:
    for detection in out:
      scores = detection[5:]
      class_id = np.argmax(scores)
      confidence = scores[class_id]
      if confidence > min_confidence:
        center_x = int(detection[0] * width)
        center_y = int(detection[1] * height)
        w = int(detection[2] * width)
        h = int(detection[2] * height)
        
        x = int(center_x - w / 2)
        y = int(center_y - h / 2)
        boxes.append([x, y, w, h])
        confidences.append(float(confidence))
        class_ids.append(class_id)

  indexes = cv2.dnn.NMSBoxes(boxes, confidences, min_confidence, 0.4)
  # 박스안에 박스(노이지)를 하나로 만들어 줌

  font = cv2.FONT_HERSHEY_PLAIN
  for i in range(len(boxes)):
    if i in indexes:
      x, y, w, h = boxes[i]
      label = str(classes[class_ids[i]])
      print(i, label)
      color = colors[i]
      cv2.rectangle(img, (x, y), (x+w, y+h), color, 1)
      cv2.rectangle(img, (x, y-20), (x+w, y), color, -1)
      cv2.putText(img, label, (x+5, y-5), font, 1, (255, 255, 255), 1)

  plt.imshow(img)
  plt.show()

  count = 0
  for i in range(len(boxes)):
    if i in indexes:
      label = str(classes[class_ids[i]])
      if label=='stop sign' or label=='fire hydrant' or label=='traffic light' or label=='stop sign' or label=='bench' or label=='parking meter':
        count += 1

  return(count)