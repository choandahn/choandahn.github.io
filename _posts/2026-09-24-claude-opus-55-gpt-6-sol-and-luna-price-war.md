---
layout: post
title: "클로드 Opus 5.5, GPT-6 Sol, GPT-6 Luna, 그리고 새로 시작된 가격전 (번역)"
date: 2026-09-24 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "Anthropic이 Opus 5.5를 내놓고 한 시간 뒤 OpenAI가 GPT-6 Sol과 Luna를 출시하며 가격전이 시작됐다. GPT-6 Luna는 GPT-5.6 대비 절반 가격이다."
source_url: "https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
image: "/assets/images/curation/2026-09-24-hero.jpg"
image_alt: "하락하는 계단 모양으로 내려앉은 서로 다른 크기의 기하학적 블록, 가장 앞에 작지만 눈에 띄는 블록"
---

> 원문: <https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/>

---

![하락하는 계단 모양으로 내려앉은 서로 다른 크기의 기하학적 블록, 가장 앞에 작지만 눈에 띄는 블록](/assets/images/curation/2026-09-24-hero.jpg)

어제는 [Grok 4.7](https://x.ai/news/grok-4-7)([펠리컨](https://news.ycombinator.com/item?id=49788838#49790209))과 [MiMo v2.6 Flash/Pro](https://mimo.xiaomi.com/mimo-v2-6)([펠리컨 더 보기](https://news.ycombinator.com/item?id=49792730#49793480))였다. 오늘 Anthropic이 [Claude Opus 5.5를 출시](https://www.anthropic.com/claude-opus-5-5)했고, 한 시간쯤 뒤 OpenAI가 [GPT-6 Sol과 GPT-6 Luna를 출시](https://openai.com/index/introducing-gpt-6-sol-and-luna/)했다. 이 새 모델들을 제대로 파악하려면 시간이 좀 걸리겠지만, 지금까지의 인상을 적어본다.

#### GPT-6 Sol과 Luna는 GPT-5.6 동급 모델의 절반 가격이다

GPT-5.6 Luna는 이미 내가 애플리케이션을 만들 때 가장 선호하는 모델이었다. 성능이 뛰어난 데다 _정말 저렴했기_ 때문이다. 그런데 GPT-6 Luna는 그 가격마저 반으로 줄었다. GPT-6 Sol도 GPT-5.6 Sol에 비해 비슷한 폭으로 내려갔다.

오늘 기준 가격 구조는 이렇다:

| 모델 | 입력 | 캐시된 입력 | 출력 |
| --- | --- | --- | --- |
| GPT-6 Luna | $0.10/M | $0.01/M | $0.50/M |
| GPT-5.6 Luna | $0.20/M | $0.02/M | $1.20/M |
| Grok 4.7 | $2/M | $0.50/M | $6/M |
| GPT-6 Sol | $2/M | $0.20/M | $10/M |
| GPT-5.6 Terra | $2/M | $0.20/M | $12/M |
| Claude Opus 5.5 | $4/M | $0.20/M | $20/M |
| GPT-5.6 Sol | $4/M | $0.40/M | $20/M |
| Claude Fable 5.1 | $10/M | $0.25/M | $50/M |
| GPT-6 Astra | $10/M | $1/M | $50/M |

GPT-5.6은 11월에 예정된 25% 인상이 있으니, GPT-6는 그 모델들의 할인 적용 가격의 절반이기도 하다.

(GPT-5.6 Terra가 GPT-6 Sol과 같은 가격으로 책정된 시점에, Terra를 쓸 이유는 남아 있지 않게 됐다.)

이 가격 경쟁력이 얼마나 치열한지 과장하기 어렵다. Grok 4.7은 $2/$6로 GPT-5.6 Sol의 절반 이하 가격으로 나섰지만, 이제 GPT-6 Sol과 입력 가격은 같고 출력 가격도 비슷해졌다.

$0.10/$0.50의 GPT-6 Luna는 OpenAI가 내놓은 가장 저렴한 모델 중 하나다. 이보다 싼 건 훨씬 약한 GPT-4.1 Nano($0.10/$0.40, 2025년 4월)와 GPT-5 Nano($0.05/$0.40, 2025년 8월)뿐이다.

[GPT-6 Luna로 펠리컨](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F40d129fc140faca378b9c9f4f16c6ec2)과 [GPT-6 Sol로 펠리컨](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2Fbe7ae25af2634b68bc34b7b7aaf02cb2)을 렌더링해 봤고, GPT-5.6 펠리컨들과 함께 [이 비교 그리드](https://static.simonwillison.net/static/2026/gpt-pelicans-grid.html)로 합쳤다. 5.6 계열은 더 진하고 선명한 색을 골랐고 6 계열은 훨씬 차분한 색을 쓴다는 걸 바로 알 수 있는 게 마음에 든다. GPT-6 Astra max가 여전히 가장 좋은 펠리컨을 만들어냈다고 본다.

![여섯 GPT 모델과 각기 다른 사고 수준별 펠리컨 그리드.](https://static.simonwillison.net/static/2026/gpt-pelicans-grid.webp)

#### Claude Opus 5.5도 가격을 인하했다

Opus 5.5는 사람들이 Opus의 커뮤니케이션 스타일에 대해 가장 크게 불평했던 부분을 개선한 것으로 보인다. [Thariq Shihipar](https://twitter.com/trq212/status/2102437686967738431)가 말했다:

> Opus 5.5는 여러분의 피드백의 결과물입니다.
>
> 명확하게 소통하고, 토큰당 가격은 Opus 5.0보다 싸면서 Fable 5.1의 지능을 갖췄습니다. 토큰 효율이 좋고 모든 effort 레벨에서 작동합니다.

[Blender에서도 더 나아졌다](https://twitter.com/alexalbert__/status/2102466523164274839)고 한다. 직접 시험해 볼 예정이다.

Opus 4.5, 4.6, 4.7, 4.8, 5는 같은 가격이었다. 입력 백만 토큰에 $5, 출력에 $25. 5.5는 20% 인하한 $4/$20이다.

캐시 읽기 가격은 60% 내렸다. 이게 중요한 이유는 긴 에이전트 대화에서 입력 토큰의 90% 이상이 캐시 가격으로 처리되기 때문이다.

Opus 5.5의 새 가격은 GPT-5.6 Sol과 같은데, 그건 OpenAI가 Sol 가격을 절반으로 내리기 전 기준이다.

GPT-6 Astra와 Claude Fable 5.1은 모두 입력 백만 토큰 $10, 출력 $50다. 이번 가격전의 영향은 그 아래 단계 모델들에 해당한다.

Anthropic은 Sonnet 5.5와 Haiku 5.5가 곧 온다고 밝혔다. 현재 Haiku 4.5가 $1/$5인데 최신 GPT-6 Luna는 그 가격의 1/10인 $0.10/$0.50이니, Haiku가 하위 가격대에서 경쟁력을 되찾을 수 있을지 지켜볼 만하다.

#### Claude Opus 5.5 max는 과도하게 생각하다가 깨진다

"[자전거 타는 펠리컨 SVG 만들기](https://simonwillison.net/tags/pelican-riding-a-bicycle/)" 테스트에서 처음 있는 일이 벌어졌다. Claude Opus 5.5가 "max" 사고 수준에서 응답 자체를 돌려주지 못한 것이다.

이 테스트를 "클래식한 테스트 요청"이라 부르더니, 자기가 하고 있는 일에 대해 정말로, _정말로_ 깊게 생각하기 시작했다:

> 클래식한 테스트 요청이니, 특유의 부리와 주머니를 갖춘 잘 구성된 펠리컨이 알맞은 바퀴, 프레임, 페달을 갖춘 자전거에 타 있고 단순한 하늘과 바닥 배경이 뒤에 있는 구도를 계획하고 싶다. [...]
>
> 정강이 길이가 대략 95.2로 맞는지 검증했다. 이제 고관절에서 무릎, 발목으로 이어지는 먼 쪽 다리 경로를 잡고, 페달 위에 자연스럽게 놓이도록 선과 곡선으로 발 모양 스케치를 하고 있다. y=478-494 부근의 페달 표면 기준이다. [...]
>
> 바구니에서 튀어 나온 물고기를 펠리컨이 내려다보는 디테일이 마음에 들어서 살려두기로 했다. 부리 밑동 근처 눈 위치가 전형적인 펠리컨 해부학과 맞는지도 확인 중이고, 표정을 조금 더 즐거워 보이게 할지도 고민한다. [...]
>
> 먼 쪽 다리가 프레임 뒤를 지나간다고 읽히니, 체인링 톱니를 확인하고 레이어 순서를 점검하자. 먼 쪽 크랭크암은 시트 튜브와 체인링에 대부분 가려져야 한다. SVG의 width와 height 속성과 viewBox를 함께 정해 스케일링이 맞도록 하고 있다. 텍스트가 없으니 font-family는 필요 없다. [...]

이 펠리컨을 보고 얼마나 기대했는지 모른다. 그런데 [멈췄다](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F61fd7c3683fffce9a3ab7c43d1180024#response-4). Opus 5.5의 최대 출력 토큰 한도는 128,000이고(다른 Claude 모델도 마찬가지다), SVG에 대해 아직 추론 중이던 그 한도에 걸렸다.

두 번째 시도에서 같은 결과가 나왔다. 이 때문에 "max"는 사실상 쓸모가 없다고 의심한다. 자잘한 SVG 프롬프트에서 한계를 넘어 과하게 생각하는 모델이, 더 복잡한 작업에서 그러지 않으리라 믿기 어렵다.

(이 두 번의 실패 각각에 [$2.56](https://www.llm-prices.com/#it=27&ot=128000&sel=claude-opus-5-5)을 썼고, 거의 20분씩 걸렸다.)

Fable 5.1은 "max"에서 과하게 생각하지 않았고, 지금까지 어떤 Anthropic 모델보다 [가장 좋은 펠리컨](https://simonwillison.net/2026/Sep/1/claude-fable-5-1/#max)을 내줬다.

[Opus 5.5 펠리컨들](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F61fd7c3683fffce9a3ab7c43d1180024)은 max를 제외하고 아래에서 볼 수 있다.

이 모델들을 Opus 5, Fable 5.1, Sonnet 5와 함께 비교하는 [비교 그리드](https://static.simonwillison.net/static/2026/claude-pelicans-grid.html)도 만들었다.

![네 Claude 모델과 각기 다른 사고 수준별 펠리컨 그리드.](https://static.simonwillison.net/static/2026/claude-pelicans-grid.webp)

자전거 타는 펠리컨을 얼마나 잘 그리는지로 모델 벤더를 비교하는 게 지금도 의미가 있었는지는 모르겠지만, 같은 모델 계열의 서로 다른 추론 수준을 비교하는 데에는 여전히 쓸모를 찾고 있다.

이제 Codex에는 GPT-6 Sol을, Claude Code에는 Claude Opus 5.5를 기본 모델로 쓴다. [agent.datasette.io](https://agent.datasette.io/)의 Datasette Agent 데모도 GPT-6 Luna로 올렸는데, SQL 쿼리와 [Datasette Apps](https://simonwillison.net/2026/Jun/18/datasette-apps/)용 HTML·JavaScript 생성 모두에서 빠르고 유능했다.

*2026년 9월 22일 오후 11시 46분에 게시됨.*
