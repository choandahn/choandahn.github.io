---
layout: post
title: "document.currentScript로 인라인 렌더링하기 (번역)"
date: 2026-10-19 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "document.currentScript로 자기 자신을 결과로 교체하는 인라인 스크립트 트릭과 실전 활용 예시를 옮긴 글이다."
source_url: "https://leanrada.com/notes/inline-rendering-currentscript/"
source_author: "Lean Rada"
source_name: "leanrada.com"
image: "/assets/images/curation/2026-10-19-hero.jpg"
image_alt: "웹페이지 격자 레이아웃 속에서 작은 블록이 자리를 바꿔 끼우는 추상 일러스트"
---

> 원문: <https://leanrada.com/notes/inline-rendering-currentscript/>

---

간단한 동적 콘텐츠를 빠르고 대충 렌더링할 일이라면, Handlebars 같은 템플릿 언어나 PHP 백엔드가 주는 복잡함이 필요 없을 수 있다.

예시 문구로 "와, 벌써 `<currentYear>`년이야"를 쓰자. 오늘 렌더링하면 "와, 벌써 2026년이야"가 되어야 한다.

이걸 HTML에 바로 쓸 수 있다. JS에 id, class, querySelector가 하나도 필요 없다. [`document.currentScript`](https://developer.mozilla.org/en-US/docs/Web/API/Document/currentScript) 프로퍼티 덕분이다. 지금 막 실행 중인 `<script>` 요소를 직접 가리킬 수 있고, 거기서부터 출발하면 된다.

그러니 "와, 벌써 2026년이야"라는 동적 문구는 이렇게 쓴다:

```
Come on, it's
<script>
  document.currentScript.replaceWith(new Date().getFullYear())
</script>
```

스크립트는 계산한 값으로 자기 자신을 그 자리에서 바꿔치기할 뿐이다.

코드가 좀 장황하긴 하다. `$=(...n)=>document.currentScript.replaceWith(...n)`처럼 상수 `$`에 별명을 붙이면 JS의 [템플릿 리터럴](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)을 연상시키는 형태가 된다.

```
Come on, it's <script>$(new Date().getFullYear())</script>
```

`$` 별명이 만드는 간접 참조 한 겹만 지나가면, 문맥 없이 봐도 코드가 꽤 읽기 쉽다.

*웹컴포넌트 버전 보기. 참고로 이건 농담이다.*

```js
class RenderJS extends HTMLElement {
  constructor() {
    super();
    const slot = document.createElement("slot") ;
    slot.addEventListener("slotchange", () => {
      const expr = slot.assignedNodes()[0].wholeText;
      const render = new Function("return [" + expr + "]");
      this.replaceWith(...render());
    });
    const shadowRoot = this.attachShadow({ mode: "open" });
    shadowRoot.appendChild(slot);
  }
}
```

이것이 `RenderJS` 커스텀 엘리먼트다. 하는 일은 하나다. 자기 내용을 JavaScript 코드로 취급해, 그 실행 결과로 자신을 교체한다.

쓰려면 먼저 태그 이름을 정해야 한다. 사랑받는 달러 기호 `$`는 쓸 수 없으니 그다음으로 좋은 것, 이모지 💲를 쓴다. 그런데 그것만으로는 부족하다. 태그 이름은 알파벳으로 시작해야 하고 하이픈을 포함해야 한다. 그래서 JavaScript를 뜻하는 `j-💲`라는 이름을 쓸 수밖에 없었다.

```
<script>customElements.define('j-💲', RenderJS);</script>
```

### 사용 예

```
I overslept by about <j-💲>Math.PI</j-💲> hours this morning.
```

> I overslept by about 3.141592653589793 hours this morning.

JS를 실행하지 않는 환경을 위한 [`noscript`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/noscript) 폴백도 곁들이면 좋다.

```
Come on, it's
<noscript>current year</noscript>
<script>$(new Date().getFullYear())</script>
```

마크업 안에서 script와 noscript가 나란히 놓이는 모습이 거의 Angular나 Vue의 if-else 마크업 같아서 깔끔하다.

기억으로는 [Surreal](https://github.com/gnat/surreal) 라이브러리나 그와 비슷한 것에서 이 기법을 배웠다. 하지만 새로운 발견은 아니다. 이 API들은 오래전부터 표준이었다.

## 실제 사용 예

이 기법이 현재 연도를 렌더링하는 용도로만 쓸모 있다고 생각한다면, 거의 맞다! 예를 들어 나는 살아있는 페이지에서 상대 날짜를 표기할 때 인라인 스크립트를 썼다. "2017년"보다 "9년 전"이 더 자연스럽게 들리기 때문이다.

```
It was planted
<noscript>in 2017</noscript>
<script>$(new Date().getFullYear()-2017, ' years ago')</script>
but now it has grown tall and strong.
```

> It was planted 9 years ago but now it has grown tall and strong.

### 무작위 인사

또 하나의 예는 내 첫 페이지다. 방문할 때마다 무작위로 고른 인사말을 보여준다.

![내 첫 페이지 인트로 섹션 스크린샷](https://leanrada.com/notes/inline-rendering-currentscript/greeting.png)

```
<span class="intro-line">
  <noscript>Hello!</noscript>
  <script>
    $([
      "Hello!",
      "Hey~~~",
      "What's up ↑",
      "Hi there →",
      "Hey there →",
    ][Date.now() % 5])
  </script>
</span>
```

무작위 추첨은 그냥 `Date.now()`에 모듈로를 취한 것이다. `Math.floor(Math.random() * 5)`보다 간결했기 때문이다.

### 애니메이션용 텍스트 분할

인라인 스크립트로 텍스트를 문자별로 쪼개 문자마다 마크업을 만들면, 그 문자들을 따로 제어하거나 애니메이션할 수 있다. 나는 원형 텍스트를 렌더링할 때 썼는데, 더 흔한 용례는 이런 식의 텍스트 애니메이션이다.

> It has been a **s** **u** **p** **e** **r** **c** **a** **l** **i** **f** **r** **a** **g** **i** **l** **i** **s** **t** **i** **c** **e** **x** **p** **i** **a** **l** **i** **d** **o** **c** **i** **o** **u** **s** week.

```
It has been a
<script>document.currentScript.outerHTML=
  "supercalifragilisticexpialidocious"
    .replace(/./g, c => `<strong>${c}</strong>`)
</script>
week.

<style>
  strong {
    display: inline-block;
    animation: wave 0.3s infinite alternate ease-in-out;
    &:nth-child(4n + 1) { animation-delay: -0.6s; }
    &:nth-child(4n + 2) { animation-delay: -0.45s; }
    &:nth-child(4n + 3) { animation-delay: -0.3s; }
    &:nth-child(4n + 4) { animation-delay: -0.15s; }
  }
  @keyframes wave {
    to { transform: translateY(-2px); }
  }
</style>
```

텍스트 분할 라이브러리를 굳이 import하겠는가?

### 메타데이터 렌더링으로 중복 줄이기

이 글의 제목 헤딩은 페이지 타이틀 메타데이터에서 동적으로 만든다. 이 글의 제목은 `<title>` 태그 한 곳에만 정의하면 된다.

```
<blog-header>
  <h1><script>$(document.title)</script></h1>
  <img src="hero.jpg" alt="" loading="lazy"></img>
</blog-header>
```

### 자동 갱신 푸터

법적 효력이 있을 수도 있고 없을 수도 있는(IANAL, 나는 변호사가 아니다) 푸터 저작권 문구를 자동으로 갱신되게 하는 건 어때?

```
<footer>
  © <script>$(new Date().getFullYear())</script> Mycorp, Ltd.
</footer>
```

비교를 위해 StackOverflow나 ChatGPT가 내놓는 답을 보자.

```
document
  .getElementById("copyright-year")
  .textContent = new Date().getFullYear();
```

```
<footer>
  © <span id="copyright-year"></span> Mycorp, Ltd.
</footer>
```

피할 수 있다면, 전역 ID 네임스페이스를 더럽히고 코드를 따로 떼어놓을 이유가 있을까?

``Date().split` `[3]``도 연도를 얻는 짧은(그러나 꽤 해키한) 방법이다.

여기쯤 와서 이렇게 물을 수 있다. 이 기법은 결국 현재 연도를 렌더링할 때만 정말 쓸모 있는 것 아닌가? 그럴 수도 있다. 하지만 텍스트를 *렌더링하는* 것 이상도 할 수 있다. 와, 벌써 10/18/2026이다. 웹은 풍부하고 인터랙티브하다!

### 만능 예제, 카운터 앱

이제 단순한 템플릿 예시 수준은 아니다. `currentScript`가 자기 완결적인 인터랙티브 HTML 조각을 [하이드레이션](https://en.wikipedia.org/wiki/Hydration_(web_development))하는 데 쓰이는 힘을 보여준다.

```
<div>
  Count: <span>0</span>
  <button>Increment</button>
  <button>Decrement</button>
  <script>
    const [span, increment, decrement] =
      document.currentScript.parentElement.children;
    let count = 0;
    increment.onclick = () => span.replaceChildren(++count);
    decrement.onclick = () => span.replaceChildren(--count);
  </script>
</div>
```

이 '로컬 스크립트' 패턴은 이 블로그의 이전 버전에서 늘 썼다. 긴 글 중간에 인터랙티브 삽화를 만들 때 유용하다. 그 로직을 파일 맨 끝이나 맨 앞처럼 해당 섹션에서 멀리 떨어진 곳에 두고 싶지는 않을 것이다. 스타일도 마찬가지다. [`@scope` 규칙](https://developer.chrome.com/docs/css-ui/at-scope#prelude-less_scope) 덕분에 이제 더 좋아졌다.

인터랙티브한 섬들을 관리하기 좋은 방법이다.

## 대가

사람들이 라이브러리와 프레임워크로 기우는 데는 이유가 있다. 너무 편리하기 때문이다.

위의 별명 정의, 즉 `$` 숏핸드를 쓰려면 HTML 최상단에서 **동기적으로** 먼저 정의해야 한다. 여러 페이지에서 쓰려고 공용 스크립트 파일에 넣고 `<script src="$.js"></script>`로 로드하면, 파서와 렌더를 막는 fetch가 생길 수 있다. 성능에 잠재적으로 아주 나쁘다!

내 경우에는 별명을 쓰지 않는다. `document.currentScript.replaceWith`를 그냥 바로 쓴다. 조금만 더 짧았으면 좋겠다만…

~~또한 이 방식으로는 데이터 기반 템플릿팅을 할 수 없었다. 데이터를 **템플릿**에 적용한다는 의미에서 말이다. 어딘가의 posts 테이블이나 frontmatter에 저장된 발행일, 글 제목, 태그 같은 메타데이터는 인라인 스크립팅에 쓸 수 없다. 인라인 스크립트는 데이터를 fetch할 수 없다. 따라서 데이터가 전역 스코프에 미리 주입되지 않는 한 순수 바닐라 JS 템플릿팅으로는 방법이 없다. [Liquid](https://shopify.github.io/liquid/) 같은 템플릿 언어가 빛나는 지점이 바로 여기다.~~

## 업데이트: 데이터 기반 템플릿팅

앞에서 이 방식으로는 데이터 기반 템플릿팅을 할 수 없다고 했다(위에서 취소선을 친 절). 그런데 좋은 독자가 방법을 찾아냈다(고마워, Amier)!

필요한 것은 `currentScript`를 변수에 저장해 두는 것뿐이다. 그러면 어떤 비동기 작업에서든 그것을 참조할 수 있다!

코드는 여기 있다: [jsfiddle](https://jsfiddle.net/0xh2mg8f/).

```
<ul class="posts">
  <script>
    const script = document.currentScript;
    fetch("/posts.json")
      .then(response => response.json())
      .then(data => data.map(p => (
        `<li><a href="${p.url}">${p.title}</a></li>`
      )).join(""))
      .then(html => script.outerHTML = html);
  </script>
</ul>
```

**주의:** `innerHTML`이나 `outerHTML`을 쓴다면 HTML을 먼저 sanitize하라. 특히 외부에서 가져온 경우라면!

다만 백엔드 쪽 템플릿 시스템과 달리, 클라이언트에서 HTTP 요청이 하나 더 발생한다.

내 사이트에는 템플릿 시스템이 필요 없다. HTML을 데이터로 직접 패치한다(소스 파일과 출력 파일이 같은 방식이다).

템플릿 프레임워크나 정적 사이트 생성기를 쓰더라도, 인라인 스크립트는 여전히 쓸모 있다!

## 더 읽기

- [Surreal](https://github.com/gnat/surreal): 이 기법과 여러 jQuery 스타일 헬퍼를 제공하는 라이브러리. 단, 동기 script 태그 로딩 문제는 주의할 것!
- [SvelteKit의 currentScript 논의](https://github.com/sveltejs/kit/issues/2221): 자기 하이드레이션에 전역 ID 대신 쓸 수 있는지에 대한 논의. 결국 생성된 ID로 갔다. :|

## 부록

[`document.write()`](https://developer.mozilla.org/en-US/docs/Web/API/Document/write)는 예전에는(?) 인라인 렌더링용으로 이런 식으로 동작했다. 동작이 일관되지 않아서 이제는 폐기됐다.

```
Come on, it's
<script>document.write(new Date().getFullYear())</script>,
stop using <code>document.write</code>!
```

> Come on, it's 2026, stop using `document.write`!
