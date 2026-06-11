This tool allows a user to define a dune alias for a given list of files. It is meant to be used in combination with `dune build --watch`.

Suppose one is working on a specification for the C++ file `fmdeps/auto/dir/foo.cpp`. One can create an alias `@foo-bar` by listing the relevant files in `build-list/foo-bar.yml`. We may want to list `foo.cpp`, `foo_cpp_spec.v` and a test file `test.v`. We can then compile them with `dune build @foo-bar`.

# Workflow

When starting a specification task, we can use a build list to monitor specific files downstream to find breakages quickly. We may begin by typing the following in a first terminal session:

```
term1 - workspace $ touch build-list/foo-bar.yml
term1 - workspace $ dune build @foo-bar --watch
```

Then we can start writing the code and use a second terminal session to update the build list:

```
term2 - workspace $ touch fmdeps/auto/dir/foo.cpp
term2 - workspace $ echo "- fmdeps/auto/dir/foo.cpp" >> build-list/foo-bar.yml
     #
     #  ... write some code ...
     #
term2 - workspace $ touch fmdeps/auto/dir/foo_cpp_spec.v
term2 - workspace $ echo "- fmdeps/auto/dir/foo_cpp_spec.v" >> build-list/foo-bar.yml
     #
     #  ... write some specifications ...
     #
term2 - workspace $ touch fmdeps/auto/dir/test.v
term2 - workspace $ echo "- fmdeps/auto/dir/test.v" >> build-list/foo-bar.yml
     #
     #  ... write a test case ...
     #
```

When we are satisfied, we commit, push, create a pull request and wait for CI to terminate. Ooops! We broke the build:

```
fmdeps/auto/somewhere-else/unrelated.v: error: something went wrong
fmdeps/auto/some-other-project/that-spec.v: error: this is broken too
```

Back to the drawing board! But now we need to keep our eye on those seemingly unrelated files:

```
term2 - workspace $ echo "- fmdeps/auto/somewhere-else/unrelated.v" >> build-list/foo-bar.yml
term2 - workspace $ echo "- fmdeps/auto/some-other-project/that-spec.v" >> build-list/foo-bar.yml
```

Since `dune build @foo-bar --watch` is still running, as we modify our code and specs, we'll keep getting feed back on the files that we accidentally broke.

# Other targets

Beside `.v` files, one can add:
 - `.cpp` file names to build their AST;
 -  dune aliases -- include the path to desired alias, put `@` or `@@` in front and put in quotation marks: `- "@fmdeps/auto/test"`
 - directory names -- write the path followed by `/*`
