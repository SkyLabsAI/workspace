Process & Tooling for Releases
==============================

The scripts in this directory are meant to help cutting simultaneous releases
for all the repositories of the workspace.

Overview of the Release Process
-------------------------------

Naming convention for release branches and tags:
- Release branch: `release/NAME`.
- Release candidate tag: `release-NAME-rcN` (starting at `N = 1`).
- Release tag: `release-NAME`.

The release process goes as follows:
1. Release branches named `release/NAME` are cut in all repositories.
2. Bug fixes are back-ported from the default branch via pull requests.
3. All `release/NAME` branches are tagged as `release-NAME-rcN`.
4. The release candidate is tested, and the process goes back to 2 if needed.
5. A stable release candidate is tagged as `release-NAME`.

Cutting Release Branches
------------------------

After making sure that you have the latest version of all repos (e.g., via the
`make status -j`), the following commands can be run to cut a release branch,
and then push it to the remote:
```sh
# Create a worktree for the release branch in ../workspace-NAME
./dev/release/cut-release-branch.sh NAME
cd ../workspace-NAME
# Check that that everything is in order.
make peek
# Push all the branches to the remote.
make push -j
```

Once the branches are pushed, others can create a corresponding worktree with
the following command.
```sh
./dev/release/add-release-worktree.sh NAME
```

To remove a release worktree, use the following command.
```sh
./dev/release/remove-release-worktree.sh NAME
```

Status of a Release Branch
--------------------------

Inside a release worktree, one can run the following command to get status
information like with `make status`.
```
./dev/release/status.sh
```
