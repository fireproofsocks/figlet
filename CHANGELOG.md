# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.3.1

Removes "fonts/*" as a requirement for the package (because it has been moved)

## v0.3.0

Finally I gave in to convention and moved the fonts folder inside `priv/`.
Bumps deps for better documentation visibility.
Removes some commented-out code.

## v0.2.0

Moved fonts to `fonts/` folder; this directory should now be included with the package.
Work to support referencing these fonts when `figlet` is used as dependency
Included fonts are now identified by their relative path, e.g. "figlet.js/Alpha.flf"
Various documentation improvements

## v0.1.0

Initial POC release. Lacks support for screen widths, unicode characters, and text squashing.
