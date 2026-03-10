run: build
    love game

test: build
    love game /test

[working-directory: 'crystal/lib']
build:
    cargo build --release
