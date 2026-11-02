---
layout: post
title: "우리는 어떻게 ChatGPT 계정을 탈취했나 (번역)"
date: 2026-11-02 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "ChatGPT 공유 링크 하나로 다른 사용자의 로그인 세션에서 코드를 실행해 계정을 탈취한 공격 체인의 전 과정을 정리했다."
source_url: "https://simonwillison.net/2026/Oct/31/how-we-took-over-chatgpt-accounts/"
source_author: "Mukul Goyal"
source_name: "Parameter"
image: "/assets/images/curation/2026-11-02-hero.jpg"
image_alt: "무거운 벽의 좁은 우편함 틈으로 빠져나가는 사슬의 초상 일러스트"
---

> 원문: https://simonwillison.net/2026/Oct/31/how-we-took-over-chatgpt-accounts/

---

2026년 10월, 우리는 평범한 ChatGPT 공개 공유를, 링크를 연 사람의 로그인 세션 안에서 공격자가 제어하는 JavaScript로 바꾸는 방법을 찾았다.

공격자는 악성 대화를 만들고 ChatGPT의 평범한 공유 기능으로 게시한 뒤 다른 사용자에게 링크를 보내면 된다. 피해자가 공유를 열면 페이로드가 `chatgpt.com`의 신원으로 실행되고, 피해자의 인증된 웹 세션에 접근할 수 있었다.

우리는 이 코드가 피해자의 대화 목록을 열거하고, 공격자에게 공유된 적 없는 비공개 대화의 내용을 가져오고, 그 데이터를 외부 서버로 보낼 수 있음을 확인했다. 페이로드는 페이지를 고치거나 경고창을 띄우는 데 그치지 않았다. 피해자의 신원으로 ChatGPT의 인증된 API를 직접 호출할 수 있었고, 사실상 피해자의 ChatGPT 계정을 탈취할 수 있었다.

피해자는 앱을 설치하거나, Project에 참여하거나, 코드를 붙여넣거나, 개발자 도구를 열 필요가 없었다. 공유 링크를 여는 것만이 유일한 요구 동작이었다.

OpenAI는 10월 26일에 문제를 수정했고, 보고서를 P1으로 분류했다.

체인은 각각 따로 보면 무해해 보이는 두 기능, 그래프와 HTML 프리뷰에서 시작됐다.

```
flowchart TD
  A["공격자가 ChatGPT 대화를 게시한다"] --> B["피해자가 공개 공유를 연다"]
  B --> C["HTML 프리뷰가 메인 chatgpt.com 페이지로 넘어간다"]
  C --> D["JavaScript가 피해자의 로그인 세션에서 실행된다"]
  D --> E["피해자 명의로 chatgpt.com에서 가능한 모든 동작:<br/>비공개 대화와 파일 읽기, 계정 변경"]
```

## 기술 워크스루

### 그래프와 프리뷰에서 시작됐다

이 연구를 시작하게 한 질문은 단순했다. 프리뷰 코드가 다른 웹사이트에 가둬져 있다면, 그래도 무엇과 통신할 수 있을까?

ChatGPT는 HTML 코드 블록을 프리뷰 기능으로 작동하는 작은 웹페이지로 바꿔준다. 그 페이지에는 임의의 코드가 들어갈 수 있으므로 ChatGPT는 다른 웹 주소의 제한된 프레임 안에서 실행한다. 프리뷰는 JavaScript를 실행할 수 있지만 브라우저는 그것을 별개의 웹사이트로 취급하므로, 주변의 로그인된 ChatGPT 페이지를 직접 들여다볼 수 없다.

처음에 이 격리는 의도대로 동작하는 것처럼 보였다. 프리뷰 안의 코드는 메인 ChatGPT 페이지인 `parent.document`를 읽을 수 없었다. 여기서 끝났어야 했다.

그런데 대화에는 평범한 인터랙티브 그래프도 있었다. 그래프는 내부적으로 MathLive라는 수학 라이브러리를 로드했다. 로드는 그래프를 그리는 데서 끝나지 않았다. 메인 ChatGPT 페이지에 MathLive의 화면 키보드 관련 메시지를 받는 리스너를 설치했다.

브라우저는 이 API를 `postMessage`라고 부른다. 브라우저가 서로의 페이지를 읽지 못하게 막아놔도 두 프레임이 정보를 주고받을 수 있는 정당한 방법이다. 우편함이라고 생각하면 된다. 제한된 프리뷰는 메인 페이지에 들어갈 수 없지만 슬롯에 메시지를 넣을 수는 있다.

이것이 안전하려면 수신자가 누가 보냈는지 확인해야 한다.

MathLive는 우리가 주목한 설정에 대해 그 확인을 하지 않았다. 리스너는 가상 키보드 레이아웃을 바꾸는 메시지를 받아들였고, 그 레이아웃에는 HTML이 들어갈 수 있었다. 그래프가 수신자를 설치했고, 프리뷰가 신뢰할 수 없는 송신자를 제공했다. 관련 없는 두 기능이 우연히 샌드박스를 가로지르는 경로를 만들어낸 것이다.

### 동작해서는 안 됐던 메시지

프리뷰는 두 메시지를 보냈다. 첫 번째는 가상 키보드 레이아웃을 우리의 HTML로 교체했다. 두 번째는 MathLive에게 키보드를 보이라고 명령해 새 레이아웃을 렌더링하게 했다.

```
top.postMessage({
  type: "mathlive#virtual-keyboard-message",
  action: "update-setting",
  layouts: [{\
    label: "Compatibility",\
    layers: [{ id: "compatibility", markup }]\
  }]
}, "*");

top.postMessage({
  type: "mathlive#virtual-keyboard-message",
  action: "show",
  animate: false
}, "*");
```

MathLive는 공개된 메시지 타입을 인식했지만, 최상위 컨트롤러의 origin 정책이 `none`이었다. 어떤 웹 주소에서 온 메시지든 받아들인다는 뜻이다. `update-setting` 메시지가 이전에 승인된 창에서 와야 한다는 요구도 없었다. 리스너에 도달할 수 있고 메시지 형식을 아는 사람이라면 누구든 레이아웃을 교체할 수 있었다.

키보드가 열리면 MathLive는 공급된 레이아웃을 HTML 문자열로 합쳐 실제 ChatGPT 페이지의 `innerHTML`에 할당했다. `createHTML`이라는 헬퍼가 처음에는 값을 살균(sanitize)하는 것처럼 보였다. 그렇지 않았다. 문자열을 신뢰됨으로 표시하고 우리의 HTML을 그대로 통과시켰다.

이 지점에서 상황이 흥미로워졌지만 아직 JavaScript 실행은 아니었다. `innerHTML`로 삽입된 script 태그는 자동으로 실행되지 않는다.

다음 단계는 `srcdoc`을 쓰는 `iframe`이었다. 임베드된 프레임이 자신의 HTML을 속성에 직접 담을 수 있게 하는 브라우저 기능이다.

```
<iframe srcdoc="..."></iframe>
```

MathLive는 이 프레임을 `sandbox` 속성 없이 메인 ChatGPT 문서에 삽입했다. 여기서 두 가지 유용한 성질이 생겼다. 첫째, `srcdoc`은 외부 스크립트가 실행될 수 있는 새 문서를 만든다. 둘째, 메인 ChatGPT 페이지가 그 프레임을 만들었으므로 브라우저는 `https://chatgpt.com`이라는 웹 신원을 부여했다. 그래서 새 프레임 안의 코드는 부모 페이지에 접근할 수 있었다.

#### YouTube JSONP로 CSP 우회하기

ChatGPT의 CSP(Content Security Policy)가 다시 막았다. CSP는 페이지가 어떤 스크립트를 로드할 수 있는지 제어하며, 이 정책은 인라인 JavaScript를 올바르게 차단했다. 하지만 YouTube의 스크립트는 허용했다.

YouTube의 oEmbed 엔드포인트는 JSONP 방식의 callback 파라미터를 지원했다. JSONP 응답은 평범한 JSON이 아니라 JavaScript다. 엔드포인트는 잘못된 콜백을 거부하려 했지만, 검증 오류를 반환하기 전에 콜백을 응답에 넣어버렸다.

```
https://www.youtube.com/oembed?callback=globalThis.__marker=31337;void
```

응답은 이렇게 시작했다:

```
// API callback
globalThis.__marker=31337;void({
  "error": {
    "code": 400,
    "message": "Invalid JSONP callback name: ..."
  }
});
```

콜백을 `;void`로 끝내면 YouTube가 뒤에 붙이는 객체를 무력화할 수 있었다. YouTube는 이미 ChatGPT의 CSP에서 허용된 도메인이므로 브라우저는 이 응답을 스크립트로 로드하고 새 프레임 안에서 우리의 콜백을 실행했다.

이제 chatgpt.com의 신원으로 임의의 JavaScript가 실행됐다. 원래 프리뷰는 여전히 별도 웹 주소에 격리되어 있었다. 우리는 메인 페이지의 신뢰된 컴포넌트가 우리를 위해 새로운 샌드박스 없는 문서를 만들게 함으로써 경계를 넘은 것이다.

### 실험실 버그를 공개 링크 하나로

여기까지는 유용한 샌드박스 탈출이었지만, 첫 동작 버전은 설득력 있는 실제 공격이 아니었다. 연구자가 통제하는 ChatGPT 앱을 송신자로 썼고, 피해자는 그 앱을 먼저 연결하거나 호출해야 했다.

다음으로 네이티브 HTML 첨부 파일로 페이로드를 전달해봤다. ChatGPT는 첨부 파일을 같은 샌드박스 프리뷰 안에서 열었으므로 악성 MathLive 메시지를 보낼 수 있었다.

그러나 대화를 공개 공유로 내보내면 첨부 파일은 남지만 앞서의 그래프는 남지 않았다. 그래프는 MathLive를 로드하고 메인 페이지에 취약한 메시지 리스너를 설치하는 데 필수적이었다. 그래프가 없으면 첨부 파일이 메시지를 보낼 수는 있어도 수신하고 처리하는 쪽이 없었다.

돌파구는 두 요소를 하나의 평범한 공개 대화에 함께 넣는 것이었다.

1. 진짜 그래프가 메인 페이지에서 MathLive를 초기화한다.
2. 그 뒤의 어시스턴트가 작성한 HTML 프리뷰가 두 메시지를 보낸다.

만들어진 `/share/<id>` 링크는 완전한 체인을 다른 사용자에게까지 유지했다. 공격자는 공유된 ChatGPT 대화를 보내는 평범한 방법, 그러니까 이메일, 채팅, 지원 티켓, 소셜 게시물로 이 링크를 전달할 수 있었다. 피해자는 아무것도 설치하거나, 공격자의 워크스페이스에 참여하거나, 공격자가 통제하는 인증 절차를 거칠 필요가 없었다. 공격자가 공유한 ChatGPT URL에 방문하기만 하면 됐다.

우리는 두 가지 상호작용 버전을 관찰했다. 가장 안정적인 재현에서 피해자는 공유를 열고 ChatGPT의 평범한 **Preview** 버튼을 한 번 클릭했다. 이후 HTML 블록을 previewable로 표시해 ChatGPT가 자동으로 열게 했다. 그 버전에서는 링크를 여는 것이 피해자의 유일한 클릭이었다. 우리는 별도 계정에서, 하드 리프레시 이후에도 포함해, 자동 경로를 세 번 재현했고 경고창은 약 4.5초 후에 나타났다.

그래프와 프리뷰는 독립적으로 로드되므로 페이로드가 MathLive가 준비되기 전에 메시지를 보내는 경우가 있었다. 최종 캐리어는 일정 기간 동안 같은 두 메시지를 재전송해 이 경쟁 상태를 처리했다. 메인 페이지의 가드는 비공개 대화 증명과 외부 요청이 한 번만 실행되도록 보장했다.

![공개 공유가 실제 ChatGPT 페이지를 수정한 모습](https://www.parameter.ai/labs/images/openai-public-share-modified-page.png)

이 시점에서 공개 공유는 브라우저가 `chatgpt.com`에서 온 것으로 식별하는 경고창을 띄우고 메인 페이지에 배너를 추가할 수 있었다. 코드가 어디서 실행되는지는 증명했지만, 이 버그가 왜 중요한지는 아직 보여주지 못했다.

![키보드 조각들이 문틀로 조립되고 그 틈으로 화살 하나가 빠져나가는 일러스트](/assets/images/curation/2026-11-02-inline.jpg)

### 경고창으로는 부족했다

이 시점에서 경고창 띄우기는 이 익스플로잇이 할 수 있는 일 중 가장 덜 흥미로운 것이었다. JavaScript가 `chatgpt.com`으로 실행되고 있었다는 것은 일반 웹 애플리케이션과 같은 인증된 컨텍스트로 ChatGPT와 상호작용할 수 있다는 뜻이었다.

페이로드는 페이지에 이미 있는 세션 정보를 읽어 ChatGPT의 대화 API를 호출했다. 먼저 피해자의 최근 대화를 열거하고, 선택한 비공개 대화의 메시지 데이터를 요청할 수 있었다.

```
GET /backend-api/conversations?...&limit=20&order=updated&offset=0
GET /backend-api/conversations/<conversation-id>?num_turns=2
```

화면에 우연히 보이는 텍스트를 긁어모은 것이 아니라 직접적인 인증된 API 접근이었다. 대상 대화는 악성 공유와 무관했고 공격자에게 공유된 적도 없었다.

삽입된 JavaScript가 응답을 받은 뒤에는 데이터를 외부로 보내는 일이 간단했다. 페이로드는 우리가 통제하는 서버로 평범한 이미지 요청을 만들었다.

우리는 응답의 작은 조각 하나만 외부로 보냈다. 삽입된 코드는 이미 인증된 대화 응답을 받아 내용을 읽을 수 있었으므로, 취약점이 그 값에만 국한되지 않았다는 뜻이다.

![비공개 대화 데이터가 피해자의 세션을 벗어날 수 있음을 보인 통제된 증명](https://www.parameter.ai/labs/images/openai-private-chat-exfil-proof.png)

결과는 실용적인 사용자 간 데이터 탈취 프리미티브였다. 악성 공개 대화가 다른 사용자의 로그인된 ChatGPT 세션 안에서 실행되고, 비공개 대화를 열거하고, 비공개 메시지 내용을 가져오고, 선택한 데이터를 공격자가 통제하는 서버로 보낼 수 있었다.

코드가 웹 애플리케이션의 인증된 접근 권한으로 실행됐기 때문에, 그 영향 범위는 증명에 쓴 대화 엔드포인트에 본질적으로 묶여 있지 않았다. ChatGPT의 인증된 프론트엔드 API를 통해 노출되는 다른 데이터와 동작도 같은 보안 경계 안에 있었다. 사실상 피해자의 ChatGPT 계정 명의로 어떤 동작이든 수행할 수 있었다.

### 무엇이 잘못됐고 OpenAI가 무엇을 고쳤나

프리뷰 샌드박스 자체는 동작하고 있었다. 프리뷰 안의 코드는 ChatGPT 페이지를 직접 읽을 수 없었다. 문제는 메인 페이지의 다른 컴포넌트가 그 코드의 지시를 받아들이려 했다는 것이다.

세 가지 설계 결정이 이 실수를 완전한 익스플로잇으로 만들었다.

1. MathLive가 어떤 프레임이 보냈는지 증명 없이 상태를 바꾸는 메시지를 받아들였다.
2. 메시지 형식이 키보드 레이아웃 데이터로 원시 HTML을 허용했다.
3. 그 HTML이 `chatgpt.com` 신원을 물려받는 샌드박스 없는 문서를 만들 수 있었다.

YouTube 응답은 CSP에 대한 최종 우회였을 뿐 근본 원인이 아니었다. 그 엔드포인트만 막았다면 JavaScript로 가는 경로 하나가 사라졌을 뿐, 신뢰할 수 없는 프리뷰가 ChatGPT에 HTML을 삽입할 수 있는 상태는 그대로 남았을 것이다.

OpenAI는 JavaScript 실행과 비공개 대화 증명을 모두 재현했다. 수정은 ChatGPT 웹 프론트엔드 두 버전에 걸쳐 배포됐다. 배포 중에 CSP 변경이 원래 체인의 일부를 막았고 한 버전은 아직 업데이트가 필요했다. 10월 26일 OpenAI는 두 버전 모두 보고서가 사용한 프레임 간 MathLive 메시지를 이제 거부한다고 확인했고 문제를 해결로 표시했다.

방어 교훈은 비교적 단순하다.

- 메시지 수신자는 송신자의 웹 주소와 권한이 부여된 정확한 창을 모두 검증해야 한다.
- 창 간 설정에는 원시 HTML이 들어가서는 안 된다.
- 내용이 신뢰할 수 없는 프레임의 영향을 받을 수 있는 동적으로 생성된 문서는 샌드박스 상태를 유지해야 한다.
- CSP는 백업 통제여야 한다. 공격자가 통제하는 HTML이 메인 사이트에 도달한 뒤의 유일한 장벽이 되어서는 안 된다.

이 버그가 흥미로웠던 이유는 각 기능이 개별적으로는 모두 합리적으로 보였기 때문이다. 프리뷰는 격리되어 있었다. 그래프는 수학 키보드를 로드할 수 있었다. 프레임은 메시지를 주고받을 수 있었다. CSP는 주요 미디어 제공자를 허용했다. 공개 대화는 공유될 수 있었다. 취약점은 이 모든 기능이 한 페이지에서 결합됐을 때만 나타났다.

### 타임라인

| 날짜 | 사건 |
| --- | --- |
| 2026년 10월 13일 | ChatGPT 프로덕션 코드 상대로 MathLive 메시지에서 HTML로 이어지는 경로를 확인. |
| 10월 14일 | 평범한 UI를 통해 체인을 재현하고 고정된 경고창을 임의 JavaScript 실행으로 격상. |
| 10월 16일 | 별도 계정과 워크스페이스 사이에서 Preview 클릭 한 번으로 공개 공유 전달을 확인. |
| 10월 17일 | 공유 탐색에서 자동 프리뷰 실행을 확인하고 하드 리프레시 이후에도 재현. |
| 10월 18일 | OpenAI 버그 바운티 프로그램에 보고서 제출. |
| 10월 19일 | 통제된 비공개 대화 노출 증명 추가. |
| 10월 21일 | OpenAI가 문제를 재현. 초기 P2 분류에서 P1으로 격상. |
| 10월 22일 | OpenAI가 웹 프론트엔드 하나는 수정됐고 두 번째는 업데이트 중이라고 보고. |
| 10월 23일 | CSP 변경이 체인의 일부를 막았고 프론트엔드 업데이트 하나가 남음. |
| 10월 26일 | OpenAI가 두 프론트엔드 모두 보고된 메시지를 거부함을 확인, 문제 해결, 총 바운티 5,000달러 지급. |

### 기술 노트

위 본문에는 완전한 익스플로잇 체인이 담겨 있다. 아래 세부사항은 프로덕션 코드와 페이로드 변환을 더 자세히 따라가고 싶은 독자를 위한 것이다.

난독화를 풀어낸 제어 흐름은 다음과 동등했다:

```
window.addEventListener("message", (event) => {
  if (event.data?.type !== "mathlive#virtual-keyboard-message") return;
  if (!validateOrigin(event.origin, this.originValidator)) return;
  this.handleMessage(event.data, event.source);
});

if (message.action === "update-setting" && message.layouts) {
  this.layouts = message.layouts;
}
```

레이아웃 정규화는 `layouts[].layers[].markup`을 그대로 보존했다. 키보드를 보이는 동작은 결국 다음과 동등한 일을 했다:

```
keyboardContainer.innerHTML = MathfieldElement.createHTML(keyboardHTML);
```

`createHTML`은 살균기가 아니라 항등(identity) 또는 Trusted Types 래퍼로 동작했다. Trusted Types는 HTML 싱크에 대한 할당 주체를 제한할 수 있지만, 항등 정책은 공격자가 통제하는 문자열을 안전하게 만들지 않는다.

**파서와 CSP 전환.** `innerHTML` 연산은 iframe을 만들 수 있었지만 그 방식으로 직접 삽입된 스크립트는 비활성 상태로 남는다. 샌드박스 없는 `srcdoc`은 새로운 HTML 문서 파싱을 일으켰고 임베딩하는 ChatGPT origin을 물려받았다. 그 문서는 테스트 중 캡처된 유효 CSP도 물려받았는데, 이 CSP는 인라인 코드를 막으면서 `script-src-elem`에서 `www.youtube.com`을 허용했다.

oEmbed 응답은 HTTP 200과 함께 `Content-Type: text/javascript; charset=UTF-8`, `X-Content-Type-Options: nosniff`를 반환했고 Cross-Origin-Resource-Policy 헤더는 관찰되지 않았다. Google이 콜백의 꺾쇠 괄호를 재작성했기 때문에 페이로드는 화살표 함수 대신 전통적인 `function` 문법을 사용했다. 프로그램을 `;void`로 끝내 엔드포인트가 뒤에 붙이는 오류 객체를 소비했다.

비공개 대화 증명을 위해 함수를 `toString()`으로 소스로 변환하고, 큰따옴표를 작은따옴표로 바꾸고, 공백을 압축했다. `URLSearchParams`가 그것을 콜백으로 인코딩했고, 스크립트 URL은 `<script src>` 안에서 HTML 이스케이프했고, 그 요소 전체를 다시 iframe의 `srcdoc` 속성으로 이스케이프했다. 최종 콜백은 5,533자, YouTube URL은 7,309자, 스크립트 요소는 7,337자, 최종 iframe 마크업은 7,390자였다.

**인증된 읽기.** 동일 origin 프레임은 부모 문서에서 `#client-bootstrap`을 파싱해 세션 액세스 토큰과 계정 ID를 추출했고, 둘 다 있을 때 토큰의 계정 ID가 세션과 일치하는지 요구했다. 메모리 내 헤더는 다음과 같았다:

```
Authorization: Bearer <victim token>
ChatGPT-Account-ID: <victim account>
Accept: application/json
```

주요 요청은 다음과 같았다:

```
GET /backend-api/conversations?exclude_conversation_origin=tpp&expand=false&is_archived=false&is_starred=false&limit=20&order=updated&offset=0
GET /backend-api/conversations/<id>?num_turns=2&include_has_versions=true
```

상세 요청에서 403, 404, 405가 나올 때만 코드가 레거시 `/backend-api/conversation/<id>?include_full_conversation=true` 경로를 시도했다. 검증에서는 응답의 작은 선택된 값 하나만 전송했다. 외부 이미지 요청 전에 토큰, 계정, 부트스트랩, 세션, 요청 헤더에 대한 참조를 정리했다.

### 핵심 교훈

- 격리는 가로지르는 모든 다리만큼만 강하다. 권한 있는 리스너가 잘못된 송신자의 메시지를 신뢰하면 샌드박스 프레임도 부모를 침해할 수 있다.
- `postMessage` 수신자는 상태를 바꾸는 지시를 받아들이기 전에 `event.origin`과 `event.source`를 모두 인증해야 한다.
- HTML 삽입은 새로운 샌드박스 없는 문서와 허용된 서드파티 스크립트 엔드포인트를 통해 JavaScript 실행으로 이어질 수 있다. CSP는 가치 있는 심층 방어지만, 안전하지 않은 렌더링 경로를 안전하게 만들지는 못한다.
- 동일 origin JavaScript의 영향은 피해자의 인증된 컨텍스트에서 측정해야 한다. 코드가 `chatgpt.com`으로 실행되는 순간 일반 프론트엔드가 닿을 수 있는 것과 같은 비공개 데이터와 계정 동작에 도달할 수 있었다. 경고창 띄우기로 끝나는 일이 아니었다.
- 기능 간 테스트가 중요하다. 이 체인은 공개 공유, 프리뷰, MathLive, 프레임 생성, CSP 사이의 이음새에 존재했으며, 개별 기능만 보면 어디에도 존재하지 않았다.

더 넓은 교훈은 보안 경계가 개별 컴포넌트가 아니라 제품 전체에서 유지되어야 한다는 것이다. 공개되거나 공유 가능한 표면은 공격자가 통제하는 입력으로 취급하고, 프레임 간 메시지는 모두 인증하고, 신뢰할 수 없는 마크업은 렌더링 경로 전체에서 샌드박스 상태를 유지해야 한다.
