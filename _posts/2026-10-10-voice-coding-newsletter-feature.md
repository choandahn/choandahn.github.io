---
layout: post
title: "목소리로 블로그 기능 만들기 (번역)"
date: 2026-10-10 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "요리하면서 목소리만으로 코딩 에이전트를 구동해 블로그에 뉴스레터 아카이브 기능을 만든 후기."
source_url: "https://simonwillison.net/2026/Oct/9/built-using-my-voice/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
---

> 원문: https://simonwillison.net/2026/Oct/9/built-using-my-voice/

---

오늘 블로그에 새 기능을 하나 배포했다. 내가 보낸 뉴스레터 전체를 묶어 보여주는 [Newsletters](https://simonwillison.net/newsletters/) 페이지다. 주간 무료 서브스택과 월간 스폰서 전용 업데이트가 한 곳에서 정리된다. 특이한 점은 만든 방식이다. 거의 전부 목소리로 만들었다. 저녁을 지으면서 노트북에 두드려대며 대화한 것뿐이다.

#### Codex 음성 모드

ChatGPT 데스크톱 앱의 Codex 탭에서 음성 대화 모드를 썼다. 로컬 개발 환경을 붙여서 돌렸다.

![ChatGPT 앱의 세 개 열. 왼쪽 열은 최근 대화 목록, 가운데 열은 대화 기록으로 음성 모드를 뜨는 검은 덩어리로 표시한다, 오른쪽 열은 내 블로그의 로컬 개발 서버로 Newsletters 페이지가 보인다.](https://static.simonwillison.net/static/2026/codex-voice.webp)

로컬 [simonwillisonblog](https://github.com/simonw/simonwillisonblog) 체크아웃을 대상으로 세션을 열었다. 타이핑으로 이렇게 시작했다.

> `Start dev server and open in browser`

덕분에 작업 대상 사이트 미리보기가 열렸고, 나중에 새 페이지를 보여달라고 하면 진행 상황을 눈으로 확인할 수 있었다.

그다음 "Start new voice chat" 버튼을 눌렀다. 마이크 버튼이 아니라 그 오른쪽에 있는 버튼이다. 그리고 노트북을 주방에 두고 요리하면서 말로 작업을 이어갔다.

#### 컴퓨터와 말하기

만들고 싶은 건 처음부터 꽤 분명했고, 간단한 Django 기능이라 이 모델(이번엔 GPT-6 Astra High)이 해낼 수 있으리라 확신했다. 새 모델 하나, 마이그레이션 하나, 뷰 코드와 템플릿, 외부 소스에서 데이터를 넣어줄 임포트 함수 두 개 정도면 됐다.

Codex가 기록해둔 음성 대화 중 한 부분이다.

> Um, they do not. Um, this is going to be a new type of content. Um, it's not going to show up... Oh, hold on. Yeah, no- I do not want this to show up in my, um, tag pages and date archive pages and... Actually, no, I think... I don't want it on the tag pages. I don't want it on the, um, blog index page. But I think I do want it to show up on the date-based pages. You know, if you navigate to September the 19th, and I sent a newsletter on that page, I think I want that to show up. So... this is- so I think we probably need a new model. The other thing is that I want them searchable, uh the Substack ones are not searchable, because those are actually just copies of other s- on content on my blog. These monthly ones do contain unique content, and spe- and once they're... published, like once they're made public a month after they've gone out, I want them to show up on my search results.

말더듬과 말끝 흐림까지 그대로 남은 [전체 대화 기록](https://gist.github.com/simonw/a65a22204f6f7228cc59b4bc34d7c7c8)을 Gist에 올려두었다. 이렇게 말했는데도 모델은 뭘 만들어야 하는지 알아들었다.

요리가 끝날 때까지 반 시간 정도 이런 식으로 진행했다. 모델이 답하고 가끔 확인 질문을 던진 다음 코드를 고쳐나갔다.

#### 만들어진 것

목소리만으로 생각보다 많이 진행됐다.

- Django에서 임포트된 뉴스레터를 표현하는 새 모델과 마이그레이션, 그에 맞춘 Django Admin 설정
- 네 가지 임포트
  - 최근 서브스택 항목은 RSS로
  - 나머지 서브스택 항목은 문서화되지 않은 API로. GPT-6 Astra가 이 API를 알고 있었다(/api/v1/archive에 바로 시도했고), 페이징 방식을 검색으로 찾아내면서 Karen Spinner의 [이 글](https://wonderingaboutai.substack.com/p/i-connected-my-newsletter-archive)을 찾아냈다
  - 공개된 월간 뉴스레터 전부는 내 [simonw/monthly-newsletter-archive](https://github.com/simonw/monthly-newsletter-archive) GitHub 저장소에서
  - 가장 최근의 스폰서 전용 비공개 뉴스레터는 비공개 저장소에서
- 공개 아카이브 페이지 [/newsletters/](https://simonwillison.net/newsletters/)와 [/newsletters/2026/](https://simonwillison.net/newsletters/2026/)
- 뉴스레터가 날짜별·월별 아카이브 페이지에는 나오지만 태그 페이지나 홈페이지에는 나오지 않도록 하는 배치
- 주간 서브스택 뉴스레터는 서브스택으로 링크되고, 아카이브된 월간 뉴스레터는 자기 페이지를 가진다
- 사이트 검색 엔진과의 연동

거의 배포 가능한 상태까지 갔다. 문제는 임포트였다. Astra가 내 로컬 사본에서 데이터를 내보내 production에 넣어주는 방식을 제안했는데, 나는 다른 임포트 스크립트처럼 동작하길 원했다. 데이터 일부가 비공개 GitHub 저장소에 있어서 그러려면 새 API 키를 만들어야 했고, 그 작업은 키보드 앞에 앉아 있어야 가능했다.

#### 리뷰로 마무리

요리를 마치고 기능이 거의 완성됐다고 판단한 뒤 Codex에게 브랜치를 만들고 PR을 열도록 했다.

GitHub PR 인터페이스에서 코드를 리뷰했다. 거의 원하던 대로였는데, 임포트 스크립트 하나에서 subprocess로 Git을 호출하도록 짠 게 마음에 걸렸다. 임포트 중 하나는 비공개 Git 저장소에서 가져와야 해서 API 쪽이 낫겠다고 판단했다. 여기서부터는 타이핑으로 전환해 Codex에게 그 부분을 API 기반 임포트로 바꾸라고 했다.

리뷰 중에 고친 내용은 [PR의 추가 커밋](https://github.com/simonw/simonwillisonblog/pull/719)에서 볼 수 있다. 임포트 방식을 고치고 공개 페이지 표시를 몇 군데 다듬었다. 여기서 만족할 상태까지 가려면 타이핑 기반 프롬프팅이 반 시간 더 필요했다. 그러고 나서 PR을 머지하며 production에 배포했다.

#### 결과물

새 [뉴스레터 인덱스 페이지](https://simonwillison.net/newsletters/)에서 결과를 볼 수 있고, 지난 월간 뉴스레터 [개별 페이지](https://simonwillison.net/newsletters/monthly-2026-08-august/)도 있다.

![Newsletters 페이지. 썸네일이 달린 서브스택 글 두 개와 목차가 나열된 LLM digest 스폰서 전용 뉴스레터 하나가 보인다. 오른쪽에는 서브스택 구독 CTA와 월 10달러 월간 브리핑 뉴스레터 CTA가 있다.](https://static.simonwillison.net/static/2026/newsletters-page.webp)

인덱스 페이지는 최근 서브스택 주간 뉴스레터와 GitHub 스폰서 월간 뉴스레터를 최신순으로 섞어 보여준다. 그 아래로 연도별 아카이브 페이지 링크가 이어진다.

페이지는 GPT-6 Astra가 디자인했고, 주방에서 로컬 미리보기를 훑어보며 말한 피드백을 반영해 몇 번 고쳤다.

#### 일상 도구라기보다 멀티태스킹용

OpenAI는 [DevDay 같은 자리](https://simonwillison.net/2026/Sep/29/openai-devday-2026-live-blog/#live-update-504)에서 이런 음성 구동 데모를 즐겨 쓴다. 실제로 그런 환경에서는 잘 동작한다. 다만 내 일상 도구가 되지는 않을 것 같다.

예전에 산책하며 휴대폰 ChatGPT 음성 모드로 하는 "일"에 대해 쓴 적이 있다. 대부분 조사와 브레인스토밍이고, 가끔 ChatGPT가 코드 조각을 짜고 테스트하게 해 실제 개발 작업까지 하기도 했다.

이번엔 좀 다르다. 시각적 미리보기가 붙었고, 말로 전달하기 어려운 건 키보드로 타이핑하거나 붙여넣을 수 있어서 훨씬 강력한 코딩 에이전트 활용 방식이 됐다.

그래도 세부로 내려가면 타이핑으로 돌아온다. 예제나 에러 메시지를 붙여넣고, 고쳐야 할 코드나 기능을 직접 드러내 보이는 편이 말로 설명하는 것보다 여전히 효율적이다.

나는 주로 재택으로 일하는데, 이게 다행이다. 공유 오피스에서 컴퓨터에 이렇게 대화하며 일하고 싶은 사람은 없을 테니까.

결정적으로 좋았던 점은 멀티태스킹이다. 평소 요리할 때 팟캐스트나 틱톡을 틀어놓는데, 이제는 그 시간에 실제로 뭔가를 만들 수 있게 됐다.

Posted 9th October 2026 at 12:54 pm · Follow me on [Mastodon](https://fedi.simonwillison.net/@simon), [Bluesky](https://bsky.app/profile/simonwillison.net), [Twitter](https://twitter.com/simonw) or [subscribe to my newsletter](https://simonwillison.net/about/#subscribe)
