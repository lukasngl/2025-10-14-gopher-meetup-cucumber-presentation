_default:
    just --choose

build: build-presentation build-handout

build-presentation:
    typst compile --root . ./slides/presentation.typ
    polylux2pdfpc --root . ./slides/presentation.typ

build-handout:
    typst compile --root . ./slides/handout.typ

watch:
    typst watch --root . ./slides/presentation.typ

fmt *args="--allow-missing-formatter":
    treefmt {{ args }}
