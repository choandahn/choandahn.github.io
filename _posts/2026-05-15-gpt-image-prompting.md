---
layout: post
title: "GPT 이미지 모델 프롬프팅 노트 (gpt-image-2)"
date: 2026-05-15
author: 운장
lang: ko
description: gpt-image-2를 쓰며 추린 프롬프팅 핵심 — 모델·크기 선택, 구조 잡는 법, 이커머스에서 실제로 먹히는 사용 사례.
---

이미지 모델을 처음 만지는 사람들이 자주 하는 실수가 있다. 프롬프트를 코드처럼 쓰려는 것이다. 토큰을 욱여넣고, 가중치 문법을 외우고, 마법의 키워드를 찾는다.

gpt-image-2는 그렇게 동작하지 않는다. **프롬프트는 코드가 아니라 디자이너에게 주는 브리프다.** 좋은 디렉터가 사진가에게 말하듯 쓰면 된다 — 무엇을, 어떤 분위기로, 무엇을 건드리지 말고.

## 어떤 모델을, 어떤 품질로

2026년 4월 21일 공개된 gpt-image-2는 GPT-5.4 백본 위에 올라간다. 텍스트 정확도가 라틴·CJK·힌디·벵골 기준 약 99%에 이르고, 최대 4K 해상도, 이전 세대보다 약 2배 빠르다. 새 작업이라면 기본값은 고민할 것 없이 gpt-image-2다.

판단 기준은 단순하다.

- **기본**: `gpt-image-2`. 최고 품질 생성·편집, 텍스트가 많은 이미지, 신원에 민감한 편집.
- **속도·단가가 중요할 때**: `gpt-image-2`에 `quality: low`. 대량 생성과 실험에 충분하다. 그보다 더 싸게 가야 하면 `gpt-image-1-mini`.
- **레거시 유지**: 마이그레이션 검증·회귀 테스트 기간에만 `gpt-image-1.5` / `gpt-image-1`.

크기는 표준 세 가지(`1024x1024`, `1536x1024`, `1024x1536`)를 기본으로 두되, gpt-image-2는 제약만 지키면 임의 해상도를 받는다 — 변은 3840px 미만·16의 배수, 긴변:짧은변 ≤ 3:1, 총 픽셀 655,360 ~ 8,294,400. 단 2K(2560×1440)를 넘으면 결과 편차가 커지므로 실험적으로 다뤄야 한다.

## 구조부터 잡는다

복잡한 요청일수록 긴 한 문단이 아니라 라벨 구획으로 쪼개는 게 유리하다. 순서는 대체로 **장면/배경 → 주체 → 핵심 디테일 → 제약**.

몇 가지 반복해서 효과를 본 원칙:

- **사실적으로 가려면 "photorealistic"을 직접 박는다.** "real photograph", "shot on a 50mm lens" 같은 표현이 모델의 사실주의 모드를 강하게 켠다. 단 카메라 사양은 정밀 시뮬레이션이 아니라 전반적 룩을 위한 단서로 쓰일 뿐이다.
- **편집은 "change only X, keep everything else the same".** 그리고 매 반복마다 보존 목록을 다시 적는다. 드리프트를 막는 가장 싼 방법이다.
- **이미지 내 텍스트는 따옴표나 ALL CAPS로.** 브랜드명·희귀 철자는 한 글자씩 풀어 써서 정확도를 높인다. 작고 빽빽한 텍스트는 `quality: high`.
- **과부하 대신 반복.** 깨끗한 베이스에서 시작해 "조명 더 따뜻하게", "여분 객체 제거" 식 단일 변경으로 다듬으면 디버깅이 쉽다.

## 실제로 먹히는 사용 사례

이론보다 사례가 빠르다. 우리가 GESTEL을 만들며 자주 돌리는 패턴 위주로.

**인포그래픽.** 구조화된 정보를 한 장에 담는 작업. 밀도가 높으니 `quality: high`가 정답이다.

```
Create a detailed infographic of the functioning and flow of an automatic
coffee machine like a Jura. From bean basket, to grinding, to scale, water
tank, boiler, etc. I'd like to understand technically and visually the flow.
```

![자동 커피머신의 동작 흐름 인포그래픽](/assets/images/gpt-infographic.jpg)

*라벨·화살표·범례가 한 번에 정렬된다. gpt-image-2의 텍스트 렌더링이 강해진 덕이 크다.*

**이미지 내 번역(현지화).** 레이아웃을 새로 만들지 않고 텍스트만 다른 언어로 갈아끼우는 작업. 이커머스 상세페이지를 시장별로 까는 데 직결된다. 핵심은 "텍스트를 제외한 모든 것 보존".

```
Translate the text in the infographic to Spanish.
Do not change any other aspect of the image.
```

**"연출하지 않은 듯한" 사실적 사진.** 광택과 스튜디오 냄새를 빼고, 실제 질감(모공·주름·옷감 마모)을 명시적으로 요청하는 게 핵심이다.

```
Create a photorealistic candid photograph of an elderly sailor on a small
fishing boat. Weathered skin with visible wrinkles, pores, sun texture.
Shot like a 35mm film photograph, 50mm lens, soft coastal daylight,
shallow depth of field, subtle grain. Honest and unposed. No glamorization,
no heavy retouching.
```

![어선 위 노년 어부의 사실적 인물 사진](/assets/images/gpt-photorealism.jpg)

**UI 목업.** 이미지 내 텍스트 렌더링이 좋아지면서 실제로 쓸 만한 화면 목업이 나온다. 디바이스 프레임, 폰트, 레이아웃을 제약으로 못 박으면 된다.

![파머스 마켓 앱 UI 목업](/assets/images/gpt-ui-mockup.jpg)

## 한 줄 요약

모델은 gpt-image-2로 고정하고, 품질만 용도에 맞춰 내린다. 프롬프트는 코드가 아니라 브리프처럼 — 구조를 잡고, 보존할 것을 못 박고, 한 번에 완성하려 들지 말 것.

---

*OpenAI의 [GPT Image Generation Models Prompting Guide](https://developers.openai.com/cookbook/examples/multimodal/image-gen-models-prompting-guide)를 바탕으로 핵심을 추려 정리한 노트다. 예시 프롬프트와 이미지는 원문 가이드의 것을 인용했다.*
