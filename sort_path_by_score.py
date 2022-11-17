import numpy as np

# 이동불편지수 낮은 순
def sort_score(total_paths, drf_paths):

    paths = []
    scores = []
    sort_path = []
    # print(total_paths)
    for idx in range(len(total_paths)):
        paths.append(total_paths[idx])
        scores.append(total_paths[idx]['score'])
    score_sorted = np.sort(scores) # 오름차순 정렬 (이동불편지수가 낮은 경로를 우선으로 정렬)
    score_sorted_idx = np.argsort(scores)
    paths_sorted = [paths[i] for i in score_sorted_idx]
    
    ''' drf 전달 데이터 이동불편지수 낮은 순으로 정렬 '''
    drf_sorted = [drf_paths[i] for i in score_sorted_idx]

    # print(paths_sorted)
    # print(score_sorted)
    return paths_sorted, drf_sorted

# 최소 시간 순
def sort_time(total_paths):

    paths = []
    times = []
    sort_path = []

    for idx in range(len(total_paths)):
        paths.append(total_paths[idx])
        times.append(total_paths[idx]['info']['totaltime'])

    time_sorted = np.sort(times) # 오름차순 정렬 (이동불편지수가 낮은 경로를 우선으로 정렬)
    time_sorted_idx = np.argsort(times)
    paths_sorted = [paths[i] for i in time_sorted_idx]

    # print(paths_sorted)
    # print(time_sorted)
    return paths_sorted

# 최소 도보 순
def sort_walk(total_paths):

    paths = []
    walks = []
    sort_path = []

    for idx in range(len(total_paths)):
        paths.append(total_paths[idx])
        walks.append(total_paths[idx]['walk']['pathd'])

    walk_sorted = np.sort(walks) # 오름차순 정렬 (이동불편지수가 낮은 경로를 우선으로 정렬)
    walk_sorted_idx = np.argsort(walks)
    paths_sorted = [paths[i] for i in walk_sorted_idx]

    # print(paths_sorted)
    # print(walk_sorted)
    return paths_sorted

# 최소 환승 순
def sort_transfer(total_paths):
    return

# total dict to list
def dict_to_list(total_paths1, total_paths2, total_paths3):

    cnt = 0
    paths_sum = {}
    
    for path in total_paths1.values():
        paths_sum[cnt] = path
    for path in total_paths2.values():
        paths_sum[cnt] = path
    for path in total_paths3.values():
        paths_sum[cnt] = path
    
    return paths_sum