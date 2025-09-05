# --- Dev auto start (MySQL via Docker) ---
export DEV_AUTO_START=1
if [ "${DEV_AUTO_START}" = "1" ] && command -v docker >/dev/null 2>&1; then
  (~/.config/dev/mysql-up.sh >/dev/null 2>&1 &)
fi

# 편의 함수/별칭
mkvenv() { python3 -m venv .venv && . .venv/bin/activate && pip install --upgrade pip wheel setuptools; }
alias act="source .venv/bin/activate"
alias mysqlc="mysql -h 127.0.0.1 -P 3306 -uroot -proot climbing"
