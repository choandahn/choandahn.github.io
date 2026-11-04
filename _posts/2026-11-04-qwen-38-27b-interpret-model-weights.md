---
layout: post
title: "내 노트북의 Qwen 3.8 27B도 모델 가중치를 해석할 수 있다 (번역)"
date: 2026-11-04 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "가중치만 보고 게임을 맞히는 실험을 노트북의 Qwen 3.8 27B로 직접 재현해 네 게임 중 셋을 맞혔다는 후기와 한계에 대한 평가."
source_url: "https://simonwillison.net/2026/Nov/3/qwen-can-interpret-model-weights/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
image: "/assets/images/curation/2026-11-04-hero.jpg"
image_alt: "수많은 숫자 덩어리가 놓인 벽을 들여다보는 사람의 실루엣과 구석에 작은 격자 게임"
---

> 원문: <https://simonwillison.net/2026/Nov/3/qwen-can-interpret-model-weights/>

---

어제 화제의 논문은 Rikiya Takehi, Jayden Teoh, Alex Zhang, Omar Khattab이 쓴 [Sparks of Weight-Space Programming: LLMs can natively read & write neural network weights](https://rikiyat.github.io/blog/weight-space-programming/)였다. 저자들은 이것을 "블로그 포스트"로 분류하지만 논문 형태를 하고 있다. 이 논문은 최전선 모델, 특히 GPT-6 Astra가 기계학습 모델의 날것 가중치를 해석하고 수정할 수 있음을 발견했다. 말 그대로 부동소수점 숫자가 잔뜩 들어 있는 모델의 텍스트 표현이다. 나는 논문의 예제 하나를 가지고 놀다가, 내 노트북에서 돌아가는 Qwen 3.8 27B도 이걸 해낼 수 있다는 사실을 알게 되었다. 기쁘게 공유한다.

#### Weight-Space Programming

초록에서 인상적인 부분을 옮기면 다음과 같다. GPT-6 Astra의 능력을 묘사하면서, LLM이 모델 가중치를 분석하고 수정하는 행위에 **Weight-Space Programming**이라는 이름을 붙인다:

> 가중치만 보고도 GPT-6 Astra는 **그 네트워크가 무엇을 하도록 학습됐는지 알 수 있다**. 환경 피드백 없이도 **처음부터 작은 게임 플레이 네트워크를 작성해서**, PPO로 1억 스텝 학습시킨 네트워크를 이길 수 있게 만들어 낸다.
>
> 마찬가지로 그래디언트 없이 Qwen3.5-0.8B의 수학 실력을 키우라고 하자, Astra는 **가중치에서 문제를 찾아낸다**. 그 추론 루프는 Qwen 자체의 [모델 카드](https://huggingface.co/Qwen/Qwen3.5-0.8B/blob/main/README.md#L856)가 경고하는 부분이었고, Astra는 **가중치의 0.016%를 직접 편집해서** 해결한다. 같은 샘플링 설정에서 이 가중치 교정은 MATH-500을 7.9%에서 48.1%로 끌어올리고, 별도의 작업 없이 instruction following으로 일반화되어 IFEval을 3배 올린다.
>
> 이 모든 것은 Astra에게 학습 루프 작성을 허용하지 않은 상태에서 가능하다. Astra는 추론으로 신경망의 각 부분이 무엇을 계산하는지, 무엇을 계산해야 하는지 파악하고 그에 맞게 가중치를 바꾼다. 우리는 이를 **Weight-Space Programming**이라고 부른다.

이 논문은 따로 다뤄야 할 두 주제를 한데 묶고 있다. 하나는 모델이 도구를 실행하거나 코드를 돌리지 **않은 상태에서** 날것 가중치로 무엇을 할 수 있는가다. 다른 하나는 코드를 쥐여준 모델이 다른 모델을 업데이트하고 개선하는 연산을 얼마나 잘 돌릴 수 있는가다.

spaCy 저자 Matthew Honnibal은 [두 가지가 뒤섞였다며 이 논문을 오해를 부른다고 평했다](https://honnibal.dev/blog/astra-read-write-misleading). Sean Goedecke는 [Qwen3.5-0.8B 업데이트 예제를 해체하면서](https://www.seangoedecke.com/llms-are-not-superhuman-at-reading-and-writing-neural-network-weights/) 인간 ML 연구자가 쓰는 것과 같은 절차를 밟는다고 보았다.

나는 도구 없이 하는 질문 쪽에 집중하려 한다. 둘 중 더 흥미로운 쪽이라고 생각하기 때문이다.

논문이 제시하는 첫 질문은 **LLM이 가중치만으로 모델의 행동을 이해할 수 있는가?**다. 저자들은 네 개의 신경망을 학습시켜, 클래식 게임 네 개인 Breakout, Pong, Pac-Man, Freeway를 단순화한 10x10 격자판 버전을 플레이하게 했다(Freeway는 [찾아봐야 했다](https://en.wikipedia.org/wiki/Freeway_(video_game)), 1981년 아타리 2600 게임이다). 그리고 그 가중치(부동소수점 숫자)를 LLM에 다음 질문과 함께 넣었다:

> `아래 가중치는 강화학습으로 학습되어 이 격자 위의 게임을 플레이하는 하나의 policy network에 속한다. 어떤 게임을 학습한 것인가? 가중치에서 출발하라. 도구는 없다. 코드 실행도, 계산기도, 돌릴 수 있는 것은 아무것도 없다. 응답은 한 번이다.`

논문과 함께 나온 GitHub 저장소는 [RikiyaT/lm_understand-logs](https://github.com/RikiyaT/lm_understand-logs)다. [exp1_which_game](https://github.com/RikiyaT/lm_understand-logs/tree/main/exp1_which_game) 폴더에 네 게임의 가중치가 담긴 프롬프트가 들어 있다:

- [breakout/prompt.txt](https://github.com/RikiyaT/lm_understand-logs/blob/main/exp1_which_game/runs/breakout/prompt.txt)
- [freeway/prompt.txt](https://github.com/RikiyaT/lm_understand-logs/blob/main/exp1_which_game/runs/freeway/prompt.txt)
- [pacman/prompt.txt](https://github.com/RikiyaT/lm_understand-logs/blob/main/exp1_which_game/runs/pacman/prompt.txt)
- [pong/prompt.txt](https://github.com/RikiyaT/lm_understand-logs/blob/main/exp1_which_game/runs/pong/prompt.txt)

가중치를 빼면 네 프롬프트가 서로 같다는 것도 확인했다.

#### Qwen 3.8 27B와 다른 모델로 해 보기

GitHub의 프롬프트는 그 자체로 완결적이다. 내 [LLM](https://llm.datasette.io/) 도구에는 텍스트 파일 URL을 프롬프트로 넘기는 `-f/--fragment` 옵션이 있어서, 위의 것을 이렇게 돌릴 수 있다:

```
llm -f https://raw.githubusercontent.com/RikiyaT/lm_understand-logs/refs/heads/main/exp1_which_game/runs/breakout/prompt.txt \
  -m openrouter/moonshotai/kimi-k3.1-pro
```

이 예제는 [llm-openrouter 플러그인](https://github.com/simonw/llm-openrouter)이 설치되어 있어야 하고, OpenRouter를 통해 Kimi K3.1 Pro에 Breakout 프롬프트를 던진다. [Kimi K3.1 Pro가 돌려준 답](https://gist.github.com/simonw/9f18d2945a105c04734ef7e5cd95717c)은 9분 41초, 19,493개의 추론 토큰 끝에 Breakout을 맞혔다.

그럼 [Qwen 3.8 27B](https://simonwillison.net/2026/Aug/16/qwen-38-27b/)는 어떤가? 여전히 내 노트북에서 돌리는 가장 좋아하는 모델이다. 겨우 17GB이고(나는 [이 버전](https://huggingface.co/lmstudio-community/Qwen3.8-27B-GGUF/blob/main/Qwen3.8-27B-Q4_K_M.gguf)을 쓴다), 무언가 2025년 최전선 proprietary 모델들에 가까운 느낌이 든다.

[LM Studio](https://lmstudio.ai/)를 켜서 Qwen 3.8 27B를 긴 컨텍스트 윈도우로 로드했다(기본 8192 컨텍스트는 에러로 실패했다). [llm-lmstudio](https://github.com/llm-lmstudio/llm-lmstudio) 플러그인을 설치하고 이 명령을 돌렸다:

```
LMSTUDIO_TIMEOUT=900 \
  llm -f https://raw.githubusercontent.com/RikiyaT/lm_understand-logs/refs/heads/main/exp1_which_game/runs/pacman/prompt.txt \
  -m lmstudio/qwen/qwen3.8-27b
```

(타임아웃을 환경 변수로 올려야 했다. [이 이슈](https://github.com/llm-lmstudio/llm-lmstudio/issues/16) 참고.)

46분 12초, 43,506개의 추론 토큰 끝에 내 노트북의 Qwen은 이렇게 끝나는 [응답](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F387d3a7927f165b1986bb6c2099d0f53#response-1)을 돌려줬다(추론 트레이스는 [여기](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F387d3a7927f165b1986bb6c2099d0f53#reasoning-1)):

> 게임: 단순화된 팩맨 스타일 그리드월드. 에이전트가 중앙과 모서리 벽 블록이 있는 고정된 8x8 미로를 움직이며, 움직이는 물체/유령과 보상 목표/알을 마주한다.
>
> 설명: 에이전트는 고정된 미로형 8x8 보드를 탐색하면서, 현재 에이전트/움직이는 물체/이전 프레임 단서를 이용해 복도를 통과하고 보상 목표 칸을 모으고, 움직이는 물체나 위험을 피한다.
>
> 신뢰도: 72%

인상적이다. 나머지 두 게임에도 돌려봤다. Pong은 [1시간 4분 54초 만에 맞혔다](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F387d3a7927f165b1986bb6c2099d0f53#response-2)([추론 트레이스](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F387d3a7927f165b1986bb6c2099d0f53#reasoning-2)):

> **Pong** — 정확히는 패들/공 게임으로, 에이전트가 오른쪽 세로 패들을 조작해 위아래로 움직이며 움직이는 공/보상 물체를 받아치거나 가로챈다.
>
> 설명:
>
> 에이전트는 8×8 필드를 가로지르는 공 모양의 보상 목표를 치거나 받아내기 위해 오른쪽 패들을 세로로 움직인다. 왼쪽의 움직이는 물체/상대와 벽 경계가 판을 이루고, 공을 성공적으로 가로채거나 받아치거나 득점하면 보상을 얻고, 놓치거나 치지 못하면 벌점을 받는다.
>
> 신뢰도:
>
> **75%**

Breakout은 [52분 25초 만에](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F387d3a7927f165b1986bb6c2099d0f53#response)([추론 트레이스](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F387d3a7927f165b1986bb6c2099d0f53#reasoning)):

> 게임: Breakout, 또는 Arkanoid 같은 패들/공/벽돌 게임.
>
> 설명: 에이전트는 맨 아래 줄의 패들이고 좌우로 움직여 공을 놓치지 않는다. 공은 위쪽 격자를 돌아다니고, 윗줄의 벽돌/보상 목표를 치면 보상을 주며, 공을 놓치거나 아래쪽 벽을 치면 에피소드가 끝나거나 벌점을 받는다.
>
> 신뢰도: 88%

Freeway 프롬프트에서는 실패했다. 다른 세 게임보다 낯선 게임이라 놀라지는 않았다. [그 트랜스크립트](https://tools.simonwillison.net/markdown-svg-renderer?url=https%3A%2F%2Fgist.github.com%2Fsimonw%2F6ed68f659e26a32e7d9096391d92f326)를 보면 Qwen은 "에이전트가 4방향으로 움직이는 단순화된 팩맨 스타일 격자 게임"이라고 생각했다.

추론 트레이스를 훑어보는 재미는 있지만 거의 알아볼 수 없다. 한 예:

> agent channel0는 어떤가? row8 col7/8 근처에 큰 channel0 행들이 보인다. 아마 맨 아래쪽에도? channel0가 큰 곳을 나열해 보자: line436 input435 (row8 col7 ch0) -2.107,1.169,0.513...; line441 input440 (row8 col8 ch0) -0.376,0.010,1.564,3.855...; line445 input444 (row8 col8 ch4) 0.142,0.491...; line382? input381 ch0? 아니다, line382 input381: 381//5=76 (row7 col6), ch1? 381%5=1? 76 * 5=380, ch1. 그러니 아니다. channel0가 큰 곳은 아마 row8 col7/8뿐이다. 맨 윗줄은? line44 input43 ch3, line49 ch3. channel0가 큰 곳은 많지 않은 모양이다. 에이전트 위치가 오른쪽 아래 근처인가? 에이전트가 보통 오른쪽 아래에 있다면?

그래도 충분히 경험이 많은 사람이 공책과 연필을 들고 있으면, 시간을 들여서는 도달할 수 있으리라고 본다.

멋진 논문이다. 하지만 그 주변에서 본 일부 얘기는 그만한 근거가 없어 보인다. 소스 코드의 시대가 끝났고, 앞으로는 알아볼 수 없는 기계들이 알아볼 수 없는 방식으로 자기 가중치를 고치는 미래가 온다고 선언할 준비는 아직 안 됐다.
