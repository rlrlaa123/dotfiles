#!/usr/bin/env bash
set -euo pipefail

# 0) 체크
command -v pnpm >/dev/null || { echo "pnpm이 필요합니다. npm i -g pnpm 후 재시도"; exit 1; }
[ -f package.json ] || { echo "package.json이 없습니다. 프로젝트 루트에서 실행하세요."; exit 1; }

echo "== Install dev deps =="
pnpm add -D husky lint-staged @commitlint/cli @commitlint/config-conventional vitest @types/node typescript prettier eslint

echo "== Husky init =="
npx husky init

echo "== commitlint.config.cjs =="
cat > commitlint.config.cjs <<'EOF'
module.exports = { extends: ['@commitlint/config-conventional'] };
EOF

echo "== package.json patch =="
node - <<'NODE'
const fs=require('fs'); const p=require('./package.json');

p.scripts ||= {};
p.scripts.lint ??= "eslint .";
p.scripts.format ??= "prettier -w .";
p.scripts.typecheck ??= "tsc -p tsconfig.json --noEmit";
p.scripts.test ??= "vitest run";
p.scripts["test:watch"] ??= "vitest";
p.scripts.prepare = "husky";

p["lint-staged"] ||= {
  "**/*.{ts,tsx,js,jsx,json,md,css,scss}": ["prettier -w", "eslint --fix"]
};

fs.writeFileSync('package.json', JSON.stringify(p, null, 2) + '\n');
NODE

# tsconfig가 없으면 최소 생성
if [ ! -f tsconfig.json ]; then
  echo "== tsconfig.json =="
  cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "jsx": "react-jsx",
    "strict": true,
    "skipLibCheck": true,
    "noEmit": true,
    "types": ["vitest/globals"]
  },
  "include": ["**/*.ts", "**/*.tsx"]
}
EOF
fi

echo "== .editorconfig =="
cat > .editorconfig <<'EOF'
root = true
[*]
end_of_line = lf
charset = utf-8
indent_style = space
indent_size = 2
insert_final_newline = true
EOF

echo "== Husky hooks =="
# pre-commit
cat > .husky/pre-commit <<'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"
pnpm lint-staged
EOF
chmod +x .husky/pre-commit

# commit-msg
cat > .husky/commit-msg <<'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"
pnpm commitlint --edit "$1"
EOF
chmod +x .husky/commit-msg

# pre-push
cat > .husky/pre-push <<'EOF'
#!/usr/bin/env sh
. "$(dirname -- "$0")/_/husky.sh"
pnpm typecheck && pnpm test
EOF
chmod +x .husky/pre-push

echo "== GitHub Actions CI =="
mkdir -p .github/workflows
cat > .github/workflows/ci.yml <<'YAML'
name: CI
on:
  pull_request:
  push:
    branches: [main]
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with: { version: 9 }
      - uses: actions/setup-node@v4
        with:
          node-version: 'lts/*'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm lint
      - run: pnpm typecheck
      - run: pnpm test
      - run: pnpm build || echo "skip build (optional)"
YAML

echo "== Vitest 기본 설정(선택) =="
cat > vitest.config.ts <<'EOF'
import { defineConfig } from 'vitest/config';
export default defineConfig({
  test: {
    environment: 'node',
    coverage: { reporter: ['text', 'lcov'] }
  }
});
EOF

# 샘플 테스트
mkdir -p src
cat > src/sample.test.ts <<'EOF'
import { describe, it, expect } from 'vitest';
describe('sample', () => {
  it('works', () => { expect(1 + 1).toBe(2); });
});
EOF

echo "== Done =="
echo "다음 실행:"
echo "  1) git add -A"
echo "  2) git commit -m 'chore: setup husky/ci/lint-staged/commitlint'"
echo "  3) git push -u origin main (또는 PR 생성)"

