import numpy as np

# 이동불편지수 낮은 순
def sort_score(total_paths):

    paths = []
    scores = []
    sort_path = []

    for idx in range(len(total_paths)):
        paths.append(total_paths[idx])
        scores.append(total_paths[idx]['score'])

    score_sorted = np.sort(scores) # 오름차순 정렬 (이동불편지수가 낮은 경로를 우선으로 정렬)
    score_sorted_idx = np.argsort(scores)
    paths_sorted = [paths[i] for i in score_sorted_idx]

    # print(paths_sorted)
    # print(score_sorted)
    return paths_sorted

# 최소 시간 순
def sort_time(total_paths):
    return

# 최소 도보 순
def sort_walk(total_paths):
    return

# 최소 환승 순
def sort_transfer(total_paths):
    return