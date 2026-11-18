---
layout: post
title: "코딩 에이전트를 위한 외부 샌드박스 (번역)"
date: 2026-11-18 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "에이전트가 실행하는 코드를 에이전트 밖의 전용 샌드박스에서 돌리는 외부 샌드박스 패턴과 세 가지 프로토타입 구현을 소개한다."
source_url: "https://simonwillison.net/2026/Nov/17/external-sandboxes-for-coding-agents/"
source_author: "Simon Willison, Prime Radiant"
source_name: "Simon Willison's Weblog / Prime Radiant Blog"
image: "/assets/images/curation/2026-11-18-hero.jpg"
image_alt: "유리 상자 안에서 기어와 코드 블록이 도는 가운데, 작은 로봇 실루엣이 상자 밖에 서 있고 밸브가 달린 파이프 하나만 상자를 연결한다."
---

> 원문: <https://simonwillison.net/2026/Nov/17/external-sandboxes-for-coding-agents/>

---

에이전트가 실행하는 코드를 에이전트 바깥의 전용 샌드박스에서 돌리는 패턴을 우리는 외부 샌드박스(external sandboxes)라고 부른다.

작업 결과물은 세 가지 프로토타입 샌드박스 구현이다. 하나는 Node.js와 WebAssembly를 쓰고, 하나는 Apple Containers를 쓰고, 하나는 Microsoft의 [Quicksand](https://github.com/microsoft/quicksand)와 QEMU를 쓴다. 세 구현 모두 같은 프로토콜을 따르며, Claude Code, Codex, Pi가 이 샌드박스 안에서 코드를 실행하게 만드는 방법도 함께 공개했다.

가장 간단한 데모는 `npx` 명령 두 개로 끝난다.

## 명령 두 개로 써보기

프로젝트 디렉터리로 이동한 뒤 `npx`로 새 샌드박스를 시작한다. 이 명령은 Alpine Linux를 내려받아 v86 안에서 실행한다. v86은 WebAssembly로 컴파일된 x86 에뮬레이터이고 Node.js 위에서 돌아간다. Node.js 22.19 이상만 있으면 된다:

```bash
npx --yes external-sandbox-v86 \
  --preserve-paths --mount-rw "project=$PWD"
```

그다음 같은 디렉터리의 두 번째 터미널에서 [Pi](https://pi.dev/) 코딩 에이전트를 이렇게 시작한다. Pi를 처음 쓴다면 에이전트 안에서 `/login`을 실행해 모델 접근 권한을 허가해야 한다.

```bash
npx --yes @earendil-works/pi-coding-agent \
  -e npm:external-sandbox-pi --no-builtin-tools \
  --sandbox-url http://127.0.0.1:8686
```

Pi에서 `!uname -a`를 실행하면 아래 출력이 나온다. 명령이 Alpine Linux 안에서 실행됐다는 뜻이다.

```
Linux (none) 6.12.114-0-virt #1-Alpine SMP PREEMPT_DYNAMIC 2026-10-21 12:19:03 i686 Linux
```

Pi 코딩 에이전트는 이제 프로젝트 폴더 안에서 명령을 실행하고 파일을 읽고 쓸 수 있지만, 머신의 그 밖의 것에는 접근할 수 없다.

![터미널에서 실행 중인 Pi. !uname -a 명령이 리눅스 커널 버전을 출력해 명령이 macOS가 아니라 샌드박스 안에서 실행됐음을 보여준다.](https://storage.ghost.io/c/c2/33/c2337b7d-2a3a-4cb4-8e28-7d30596f7cd7/content/images/2026/11/sandbox-pi.png)

Claude Code와 Codex도 조금 더 설정을 거쳐 쓸 수 있다. 아래를 참고하라.

## 이 패턴이 주는 것

- **에이전트는 맥에 그대로 있다.** Pi, Claude Code, Codex는 평소처럼 맥에서 실행되고, 실행하는 명령만 샌드박스로 간다.
- **샌드박스는 마운트한 폴더만 본다.** 어떤 폴더를 명령에 노출할지, 읽기 전용으로 할지 읽기 쓰기로 할지도 사용자가 정한다.
- **허용하지 않으면 네트워크 접근이 없다.** 기본 상태에서 샌드박스는 외부와 통신할 수 없다. 샌드박스를 시작할 때 `--proxy` 옵션을 붙이면 HTTP/HTTPS 프록시를 통해 허용한 호스트에만 접근할 수 있다.
- **에이전트가 볼 수 없는 API 키.** 프록시는 자격증명 대체(credential replacement)를 구현한다. 특정 호스트로 가는 요청에 API 키를 끼워 넣되, 그 비밀은 샌드박스 밖에 두고 호출한 에이전트에게는 보이지 않게 한다.
- **규칙을 고치는 웹 UI.** 샌드박스의 웹 UI는 브라우저 안 터미널, 프록시 설정 도구, 네트워크로 나간 요청의 로그를 제공한다.
- **어떤 에이전트든 어떤 샌드박스와도 쓴다.** 세 샌드박스가 같은 프로토콜을 구현하기 때문에 원하는 조합으로 섞을 수 있다.

## 다이어그램으로 보면

![다이어그램: 맥 위의 코딩 에이전트(Claude Code, Codex 또는 Pi)가 localhost의 샌드박스 서버에 명령을 보내고, 서버는 리눅스 VM에서 명령을 실행한다. VM은 마운트한 폴더와 파일을 주고받고, 허용 목록이 있는 프록시를 통해서만 인터넷의 허용된 호스트에 닿는다. VM을 나가는 길은 이 둘뿐이다.](https://storage.ghost.io/c/c2/33/c2337b7d-2a3a-4cb4-8e28-7d30596f7cd7/content/images/2026/11/sandbox-diagram.svg)

## 왜 외부 샌드박스인가

코딩 에이전트는 실수를 한다. 실수하는 순간, 에이전트가 읽거나 수정할 수 있었던 것은 뭐든 손상되거나 오염될 수 있다.

이상적인 세상이라면 에이전트는 안전한 환경에서 실행되어 남길 수 있는 피해가 엄격히 제한될 것이다. 현실에서는 많은 사람이 에이전트에게 컴퓨터와 외부 세계 모두를 통째로 열어주고 잘 되기를 바라며 손을 모은다.

에이전트 안전의 한 가지 해법은 에이전트가 원하는 모든 행동을 사람이 일일이 승인하는 것이다. 이건 끔찍하게 느린 방식이다. 결정 피로에 빠져 질문을 제대로 읽지도 않고 반사적으로 전부 승인해버리게 된다.

외부 샌드박스 패턴은 코딩 에이전트가 샌드박스 안에서 코드를 실행하고 파일을 수정하되, 사용자가 그 에이전트가 다룰 수 있는 파일·환경변수·네트워크 연결을 통제하게 해준다. 명령을 실행하고 코드를 작성·실행하는 에이전트의 유연함은 그대로 남는다.

Anthropic과 OpenAI 둘 다 에이전트를 안전하게 유지하려는 작업에 많은 투자를 했다. Claude Code의 [auto mode](https://code.claude.com/docs/en/auto-mode-config)와 Codex의 [auto-review](https://alignment.openai.com/auto-review/)는 추가 AI 검사로 계속 진행해도 안전할 것 같은 시점을 판단하는데, 잘 작동하는 것으로 보인다.

다만 이 검사들은 해당 제품의 기능일 뿐이고, 여전히 모델이 행동 하나하나를 옳게 판단하기를 기대한다. 샌드박스는 모델의 판단에 의존하지 않는 보호막이다. 저렴한 모델이나 로컬에서 돌리는 모델 같은 대안을 시도하려는 사람이라면 안전이 최우선 과제다. 가벼운 모델은 실수가 잦고, 프롬프트 인젝션 공격에는 더 쉽게 넘어간다.

우리의 목표는 코딩 에이전트가 샌드박스 안에서 일하도록 만드는 견고하고 신뢰할 수 있고 쓰기 쉬운 방법을 찾는 것이다. 에이전트가 실행하는 명령은 우리가 고른 파일만 읽고 쓸 수 있고, 우리가 허용한 네트워크 요청만 보낼 수 있어야 한다.

에이전트와 샌드박스를 결합하는 방법은 두 가지를 탐색했다. 첫째는 에이전트 자체를 샌드박스 안에서 실행하는 것이다. [Fly의 Sprites](https://sprites.dev/) 같은 시스템이 이 접근을 쓴다. 둘째는 에이전트를 샌드박스 밖에 두고, 에이전트가 에이전트와 별도로 존재하는 샌드박스에 명령을 보내는 것이다.

우리는 둘째를 골랐다. 에이전트가 자기 자신이나 자기 직속 환경을 수정하는 기묘한 상황을 피할 수 있고, 샌드박스 경계가 명확히 정의되어 감사하기 쉬워진다.

외부 샌드박스라고 부르는 이유는 샌드박스가 컴퓨터가 아니라 에이전트의 바깥에 있기 때문이다. 샌드박스와 에이전트는 같은 머신에서 실행될 수 있다.

## 세 가지 프로토타입

세 프로젝트는 서로 별개지만 호환되며, 외부 샌드박싱의 서로 다른 전략 세 가지를 담당한다.

- **external-sandbox-v86**은 Node.js 프로세스로, [WebAssembly의 v86](https://github.com/copy/v86)으로 Alpine Linux를 실행한다. [npm 패키지](https://www.npmjs.com/package/external-sandbox-v86)에 리눅스 배포판 전체가 샌드박스 안에서 돌아가는 형태로 들어 있다.
- **external-sandbox-container**는 [Apple Containers](https://github.com/apple/container)로 리눅스를 실행하는 것을 감싼 Python 프로세스다. 컨테이너를 띄우고 (프로토콜로 보낸) 명령을 실행한 뒤, 종료 시 컨테이너를 끝낸다.
- **external-sandbox-quicksand**는 Microsoft의 [Quicksand](https://microsoft.github.io/quicksand/)로 QEMU 가상머신 전체를 실행하는 Python 프로세스다. QEMU와 Alpine 이미지가 Python wheel로 오기 때문에 따로 설치할 것이 없다.

세 시스템은 동일한 localhost 웹 API를 제공하지만, 에이전트마다 접속 방식은 다르다:

- **Claude Code**는 Bash 도구 명령만 샌드박스로 보낸다. 자체 Read와 Edit 도구는 호스트에서, 즉 샌드박스 밖에서 그대로 돈다.
- **Codex**는 프로세스와 파일시스템 작업(네이티브 `apply_patch` 포함)을 보낸다.
- **Pi**는 `bash`, `read`, `write`, `edit`, `grep`, `find`, `ls` 도구를 보낸다. `grep`과 `find`는 게스트 안의 ripgrep이 필요한데, 세 기본 이미지 모두 포함하고 있다.

이 API에 대한 [명세](https://github.com/prime-radiant-inc/external-sandbox/blob/main/PROTOCOL.md)와 적합성 테스트 도구도 만들었다. 다른 기술 위에 호환되는 샌드박스 서버를 만들기가 쉬워진다.

![서로 다른 모양의 모듈 블록 세 개가 하나의 공용 소켓에 결합되는 모습.](/assets/images/curation/2026-11-18-inline.jpg)

## 다른 샌드박스와 에이전트에서 쓰기

v86 Alpine Node.js 서버는 기본 포트 8686, Python Apple Containers 서버는 8687, Python Quicksand 서버는 8688을 쓰기 때문에 세 개를 나란히 실행할 수 있다.

v86 서버는 [npm에 공개](https://www.npmjs.com/package/external-sandbox-v86)되어 `npx`로 실행한다. 두 Python 서버는 PyPI에 [external-sandbox-container](https://pypi.org/project/external-sandbox-container/), [external-sandbox-quicksand](https://pypi.org/project/external-sandbox-quicksand/)로 공개되어 `uvx`로 실행한다.

v86 Node.js 서버는 이렇게 시작한다:

```bash
# v86 Alpine Node.js (Node.js 22+)
npx --yes external-sandbox-v86 \
  --preserve-paths --mount-rw "project=$PWD"
```

Apple Containers는 이렇게:

```bash
# Python Apple Containers (Apple silicon Mac + Apple container CLI)
container system start
uvx external-sandbox-container \
  --preserve-paths --mount-rw "project=$PWD"
```

Quicksand는 이렇게. 첫 실행은 Alpine 이미지를 준비하고 캐시하는 시간 때문에 조금 더 걸린다:

```bash
# Python Quicksand (Apple silicon Mac)
uvx external-sandbox-quicksand \
  --preserve-paths --mount-rw "project=$PWD"
```

각 서버는 현재 디렉터리를 `/mnt/project`에 읽기 쓰기로 마운트하고, `--preserve-paths` 덕분에 원래 경로로도 마운트한다. 그래서 호스트 경로를 언급하는 명령도 샌드박스 안에서 그대로 동작한다. 읽기 전용 폴더는 `--mount-ro name=/some/path`로 추가한다. 서버의 포트를 브라우저로 열면 터미널과 네트워크 규칙 UI를 쓸 수 있다.

### Claude Code

다른 에이전트와 달리 Claude Code의 read와 edit 도구는 샌드박스를 거치지 않는다. 마운트 규칙이 Claude의 Bash 명령이 닿을 수 있는 범위를 제한하지만, Claude는 여전히 맥의 파일을 직접 읽고 수정할 수 있다.

샌드박스를 붙여 Claude Code를 실행하려면 external-sandbox 저장소의 공용 셸 접두사 스크립트를 가져온다:

```bash
git clone https://github.com/prime-radiant-inc/external-sandbox.git
PREFIX_DIR="$(cd external-sandbox/claude-code && pwd)"
```

그다음 서버를 시작한 프로젝트 디렉터리에서 이렇게 실행한다(예시는 8686 포트의 v86):

```bash
mkdir -p .external-sandbox-claude-tmp
CLAUDE_CODE_SHELL=/bin/bash \
CLAUDE_CODE_TMPDIR="$PWD/.external-sandbox-claude-tmp" \
CLAUDE_CODE_SHELL_PREFIX="$PREFIX_DIR/claude-shell-prefix.sh" \
EXTERNAL_SANDBOX_API_URL=http://127.0.0.1:8686 \
claude
```

v86 서버는 8686 포트이고, Apple Containers는 8687, Quicksand는 8688을 쓴다. `.external-sandbox-claude-tmp` 디렉터리는 쓰기 가능한 마운트 안에 있어야 한다. Claude Code가 자기 장부 기록용으로 쓰기 때문이다.

### Codex

Codex를 붙이려면 샌드박스를 가리키는 `environments.toml`이 담긴 전용 Codex 홈을 만든다(예시는 8686 포트의 v86):

```bash
mkdir -p ~/.codex-external-sandbox
cat > ~/.codex-external-sandbox/environments.toml <<'EOF'
default = "external-sandbox"
include_local = false

[[environments]]
id = "external-sandbox"
url = "ws://127.0.0.1:8686/codex"
connect_timeout_sec = 5
initialize_timeout_sec = 10
EOF
```

그 홈으로 한 번 로그인한 뒤 Codex를 실행한다:

```bash
CODEX_HOME=~/.codex-external-sandbox codex login
CODEX_HOME=~/.codex-external-sandbox codex --sandbox danger-full-access \
  -c features.shell_snapshot=false \
  -c features.unified_exec_tty=false \
  --cd "$PWD"
```

`danger-full-access`는 Codex가 우리 샌드박스 안에 자기 샌드박스를 또 쌓지 않게 한다. 자동화 테스트는 Codex CLI 0.164.0 기준으로 `codex exec`와 시뮬레이션 모델을 사용해 통과했다. exec-server 프로토콜은 실험적이라 다른 버전에서는 확인이 필요할 수 있다.

### Pi

[Pi](https://pi.dev/)를 붙이려면 Pi의 내장 도구를 끈 상태로 [external-sandbox-pi](https://www.npmjs.com/package/external-sandbox-pi) 확장을 읽어들인다. 서버를 시작한 프로젝트 디렉터리에서 실행한다(예시는 8688 포트의 Quicksand):

```bash
pi -e npm:external-sandbox-pi --no-builtin-tools \
  --sandbox-url http://127.0.0.1:8688
```

`-e npm:`은 그 실행에만 확장을 내려받고, `--no-builtin-tools`는 확장 로딩에 실패해도 내 컴퓨터에서 아무것도 실행될 수 없게 만든다. 확장은 Pi 1.5 이상이 필요하다. 접속이 되면 Pi의 상태 표시줄에 `Sandbox: ...`가 나타난다.

## 네트워크 접근 통제

세 샌드박스 구현은 기본적으로 외부 네트워크 접근이 전혀 없다. [lethal trifecta](https://simonwillison.net/2025/Jun/16/the-lethal-trifecta/)에서 다룬 것처럼, 개인 데이터를 외부로 유출할 수 있는 버그나 프롬프트 인젝션 공격에 기본 상태로 방어가 된다.

각 샌드박스는 프록시를 거치는 HTTP, HTTPS 접근을 허용하도록 설정할 수 있고, 프록시가 어떤 호스트에 접근할 수 있는지, 어떤 HTTP 동사를 쓸 수 있는지 통제한다. 특정 호스트에 읽기 전용 접근을 허용할 수도, 전체 접근을 허용할 수도 있다.

프록시가 켜지면 샌드박스 안에 `HTTP_PROXY`와 `HTTPS_PROXY` 환경변수가 설정되어 `wget` 같은 클라이언트가 프록시 경유 접근 방법을 알게 된다. 샌드박스는 프록시의 CA 인증서도 제공하고 `SSL_CERT_FILE`, `REQUESTS_CA_BUNDLE`, `NODE_EXTRA_CA_CERTS` 같은 변수를 그 인증서로 향하게 해서, 클라이언트는 보안 사이트에 접속하면서 프록시가 트래픽을 검사하고 걸러낼 수 있게 한다. 이 설정들을 무시하고 직접 연결을 시도하는 코드는 여전히 막힌다.

`--proxy-config` 옵션을 파일로 향하게 하면 세션에서 어떤 호스트와 어떤 메서드를 허용할지 지정할 수 있다. 프록시 설정 파일의 예:

```json
{
  "allow": [
    {
      "origin": "https://pypi.org",
      "methods": ["GET", "HEAD"]
    },
    {
      "origin": "https://files.pythonhosted.org",
      "methods": ["GET"]
    },
    {
      "origin": "https://api.github.com",
      "methods": ["GET"],
      "credential": {
        "header": "authorization",
        "placeholder": "Bearer placeholder-github-token",
        "secretEnv": "GITHUB_TOKEN",
        "prefix": "Bearer "
      }
    }
  ],
  "guestEnv": {
    "GITHUB_TOKEN": "placeholder-github-token"
  }
}
```

### HTTP API의 자격증명 대체

자격증명 대체는 샌드박스 안에서 실행되는 코드가, 키 자체를 에이전트에게 노출하거나 샌드박스 안에 두지 않은 채 웹 API에 인증된 호출을 할 수 있게 한다.

위 예시는 GitHub API에 그걸 설정한다. 프록시를 통해 `https://api.github.com/`으로 요청을 보내면 authorization 헤더는 `Bearer placeholder-github-token`이 된다. 프록시는 이 헤더를 호스트에서 실행 중인 샌드박스 서버 환경의 `GITHUB_TOKEN` 환경변수 값으로 바꾼다. `guestEnv` 블록은 샌드박스 안의 코드에게 placeholder 값을 담은 `GITHUB_TOKEN` 변수를 준다.

이렇게 하면 에이전트는 API 키가 에이전트 자신에게 보이지 않는 상태로 API에 인증된 호출을 할 수 있다. 다만 허용한 호스트가 응답에 자격증명을 되돌려줄 수도 있으니, 자격증명 규칙은 신뢰하는 서비스에만 쓰고 메서드와 경로 범위는 좁게 유지하라.

이렇게 샌드박스를 실행하면 프록시에 GitHub API 토큰이 제공된다:

```bash
GITHUB_TOKEN="$(gh auth token)" npx --yes external-sandbox-v86 \
  --proxy-config proxy.json \
  --preserve-paths --mount-rw "project=$PWD"
```

### 네트워크 감시와 정책 수정

아래는 위 네트워크 설정을 기준으로 요청들이 차단되거나 허용되는 모습을 보여주는 샌드박스 웹 UI 세션이다. `fetch.py`는 요청을 하나 보내고 결과를 출력하는 짧은 스크립트다:

![external-sandbox-v86의 웹 터미널. 요청 하나는 허용되고 두 개는 거부된다.](https://storage.ghost.io/c/c2/33/c2337b7d-2a3a-4cb4-8e28-7d30596f7cd7/content/images/2026/11/sandbox-terminal.png)

샌드박스 웹 UI의 `/proxy` 페이지에서는 세션이 실행 중인 상태에서 네트워크 정책을 수정할 수 있고, 프록시가 최근에 허용하거나 거부한 요청의 로그도 보여준다:

![네트워크 정책 페이지. 허용된 목적지, 정책 JSON 편집기, 최근 프록시 활동이 보인다.](https://storage.ghost.io/c/c2/33/c2337b7d-2a3a-4cb4-8e28-7d30596f7cd7/content/images/2026/11/sandbox-proxy.png)

`/proxy` 페이지는 서버가 `--proxy` 플래그로 시작했거나 `--proxy-config proxy.json`으로 초기 설정을 넘겼을 때만 제공된다.

정책 형식 전체는 세 샌드박스가 공유하는 [프로토콜 명세의 프록시 섹션](https://github.com/prime-radiant-inc/external-sandbox/blob/main/PROTOCOL.md#7-managed-https-proxy-p1p4)을, 더 많은 예는 [v86 프록시 가이드](https://github.com/prime-radiant-inc/external-sandbox-v86/blob/main/docs/proxy.md)를 참고하라.

## 에이전트가 샌드박스에 접속하는 방식

코딩 에이전트마다 실행하는 모든 명령을 사용자 지정 환경에서 돌게 만드는 방법이 다르다.

### CLAUDE_CODE_SHELL_PREFIX

Claude Code의 장치는 환경변수로 조작된다. `CLAUDE_CODE_SHELL_PREFIX`가 설정되어 있으면 Claude의 Bash 도구는 모든 명령을 그것을 접두사로 붙여 실행한다:

```bash
claude-shell-prefix.sh 'uname -m; pwd; printf "hello from Linux\n"'
```

이를 이용하면 의도된 명령을 임의의 방식으로 실행할 수 있다. 실행 환경이 (환경변수와 세미콜론 등을 포함한) 완전한 셸 문자열을 처리할 수 있기만 하면 된다.

### codex exec-server

Codex에는 `codex exec-server` 장치가 있다. "서브프로세스를 생성하고 제어하는 작은 JSON-RPC 서버"와 통신할 수 있게 해준다.

OpenAI가 Codex의 일부로 자체 구현을 제공하지만, Codex는 오픈 소스라서 세부 사항을 뽑아 별도 구현을 만드는 것도 가능하다.

즉, 그 JSON-RPC 명세를 구현하는 서버에 Codex를 향하게 하면 Codex가 그 다른 환경을 제어할 수 있다. 위 Codex 섹션의 `environments.toml` 파일이 바로 Codex를 그 서버로 향하게 하는 파일이고, `url`은 샌드박스의 `/codex` WebSocket 엔드포인트다.

### Pi 확장

[Pi 코딩 에이전트](https://pi.dev/)는 확장이 Pi의 기본 도구 세트를 커스텀 버전으로 대체할 수 있게 해준다. `external-sandbox-pi`는 `bash`, `read`, `write`, `edit`, `grep`, `find`, `ls` 도구를 설정된 샌드박스에 대해 동작하는 버전으로 바꾼다.

Pi의 `!command`와 `!!command` 단축키도 샌드박스 안에서 실행되도록 설정한다. `!command`는 명령을 실행하고 그 출력을 대화에 추가하고, `!!command`는 출력을 모델에 보내지 않고 실행한다.

`pi -e npm:external-sandbox-pi --no-builtin-tools`로 실행하면 확장 로딩에 실패하더라도 Pi가 내 컴퓨터에서 실행되는 도구를 갖지 않게 된다. 샌드박스에 닿을 수 없으면 도구는 기본값으로 떨어지는 대신 오류를 반환한다.

명령이 샌드박스로 전달되는지 확인하려면 Pi 안에서 이렇게 실행한다:

```
!uname -a
```

Darwin이 아니라 Linux가 보여야 한다. 나머지 출력은 실행 중인 샌드박스에 따라 달라진다.

Pi가 항상 샌드박스와 통신하도록 설정할 수도 있다. 확장을 설치하고 환경변수를 이렇게 설정한다:

```bash
pi install npm:external-sandbox-pi
export EXTERNAL_SANDBOX_API_URL=http://127.0.0.1:8686
```

`export` 줄을 셸 프로필에 넣으면 터미널 세션을 넘어 유지된다.

확장을 제거하려면:

```bash
pi remove npm:external-sandbox-pi
```

## 의견을 들려달라

이 샌드박스들은 여전히 실험적 프로토타입으로 봐야 한다. 외부 샌드박스 패턴을 효과적으로 보여주지만, 민감한 작업을 맡기고 믿을 수준까지는 감사되지 않았다.

기억할 제약이 둘 더 있다. 읽기 쓰기 마운트는 에이전트가 그 폴더 안의 무엇이든 손상시킬 수 있게 하므로, 버전 관리 아래 두고 가능한 한 읽기 전용 마운트를 쓰라. 그리고 샌드박스는 리눅스에서 돌기 때문에, macOS용으로 빌드된 의존성(프로젝트의 `node_modules`나 `.venv` 폴더 같은 것)은 샌드박스 안에서 다시 설치해야 할 수 있다.

세 가지 샌드박스 구현과 세 가지 클라이언트 에이전트의 조합은, 이 프로토콜로 모델·에이전트·샌드박싱 플랫폼을 자유롭게 섞을 수 있음을 보여준다. 다른 기술 위에 샌드박스를 만들고 싶다면 [명세](https://github.com/prime-radiant-inc/external-sandbox/blob/main/PROTOCOL.md)와 [적합성 도구](https://github.com/prime-radiant-inc/external-sandbox)부터 시작하라.

직접 써보고 개선 제안이 있거나 설계의 결함을 발견하면 [external-sandbox](https://github.com/prime-radiant-inc/external-sandbox) 저장소에 이슈로 알려달라.
