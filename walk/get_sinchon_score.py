import pandas as pd
import pickle
import score

graph = pd.read_pickle("graph.pkl")

# 이동불편지수 정하기
scoreN = []
# with open("check.pkl","rb") as f:
#     scoreN = pickle.load(f)

for i in range(len(graph['coor'])):
    print(i,'of', len(graph['coor']))
    coor = graph['coor'].loc[i]
    scoreN.append(score.get_walkscore(coor))
    
    with open("check.pkl","wb") as f:
        pickle.dump(scoreN, f)
    print("======================================\n")

graph['score'] = scoreN
print(graph)

with open("final.pkl","wb") as f:
        pickle.dump(graph, f)