# choandahn.github.io

www.choandahn.com(조앤안 블로그)의 Jekyll 소스입니다. `main`에 병합하면 GitHub Actions(`.github/workflows/pages.yml`)가 빌드해 GitHub Pages로 배포합니다. 앞단은 Cloudflare이고, `choandahn.com`은 경로와 쿼리를 유지한 채 `www`로 301됩니다.

## 명함 QR 리다이렉트

공동대표 명함의 QR은 아래 주소를 가리키고, 이 주소가 조앤안AX 랜딩(UTM 포함)으로 보냅니다. 인쇄한 QR은 바꿀 수 없으므로 목적지는 이 저장소의 **`_data/qr.yml` 한 곳에서만** 관리합니다. Cloudflare에 `/qr/*` 리다이렉트 규칙을 만들지 않습니다(두 곳에서 관리하면 어느 쪽이 이기는지 헷갈림).

| id | 명함 | 인쇄된 주소 |
|---|---|---|
| `cho` | 조성우 | https://choandahn.com/qr/cho |
| `ahn` | 안운장 | https://choandahn.com/qr/ahn |

**이미 인쇄된 id(`cho`, `ahn`)는 절대 지우거나 이름을 바꾸지 마세요.** 지우면 그 명함의 QR이 `unknown` 목적지로 가서 누구 명함으로 들어왔는지 알 수 없게 됩니다. 명함을 더 이상 쓰지 않더라도 남겨 둡니다.

`unknown`은 인쇄용 id가 아니라, 목록에 없는 `/qr/...` 주소로 들어왔을 때 보내는 곳입니다.

### 목적지 바꾸기

1. `_data/qr.yml`에서 id 옆의 주소만 고치고, 브랜치에서 PR을 올려 `main`에 병합합니다.
2. 배포(1~2분)가 끝나면 아래 "확인"의 curl로 새 주소가 나오는지 봅니다.

- 주소는 `https://`로 시작하는 전체 주소로 씁니다. id나 주소 형식이 잘못되면 빌드가 실패하고, 사이트에는 이전 목적지가 그대로 남습니다(Actions 실패 메일로 알 수 있음).
- `utm_source=namecard`, `utm_medium=qr`, `utm_campaign`, `utm_content=<id>`를 빼면 랜딩의 신청 시트와 PostHog에서 명함 유입을 구분할 수 없습니다. 캠페인 이름만 바꾸는 것은 괜찮습니다.

### 새 id 추가하기

1. `_data/qr.yml`에 `id: 주소` 한 줄을 추가합니다. id는 영문 소문자, 숫자, `-`, `_`만 쓰고, 주소의 `utm_content`도 같은 id로 맞춥니다.
2. 병합과 배포가 끝난 뒤 `https://choandahn.com/qr/<새 id>`가 목적지로 가는지 확인하고 나서 QR을 인쇄합니다. 인쇄 뒤에는 위의 `cho`, `ahn`과 똑같이 지우거나 이름을 바꾸지 않습니다(표에도 추가).

### 동작 방식

- `_plugins/qr_redirects.rb`가 `_data/qr.yml`의 id마다 `/qr/<id>/index.html`을 만듭니다. 레이아웃은 `_layouts/qr.html`로, 사이트 레이아웃·분석 스크립트·글꼴·CSS 없이 noindex이고 사이트맵에서 빠집니다(측정은 목적지에서 함).
- 페이지는 `<head>` 맨 앞 스크립트(`_includes/qr-redirect.js`)에서 `location.replace()`로 바로 이동합니다. JS가 꺼져 있으면 `<noscript>` 안의 meta refresh로 이동하고, 화면에는 목적지 링크 한 줄만 있습니다.
- 들어온 쿼리는 목적지에 붙이되 목적지에 이미 있는 키는 덮어쓰지 않습니다. 팀 테스트용 `https://choandahn.com/qr/cho?ph_internal=1`은 목적지에 `ph_internal=1`이 붙고 utm 값은 그대로입니다.
- `/qr/cho`는 GitHub Pages가 `/qr/cho/`로 301합니다(쿼리 유지).
- 목록에 없는 `/qr/...`는 `404.html`의 스크립트가 `unknown` 목적지로 보냅니다. 대소문자만 다른 주소(`/QR/CHO`, QR 생성기가 주소를 대문자로 바꾼 경우)는 그 id의 목적지로 보냅니다. `/qr/` 밖의 404는 예전과 같습니다.

### 확인

```bash
# 각 단계의 상태와 Location (apex → www → 끝 슬래시)
curl -sIL "https://choandahn.com/qr/cho" | grep -iE '^(HTTP|location)'
# 최종 페이지 안의 목적지
curl -sL "https://choandahn.com/qr/cho" | grep -oE 'qrGo\("[^"]+"\)'
curl -sL "https://choandahn.com/qr/ahn/" | grep -oE 'qrGo\("[^"]+"\)'
# 목록에 없는 id: 상태는 404, 본문에 unknown 목적지가 있어야 함
curl -s -o /dev/null -w '%{http_code}\n' "https://www.choandahn.com/qr/xyz"
curl -s "https://www.choandahn.com/qr/xyz" | grep -o 'utm_content=unknown'
```

쿼리 합치기는 브라우저에서 `https://choandahn.com/qr/cho?ph_internal=1`을 열어 주소창에 `...&utm_content=cho&ph_internal=1`이 나오는지 봅니다.
