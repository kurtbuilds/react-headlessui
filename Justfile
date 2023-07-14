set dotenv-load := true
export PATH := "./node_modules/.bin:" + env_var('PATH')

# Run the dev server
run:
    vite

check:
    tsc

install:
    pnpm install

# Builds the javascript bundle
build:
    test -n "${VITE_FATHOM_SITE_ID+1}" || ! echo "ERROR: VITE_FATHOM_SITE_ID is not set"
    vite build

# Creates the static site (including prerendering/SSG)
static: build
    # Create sitemap
    { ls -1 src/blog/*.mdx | sd '(.*).mdx' /'$1' ; echo /; }
    vite build --ssr src/entry-server.tsx --emptyOutDir false
    node prerender.js
    rm -rf dist/entry-server.js

watch-static:
    watchexec -- just static

# Serve the static build
serve:
    cd dist && python3 -m http.server