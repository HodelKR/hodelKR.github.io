---
layout: post
title: "Topology Sort (위상정렬)"
categories: Graph
---

###  Background
Topology Sort는 유향 그래프의 indegree가 없는 vertex를 시작으로 outdegree가 없는 vertex까지 나열하는 것을 의미한다. 해당 정렬이 가능하려면 그래프는 DAG를 만족해야 한다.
Directed Acyclic Graph (DAG, 유향 비순환 그래프)란 간선의 방향이 있고 Cycle이 존재하지 않는 그래프를 의미한다.

## Kahn's Algorithm
Kahn's Algorithm은 Topology Sort 알고리즘 중 하나이다. 각 vertex의 indegree와 outdegree를 체크해서 indegree가 없는 vertex 부터 위상 정렬 배열에 추가하고 해당 vertex의 edge를 삭제하면서 다시 indegree가 없는 vertex를 찾는 것을 반복한다.
시간복잡도는 indegree를 세는 과정에서 O(E), 정렬된 배열을 만드는 과정에서 O(V)가 걸리고 총합 O(V+E)이다.
### Implement
```cpp
#include<iostream>
#include<vector>
using namespace std;
// Vertex 번호는 1~N임을 가정
vector<int> TopologySort(vector<vector<int>> DAG){
    int vertex = DAG.size(); // vertex의 개수
    vector<int> indegree(vertex, 0); // indegree 배열
    for(int i=0;i<vertex;i++){
        for(int nxt : DAG[i]){
            indegree[nxt]++; // indegree 체크
        }
    }
    int start = 0;
    // indegree가 0인 vertex를 찾기
    for(int i=1;i<=vertex;i++){
        if(indegree[i]==0){
            start = i;
            break;
        }
    }
    vector<int> result(vertex, 0); // 위상 정렬 결과
    result.push_back(start); // 시작 vertex를 저장
    for(int i=0;i<result.size();i++){
        int now = result[i];
        // outdegree를 체크해서 다음 vertex의 indegree를 감소
        for(int nxt : DAG[now]){
            indegree[nxt]--;
            // indegree가 0이면 result 배열에 추가
            if(!indegree[nxt])result.push_back(nxt);
        }
    }
    return result;
}
```