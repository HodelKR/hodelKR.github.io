---
layout: post
title: "Linked List (연결리스트)"
categories: Data Structure
---

## Arrays
Linked List를 설명하기 전에 우리가 기존에 사용하고 있던 배열이 무엇인지 알 필요가 있다. 배열은 같은 자료형을 순차적으로 저장할 수 있는 공간이다.

이렇듯 배열은 순차적으로 저장되어 현재 요소에서 다음 요소, 다다음 요소를 가리키기 쉽지만 배열은 한 번 선언될 때 크기가 정해지기 때문에 가변적이지 못하다.

## Linked List
Linked List는 새로운 원소가 삽입될 때 마다 새로운 노드를 생성하고 이전 노드와 연결시켜준다. head와 tail이라는 값이 없는 위치 노드를 가지고 원하는 원소들의 값을 유지, 관리한다.

이 글에서 구현하는 기능은 다음과 같다.
- bool empty() : 리스트가 비어있으면 true, 원소가 하나라도 있으면 false
- int front() : 맨 앞 값을 리턴
- int back() : 맨 뒤 값을 리턴
- void addFront() : 맨 앞에 원소 삽입
- void addBack() : 맨 뒤 원소 삽입
- int removeFront() : 맨 앞 원소를 삭제하고 값을 리턴
- int removeBack() : 맨 뒤 원소를 삭제하고 값을 리턴

## Base
기본적인 클래스 모양은 다음과 같다.
```cpp
class Node{
private:
    Node* prev;
    Node* next;
    int value;
    friend class LinkedList;
};
class LinkedList{
public:
    LinkedList();
    ~LinkedList();
    bool empty() const;
    int front() const;
    int back() const;
    void addFront(int x);
    void addBack(int x);
    int removeFront() const;
    int removeBack() const;
private:
    Node* head;
    Node* tail;
}
```
## Constructor, Destructor
먼저 생성자와 소멸자의 구현이다.
```cpp
LinkedList(){
    head = new Node;
    tail = new Node;
    head->prev = NULL;
    head->next = tail;
    tail->prev = head;
    tail->nexrt = NULL;
}
~LinkedList(){
    while(head!=tail){
        head = head->next;
        delete head->prev;
    }
}
```
## Empty, Front, Back
LinkedList에 꼭 필요한 기능은 아니지만 구현하면 좋은 기능들이다.
```cpp
bool empty(){
    return head->next == tail;
}
int front(){
    if(empty())return -1; // error
    else return head->next->value;
}
int back(){
    if(empty())return -1; // error
    else return tail->prev->value;
}
```
## Add
LinkedList의 삽입 기능이다. 이 글에서는 앞, 뒤 모두 삽입 가능하게 구현한다.
```cpp
void addFront(int x){
    Node* tmp = new Node;
    tmp->value = x; // 값을 넣어준다.
    head->next->prve = tmp; // 첫번째 노드의 prev가 tmp를 가리키도록 한다.
    tmp->next = head->next; // 현재 노드의 next가 첫번째 원소를 가리키도록 한다.
    head->next = tmp; // head의 next가 현재 노드를 가리키도록 한다.
    tmp->prev = head; // 현재 노드의 prev가 head를 가리키도록 한다.
}
void addBack(int x){
    Node* tmp = new Node;
    tmp->value = x;
    tail->prev->next = tmp; // 마지막 원소의 next가 tmp를 가리키도록 한다.
    tmp->prev = tail->prev; // 현재 노드의 prev가 마지막 노드를 가리키도록 한다.
    tail->prev = tmp; // tail의 prev가 tmp를 가리키도록 한다.
    tmp->next = tail // 현재 노드의 next가 tail를 가리키도록 한다.
}
```
## Remove
LinkedList의 삭제기능이다. 이 글에서는 앞, 뒤 모두 삭제 가능하게 했다.
```cpp
int removeFront(){
    if(empty())return -1; // error
    Node* tmp = head->next; // 지울 노드를 tmp로 지정
    int ret = tmp->value;
    head->next = tmp->next; // head의 next가 두 번째 노드를 가리키게 한다.
    tmp->next->prev = head; // 두번째 노드의 prev가 head를 가리키게 한다.
    delete tmp; // 첫 번째 노드를 삭제한다.
    return ret;
}
int removeFront(){
    if(empty())return -1; // error
    Node* tmp = tail->prev; // 지울 노드를 tmp로 지정
    int ret = tmp->value;
    tail->prev = tmp->prev; // tail의 prev가 마지막 전 노드를 가리키도록 한다.
    tmp->prev->next = tail; // 마지막 전 노드의 next가 tail를 가리키게 한다.
    delete tmp; // 첫 번째 노드를 삭제한다.
    return ret;
}
```