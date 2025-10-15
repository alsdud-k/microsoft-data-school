# Django Todo App

## 프로젝트 소개

이 프로젝트는 Python Django를 활용하여 제작한 Todo 리스트 애플리케이션입니다.
기본적인 CRUD 기능에서 시작해, 회원가입 및 로그인 기능, 그리고 캘린더 뷰를 통한 시각적인 일정 관리 기능까지 확장하였습니다.

---

## 주요 기능

1. **기본 CRUD**: 할 일 생성(Create), 조회(Read), 수정(Update), 삭제(Delete)
2. **회원가입 및 로그인**: 사용자 인증 및 권한 관리
3. **캘린더 뷰**: FullCalendar를 통한 일정 시각화

---

## GPT 활용 포인트 (Vibe Coding)

이 프로젝트는 GPT와의 상호작용을 통해 단계적으로 발전했습니다.
단순히 코드를 받아 적는 것이 아니라, 질문을 설계하고 GPT와의 대화를 통해 점진적으로 기능을 확장한 것이 핵심입니다.

* **1단계**: "Django로 간단한 Todo CRUD 구현하기"라는 질문을 통해 기본 뼈대 완성
* **2단계**: "회원가입과 로그인 기능 추가하기"라는 질문으로 사용자 친화적 기능 확장
* **3단계**: "기존 데이터를 시각적으로 볼 수 있는 캘린더 기능 추가하기"라는 질문으로 일정 관리 고도화

이 과정에서 **Vibe Coding**을 실천하였습니다.
즉, 단순히 정답을 요구하는 것이 아니라, GPT가 제안한 방향을 이해하고, 흐름을 타며(바이브) 코드를 발전시켜 나가는 방식입니다.

---

## 실행 방법

```bash
# 가상환경 실행 후 필요 패키지 설치
django-admin startproject todo_project
cd todo_project
python manage.py runserver
```

브라우저에서 `http://127.0.0.1:8000` 접속 후 확인 가능합니다.

---

## 기술 스택

* Python 3.9
* Django 4.2
* SQLite3
* FullCalendar (Frontend 일정 시각화)

---

## 향후 발전 방향

* 마감일 알림 기능 추가
* 태그별 Todo 분류
* REST API 제공 및 React/Vue 연동
