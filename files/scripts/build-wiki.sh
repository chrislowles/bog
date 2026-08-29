#!/usr/bin/env bash
set -euo pipefail

# Converts the markdown sources under wiki/src into static HTML pages under wiki/html, wrapped in a shared sidebar-nav template. Runs at build time so the shipped image needs no JS runtime or network access to browse it.

WIKI_ROOT=/usr/share/bog/wiki
SRC_DIR="${WIKI_ROOT}/src"
OUT_DIR="${WIKI_ROOT}/html"

rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"
cp -r "${WIKI_ROOT}/assets" "${OUT_DIR}/assets"

# First pass: collect (slug, title) pairs in filename order so every page can render an identical nav. Slugs strip the leading NN- ordering prefix.
slugs=()
titles=()
for src in "${SRC_DIR}"/*.md; do
    slug="$(basename "${src}" .md | sed -E 's/^[0-9]+-//')"
    title="$(grep -m1 '^# ' "${src}" | sed -E 's/^#[[:space:]]*//')"
    slugs+=("${slug}")
    titles+=("${title}")
done

render_nav() {
    local current="$1" i
    echo "<ul>"
    for i in "${!slugs[@]}"; do
        if [[ "${slugs[$i]}" == "${current}" ]]; then
            echo "<li><a class=\"active\" href=\"${slugs[$i]}.html\">${titles[$i]}</a></li>"
        else
            echo "<li><a href=\"${slugs[$i]}.html\">${titles[$i]}</a></li>"
        fi
    done
    echo "</ul>"
}

render_page() {
    local slug="$1" title="$2" body="$3" out="$4"
    cat <<HTML > "${out}"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="color-scheme" content="light dark">
<title>${title} / bog wiki</title>
<link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="wiki-layout">
<nav class="wiki-nav">
<a class="wiki-brand" href="index.html">bog wiki</a>
$(render_nav "${slug}")
</nav>
<main class="wiki-content">
${body}
</main>
</div>
</body>
</html>
HTML
}

count=0
for src in "${SRC_DIR}"/*.md; do
    slug="$(basename "${src}" .md | sed -E 's/^[0-9]+-//')"
    title="$(grep -m1 '^# ' "${src}" | sed -E 's/^#[[:space:]]*//')"
    body="$(cmark --unsafe "${src}")"
    render_page "${slug}" "${title}" "${body}" "${OUT_DIR}/${slug}.html"
    if [[ "${slug}" == "home" ]]; then
        cp "${OUT_DIR}/${slug}.html" "${OUT_DIR}/index.html"
    fi
    count=$((count + 1))
done

echo "bog Wiki: built ${count} page(s) into ${OUT_DIR}"