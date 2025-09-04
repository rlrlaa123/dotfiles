# --- Load system default ---
[ -f /etc/bash.bashrc ] && . /etc/bash.bashrc

# --- Load user custom scripts (~/.bashrc.d/*.sh) ---
for f in ~/.bashrc.d/*.sh; do
  [ -r "$f" ] && . "$f"
done
unset f

