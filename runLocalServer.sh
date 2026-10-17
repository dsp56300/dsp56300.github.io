#!/bin/sh
# macOS/Linux counterpart of runLocalServer.bat.
# The github-pages gem needs Ruby 3, which macOS doesn't ship, so prefer Homebrew's
# ruby@3.3 (the version GitHub Pages builds with): brew install ruby@3.3
for prefix in /opt/homebrew/opt/ruby@3.3 /usr/local/opt/ruby@3.3; do
  if [ -x "$prefix/bin/ruby" ]; then
    PATH="$prefix/bin:$PATH"
    break
  fi
done

cd "$(dirname "$0")" || exit 1
bundle check >/dev/null 2>&1 || bundle install || exit 1
exec bundle exec jekyll serve --port 4001 "$@"
