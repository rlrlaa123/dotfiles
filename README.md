---

# 📄 Dotfiles

개발환경 자동 세팅용 dotfiles
(Windows + WSL2 + Docker Desktop + MySQL 자동 기동 + Node.js + Python)

---

## 0) Windows 측 준비 (최초 1회)

1. WSL2 + Ubuntu 설치

   ```powershell
   wsl --install -d Ubuntu
   ```
2. Docker Desktop 설치

   * WSL2 기반 엔진 활성화
   * Ubuntu 통합 활성화
   * 자동 시작 옵션 켜기
3. VS Code + Remote WSL 확장 설치

---

## 1) Ubuntu 최초 1회 부트스트랩

```bash
sudo apt-get update -y
sudo apt-get install -y build-essential git curl vim tig htop jq make mysql-client \
  python3 python3-venv python3-pip python3-dev
```

* Node.js: `n` 으로 설치 후 `lts` 버전 사용, pnpm 활성화
* Python: `virtualenv`, `venv` 기본 세팅

---

## 2) Dotfiles 설치

```bash
git clone git@github.com:YOURNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## 3) SSH Key 설정 (최초 1회)

install.sh 실행 시, ~/.ssh/id_ed25519.pub 파일이 없으면 자동으로 SSH 키를 생성합니다.

* 생성된 공개키 출력 예시:
```bash
[install] SSH key not found, generating new key...
[install] Public key generated:
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB...
👉 위 키를 GitHub > Settings > SSH and GPG keys 에 등록하세요.
```
* GitHub에 등록한 후 연결 테스트:
```bash
ssh -T git@github.com
```
성공 시:
```bash
Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.
```
* 권한 설정 (install.sh에서 자동 적용):
** ~/.ssh → 700
** ~/.ssh/id_ed25519 → 600
** ~/.ssh/id_ed25519.pub → 644

### 레포 구조

```
dotfiles/
├── .bashrc               # 기본 + ~/.bashrc.d/*.sh 로딩
├── .bashrc.d/
│   └── dev.sh            # MySQL 자동 기동, alias 등
├── .config/dev/
│   ├── mysql.env
│   ├── docker-compose.yml
│   └── mysql-up.sh
├── install.sh            # 심볼릭 링크 스크립트
└── README.md
```

---

## 3) 주요 기능

* **.bashrc**: 시스템 기본 로딩 + `~/.bashrc.d/*.sh` 자동 실행
* **dev.sh**: MySQL 자동 기동, venv alias, mysqlc alias
* **docker-compose.yml**: MySQL 8.0 컨테이너
* **mysql-up.sh**: Docker 준비되면 MySQL 자동 실행
* **install.sh**: dotfiles → 홈 디렉토리 심볼릭 링크 생성

---

## 4) VS Code 사용 (WSL Remote)

1. VS Code 실행 → `><` → *WSL: Ubuntu* 선택
2. `cd ~/work && code .` 로 프로젝트 열기
3. 추천 확장: ESLint, Prettier, Tailwind CSS IntelliSense, Docker, GitLens, SQLTools

---

## 5) 빠른 검증 체크리스트

```bash
# Docker/MySQL
docker ps
mysqlc -e "SHOW DATABASES;"

# Node
node -v
pnpm -v

# Python venv
mkvenv && act && python -c "print('venv ok')"
```

## 6) CI / Husky 세팅

이 레포에는 `setup-ci-husky` 스크립트가 포함되어 있어, 새 프로젝트에서 쉽게
Husky(로컬 훅) + commitlint + lint-staged + GitHub Actions CI 를 구성할 수 있습니다.

### 1) 실행 방법
프로젝트 루트에서:
```bash
setup-ci-husky
git add -A
git commit -m "chore: setup husky/ci"
git push -u origin main
```

### 2) 생성되는 주요 파일
* .husky/pre-commit → 커밋 전에 lint-staged 실행 (변경 파일만 prettier/eslint fix)
* .husky/commit-msg → 커밋 메시지 규칙 검사 (Conventional Commits 강제)
* .husky/pre-push → 푸시 전에 typecheck + test 실행
* commitlint.config.cjs → 커밋 규칙 정의
* package.json → scripts, lint-staged 설정 추가
* .github/workflows/ci.yml → GitHub Actions CI 워크플로우 (lint/typecheck/test/build)

### 3) 로컬 vs 원격 역할
* 로컬 (Husky): 빠른 피드백
* pre-commit → 포맷 + 린트
* commit-msg → 커밋 메시지 룰 확인
* pre-push → 최소 안전망 (타입체크 + 테스트)
* 원격 (GitHub Actions CI): 풀 검증
* lint / typecheck / test / build 전체 실행
* PR / main push 시 자동으로 동작

### 4) 커밋 메시지 예시 (Conventional Commits)
* feat(auth): add OAuth login
* fix(api): handle null user
* chore: update dependencies
* docs(readme): add setup guide

### 5) 참고
* Husky는 prepare 스크립트로 자동 활성화됩니다.
* GitHub main 브랜치 보호 규칙에 CI 체크 필수를 걸어두면, PR 머지 전에 자동으로 품질 보장됩니다.
---
