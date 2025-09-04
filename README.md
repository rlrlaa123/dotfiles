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

---
