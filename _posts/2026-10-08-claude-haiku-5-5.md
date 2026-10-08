---
layout: post
title: "Claude Haiku 5.5 (번역)"
date: 2026-10-08 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "앤스로픽의 저가 모델 하이쿠 5.5가 GPT-6 루나와 같은 가격에 나왔고, 10만 토큰을 넘는 순간 가격 구도가 뒤집히는 이유를 정리한 글이다."
source_url: "https://simonwillison.net/2026/Oct/7/claude-haiku-5-5/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
image: "/assets/images/curation/2026-10-08-hero.jpg"
image_alt: "저울 양쪽에 놓인 서로 다른 크기의 토큰 블록과 가격표가 그려진 미니멀한 에디토리얼 일러스트"
---

> 원문: https://simonwillison.net/2026/Oct/7/claude-haiku-5-5/

---

앞서 예고한 대로, 앤스로픽의 새로운 빠른 저가 모델이 나왔다. [Introducing Claude Haiku 5.5](https://www.anthropic.com/claude-haiku-5-5).

이전 하이쿠인 4.5는 나이가 꽤 든 모델이었다. 거의 1년 전에 나왔고 가격은 입력 백만 토큰에 1달러, 출력에 5달러였다. 그 당시에도 비교적 비싼 편이었고, 지난달에 나온 OpenAI의 [GPT-6 Luna](https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/#gpt-6-sol-and-luna-are-half-the-price-of-their-gpt-5-6-equivalents)의 10배 가격이었다.

새 하이쿠는 10만 토큰까지 루나와 가격이 정확히 같다. 0.10달러/0.50달러. 10만 토큰을 넘으면 가격이 5배로 뛰어 0.50달러/2.50달러가 된다. 루나도 27만 2천 토큰에서 가격이 오르지만 0.20달러/0.75달러까지만 오른다.

하이쿠 5.5는 그보다 덜 후한 새 토크나이저도 쓴다. 내 [Claude Token Counter](https://tools.simonwillison.net/claude-token-counter) 도구로 확인해 보면 같은 긴 프롬프트가 하이쿠 4.5보다 하이쿠 5.5에서 약 1.25배 많은 토큰을 쓴다. 숨은 가격 인상이 하나 더 있는 셈이다.

작업이 10만 토큰 안에 들어간다면 하이쿠는 루나와 같은 가격에 벤치마크 점수는 더 높다고 나온다. 10만 토큰을 넘는다면 루나가 훨씬 나은 선택으로 보인다.

[최신 릴리스의 llm-anthropic](https://github.com/simonw/llm-anthropic/releases/tag/0.30) 덕분에 새 모델이 나올 때마다 플러그인 새 버전을 내놓지 않아도 되게 됐다. 새 모델은 이렇게 테스트했다:

```
llm install -U llm-anthropic
llm anthropic refresh
llm -m claude-haiku-5.5 "Generate an SVG of a pelican riding a bicycle" -o thinking_effort low
```

### 펠리컨

[low, medium, high, xhigh, max 결과를 한데 모은 펠리컨](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F485dfa24b4efa1267ee2d0911594fb81)이 여기 있다. 새 하이쿠는 추론을 끌 수 없고 기본값은 `medium`이다. `low`보다 높은 단계에서는 전부 좋은 자전거 프레임을 얻었다. [low 단계 펠리컨](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F485dfa24b4efa1267ee2d0911594fb81#response)은 0.0936센트에 7초 걸렸다.

`max` 단계 펠리컨은 생성에 5분 9초가 걸렸지만 그래도 [3.3826센트](https://www.llm-prices.com/#it=27&ot=67647&sel=claude-haiku-5.5)밖에 들지 않았다:

![흰 펠리컨이 빨간 모자를 쓰고 어두운 회색 자전거를 타고 초록 잔디 띠를 따라 왼쪽에서 오른쪽으로 달리는 플랫 벡터 일러스트. 긴 주황색 다리가 주황색 페달에 닿아 있고, 회색 날개를 앞으로 뻗어 구부러진 핸들바를 잡고 있으며, 크고 주황색인 부리와 부풀어 오른 주머니가 앞을 향한다. 뒤로는 하얀 속도선이 그려져 있고 위로는 노란 태양과 연한 후광, 두 개의 하얀 구름이 파란 그러데이션 하늘에 떠 있다.](https://static.simonwillison.net/static/2026-10-07/haiku-5.5-max.webp)

비교를 위해 1년 전 하이쿠 4.5가 그려준 펠리컨도 올린다([0.7583센트](https://www.llm-prices.com/#it=18&ot=1513&ic=1&oc=5)짜리다. 하이쿠 4.5는 추론 단계를 지원하지 않았다). 하이쿠 4.5는 펠리컨 그리기에 한심할 정도로 못했었다:

![하이쿠 4.5의 설명: 파란 하늘과 초록 잔디 배경 위에서, 둥근 갈색 몸과 분홍 부리, 주황색 다리를 가진 새가 자전거를 타는 기발한 일러스트.](https://static.simonwillison.net/static/2025/claude-haiku-4.5-pelican.jpg)

### 그리고 구독자를 위한 후한 API 크레딧

하이쿠 5.5와 함께 앤스로픽은 소넷 5.5의 캐시 읽기 가격을 절반으로 낮췄다고 발표했다. 구독 플랜에 API 크레딧도 추가했다:

> 둘째, 이번 주에 모든 Max와 Team 구독자에게 Claude 플랫폼에서 쓸 수 있는 새로운 월간 API 크레딧을 제공한다. Max 5x 사용자는 매월 100달러, Max 20x 사용자는 200달러를 받고, Team 구독자는 사용자 전체가 함께 쓰는 최대 500달러를 받는다.

신청하는 것도 기분 좋을 만큼 쉽다. [Settings -> Billing](https://claude.ai/new#settings/billing)으로 가서 매월 크레딧을 받을 API 조직을 선택하면 된다:

![오른쪽 위에 닫기 X 버튼이 있고 General, Account, Privacy, Billing(선택됨), Usage, Capabilities, Memory, Design sys(가장자리에서 잘림) 탭이 나란히 놓인 설정 대화상자 스크린샷. 원이 달린 가지 모양 선화 아이콘 옆에 Max 플랜, Pro보다 20배 많은 사용량, 구독이 2026년 11월 2일에 자동 갱신된다는 문구와 Adjust plan 버튼이 있다. 그 아래 파란 New 배지가 붙은 API credits 섹션에 Max 20x 플랜에는 매월 200달러의 API 크레딧이 포함된다는 문구와, 크레딧을 받으려면 API 조직을 연결하라는 회색 안내, Link organization 버튼이 있다.](https://static.simonwillison.net/static/2026-10-07/claude-credits.webp)

이 API 크레딧은 구독료와 정확히 같은 금액이다. 정말 후한 정책이다. 구독자가 API를 쓰기가 훨씬 쉬워진다. 앤스로픽은 API의 자동 충전을 끌 수도 있게 했고, 그러면 "잔액이 떨어지면 API 요청이 멈춘다". API 크레딧을 쓰다 만들 계획이라면 [불쾌한 청구서 놀람](https://simonwillison.net/2026/Oct/3/default-hard-budget-caps/) 없이 정확히 원하는 동작이다.

월간 크레딧은 [이월되지 않는다](https://support.claude.com/en/articles/17154008-monthly-api-credits-for-max-and-team-plans#h_dfc1659cee). 쓰지 않으면 사라진다.

OpenAI는 여전히 Codex 구독을 개인 API 사용에 쓸 수 있게 해 주고 있어서, API를 많이 쓰는 사람에게는 여전히 OpenAI 쪽이 더 나은 거래다. 이번 크레딧 정책은 그 격차를 메우는 어느 정도의 역할은 한다.
