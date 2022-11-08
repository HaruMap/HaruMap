import numpy as np

def sort_score(total_paths):

    # print(paths)

    paths = []
    scores = []
    sort_path = []

    print(len(total_paths))

    for idx in range(len(total_paths)):
        print(idx)
        print()
        paths.append(total_paths[idx])
        scores.append(total_paths[idx]['score'])

    print(paths)
    # print(scores)

    score_sorted = np.sort(scores) # 오름차순 정렬 (이동불편지수가 낮은 경로를 우선으로 정렬)
    score_sorted_idx = np.argsort(scores)
    paths_sorted = [paths[i] for i in score_sorted_idx]

    print(paths_sorted)
    print(score_sorted)

    return paths_sorted