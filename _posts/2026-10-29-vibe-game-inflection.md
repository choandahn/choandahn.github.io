---
layout: post
title: "바이브 게임 개발의 10월 변곡점 (번역)"
date: 2026-10-29 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "2026년 10월, Claude Opus 5.5가 게임 디자인까지 소화하면서 바이브 코딩으로 게임 만들기의 변곡점이 왔다는 글."
source_url: "https://simonwillison.net/2026/Oct/28/vibe-game-development/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
image: "/assets/images/curation/2026-10-29-hero.jpg"
image_alt: "화면 안에서 저폴리 3D 장면이 형성되는 창 위로 노래하는 선과 조각 블록이 떠 있는 미니멀 일러스트"
---

> 원문: <https://simonwillison.net/2026/Oct/28/vibe-game-development/>

---

나는 2025년 11월이 코딩 에이전트의 변곡점이었다고 여러 번 쓴 적이 있다. Opus 4.5와 GPT-5.1이 어떤 문턱을 넘어서면서, 각자의 코딩 에이전트가 소프트웨어 엔지니어의 일상적인 도구로 쓸 만해진 지점이었다. 2026년 10월에 새로운 변곡점에 도달했다고 생각한다. 이번에는 **바이브 코딩으로 컴퓨터 게임 만들기**가 그 대상이다.

- [Tree Appreciator](https://simonwillison.net/2026/Oct/28/vibe-game-development/#tree-appreciator)
- [Emberwick](https://simonwillison.net/2026/Oct/28/vibe-game-development/#emberwick)
- [Battle Drones](https://simonwillison.net/2026/Oct/28/vibe-game-development/#battle-drones)
- [Pumpkin Farmer, aka Quarter Sun Cove](https://simonwillison.net/2026/Oct/28/vibe-game-development/#pumpkin-farmer-aka-quarter-sun-cove)
- [Four times as insulting](https://simonwillison.net/2026/Oct/28/vibe-game-development/#four-times-as-insulting)
- [What happens if someone actually puts the work in?](https://simonwillison.net/2026/Oct/28/vibe-game-development/#what-happens-if-someone-actually-puts-the-work-in-)
- [You should build a game!](https://simonwillison.net/2026/Oct/28/vibe-game-development/#you-should-build-a-game-)

Claude Opus 5.5는 특히 매력적인 게임을 만드는 데 필요한 여러 영역에서 의미 있는 향상을 보인다.

- 3D 모델링
- 음악 생성 ([Scrimshaw Jukebox](https://simonwillison.net/2026/Oct/6/scrimshaw-jukebox/) 참고)
- 게임 디자인 (!)

마지막 항목이 특히 중요하다. 모델은 꽤 오래 전부터 게임처럼 *보이는* 무언가를 만들 수 있었다 ([내 이전 실험](https://simonwillison.net/2026/Aug/7/moonlight-mayhem/)이 그 예다). 문제는 실제로 *플레이해 볼 만한 재미있는* 게임에 도달하는 것이었다.

게임 디자인은 다루기 깊은 분야다. 나는 그 분야에 능숙하다고 말하지 않겠다. 하나의 기예로서 존중할 만큼은 안다. 플레이어를 적절한 수준에서 도전시키고 만족스러운 학습 곡선을 제공하는 참신하고 매력적인 게임플레이 루프를 만드는 일은 정교한 기술이다. 모델이 그것을 해낼 수 있으리라고는 생각하지 않았다.

그러다 Claude Opus 5.5에게 "Make it a LOT more fun"이라고 말해봤는데... [실제로 해냈다](https://simonwillison.net/2026/Oct/20/battledrones/#v4-the-fun-update).

지난 몇 주 동안 나는 바이브 코딩으로 ([이 용어의 원래 의미대로](https://simonwillison.net/2025/Mar/19/vibe-coding/), 코드를 전혀 보지 않고) 정말로 즐겁게 플레이한 게임 네 개를 만들었다.

주말에 버클리에서 열린 [Foo Camp](https://en.wikipedia.org/wiki/Foo_Camp)에 참석했는데, 비슷한 경험을 하고 있는 사람들을 여럿 만났다. 잘 플레이되는 게임을 만드는 일이 지금은 놀랄 만큼 쉽다. 새로운 도전은 AI 도움 없이는 존재하지 않았을, 참신하고 매력적인 게임 컨셉을 떠올리는 것이다.

전수 조사를 한 것은 아니지만, 지금 내 인상은 GPT-6 Astra가 아직 거기까지는 못 미친다는 것이다. 게임을 만드는 것은 물론 가능하지만, 재미를 느끼는 감각이 Opus 5.5만은 못하다. 올해 안에는 OpenAI도 도달할 것으로 본다.

여기 소개하는 네 개의 게임 프로젝트가, 모델이 이제 거의 지시 없이도 재미있는 게임을 만들 수 있다는 확신을 준 것들이다. 넷 모두 HTML과 JavaScript로 만들었고 브라우저에서 완전히 동작한다.

## Tree Appreciator

정말 즐겁다고 느낀 가장 작은 게임은 [Tree Appreciator](https://tools.simonwillison.net/tree-appreciator)다. 일반 Claude 채팅 인터페이스로 만들었다. Claude Code도 필요 없었다.

[Skyline Boulevard](https://en.wikipedia.org/wiki/California_State_Route_35)를 따라 운전하며 나무를 보다가 충동으로 만들었다. 내 프롬프트는 이러했다:

> `Build a three js game called "Tree appreciator" - it shows you two algorithmically generated trees and the game mechanics is about appreciating the differences between them. Think hard about how to make sure it is both fun and beautiful.`

모델에게 [three.js](https://threejs.org/)를 쓰라고 말하는 것이 꽤 잘 통하는 것을 발견했다. Claude에는 자체 이미지 생성 모델이 없지만, 보고 만지기 좋은 풀컬러 3D 모델을 만들어내는 능력은 뛰어나다.

이 게임은 반복이나 추가 프롬프트가 전혀 필요 없었다. 한 번에 완성됐다. 모바일 친화적인 귀여운 틀린 그림 찾기 게임이 그대로 나왔다. [여기서 플레이할 수 있다](https://tools.simonwillison.net/tree-appreciator). 만든 [채팅 기록](https://claude.ai/share/ee7de555-f85c-4ff0-96cb-d51ed5e479e9)도 공개돼 있다.

차분하게 즐길 수 있는 게임이다. 그래픽이 재미있고, 완성한 나무를 "표본집(herbarium)"에 모으면 소소하고 아늑한 성취감이 쌓인다.

## Emberwick

이것은 더 야심 있는 프로젝트였다. 이번에도 일반 Claude 채팅으로 만들었다. 탑다운 판타지 RPG 엔진의 실험적 프로토타입부터 만들기 시작했다:

> `Build a demo game engine three.js which is a top down (but at an angle) RPG - the player gets to move through the world with one or two companions. Create a fantasy village setting that demonstrates walking around outside and then shows how when the player enters a building the wall between the player and the camera goes transparent so the user can see what is happening`
>
> `Add some NPCs and plenty of furniture and different types of building some with an upstairs - be creative, make it look great`

[첫 버전](https://simonw.github.io/emberwick/v01/emberwick.html)이다. 꽤 잘 동작했다!

야심을 키울 명분이 생겼다:

> `Make it not so flat - the buildings are great but the landscape itself is completely flat at the moment, fix that`
>
> `Add basements to two of the buildings with a tunnel system joining them below the village`
>
> `Add the start of a rocky mountain on one side of the village containing a cave with a sleeping troll`

[그 버전](https://simonw.github.io/emberwick/v02/emberwick.html)이다.

결과가 좋아지자 마지막까지 밀어붙이기로 했다:

> `Now turn this into an actual game - quadruple the size of the playable area, introduce fun game mechanics, add a plot that isn't too cliche, some twists, a magic system, make it really good`

"make it really good" 같은 프롬프트가 여기서 다시 등장한다. "너무 클리셰이지 않은" 줄거리를 달라고 한 것도 효과가 있었는데, 약간 클리셰이지만 이야기를 따라가기에 충분히 참신했다.

Tree Appreciator와 달리 이것은 완성본에 이르기까지 상당한 플레이테스트와 추가 프롬프트가 필요했다. 주된 원인은 게임플레이 문제였다. 다른 스토리 요소가 캐릭터를 다른 장소로 이동시켜서, 퀘스트를 완료할 위치에 캐릭터가 없게 되는 식이었다.

[완성된 게임](https://simonw.github.io/emberwick/v11/emberwick.html)이다. 처음부터 끝까지 플레이하는 데 15분 정도 걸리는 완전한 스토리가 들어 있다.

심지어 실험적인 레벨 에디터도 있다. 자신만의 집, 가구, 지형 요소를 넣어볼 수 있다.

전부 동작하게 되고(게임플레이 버그를 몇 차례 고치고 나서) 처음부터 끝까지 플레이했는데, 결말에서 감정적으로 움직였다! 약간 부끄러운 일이다. 이 게임의 *모든 것*, 그래픽, 줄거리, 캐릭터, 음악, 대사가 전부 모델이 만든 것이기 때문이다. 내 창작 기여는 대략 "판타지 마을이고, 동굴에 트롤이 자고 있다" 정도였다.

이 게임을 만든 [전체 공개 Claude 채팅](https://claude.ai/share/840e0bc0-a68e-4894-8eec-8f83bd6ade26)이다.

같은 초기 프롬프트 시퀀스를 ChatGPT GPT-6 Pro에도 넣어봤다. 비교용으로 [기록](https://chatgpt.com/share/6ae176eb-1eac-83e8-ae54-729281fbdb70)과 [완성된 게임](https://lantern-hollow-rpg.simonw.chatgpt.site)이 있다. 화면은 훌륭하지만, 플레이 감각만큼은 크게 못 미친다고 본다.

![사람이 앉은 책상 위 화면 속에서 저폴리 3D 마을이 만들어지고, 그 위로 프롬프트 창과 작은 창작자 형상이 떠 있는 미니멀 일러스트](/assets/images/curation/2026-10-29-inline.jpg)

## Battle Drones

지금까지 중 가장 성공적인 프로젝트다. [저번 주에 따로 쓴 글](https://simonwillison.net/2026/Oct/20/battledrones/)이 있다. 두 개의 로봇 군대([토요일부터는 넷](https://simonwillison.net/2026/Oct/24/battledrones/))이 유닛을 생산하고 고철을 모으고 영토를 두고 싸우는, Command & Conquer 스타일 실시간 전략 게임이다.

이 프로젝트가 내게 Opus 5.5가 "재미(fun)"가 무엇인지 안다고 확신시킨 사례다.

초기 버전들은 7월에 Claude Fable 5로 만들었다. 동작하는 2D Command & Conquer 스타일 게임까지는 갔지만, 플레이하기 좋지는 않았다.

Opus 5.5에게 "Make it a LOT more fun"이라고 지시했고, 이어서 "Port this game to three.js"라고 지시했더니 게임이 변했다. 프롬프트를 포함한 상세 기록은 [내 글](https://simonwillison.net/2026/Oct/20/battledrones/)에 있다.

지금의 Battle Drones에는 2~4인 멀티플레이(바이브 코딩한 WebSockets 릴레이 서버로), 메달, 리플레이, 일곱 개의 맵, 랜덤 맵 생성기, 규칙 변형을 더하는 "뮤테이터" 세트가 있다.

서로 다른 LLM끼리의 대전도 가능하다. 게임이 5초 진행 후 일시정지하고, 각 모델이 새 게임 상태를 해석하고 다음 명령 세트를 준비할 시간을 주는 방식이다. [Claude Haiku 5.5 vs. GPT-6 Luna 리플레이](https://simonw.github.io/battledrones/v11/?replay=battles/showcase/2026-10-14-frostbite-42-claude-haiku-5.5-vs-gpt-6-luna.json)가 여기 있다.

Battle Drones은 Opus 5.5의 3D 모델링 능력을 보여주는 특히 좋은 사례다. [이 페이지](https://simonw.github.io/battledrones/models.html)에서 게임의 모든 모델을 둘러볼 수 있다.

지난 화요일 Battle Drones을 Apache 2.0 라이선스로 공개했다. 수요일에는 Gabriel Turpin이 [Panache](https://github.com/menufactory43/panache/)를 공개했다([스크린샷](https://simonwillison.net/2026/Oct/21/panache/)). Battle Drones의 포크로, 게임을 1900년대 벨 에포크 감성의 스팀펑크 프랑스로 재구성했고 새 모델과 음악, 애니메이션 인트로 시퀀스를 넣었다. 오픈소스가 일하긴 한다!

## Pumpkin Farmer, aka Quarter Sun Cove

나는 캘리포니아 [하프문베이](https://en.wikipedia.org/wiki/Half_Moon_Bay,_California)에 산다. 매년 열리는 [하프문베이 아트 앤 펌킨 페스티벌](https://en.wikipedia.org/wiki/Half_Moon_Bay_Art_and_Pumpkin_Festival)의 본고장인데, 거인 펌킨 저울 달기 대회도 함께 연다.

이미 존재하는 어떤 게임의 싸구려 모방이 아닌 게임을 만들어보기로 하고, 펌킨 농사를 짓고 거인 펌킨을 기르고 10월 펌킨 성수기를 소화하는 게임을 만들기 시작했다. 이름은 "Quarter Sun Cove"다.

아직 이터레이션 중이지만 제법 모습이 잡혀 간다. 1년 내내 거인 펌킨을 가꾸고 10월에 팔 일반 펌킨을 심고, 성수기에 펌킨을 팔고 거인 펌킨을 저울 대회에 내는 아늑한 농장 시뮬레이터다.

모든 캐릭터가 (채식주의) 동물이다. 마을 시장은 펠리컨이다. 플레이어는 펠리컨, 스컹크, 너구리, 주머니쥐, 비버, 코요테, 여우, 올빼미, 해달, 점박이물범 중에 선택할 수 있다. 그 종들 모두 나중에 자식들과 함께 나타나 펌킨을 사러 온다.

걷잡을 수 없을 만큼 귀엽다.

[최신 버전](https://simonw.github.io/pumpkin-farmer/)을 이곳에서 플레이할 수 있다. 게임 메커니즘이 아직 확신에 들지 않는다. 실제로 꽤 복잡하다. 10월에 방문객이 가장 많은 주말에 펌킨이 익도록, 심는 시기를 계산해야 한다.

[초기 브레인스토밍 세션](https://claude.ai/code/cshk_01V63sUyETi6UNbGUyjSYbHd13Mq93U6ty824Ha4eAxF4i)이 있었고, 그 결과 [스펙 파일](https://github.com/simonw/pumpkin-farmer/blob/cdcf12083f403946b5c2a9e04312bbb42359bf58/SPEC.md)이 나왔다. 그다음 Opus 5.5 Ultracode가 수백만 토큰과 이틀 가까운 시간을 소모하며 게임을 만들게 했다.

Claude에게 "사용자를 자주 놀라게 하고 기쁘게 하라(surprise and delight the user frequently)"고 말했더니, 결과물에는 작은 디테일과 이스터에그가 넘쳐난다. 장난기 많은 너구리들, 저울 대회를 운영하는 코끼리바다표범, 펌킨을 다시 바다로 굴려버리는 점박이물범들, 떠돌이 염소, 그리고 *가끔* 실제로 응답하는 거인 펌킨 기르기 관련 미신까지 있다.

아직 내 최고작은 아니다. Battle Drones만큼 재미있게 플레이되지는 않는다. 하지만 내가 더 원하는 종류의 게임을 보여준다. 이상하고, 재미있고, 개인적인 무언가. 이전 시대에는 만들어지지 않았을 게임이다.

## 네 배는 모욕적이다 (Four times as insulting)

AI 생성 아트, AI 생성 음악, AI 생성 글, AI 생성 코드에 반감이 있다면, 나쁜 소식이 있다. 바이브 코딩한 게임은 그 **네 가지를 동시에** 담고 있다.

그런 의견을 존중한다. 물론 나 자신은 그렇게 강하게 갖고 있지 않지만.

게임 커뮤니티 전반에는 이미 게임 속 AI 생성 에셋에 대한 거부감이 있다. Midjourney 같은 도구로 개발자가 에셋을 생성할 수 있게 된 지난 몇 년간 이 문제는 커져왔다. Valve의 Steam Next Fest에서 슬롭(slop)에 대한 불만을 다룬 [이 IGN 기사](https://www.ign.com/articles/steam-fans-are-begging-for-a-no-ai-filter-as-steam-next-fest-is-filled-with-slop)가 좋은 최근 사례다.

이제는 코드, 에셋, 대사, 심지어 게임 디자인 자체까지 모든 것을 모델에 맡길 수 있는 게임이 존재한다. 그리고 결과물도 형편없지 않다!

컴퓨터 게임 만들기는 예전에는 소프트웨어 개발 전체에서 가장 어려운 프로젝트 중 하나였다. 다양한 기술을 요구했고, 몇 달에서 몇 년간 집중과 노력을 필요로 했다. 그리고 지금 나는 폰에서 프롬프트를 치면서 플레이 가능한 멀티플레이 RTS를 뱉어내고 있다!

프로그래밍에서 이미 본 것처럼, 이것은 분열을 낳을 것으로 본다. 이런 식으로 만들어진 게임은 아예 취급하지 않겠다는 플레이어가 있을 것이다. 반대로 게임 개발이 훨씬 넓은 대중에게 열렸다고 받아들이는 이들도 있을 것이다. 나는 후자 쪽이다!

물론 내 바이브 코딩 게임을 전통적인 게임잼이나 대회에 출품하지는 않겠다. 그 자격을 얻은 것 같지 않다. 바이브 게임 개발자들이 자기 프로젝트를 겨루는 새로운 통로가 생기겠지.

## 실제로 일을 들이붓는 사람은 어떤 결과를 낼까

이 일에서 나를 신나게 하면서 부끄럽게 하는 것은, 그렇게 적은 창작 기여로 흥미로운 결과를 얻었다는 점이다. 여기 소개한 프로젝트들은 대략 내가 들인 노력 순서로 늘어놨다. 어느 프로젝트도 내 작업 시간 4시간을 넘지 않았다(Claude Code가 홀로 굴러간 시간은 훨씬 많다).

이것을 진지하게 받아들이고, 상당한 창작 시간을 쓰고, 더 나은 게임 디자인 취향을 적용한 다음, 결과를 플레이테스트하고 최대한 좋을 때까지 이터레이션하는 사람이라면 무엇을 해낼지 상상해보라.

나는 이 새 도구들이 없었다면 존재하지 않았을 게임을 보고 싶다.

## 게임을 만들어보길!

이런 식으로 게임을 만드는 일은 *정말 재미있다*. 바이브 코딩에 가장 잘 맞는 용도다. 위험이 낮기 때문이다. 개인 바이브 코딩 게임 프로젝트의 버그가 얼마나 큰 피해를 내겠나?

(물론 피해도 낸다. 내 오디오 기반 멀티플레이 시도는 아내 Natalie에게 [지독한 두통](https://simonwillison.net/2026/Oct/20/battledrones/#update-online-multiplayer-support)을 안겨줬다!)

지금까지 내 게임은 전부 HTML과 JavaScript로, 정적 호스팅(주로 GitHub Pages나 Cloudflare Pages) 위에서 돌아간다. 모바일 브라우저를 포함한 현대의 브라우저는 놀랍도록 강력하다. 프론티어 모델은 [three.js](https://threejs.org)나 [Phaser](https://github.com/phaserjs/phaser) 같은 라이브러리를 이미 알고 있다. 적어도 내가 만들려는 종류의 게임에서는 이 모바일 웹 게임이 네이티브 경험과 구분이 안 된다.

이런 프롬프트로 시작하라고 제안한다:

> `Build a mobile-friendly three.js game where...`

[chatgpt.com](https://chatgpt.com/)과 [claude.ai](https://claude.ai) 양쪽에서 통하는 문구다. 풀 코딩 에이전트를 켤 필요조차 없다. 마지막 예시로, "마우스가 고양이에게 숨어야 하는 모바일 친화적 three.js 게임"을 [Claude Opus 5.5 Extra가 만든 것](https://claude.ai/artifact/RRyEndXLSPQbcig3BgzgCZ)과 [GPT-6 Extra High가 만든 것](https://squeak-and-seek-mouse-1027.simonw.chatgpt.site/)을 비교해볼 수 있다.

프로젝트가 개념 증명 단계를 넘어서면 Codex나 Claude Code로 넘어가면 된다.

그래도 재미가 부족하다면 이렇게 덧붙이면 된다:

> `Make it a LOT more fun`
