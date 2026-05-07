Dune Commands
=============

This package provides a program called `dune-commands`, which can extract the
run command from a JSONL dune trace.

It can be used as follows.
```sh
dune trace cat > trace.jsonl
dune exec -- dune-commands --json --trace-file trace.jsonl > commands.json
```

Run `dune-commands --help` for more information.
