---
layout: post
title: "MST Kruskal Algorithm (최소신장트리)"
categories: Graph
---

# Minimum Spaning Tree

###  Background
Minimum Spaning Tree란 각 간선의 가중치가 동일하지 않을 때 Vertex - 1개의 Edge로 모든 정점을 최소 비용으로 연결시키는 Tree를 말한다. MST의 특징으로는 간선의 가중치의 합이 최소이고 사이클이 포함되어서는 안된다.

## Kruskal Algorithm
아직 연결되지 않은 정점의 쌍에 대하여 최소 비용의 간선을 선택해 greedy하게 MST를 만드는 알고리즘이다. greedy한 방법은 순간적에서는 최적이지만 전체적인 관점에서 최적이라는 보장이 없다. 그러나 Kruskal Algorithm은 최적의 해답을 보장해주는 것으로 알려져 있다.

## Union-Find
Disjoint Set을 만들기 위한 알고리즘이다. Disjoint set란 서로 중복되지 않은 부분 집합들로 나눠진 원소들에 대한 정보를 저장하는 자료구조이다. 
- Union-Find의 연산
    - Union(A, B) : A가 속한 집합과 B가 속한 집합을 합친다.
    - Find(A) : A가 속한 집합의 대표 값을 반환한다.

### Implement
```cpp
#include<iostream>
using namespace std;
int find(int n){
    if(n==par[n])return n;
    else return par[n] = find(par[n]);
}
void merge(int x, int y){
    x = find(x);
    y = find(x);
    par[x] = y;
}
```