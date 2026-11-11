---
layout: post
title: "메타의 가장 작고 효율적인 모델, Muse Ember (번역)"
date: 2026-11-11 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "메타가 에이전트 반복 작업용 소형 모델 Muse Ember를 공개했다. 가격은 Haiku·Luna급이고 Artificial Analysis 효율성 최전선에 위치한다."
source_url: "https://simonwillison.net/2026/Nov/10/muse-ember/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
image: "/assets/images/curation/2026-11-11-hero.jpg"
image_alt: "하나의 작은 원이 효율성 최전선의 꺾이는 지점에 놓여 있고, 더 큰 회색 형태들이 선에서 떨어져 흩어져 있는 미니멀한 일러스트"
---

> 원문: <https://simonwillison.net/2026/Nov/10/muse-ember/>

---

메타 AI가 Claude Haiku와 GPT Luna 카테고리에 자사의 엔트리를 내놓았다: [Muse Ember](https://research.meta.ai/blog/muse-ember). 메타는 이 모델을 이렇게 설명한다.

> [...] 복잡한 추론 실행과 에이전트가 하루 종일 반복하는 작업을 위해 설계된, 우리의 가장 작고 효율적인 모델이다. 도구 호출, 코딩 하위작업, 라우팅, 추출, 긴 문서 파싱이 그 작업들이다.

짧은 프롬프트 기준 가격은 GPT-6 Luna와 Claude Haiku 5.5와 같다. 둘 다 입력 100만 토큰당 $0.10, 출력 $0.50이다. 오늘 함께 나온 다른 대형 모델 출시작인 Claude Fable 5.2는 그 80배 가격인 $8/$40이다.

다만 프롬프트가 길어지면 가격 구조가 단순하지 않다. Luna, Ember, Haiku 모두 최대 100만 입력 토큰을 지원하지만, 세 모델 모두 임계점을 넘으면 가격이 올라간다. 그 임계점까지 반영하면 Ember는 두 모델 사이 가격대에 놓인다.

| 모델 | 프롬프트 크기 | 입력 ($/M) | 캐시된 입력 | 출력 |
| --- | --- | --- | --- | --- |
| GPT-6 Luna | ≤272k | $0.10 | $0.01 | $0.50 |
| | >272k | $0.20 | $0.02 | $0.75 |
| Muse Ember 1.0 | ≤200k | $0.10 | $0.004 | $0.50 |
| | >200k | $0.30 | $0.012 | $1.50 |
| Claude Haiku 5.5 | ≤100k | $0.10 | $0.01 | $0.50 |
| | >100k | $0.50 | $0.05 | $2.50 |

그런데 요즘은 토큰당 가격 비교가 큰 의미가 없다. 추론 토큰 때문에 같은 문제를 모델마다 전혀 다른 토큰 수로 풀 수 있기 때문이다.

그 비교에 유용한 지표 중 하나가 Artificial Analysis다.

![Artificial Analysis가 여섯 모델의 비용(달러)을 낮은 순부터 높은 순까지 비교한 누적 막대 그래프. 각 막대는 라벨 없는 네 개 구간으로 나뉜다. Claude Haiku 5.5 (low)가 총 $0.04*로 가장 낮고, GPT-6 Luna (비추론) $0.07, GPT-6 Luna (xhigh) $0.10, Muse Ember (xhigh) $0.12, Muse Ember (max) $0.14, Claude Haiku 5.5 (xhigh) $0.25* 순이다. 막대는 Anthropic은 테라코타, OpenAI는 진회색, Meta는 파란색이며 로고가 아래 붙어 있다.](https://static.simonwillison.net/static/2026/artificial-analysis-haiku-class.webp)

그보다 더 유용한 건 Intelligence Index vs. Cost per Task 차트다. 세 모델은 이 차트에서 이렇게 나온다.

![Artificial Analysis의 "Intelligence Index vs. Cost per Task" 산점도. y축은 지능 지수(5~40), x축은 과업당 비용(로그 스케일, $0.04~$0.3)이고, 왼쪽 위에 초록 "가장 매력적인 사분면"과 점선 Pareto선이 있다. Claude Haiku 5.5 (low)*는 약 $0.044에서 19점, GPT-6 Luna (비추론)는 약 $0.07에서 9.5점, GPT-6 Luna (xhigh)는 약 $0.10에서 23.5점, Muse Ember (xhigh)는 약 $0.12에서 34점, Muse Ember (max)는 약 $0.14에서 36점으로 둘 다 Pareto선 위에 있다. Claude Haiku 5.5 (xhigh)*는 약 $0.25에서 34.5점으로 Pareto선에서 상당히 오른쪽으로 벗어나 있다. 라벨 없는 회색 점 세 개도 Pareto선 위에 있다.](https://static.simonwillison.net/static/2026/artificial-analysis-pareto.webp)

Muse Ember 모델들은 그 Pareto선 바로 위에 있다. 한 차원을 개선하려면 다른 차원을 포기해야 하는 선이다. 메타도 발표에서 이 점을 짚었다.

> Artificial Analysis 전체 리더보드의 효율성 최전선에도 위치한다. 더 적은 과업당 비용으로 더 높은 점수를 내는 모델은 없다.

(초록 영역 한가운데 Pareto선 위에 있는 그 회색 점은 GPT-6.1 Terra (low)다. Terra 계열을 더 주의 깊게 봐야겠다.)

Muse Ember에는 추론 수준이 여섯 개 있다. minimal, low, medium, high, xhigh, max. 그래서 나는 [여섯 마리 펠리컨이 자전거를 타는 그림](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2Fc7666e8a54d84f724ac8121f9fa6cc4d)을 렌더링해봤다. "high" 추론 수준은 완전한 SVG를 돌려주지 못했고, 나머지 SVG는 의외였다. 추론 수준이 응답의 시각적 품질에 깔끔하게 대응하지 않았기 때문이다.

"max" 결과는 다음과 같다. 나머지도 볼 만하다:

![자전거 프레임은 괜찮고, 바구니에 생선이 있으며, 펠리컨은 이상한 파란 모자를 쓰고 있다.](https://static.simonwillison.net/static/2026/muse-ember.webp)

Ember 펠리컨들은 내가 [Muse Wonder에서 받은 결과](https://tools.simonwillison.net/markdown-svg-renderer?url=https://gist.github.com/simonw/185cff7ff0b11379725abf7f78d5d2b2)와 품질이 비슷한데, Muse Wonder는 Muse Ember의 [40배 가격](https://www.llm-prices.com/#sel=muse-ember-1.0%2Cmuse-ember-1.0-200k%2Cmuse-wonder-1.0)이다.
