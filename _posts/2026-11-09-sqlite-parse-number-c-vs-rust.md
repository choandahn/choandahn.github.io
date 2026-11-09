---
layout: post
title: "SQLite 확장으로 만드는 parse_number(): C vs Rust (번역)"
date: 2026-11-09 09:00:00 +0900
author: Sam
lang: ko
categories: [curation]
image: "/assets/images/curation/2026-11-09-hero.jpg"
image_alt: "같은 함수를 구현한 두 언어의 성능을 나란히 놓고 재는 모습을 추상화한 일러스트. 무거운 형태와 가벼운 형태 사이로 속도선이 흐른다."
description: "같은 parse_number() 함수를 C와 Rust로 각각 만들어 속도, 코드 크기, 바이너리 크기를 비교한 리서치 리포트 번역"
source_url: "https://simonwillison.net/2026/Nov/8/sqlite-parse-number-c-vs-rust/"
source_author: "Simon Willison"
source_name: "Simon Willison's Weblog"
---

> 원문: https://simonwillison.net/2026/Nov/8/sqlite-parse-number-c-vs-rust/

---

개를 산책시키다가 문득 궁금해졌다. `-$1,234.56`이나 `'12.5%'` 같은 문자열을 더하거나 정렬할 수 있는 숫자 값으로 바꿔주는 `parse_number()` 함수를 SQLite C 확장으로 만들면 얼마나 쉬운지, 어려운지.

평소 쓰는 Claude chat(Opus 5.5)을 켜고 이렇게 프롬프트를 던졌다:

> `','` `$` `£` `%`를 지우고 앞의 `-`를 처리하며, 파싱할 수 없는 입력에는 `NULL`을 돌려주는 SQLite 커스텀 함수 `parse_number(value)`를 생각 중입니다.
> 같은 기능을 SQLite 확장으로 C로 만드는 것과 Rust로 만드는 것의 차이를 조사해 주세요. 성능과 코드 복잡도, 그리고 결과물인 `.so`(또는 그에 준하는) 파일의 크기를 비교하고 싶습니다.

꽤 쓸만한 출발점이 나왔다. Rust 확장은 [Rusqlite](https://github.com/rusqlite/rusqlite)를 쓴 버전이 321KB, [sqlite-loadable-rs](https://github.com/asg017/sqlite-loadable-rs)를 쓴 버전이 298KB였는데 C 확장은 14KB였다. 그런데 Rust 확장이 더 빨랐다!

알고 보니 Rust에 있는 C의 `strtod`에 해당하는 함수가 "2배 빠르기" 때문이었다. 그래서 이렇게 프롬프트를 이어갔다:

> Rust 구현을 따라잡거나 앞지르는, 텍스트를 소수로 파싱하는 C 함수를 직접 작성해 보세요

실제로 그렇게 됐다:

> 200만 행 기준 행당 순 비용, 낮을수록 좋음:
>
> |  | 첫 C | 새 C | rusqlite | sqlite-loadable |
> | --- | --- | --- | --- | --- |
> | 혼합 데이터 | 67 ns | **19 ns** | 46 ns | 41 ns |
> | 정수만 | 25 ns | **16 ns** | 36 ns | 32 ns |
> | 소수만 | 106 ns | **18 ns** | 55 ns | 47 ns |

마지막으로 위 조사를 [simonw/research](https://github.com/simonw/research)에 있는 다른 리포트들과 같은 형식의 리서치 리포트로 다시 쓰도록 이렇게 지시했다:

> GitHub에서 simonw/research를 클론한 뒤, 위 조사를 그 저장소에서 볼 수 있는 리서치 리포트 형식으로 만들어 주세요. 새 폴더가 담긴 zip 파일을 다운로드할 수 있게 주면 됩니다.

[결과 리포트](https://github.com/simonw/research/tree/main/sqlite-parse-number-c-vs-rust#readme)는 이렇게 나왔다.

아래는 이 리포트의 전문 번역이다.

## 리포트: parse_number()를 SQLite 확장으로, C vs Rust

> 참고: 이 리포트는 AI가 생성한 리서치 리포트다. 리포트의 모든 텍스트와 코드는 LLM(대규모 언어 모델)이 만들었다. 이런 리포트가 만들어지는 방식은 [메인 리서치 저장소](https://github.com/simonw/research)를 참고한다.

C와 Rust로 작성한 SQLite 스칼라 함수 `parse_number(value)`를 비교한다. 이 함수는 `,` `$` `£` `%`를 지우고, 앞의 `-`를 처리하고, 파싱할 수 없는 입력에는 `NULL`을 돌려준다:

```sql
select parse_number('-$1,234.56');  -- -1234.56
select parse_number('£1,000,000');  -- 1000000 (INTEGER)
select parse_number('12.5%');       -- 12.5
select parse_number('n/a');         -- NULL
```

같은 동작을 하는 네 버전을 만들고 속도, 코드 크기, `.so` 크기를 비교했다:

| 버전 | 내용 |
|---|---|
| [`c/`](c/parse_number.c) | 단순한 C. 소수는 `strtod()`를 거친다. |
| [`c-fast/`](c-fast/parse_number.c) | 올바르게 반올림되는 십진 fast path를 직접 넣은 C |
| [`rust-rusqlite/`](rust-rusqlite/src/lib.rs) | Rust, `loadable_extension`을 쓰는 [rusqlite](https://crates.io/crates/rusqlite) 0.41 |
| [`rust-loadable/`](rust-loadable/src/lib.rs) | Rust, [sqlite-loadable](https://crates.io/crates/sqlite-loadable) 0.0.6-alpha.6 |

두 Rust 버전은 [`rust-core/parse.rs`](rust-core/parse.rs)의 파서를 공유한다.

## 핵심 결과

- **일반 C는 속도에서 Rust에 졌다.** 혼합 데이터에서 행당 67ns로 41~46ns에 비해 느렸다. 정수에서는 더 빨랐지만 소수에서는 2배 느렸는데, glibc의 `strtod`가 Rust의 `f64::from_str`보다 훨씬 느리기 때문이다.
- **약 30줄짜리 C fast path가 이 격차를 메웠다.** 모든 데이터셋에서 행당 16~19ns로 두 Rust 버전 중 어느 쪽보다도 약 2배 빠르며, 800만 건 퍼징 검사에서 비트 단위로 동일한 결과를 유지했다.
- **C는 20배 작다**: 14KB vs 약 300KB. `opt-level = "z"`로 빌드해도 Rust 파일은 284~306KB를 유지한다. Rust 표준 라이브러리를 함께 싣기 때문이다.
- **Rust는 더 짧고 안전하게 쓸 수 있다**: 수동 버퍼와 오버플로 검사가 필요한 C 75줄(일반) 또는 104줄(fast)에 비해 30~36줄과 41줄짜리 공유 파서면 충분하다.
- **네 버전 모두 순수 SQL의 중첩 `replace()`보다 5~20배 빠르다.** 그리고 그 SQL은 규칙조차 강제하지 않는다.

## 규칙

요청이 일부 엣지 케이스를 열어두었기 때문에 아래처럼 정하고 모든 버전에 같은 규칙을 적용했다:

- `INTEGER`와 `REAL` 값은 그대로 돌려준다. `NULL`과 `BLOB`는 `NULL`을 돌려준다.
- 양쪽 끝의 공백, 탭, 줄바꿈은 무시한다. `,` `$` `£` `%`는 어디에 있든 제거한다.
- 첫 숫자 앞에 `-`를 하나 허용한다(`-$5`와 `$-5` 모두 동작). `.`은 하나만 허용하고 숫자는 최소 하나 필요하다.
- `.`이 없으면 `INTEGER`를 돌려주고, 64비트에 담기에 너무 크면 `REAL`을 돌려준다. `.`이 있으면 결과는 `REAL`이다.
- `1e5`, `+5`, `1 000`, `€5`, `5-`, `--5`는 모두 `NULL`이다. `%`는 제거만 한다(`45%` → 45).

## 성능

각 확장을 Python의 `sqlite3`(SQLite 3.53.1)에 올리고 200만 행에 `select sum(parse_number(v)) from t`를 돌린다. 루프 전체가 SQLite 안에서 돌도록 만들기 위해서다. 버전을 번갈아 가며 실행하고, 각 수치는 15회 실행 중 가장 빠른 값에서 같은 행에 대한 베이스라인 `sum(length(v))` 스캔을 뺀 값이다. 남는 것은 함수 호출과 파싱의 순 비용이다. 머신은 2 vCPU Linux x86-64 VM, gcc 13.3, rustc 1.97이다.

행당 순 나노초 (낮을수록 좋다):

| 데이터셋 | 일반 C | **fast C** | rusqlite | sqlite-loadable | 순수 SQL `replace()` |
|---|---|---|---|---|---|
| 혼합(`$1,234.56`, `£1,000`, `12.5%`, 정수, 10% 쓰레기 값) | 67.3 | **19.2** | 45.9 | 40.5 | 328.9 |
| 정수만(`$-123,456`) | 25.1 | **15.8** | 36.4 | 32.1 | 342.5 |
| 소수만(`$-123,456.78`) | 106.3 | **17.5** | 54.5 | 46.5 | 356.9 |

원본 출력: [`results/`](results/).

### 일반 C가 느렸던 이유, 그리고 fast C가 이기는 방법

일반 C는 정리한 문자를 버퍼에 복사한 뒤 `strtod()`를 불렀다. glibc의 `strtod`는 범용이고 로캘에 따라 달라진다. Rust의 float 파서는 먼저 빠른 정확 계산(*Clinger's fast path*)을 시도하고, 그다음 Eisel-Lemire를 쓴다.

`c-fast`는 이미 돌고 있던 스캔 루프 안에서 같은 빠른 계산을 한다:

```c
/* while scanning: mant = first <=19 significant digits, frac = digits after '.' */
}else if( FAST_PATH_OK && nsig<=19 && mant <= ((uint64_t)1<<53) && frac<=22 ){
  double v = (double)mant / POW10[frac];   /* both exact -> one correctly rounded op */
  sqlite3_result_double(ctx, neg ? -v : v);
  return;
}
parse_slow(ctx, s, start, end);            /* rebuild buffer + strtod, rarely taken */
```

숫자가 2^53 안에 들어가고 소수점 아래가 22자리 이하라면 두 수 모두 정확한 double이므로 IEEE 나눗셈 한 번이 `strtod`가 내놓을 답을 정확히 준다. 더 긴 입력은 `strtod`로 폴백한다. 정수는 아예 버퍼에 쓰지 않도록 바꿨다. 이 작업에서 Rust가 `c-fast`보다 느린 요인은 두 가지다. rusqlite가 호출마다 감싸는 것(closure, `Result`, `Value`)과 두 Rust 버전이 호출마다 할당하는 `Vec`이다. 그 `Vec`을 스택 버퍼로 바꿔도 정수에서 rusqlite는 35ns에서 31ns로 움직인 데 그쳤다.

![느린 우회 경로와 빠른 직선 경로로 갈라졌다 다시 만나는 추상적 경로 일러스트](/assets/images/curation/2026-11-09-inline.jpg)

## 크기와 복잡도

| | 일반 C | fast C | rusqlite | sqlite-loadable |
|---|---|---|---|---|
| strip 처리한 `.so` | 14,408 B | 14,408 B | 320,864 B | 298,464 B |
| 크기 최적화 적용 시 (`-Os` / `opt-level="z"`) | 14,408 B | 해당 없음 | 305,768 B | 284,264 B |
| 파일에 실제 들어있는 코드+데이터 (`size`) | 3.1 KB | 3.5 KB | 323 KB | 297 KB |
| 코드 줄 수 (빈 줄·주석 제외) | 75 | 104 | 36 + 41 공유 | 30 + 41 공유 |
| 의존성 | SQLite 헤더 | SQLite 헤더 | 크레이트 20개 | 크레이트 62개 |
| 처음부터 빌드 | 0.1초 | 0.1초 | 11초 | 72초 (bindgen, libclang 필요) |
| 필요한 공유 라이브러리 | libc | libc | libc, libgcc_s, ld-linux | libc, libgcc_s, ld-linux |

C 파일의 실제 내용은 약 3KB이고 14KB의 나머지는 ELF 페이지 정렬이다. Rust 파일은 함수 하나짜리 작은 프로그램임에도 Rust 표준 라이브러리, 포맷팅, 패닉 코드를 싣고 있다.

각각 작성하며 남긴 노트:

- **Rust**는 메모리와 슬라이스를 대신 다뤄주고 `str::parse::<i64>`로 정수 오버플로 처리를 얻는다. rusqlite의 `ValueRef` enum은 타입 처리를 하나의 명확한 `match`로 만든다. sqlite-loadable이 조금 더 쓰기 편하지만 여전히 알파다.
- **C**는 손으로 버퍼 처리와 오버플로 검사, `INT64_MIN` 특수 케이스를 써야 하고 fast 버전에서는 부동소수점 디테일에도 신경 써야 한다(`FLT_EVAL_METHOD == 0`일 때만 fast path를 켠다). 대신 파일 하나, 의존성 없음, 0.1초 빌드다.
- C 두 버전 공통 주의점: `strtod`는 호스트 프로그램의 로캘에 따라 소수점을 읽는다. `c-fast`에서는 드문 폴백 경로에만 영향을 준다.

## 정확성

- [`test.py`](test.py): 손으로 쓴 40개 케이스. 값과 `typeof()`를 함께 검사하며 모든 확장에 대해 돌린다. 모두 통과했다.
- [`fuzz.py`](fuzz.py): 올바르게 반올림되는 `float()`을 쓰는 Python 참조 구현과 모든 확장을 비트 단위로(`-0.0`과 integer vs real 포함) 비교한다. 입력은 무작위 쓰레기 값, 유효숫자 1~25자리 소수, 2^53 근처의 정확한 double을 전체 자릿수로 쓴 것. 시드 4개 × 입력 50만 개 × 확장 4개에서 불일치가 하나도 없었다([`results/fuzz.txt`](results/fuzz.txt)).

## 재현

```bash
./build.sh            # gcc + cargo; sqlite-loadable needs libclang
python test.py
python fuzz.py 1      # seed
python bench.py mixed # or: int, real
```

fast C 버전만 빌드하려면:

```bash
gcc -O2 -fPIC -shared c-fast/parse_number.c -o parse_number.so
```

```sql
.load ./parse_number
select parse_number('$1,234.50');
```

작업 노트는 [`notes.md`](notes.md)를 참고한다.
