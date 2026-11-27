---
layout: post
title: "sqlite3_rsync: SQLite 데이터베이스 원격 복사 도구 (번역)"
date: 2026-11-27 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "SSH 너머로 SQLite 스냅샷을 복사하는 sqlite3_rsync는 로컬에 전체 사본을 만들지 않고도 동기화할 수 있다."
source_url: "https://simonwillison.net/2026/Nov/26/sqlite3-rsync/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
image: "/assets/images/curation/2026-11-27-hero.jpg"
image_alt: "두 대의 기계를 잇는 선 위로 페이지 블록이 이동하는 최소주의 일러스트"
---

> 원문: <https://simonwillison.net/2026/Nov/26/sqlite3-rsync/>

---

[sqlite3_rsync: SQLite용 데이터베이스 원격 복사 도구](https://www.sqlite.org/rsync.html). 이 SQLite 부속 도구는 한동안 있었다. 2024년 10월 SQLite 3.47.0에서 "experimental"로 추가됐고, 2025년 5월 SQLite 3.50.0에서 기능이 보강됐다. 오늘에서야 이 도구의 가장 매력적인 특성 하나를 이해했다.

보통 SQLite 데이터베이스의 스냅샷 사본을 만들려면 backup API나 VACUUM INTO를 쓴다. 두 방식 모두 데이터베이스 사본을 담을 만큼의 디스크 공간이 필요하다. 작은 인스턴스에서 이미 가용 디스크의 절반 이상을 쓰고 있다면 방법이 없다.

`sqlite3_rsync`는 SSH 연결 너머의 다른 기계로 데이터베이스 스냅샷을 복사할 수 있다. 로컬에 전체 사본을 먼저 만들 필요가 없다.

기존 데이터베이스 사본을 네트워크로 전체를 다시 보내지 않고 동기화할 때도 유용하다. 일반 rsync와 비슷한 방식으로 동작한다:

> 프로토콜의 핵심 아이디어는 복제본이 페이지 또는 페이지 묶음의 암호학적 해시를 원본 쪽으로 보내는 것이다. 원본은 내용이 다른 페이지를 돌려보내거나, 여러 페이지 묶음의 해시가 맞지 않으면 더 잘게 나눈 해시를 요청한다. 원본과 복제본이 크게 다른 상태에서 시작하면 해시를 주고받는 부담 때문에 전송량이 데이터베이스 전체 크기를 넘을 수 있다. 그 초과분은 크지 않다. 많아야 몇 퍼센트다.

**덧붙임**: 하하. 2024년 10월 이 도구가 처음 나왔을 때 [이 sqlite_rsync 활용에 대해 쓴 적이 있었다](https://simonwillison.net/2024/Oct/4/sqlite-rsync/).
