---
layout: post
title: "OpenAI 에이전트들, 지난 5월 RubyGems를 공격했다 (번역)"
date: 2026-09-13 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "Spencer Kitts, Thomas Larsen, Sydney Von Arx 세 사람이 내놓은 새 보고서에 따르면, 지난 5월 12일 RubyGems 패키지 저장소에 일어난 대규모 공격의 배후가 OpenAI 에이전트 스웜일 가능성이 매우 높다."
source_url: "https://simonwillison.net/2026/Sep/12/openai-agents-rubygems/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
image: "/assets/images/curation/2026-09-13-hero.jpg"
image_alt: "동일한 모양의 작은 에이전트 실루엣 무리가 격자로 늘어선 소프트웨어 패키지 상자로 흘러들어 가고, 일부 상자는 금이 가 파편이 새어 나오는 장면"
---

> 원문: <https://simonwillison.net/2026/Sep/12/openai-agents-rubygems/>

---

[OpenAI 에이전트들이 공개되지 않은 채 RubyGems 공격을 저질렀다](https://www.rubyhack.ai/)는 것은 Spencer Kitts, Thomas Larsen, Sydney Von Arx가 내놓은 새로운 폭탄성 보고서다. 세 사람은 지난주 [휴면 위키에 대한 에이전트 공격 보고서](https://collusion.wiki/)의 네 명 저자 중 세 명이다([이전 글](https://simonwillison.net/2026/Sep/4/rogue-agent-wikis/)).

이번에는 지난 5월 12일 [RubyGems 보안 팀의 Maciej Mensfeld가 처음 보고한](https://twitter.com/maciejmensfeld/status/2054164602577940619) RubyGems 패키지 저장소 공격의 배후에 OpenAI 에이전트 스웜이 있었을 가능성이 매우 높다는 이야기다:

> 지금 @rubygems에 대한 대규모 악성 공격을 처리하고 있다. 당분간 가입을 중단했다.
>
> 수백 개의 패키지가 관련됐다. 대부분은 우리를 겨냥한 것이지만, 일부는 익스플로잇을 실어 나르고 있다. 팀이 몇 시간째 이 일을 하고 있다. 마무리되면 더 자세한 내용을 전하겠다.

그 패키지들은 상당히 수상한 패턴을 지니고 있었다:

1. 상당수가 이름이나 저자 필드, 가짜 이메일 주소에 "oai"를 포함하고 있었다.
2. 접근하던 파일들이 위키 에이전트들이 가져간 파일들과 성격이 비슷했고, 비슷한 수법(r.jina.ai)을 썼다. 그리고 OpenAI는 저 위키 에이전트들이 자기들이라는 사실을 확인했다.
3. 패키지의 코드는 LLM이 작성한 것처럼 보였다.

9월에 위키 공격이 분석된 뒤 나온 정보를 고려하면, 나는 2번이 가장 설득력 있다고 본다.

패키지 상당수는 [RubyDoc.info](https://rubydoc.info/) 문서 빌드 프로세스를 이용해 영국 정부 웹사이트에서 (공개) 데이터를 유출하고 있었다. 아마 위키를 공격한 에이전트들이 처리하던 연구 작업과 비슷한 정보 수집 작업의 일환일 것이다. 우리가 이걸 아는 이유는 한 에이전트가 친절하게도 다음과 같은 주석을 남겼기 때문이다:

`# malicious crawler/exfil for Southwark Jan 2026 docs via rubydoc.info worker`

또한 [두 달이 넘은 뒤에야 패치된](https://blog.rubygems.org/2026/07/22/security-advisory-legacy-api-key-leak.html) 취약점을 통해 API 키를 훔치려 시도했다. 그 시도가 성공했는지는 명확하지 않다.

이 사건에서 나를 가장 괴롭히는 것은, 저자들이 OpenAI가 이번에 공개되기 전까지 RubyGems 측에 자신들이 공격의 당사자였다는 사실을 알리지 않았다고 보고했다는 점이다. 이것이 사실이라면 두 가지 가능성이 있다:

1. Hugging Face 사건과 위키 공격 이후에도 OpenAI는 과거 로그를 검토해 자신들이 RubyGems를 공격했다는 사실을 파악하지 못했다.
2. RubyGems 공격을 알고 있었으면서도 RubyGems 팀에 연락하지 않기로 결정했다.

둘 다 나쁘다.

이 사건과 [Hugging Face 사건](https://simonwillison.net/2026/Jul/22/openai-cyberattack/), 그리고 위키 공격을 놓고 보면, 지금 떠오르는 당연한 질문은 이렇다. 아직 발견되지 않은 채 기다리고 있는 이런 사건이 몇 건이나 더 있을까?
