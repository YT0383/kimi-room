#!/bin/sh
set -e
rm -rf src/app/api
rm -f src/proxy.ts
rm -f src/app/opengraph-image.tsx
grep -rl force-dynamic src/app | xargs -r sed -i '/force-dynamic/d'
cat > next.config.ts <<'XEOF'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  images: { unoptimized: true },
  trailingSlash: true,
};

export default nextConfig;
XEOF
for f in $(find src/app -name page.tsx | grep "\["); do sed -i "/^export.*generateStaticParams/,/^}/d" "$f"; echo "export function generateStaticParams() { return [{ slug: \"_\" }]; }" >> "$f"; done
