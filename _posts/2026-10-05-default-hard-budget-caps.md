---
layout: post
title: "거의 모든 것에 기본 하드 예산 한도가 필요하다 (번역)"
date: 2026-10-05 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
description: "사용량 기반 서비스에는 월 예산 초과 시 서비스를 끊는 하드 한도가 기본값이어야 한다는 주장과 AWS, Google Cloud의 지출 한도 출시 소식."
source_url: "https://simonwillison.net/2026/Oct/3/default-hard-budget-caps/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
image: "/assets/images/curation/2026-10-05-hero.jpg"
image_alt: "닫힌 밸브가 파이프에 흐르는 동전을 막고 있고, 한도 눈금이 그려진 작은 계기판이 옆에 놓인 미니멀 일러스트"
---

> 원문: https://simonwillison.net/2026/Oct/3/default-hard-budget-caps/

---

세상에 앞으로 훨씬 많이 필요해질 제품 기능이 있다. 기본으로 켜지는 하드 예산 한도(default hard budget caps)다. 사용량 기반 과금 서비스와 API에서 "월 X달러를 넘기면 이 기능을 끊고 에러를 반환하라"고 지정할 수 있게 하는 기능이다. 이 한도는 하드(hard)해야 한다. X달러를 넘기면 경고 메일을 보내주는 소프트 한도로는 부족하다.

코딩 에이전트와 개인용 에이전트(코딩 에이전트를 덜 위협적인 UI로 감싼 것)는 쓸모 있는 일을 하는 코드를 만드는 마찰을 크게 줄인다. 그 일에는 때때로 비용이 든다. 유료 API 호출, 호스팅된 웹 애플리케이션, 추가 스토리지와 컴퓨팅에 청구하는 시스템 같은 것들이다.

아무도 자정에 도착한 예산 경고 메일을 받으며 깨고 싶지 않다. 잠든 사이 자기 서비스가 몇백, 혹은 몇천 달러를 더 써버렸다는 메일 말이다.

반대 논거도 있다. 예산을 초과했다는 이유로 호스팅 애플리케이션이 에러를 뱉는 건 기업들이 원하지 않는다는 것이다. 나는 대부분의 기업과 개인이 1만 달러가 넘는 청구서보다 에러를 택한다고 본다.

하드 예산 한도가 기본값이어야 한다고 생각한다. 위험하게 살고 싶은 사람은 그렇게 할 수 있어야 하겠지만, 옵트인 방식이어야 한다. 눈에 잘 띄는 곳에 이런 체크박스를 두면 된다.

> Remove the budget cap. My application will not be shut down if I exceed the configured budget limit, and I will be responsible for subsequent charges.
>
> (예산 한도를 제거한다. 설정한 예산 한도를 초과해도 내 애플리케이션은 중단되지 않으며, 이후 청구분은 내가 책임진다.)

가장 이 기능을 갖췄으면 하는 서비스는 AWS다. 폭주한 서비스가 자신을 파산시킬 수 있다는 (합당한) 두려움 때문에 개인 프로젝트에는 AWS를 쓰지 않겠다고 하는 사람들의 이야기를 수없이 들었다. 이런 문제를 예상하지 못해 크게 데인 사람들 이야기도 들었다.

그런데 AWS가 몇 주 전에 마침내 지출 한도를 출시했다. 9월 16일자 공지 [New AWS experience helps builders get started and ship faster](https://aws.amazon.com/about-aws/whats-new/2026/09/New-AWS-Builder-Experience/)에는 이렇게 나온다.

> 유료 플랜으로 업그레이드할 준비가 되면 사용 패턴에 맞춰 프로젝트의 월 지출 한도를 설정해 예산을 벗어나지 않도록 할 수 있다. 프로젝트 사용량이 지출 한도에 도달하면 해당 월에는 프로젝트가 일시 중지된다.

[Create a spend limit in AWS Settings](https://docs.aws.amazon.com/accounts/latest/reference/create-spend-limit.html) 문서도 있다. 다만 그 문서는 "새 경험을 일부 고객에게 단계적으로 공개하고 있다"고 안내한다. 기존 계정에도 조만간 정식 제공되기를 바랄 뿐이다.

Google Cloud는 7월에 [Spend Caps라는 비슷한 기능](https://cloud.google.com/blog/topics/cost-management/new-early-anomalies-and-spend-caps-on-google-cloud-budgets)을 출시했다. 프로젝트 내 특정 서비스에 월 단위 재정 한도를 설정할 수 있게 해준다. 하나의 흐름이 되어가는 모양새다.

이상적인 세계에서는 에이전트가 이 문제를 도울 수 있다. 에이전트가 하드 예산 한도를 제공하는 프로바이더를 우선 추천하고, 한도 없는 서비스에 애플리케이션을 배포하면 곤란에 빠질 수 있다고 경험이 적은 빌더들에게 경고해주면 좋겠다.
