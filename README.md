# Cho&Ahn

PG/HN 스타일 하이퍼텍스트 블로그. Jekyll + GitHub Pages.

## 구조

```
choandahn-site/
├── _config.yml          # 사이트 설정
├── _layouts/
│   ├── default.html     # 공통 셸 (헤더, 푸터)
│   └── post.html        # 에세이 개별 페이지
├── _posts/              # 에세이 마크다운 파일
│   └── YYYY-MM-DD-slug.md
├── assets/
│   └── style.css        # 전체 스타일 (~200줄)
├── index.html           # 홈
├── essays.html          # 에세이 목록 (/essays/)
├── about.html           # 소개 (/about/)
├── feed.xml             # RSS
├── Gemfile              # (로컬 미리보기용)
└── .gitignore
```

## GitHub Pages 배포

### 1. 리포지토리 생성

두 가지 옵션:

**옵션 A — User site (권장, 주소가 가장 깔끔)**
- 리포 이름을 **`choandahn.github.io`** 로 생성
- 배포 주소: `https://choandahn.github.io`

**옵션 B — Project site**
- 아무 이름 (예: `website`)
- `_config.yml`의 `baseurl: ""`을 `baseurl: "/website"`로 변경
- 배포 주소: `https://choandahn.github.io/website`

### 2. Push

```bash
cd choandahn-site
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/choandahn/choandahn.github.io.git
git push -u origin main
```

### 3. Pages 활성화

GitHub 리포 → **Settings → Pages** → Source를 `Deploy from a branch`, Branch를 `main` / `/ (root)`로 설정.

1–2분 뒤 배포됨. Actions 탭에서 빌드 상태 확인 가능.

### 4. 커스텀 도메인 (choandahn.com)

1. 리포 루트에 `CNAME` 파일 추가:
   ```
   choandahn.com
   ```
2. 도메인 DNS에 아래 레코드 추가:
   ```
   A    @    185.199.108.153
   A    @    185.199.109.153
   A    @    185.199.110.153
   A    @    185.199.111.153
   CNAME www  choandahn.github.io
   ```
3. Settings → Pages → Custom domain에 `choandahn.com` 입력, `Enforce HTTPS` 체크.
4. `_config.yml`의 `url:`도 `https://choandahn.com`으로 변경.

---

## 로컬 미리보기

```bash
# Ruby 3.x 필요 (macOS는 rbenv 권장)
bundle install
bundle exec jekyll serve
# → http://localhost:4000
```

변경사항은 자동 리빌드됨. `_config.yml` 수정 시에만 재시작 필요.

---

## 에세이 쓰기

`_posts/` 아래에 `YYYY-MM-DD-slug.md` 형식 파일 생성:

```markdown
---
layout: post
title: "제목"
date: 2026-04-20
author: 운장
description: 검색/SNS 미리보기용 짧은 설명.
---

여기부터 본문. 일반 마크다운.

## 섹션

- 리스트
- `코드 인라인`
- [링크](https://example.com)

```python
def hello():
    print("코드 블록")
```

> 인용문.
```

### 작성 팁 (PG 스타일)

- **문단은 짧게.** 3–5줄 넘기지 않기.
- **소제목은 drop.** 필요한 곳에만. 자주 쓰면 밀도가 떨어짐.
- **링크를 많이.** 외부 참조, 자기 글 상호 참조.
- **이미지는 최소.** 글이 주인공.
- **인용은 아끼기.** 진짜 필요할 때만 `>`.

---

## 커스터마이징 포인트

- **브랜드 색**: `assets/style.css`의 `#ff6600` (HN 오렌지). `#c99` 같은 톤으로 바꾸면 느낌이 확 달라짐.
- **본문 폭**: `body { max-width: 600px }` 조정. PG는 550–600px, HN은 ~800px.
- **폰트**: Verdana를 Georgia(세리프)로 바꾸면 더 "에세이"스러움. `font-family: Georgia, "Noto Serif KR", serif`.
- **링크 색**: `#0000ee`가 정통 브라우저 기본. 취향에 따라 `#003399` (덜 쨍하게) 또는 `#ff6600` (HN 통일) 가능.
- **헤더 링크 추가**: `_layouts/default.html`에서 nav 항목 추가.

---

## 추가하면 좋을 것들

우선순위 낮지만 필요하면:

- [ ] `sitemap.xml` (jekyll-sitemap gem 이미 Gemfile에 포함)
- [ ] OG 이미지 메타 태그 (SNS 공유용)
- [ ] 다크 모드 (`@media (prefers-color-scheme: dark)`)
- [ ] 태그 페이지 (Jekyll collections or manual)
- [ ] 검색 (lunr.js — JS 쓰면 PG 철학 위배, 권장 안 함)
- [ ] 댓글 (utterances — GitHub Issues 기반, 깔끔함)
