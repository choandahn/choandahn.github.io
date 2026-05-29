---
layout: post
title: "FLUX.2 프롬프팅 노트 — 자연어를 버려야 할 때"
date: 2026-05-22
author: 운장
lang: ko
description: FLUX.2 [pro] & [max]를 쓰며 추린 핵심 — 네거티브 프롬프트가 없는 모델, HEX 색상과 JSON으로 재현성을 잡는 법.
---

대부분의 이미지 모델 프롬프팅 글은 "자연어로 풍부하게 묘사하라"고 한다. 맞는 말이다. 하지만 브랜드 작업처럼 **같은 결과를 반복 재현해야 하는 순간**, 자연어는 한계를 드러낸다. "빨간 소파"는 매번 다른 빨강을 뱉는다.

FLUX.2의 진짜 무기는 화려한 문장이 아니다. **HEX 색상과 JSON으로 자연어를 버리고 구조를 잡는 능력**이다.

## 먼저, 네거티브 프롬프트가 없다

FLUX.2는 네거티브 프롬프트를 지원하지 않는다. "흐림 없음"이 아니라 "sharp focus throughout", "사람 없음"이 아니라 "empty scene"이라고 **원하는 것을 서술**해야 한다. 여기서부터 사고방식을 바꿔야 한다.

기본 구조는 **주체(Subject) + 동작(Action) + 스타일(Style) + 맥락(Context)**. 그리고 단어 순서가 중요하다 — FLUX.2는 앞에 오는 것에 더 주목한다. 가장 중요한 요소를 맨 앞에.

사실적 표현은 카메라·렌즈·필름 스톡을 박을 때 가장 잘 나온다. `"professional photo"`보다 `"Shot on Fujifilm X-T5, 35mm f/1.4"`가 훨씬 그럴듯하다.

## HEX 색상 — 브랜드 작업의 분기점

`color`나 `hex` 같은 키워드 뒤에 코드를 붙이면 FLUX.2는 정확한 색을 맞춘다. 브랜드 컬러를 다루는 우리(GESTEL) 입장에선 이게 게임 체인저다.

```
A modern living room with warm terracotta walls in hex #C4725A,
an L-shaped sectional sofa in deep teal hex #1B6B6F, and golden amber
hex #E8A847 accent pillows. Light oak floors, soft afternoon light.
```

![지정한 HEX 색상으로 렌더링된 거실](/assets/images/flux-hex-color.jpg)

*벽 #C4725A, 소파 #1B6B6F, 포인트 #E8A847 — 지정한 세 색이 그대로 들어온다.*

다만 한 가지 규칙: **HEX는 특정 사물과 명확히 묶일 때만 작동한다.** `"The car is #FF0000"`은 잘 되지만 `"use #FF0000 somewhere"`는 일관성이 무너진다.

## 타이포그래피

FLUX.2는 깔끔한 텍스트 레이아웃을 잘 만든다. 요령은 GPT 쪽과 비슷하다 — 따옴표로 문구 감싸기, 위치 지정, 폰트 스타일 묘사, 브랜드 텍스트엔 HEX.

```
Groovy retro poster with the quote "If you love me let me sleep".
Bold 70s typography in deep red and warm pink tones. Cream background,
bold orange doodle around the text. Funky layout with playful shadow.
```

![레트로 타이포그래피 포스터](/assets/images/flux-typography.jpg)

## JSON — 재현성과 자동화

복잡한 장면이나 프로덕션 파이프라인에서는 JSON 구조화 프롬프트가 답이다. 제품을 부위로 분해하고 각 부분에 정확한 색을 박은 뒤 `color_match: "exact"`를 걸면, 브랜드 일관성을 강제할 수 있다.

```json
{
  "scene": "Studio product shot of a sweatshirt on white background",
  "subjects": [
    {"type": "Main Torso", "description": "central panel, strictly #FFFFFF white", "color_match": "exact"},
    {"type": "Sleeves", "description": "long sleeves, strictly #86E04A lime green", "color_match": "exact"},
    {"type": "Trims", "description": "collar and cuffs, strictly #000000 black", "color_match": "exact"}
  ],
  "color_palette": ["#FFFFFF", "#86E04A", "#000000"]
}
```

자연어가 나은 경우도 분명히 있다 — 빠른 탐색, 단순한 단일 주체, 유연성이 중요한 창작. FLUX.2는 두 형식을 똑같이 이해한다. **요점은 "워크플로의 성격에 맞춰 형식을 고르라"는 것.** 탐색은 자연어, 재현은 JSON.

## [pro]와 [max], 그리고 다중 참조

`[max]`는 현재 BFL의 최상위 모델이다. 프롬프트 준수도와 편집 일관성이 더 높고, **웹을 검색해 실시간 맥락을 가져오는 그라운디드 생성**과 최대 10장의 참조 이미지를 지원한다(`[pro]`는 8장). 패션 룩 조합, 인테리어 배치, 제품 합성처럼 여러 입력을 섞을 때 — 각 입력의 역할("이미지 1의 의류, 이미지 2의 스타일")을 명확히 묘사하는 게 핵심이다.

해상도는 최소 64×64, 최대 4MP, 출력 치수는 16의 배수. 대부분 용도엔 2MP까지가 권장이다.

## 한 줄 요약

탐색은 자연어로 빠르게, 재현은 HEX와 JSON으로 단단하게. 네거티브 프롬프트가 없다는 사실을 잊지 말고 — 원하는 것만 서술할 것.

---

*Black Forest Labs의 [FLUX.2 Prompting Guide](https://docs.bfl.ai/guides/prompting_guide_flux2)를 바탕으로 핵심을 추려 정리한 노트다. 예시 프롬프트와 이미지는 원문 가이드의 것을 인용했다.*
