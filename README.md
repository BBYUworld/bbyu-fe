# 가계쀼

## 😎 개요

<p style="margin-left: 30px;">
    <img src="README_assets/가계쀼로고.png" alt="gagyebbyu Logo" width="110" />
</p>

- 팀명: **쀼의세계**
- 서비스명: **가계쀼: 신혼부부 공동 자산 관리 애플리케이션**
- 개발기간: **2024년 8월 16일 ~ 8월 31일**

<br/>
<br/>

## 🤔 기획배경

- 신혼 부부들의 공동 자산 관리 경험 부족
- 경험 부족으로 인해 개인과 공동 재무의 균형 유지 어려움
- 서로 다른 재무 습관 갈등 해소
-

<br/>

## 🎇 서비스 소개

- 자산 공유를 통해 부부가 함께 재무 목표를 설정하고 달성해 나가는 '공유 펀딩' 시스템
- 공동 및 개인 지출 카테고리화와 AI 기반 지출 패턴 분석 제공
- 실시간 자산 현황 대시보드와 공동 및 개인 지출 내역 간편 조회
- 공동으로 관리할 계좌 및 카드만 선택 공유 가능
- 비슷한 재정 상태(연령대, 연봉)를 가진 타 부부와의 한 달 지출 금액 비교
- 공동 자산을 바탕으로 부부의 소비성향 분석 후 AI를 통한 맞춤형 예·적금 상품 추천
- 부부가 필요한 대출 금액 설정 후, 부부의 상황에 맞춘 비율을 제공하여 최적화된 대출 상품 및 방안 추천

<br/>

## 타 서비스와의 차별점

- 토스뱅크 -> 토스 뱅크는 모임 통장의 카드를 쓴 사람의 이름으로 소득 공제가 되어 결국 부부 통장일지라도 소득이 많은 사람 명의의 카드를 사용해야 한다.
  따로 공동 명의 통장을 개설할 필요 없이 현재 가지고 있는 통장의 등록으로 공유 자산으로 취급할 수 있다.
  마이데이터 API 분석을 통해 더 좋은 조건의 카드나 상품을 추천해줌.

- 뱅크 샐러드 -> 단순 보여주기에 그치지만 ‘가계쀼’는 분석을 통한 맞춤형 상품을 추천해준다.
  부부는 자산 리포트을 통해 자산을 관리할 수 있으며 타 부부와의 소비 패턴 분석을 통해 부부의 소비 습관을 확인할 수 있다.

## 💞 기능 상세

### 1. 메인 페이지

|                                        |                                          |                                        |
| -------------------------------------- | ---------------------------------------- | -------------------------------------- |
| ✨ 회원가입                            | 📌 초기로그인                            | 📌 로그인                              |
| ![](./README_assets/회원가입.gif)      | ![ ](./README_assets/로그인.gif)         | ![ ](./README_assets/초기로그인.gif)   |
| ✨ 커플신청                            | 📌 커플연결                              | 📌 자산연결                            |
| ![ ](./README_assets/커플신청.gif)     | ![ ](./README_assets/커플연결.gif)       | ![ ](./README_assets/자산연결.gif)     |
| 🔑 펀딩생성                            | 🔍 펀딩입금                              | 🔍 펀딩출금                            |
| ![ ](./README_assets/펀딩생성.gif)     | ![ ](./README_assets/펀드입금.gif)       | ![ ](./README_assets/펀드출금.gif)     |
| 💚 개인대출추천                        | 👶 개인예적금추천                        | 👶 부부대출추천                        |
| ![ ](./README_assets/개인대출추천.gif) | ![ ](./README_assets/개인예적금추천.gif) | ![ ](./README_assets/부부대출추천.gif) |
| 📖 가계부리스트                        | 👱‍♀️ 가계부캘린더                          | 👱‍♀️ 소비통계                            |
| ![ ](./README_assets/가계부리스트.gif) | ![ ](./README_assets/가계부캘린더.gif)   | ![ ](./README_assets/소비통계.gif)     |
| 🚪 자산리포트                          |                                          |                                        |
| ![ ](./README_assets/자산리포트.gif)   |                                          |                                        |

<br/>

## 💾 AI 개인 추천시스템

### 1. 전처리

- 범주형 데이터는 LabelEncoder를 사용해서 수치화 시키기 위해 전처리 진행
- 수치형 데이터는 MinMaxScaler를 사용해서 전처리 진행
  <br/>

![image.png](README_assets/전처리.PNG)

<br/>

### 2. DeepFM 모델 학습

- DeepFM 모델 : CTR(Click Through rate)을 최대화 하는 것을 목적으로 하는 모델 -> 가계쀼 서비스에서는 상품 추천을 선택할 확률을 목적으로 하였음

  ![DeepFM 모델 구조](README_assets/deepFM.png)


<br/>

### 3. 추천 결과

- key값은 추천하는 ID, value값은 이 상품을 선택할 확률을 반환
  ![image.png](README_assets/개인대출추천결과.png)

<br/>

## 부부 공동 대출 추천 시스템

- 남자, 여자의 소득, 부채, 총 목표 금액, 신용등급, 주택담보대출 여부를 기반으로 가능한 모든 상품을 체크해서 남자 여자가 어느정도의 비율로 어떤 상품을 대출하면 좋을지 추천을 진행.

- 추천 진행 시 2024년 9월 1일부터 적용되는 스트레스 DSR 반영

  ![image.png](README_assets/공동추천결과.png)
  
<br/>

## AI 지출 내역 카테고리 분류 자동화

### 1. 학습
- 데이터: 한국 전화번호부 사이트 업체명
- 라벨링: 총 19개


![라벨링](README_assets/label.PNG)


<br/>

### 2. KoBERT 모델
-	Model: KoBERT
한국어 버전의 자연어 처리 모델. 
위키피디아나 뉴스 등에서 수집한 수백만 개 한국어 문장의 대규모 말뭉치(Corpus)를 학습하였으며, 한국어의 불규칙한 언어 변화의 특성을 반영하기 위해 데이터 기반 토큰화기법을 적용하여 기존 대비 27%의 토큰만으로 2.6% 이상의 성능 향상을 이끌어 낸 모델
-	Max Seq Len: 26
-	Loss Function: CrossEntropyLoss

  ![KoBERT 모델 구조](README_assets/kobert.png)


<br/>

### 3. 추천 결과

- 장소 입력시 카테고리와 예측 확률 반환

  ![결과](README_assets/expenseCategoryResult.PNG)

<br/>


## 📊 ERD 다이어그램

![ERD다이어그램](README_assets/ERD.PNG)

<br/>

## 💬 API 명세서

![API명세서](README_assets/API명세서.gif)

<br/>

## 💬 플로우 차트

![API명세서](README_assets/플로우차트.png)


## ⚙ 사용 기술

**FE**

<img src="https://img.shields.io/badge/Flutter-61DAFB?style=for-the-badge&logo=React&logoColor=black">

**BE**

<img src="https://img.shields.io/badge/IntellijIdea-000000?style=for-the-badge&logo=intellijidea&logoColor=white">

<img src="https://img.shields.io/badge/Springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white">

<img src="https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white">

<img src="https://img.shields.io/badge/AmazonEC2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white">

<img src="https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=Java&logoColor=white"/>

**AI**

<img src="https://img.shields.io/badge/TensorFlow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white">

<img src="https://img.shields.io/badge/Pytorch-D24939?style=for-the-badge&logo=pytorch&logoColor=white">

**DevOps**

<img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white">

<img src="https://img.shields.io/badge/Jenkins-3178C6?style=for-the-badge&logo=jenkins&logoColor=white"/>

**협업**

<img src="https://img.shields.io/badge/GitLab-FC6D26?style=for-the-badge&logo=gitlab&logoColor=white">

<img src="https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=notion&logoColor=white">

<br/>

## ⚙ 시스템 아키텍처
![시스템 아키텍처](https://github.com/user-attachments/assets/5310207c-be50-4b7b-9994-f20f3ca457cb)


## 개발환경

| 분야     | 기술 스택      | 버전      |
| -------- | -------------- | --------- |
| Backend  | Java           | 17        |
|          | Spring Boot    | 3.3.2     |
|          | JPA            | 5.0.0     |
| Database | MySQL          | 8.0       |
| AI       | PyTorch        | 2.4.0     |
|          | TensorFlow     | 2.17.0    |
|          | FastAPI        | 0.112.2   |
|          | Python         | 3.9, 3.12 |
| Frontend | Flutter        | 3.24.1    |
|          | Dart           | 3.5.1     |
| DevOps   | Docker         | 27.1.2    |
|          | Docker Compose | 2.1.0     |

## 빌드 및 배포 환경

| 도구    | 버전   |
| ------- | ------ |
| Gradle  | 7.3    |
| Uvicorn | 0.30.6 |

## 실행 방법

| 도구        | 방법        |
| ----------- | ----------- |
| Spring boot | AWS, Docker |
| FastAPI     | AWS, Docker |
| MySql       | AWS, Docker |
| Jenkins     | AWS, Docker |
| Flutter     | APK build   |

## <img src="README_assets/가계쀼.png" alt="gagyebbyu Logo" width="35" /> 팀원소개

| <img src="./README_assets/서지흔.png" width="100%" height="100"> | <img src="./README_assets/박정의.jpg" width="100%" height="100"> | <img src="./README_assets/유병주.png" width="100%" height="100"> | <img src="./README_assets/윤정섭.png" width="100%" height="100"> | <img src="./README_assets/임동길.png" width="100%" height="100"> |
| :--------------------------------------------------------------: | :--------------------------------------------------------------: | :--------------------------------------------------------------: | :--------------------------------------------------------------: | :--------------------------------------------------------------: |
|                              서지흔                              |                              박정의                              |                              유병주                              |                              윤정섭                              |                              임동길                              |
|                     팀장, Backend, Frontend                      |                      Backend, Frontend, AI                       |                        Backend, Frontend                         |                           AI, Backend                            |                     Infra, Backend, Frontend                     |
