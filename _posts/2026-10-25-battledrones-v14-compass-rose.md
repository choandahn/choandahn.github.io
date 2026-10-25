---
layout: post
title: "battledrones v14: 컴퍼스 로즈, 4인용 맵 (번역)"
date: 2026-10-25 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "Simon Willison이 Battledrones에 4인 온라인 모드를 추가했다. 프롬프트 한 번으로 4방향 대칭 맵과 4인 WebSocket 멀티플레이가 붙었다."
source_url: "https://simonwillison.net/2026/Oct/24/battledrones/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
---

> 원문: <https://simonwillison.net/2026/Oct/24/battledrones/>

---

[릴리스](https://simonwillison.net/elsewhere/release/) · [battledrones v14: Compass Rose, 4인용 맵](https://github.com/simonw/battledrones/releases/tag/v14) · 모바일 웹 RTS

Battledrones에 4인 온라인 모드를 추가했다. 그전까지 맵들은 2인까지밖에 지원하지 않았다.

사용한 초기 프롬프트는 이렇다:

> `Add a new map for a four player battle - four way rotational symmetry, up to four AI players, works with the WebSocket non-audio based multiplayer mode so up to four human players can join (any spare slots use AI)`

Claude Opus 5.5가 "Compass Rose"라는 새 맵을 만들고, 그 맵에서 4인까지 플레이할 수 있도록 WebSocket 멀티플레이 네트워크 코드를 고쳤다. 플레이어는 공유 링크나 QR 코드로 참가한다.

![새 맵은 실제로 장미를 닮았다. cold and ice 바이옴을 쓰며, 보라색 로봇들이 맵 위에서 싸우고 있다.](https://raw.githubusercontent.com/simonw/battledrones/v14/progress-shots/v14/compass-rose.jpg)

새 팀은 보라와 초록 테마의 로봇이다. 기존의 파란 팀, 빨간 팀 디자인에 이어진다. 색은 [업데이트된 모델 브라우저](https://simonw.github.io/battledrones/models.html)에서 미리 볼 수 있다.

[Goliath Armada 뮤테이터를 켠 4방향 AI 전투 리플레이](https://simonw.github.io/battledrones/v14/?replay=https://gist.githubusercontent.com/simonw/faa550a002b25a78f1c88a64217786c1/raw/4ff9b03de71d757cd33eb5d1a0e388155b6c20e5/compass.json)도 올려두었다. 이 뮤테이터에서는 각 진영이 거대한 Goliath 기계 유닛 네 개로 시작한다.
