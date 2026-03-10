run: build
    love game

test: build
    love game /test

crystal-test: build
    love crystal/runtime /test

[working-directory: 'crystal/lib']
build:
    cargo build --release

upstream:
    git subrepo pull crystal
    git subrepo push crystal
