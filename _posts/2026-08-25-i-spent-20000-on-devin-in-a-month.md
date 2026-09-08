---
layout: post
title: "I spent $20,000 on Devin in a month. Here's what I learned"
date: 2026-08-25 09:00:00 +0900
author: CHO&AHN 큐레이션
lang: ko
categories: [curation]
description: "**Ryan Carson**은 5회 창업자이자 현재 Untangle의 솔로 파운더다. Untangle은 법률 회사(B2B SaaS)를 위한 이혼 케이스 관리 플랫폼이다. 전에는 Treehouse(온…"
source_url: "https://www.lennysnewsletter.com/p/i-spent-20000-on-devin-in-a-month"
source_author: "Ryan Carson 인터뷰 · Claire Vo 진행"
source_name: "Lenny's Podcast"
image: "/assets/images/curation/2026-08-25-hero.jpg"
image_alt: "A robot arm holding a credit card over burning dollar bills"
---

> **원문**: [I spent $20,000 on Devin in a month. Here's what I learned](https://www.lennysnewsletter.com/p/i-spent-20000-on-devin-in-a-month) — Ryan Carson 인터뷰 · Claire Vo 진행, Lenny's Podcast (2026-08-24)
> 이 글은 CHO&AHN이 AI 에이전트(Sam)를 활용해 한국어로 번역한 것입니다. 원문의 저작권은 원작자에게 있으며, 번역상의 오역·의역은 CHO&AHN에 귀속됩니다. 원문을 직접 읽어보시길 권합니다.

---


**Ryan Carson**은 5회 창업자이자 현재 Untangle의 솔로 파운더다. Untangle은 법률 회사(B2B SaaS)를 위한 이혼 케이스 관리 플랫폼이다. 전에는 Treehouse(온라인 코딩 교육)를 공동 창업했고, 거의 20년 동안 테크 회사를 만들고 이끌어왔다. 그는 X에서 자신의 솔로 파운더 여정, AI 툴에 실제로 얼마를 쓰는지까지 포함해, 을 실시간으로 공유하고 있다.

---

**1. Devin 폴더 시스템과 종이 한 장**

Ryan의 Devin 스택은 '폴더' 시스템으로 되어 있다. P0(버그), P1(큰 기능), P2(중요한 것들), Investors(투자자 업데이트)로 버켓팅된다. 핵심은 **P0 폴더**: 오늘 아무리 산만해져도 반드시 진전시켜야 할 일들이다.

그런데 결정적 도구는 따로 있다. **Dell 52인치 모니터 8개를 동시에 열어놓고도**, 그는 주간 우선순위가 적힌 **종이 한 장(Ugmonk 시스템)**을 책상에 두고 수시로 눈을 내리깐다. "이게 나를 접지시켜줘요(keeps me grounded)."

Claire가 반응한다: "너는 항상 '여기 내 3단계 에이전트 관리법이야' 하는데, 나는 그냥 토큰 속을 떠다니면서 나오는 걸 본다. 너는 Devin에 우선순위 정리된 폴더를 만들어두는데, 나는 그냥 Slack에 '야 이거 봤냐'고 DM 보낸다."

Ryan: "그것도 완전히 작동해요. 근데 중요한 건 지금 우리의 진짜 직업은 **에이전트를 관리하는 법을 익히는 것**이라는 점이에요. 조직을 피라미드 형태로 만든 이유가 인간은 스케일이 안 되고 1,000명을 직접 관리할 수 없기 때문이잖아요. 지금 우리는 정확히 그 스킬을 AI 에이전트에게 적용하고 있는 거예요."

→ **핵심**: 경력 내내 쌓아온 관리 스킬(구조화, 팀 구성, 우선순위, 위임, 마이크로매니지 vs 풀어주기)이 지금 AI 에이전트 시대에 그대로 통한다.

---

**2. Watchdog 플레이북, CS팀을 대체하는 에이전트**

Untangle이 여러 가정법률 사무실을 고객으로 확보하면서, Ryan은 혼자서 CS, 엔지니어링, 세일즈를 전부 해야 했다. 그의 해결책: **Watchdog 플레이북**.

각 펌(고객)마다 반복 실행되는 스킬이다. Devin이 각 고객 계정에 들어가서 "이 계정에 무슨 일이 있었나? 마지막 Watchdog 이후 어떤 활동이 있었나? Sentry 에러는 어디서 나나?"를 점검한다. 하지만 데이터만 던져주는 게 아니라 **상위 3개 문제를 추리고, 이미 고쳐졌는지, 수정 중인지, PR이 오픈된 채 머지 안 된 건지까지 추적**해서 알려준다. Ryan은 그 스레드로 들어가서 "자, 좀 더 파보자"고 말한다.

---

**3. LAN PR 스킬, QA팀 없이 하루 40개 PR 처리**

Ryan은 하루 약 40개 PR을 배포한다. 이걸 어떻게 QA 없이 처리할까?

LAN PR은 Devin 플레이북/스킬이다. Devin 에이전트가 PR을 완료했다고 보고하면, Ryan이 LAN PR을 트리거한다. 그럼 Devin이:
1) PR에 대해 **신선한 Devin 리뷰**를 실행한다 (Devin Review는 Devin 안의 실제 제품)
2) 최대 2회 루프, 모든 버그를 찾고, 모든 코멘트가 해결됐는지 확인
3) **비디오 워크스루를 자동 녹화**한다. Devin이 브라우저에서 직접 조작하며 테스트하고, 캡션과 통과/실패 테스트 목록을 보여준다
4) Ryan이 비디오를 보고 "승인, 랜딩하자"고 말하면 머지

Claire의 Merge Mommy 접근법과 비교된다:
- Merge Mommy: PR이 열리고 CI 통과(including BugBot) → Eve agent(Vercel에 배포)가 **5가지 위험도(blast radius, security 등)를 점수화** → 저위험은 자동 승인/머지, 중/고위험은 Slack에 알림
- Ryan의 LAN PR: 개념은 같지만 Devin의 비디오 워크스루 기능을 적극 활용

Ryan: "내가 직접 코드 팩토리를 만들려고 해봤는데 시간이 없었어요. Devin이 제공하는 built-in 비디오 워크스루가 정말 좋아요."

---

**4. 클라우드 에이전트 vs 로컬 에이전트, 용도 구분의 기술**

Ryan의 강력한 주장: "당신이 지금 로컬에서 엔지니어링을 하고 있다면, 눈을 뜨세요. 미래는 거의 100% 클라우드 에이전트입니다."

- **Devin(클라우드)**: 사람이 기계 앞에 앉아있지 않아도 PR을 보내고, 폰으로 확인 가능. 15개 스레드 동시 운영. 실제로 한 달 $20,000까지 썼음 (현재는 Cognition에서 크레딧 후원)
- **Codex(로컬)**: 복잡한 프론트엔드 UI처럼 시각적 판단과 hand-holding이 필요한 대형 피처에는 여전히 Codex가 unmatched. Latency가 낮고, Goal + sub-agent가 효과적.

Claire의 Codex 사용 패턴:
- 대형 피처(프론트+백엔드) → pair programming 모드
- 장기 리팩터, 헥텍트 작업
- 검증(verification)에 특히 강함: Goal + browser-use 조합으로 프론트엔드 E2E 검증
- "유저 스토리를 쓰고, Chrome으로 프리뷰 브랜치 열어서, 유저처럼 하나씩 돌면서 통과/실패 확인, 버그 발견하면 수정, 이게 제 Codex 사용법이에요"

---

**5. Claude Design → Markdown → Codex 기술 디자인 시스템**

두 사람 모두 동의: **Claude Design이 디자인 시스템 생성에서는 unmatched다.**

Ryan의 워크플로우:
1) Claude Design에서 디자인 시스템 생성 → DESIGN.md 다운로드
2) Codex에 "이 디자인 파일 + Figma 내용을 가져가서 실제 **기술적 디자인 시스템**을 만들어줘"
3) Codex가 모든 공유 컴포넌트를 빌드, 모노레포에 interlinking까지 완성
4) Figma 플러그인으로 디자인 토큰을 다시 Figma 컴포넌트로 가져옴

Claire: "한 번 DESIGN.md를 Codex에 임포트하고 나면, 정말 마법 같은 일이 일어나요."

---

**6. "더 많은 AI 아웃풋이 더 나은 제품을 만드는 게 아니다"**

이게 에피소드 전체에서 가장 중요한 테마. Claire의 관점:
- "저는 maximum token maxer라는 걸 사람들이 알지만, 실제로는 시장이 원하는 것보다 더 많이 배포하지 않으려고 해요. 아웃풋의 양이 품질의 배수가 되지 않는다는 걸 알거든요."
- "프론티어 모델이 무엇을 출시할지 아는 지능을 가질 날은 아직 수백만 광년 떨어져 있어요."
- "AI 지능이 마법처럼 시장을 창조하지 않습니다. AI 마켓을 제외하면, 갑자기 새로운 구매자가 솔루션을 찾아서 나타나지 않아요."

Ryan: "사람들이 의자에서 일어나서 실제 사람과 대화하는 걸 충분히 안 하고 있어요. 내가 Untangle의 PMF를 찾은 방법은, 잠재 고객에게 이메일을 보내고 Google Meet을 하고 대화한 거예요. 그게 1단계였어요. 근데 2단계는, 고객이 확보되자마자 '사무실에 가도 될까요?' 하는 거였어요. 그냥 앉아서 이야기하고 싶다고. 우리가 너무 많이 디지털 프로덕트를 만들 수 있게 된 나머지, 의자에서 일어나지를 않아요."

---

**7. Devin을 코딩 너머 비즈니스 전반에 활용하기**

Ryan: "사람들은 여전히 클라우드 코딩 에이전트를 '코딩 에이전트'로만 버케팅해요. 근데 Devin은 우리 회사의 **Deal Desk**를 돌리고 있어요. 견적(quoting), 커스텀 견적, 운영, 문서화, 고객 트라이어지... 당신의 코드베이스를 알고 코드를 쓸 수 있는 누군가가 있다면, 비즈니스의 어떤 문제든 해결할 수 있다고 생각해보세요. 그게 내가 background agent를 사용하는 방법이에요."

---

**8. 슬랙 vs Devin 스레드, 에이전트 시대의 커뮤니케이션**

Ryan은 Untangle에서 **Slack을 완전히 없애는 방향**으로 가고 있다:
- "앞으로 hire할 사람들은 Devin 안에서 multi-user interaction을 하게 할 거예요. 우리는 스레드에서 이야기해요. 그러면 '이 맥락이 에이전트에 있는 건가, Slack에 있는 건가, Google Docs에 있는 건가?' 하는 문제가 사라져요."
- Jack Dorsey의 Buzz 철학처럼: "일대일 채팅은 금지. 비공개 대화가 필요하면 전화할게."
- "Slack 문화를 없애야 해요, DM 문화, 비공개 채널 문화. 결과물로 이어지지 않는 불필요한 수다 문화."
- "모든 Slack 스레드는 작업으로 이어져야 해요. 근데 현실은 그렇지 않아요."

Claire의 반론: "난 내 에이전트들을 의인화(personify)하고 싶어. 솔로 파운더로서 동료들이 재미있어야 해. Devin을 Slack에서 쓰는 게 좀 더 재미있어."

---

**9. 전화 면접 없이 채용하기**

Ryan이 첫 번째 엔지니어를 채용하는 방법:
1) 트위터에 공고: "AI-forward한 엔지니어 구합니다. 당신의 전체 데스크탑을 녹화해서, 이미 존재하는 앱에 새 기능을 빌드하는全过程을 보여주세요."
2) 전화 면접, 미팅 없음. 인상 안 봄.
3) 비디오를 보고 "이 사람이 에이전트를 얼마나 잘 관리하는가"를 평가
4) 2차: Devin에 접근권을 주고 실제 기능을 빌드하게 함 (다시 비디오 녹화)
5) 마지막으로 한 번 만나서 이야기

Claire의 반응: "이건 말 그대로 에이전트를 고용하듯 인간을 고용하는 거예요. '우린 잘 맞을 거야, 믿어. 근데 진짜 중요한 건 네가 이 일을 어떻게 하는지 보는 거야', 이게 예전의 미친 채용 방식보다 훨씬 낫죠."

---

**10. 각자의 EA(Executive Assistant), Paulie vs Claude Code on Mac Mini**

- Ryan: **Paulie the OpenClaw**, 아직도 OpenClaw에 정착
- Claire: OpenClaw에서 최근에 **Claude Code + Mac Mini**로 이사 → "Codex UI가 너무 좋아서" → 근데 Codex로 Gmail 2,000개 읽지 않은 메일을 한 번에 처리하고 "인생이 바뀌었다"

---

**총평 요약:**
- 솔로 파운더의 현실은 AI로 다 해보려다가 결국 인간을 고용해야 하는 아이러니
- 두 사람이 가장 많은 시간을 할애해 이야기한 주제: "더 많은 AI 코드가 좋은 제품을 만들지 않는다", 의자에서 일어나서 고객과 대화하라
- 에이전트 시대의 핵심 스킬: **에이전트 관리 능력**
- 실제 Devin 운영: 폴더/P0/P1/P2 + 종이 한 장의 아날로그 시스템
- Watchdog + LAN PR + Merge Mommy = CS팀, QA팀 없이 운영하는 구체적 방법론
- Claude Design + Codex의 콜라보레이션이 현재 최강의 디자인→개발 파이프라인
