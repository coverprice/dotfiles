# Git Stacked Diffs

Stacked Diffs are a method of breaking up large changes into chunks, separated by branch.

                              --+-+--+ extend_my_feature
                             /
                       --+--+          add_my_feature
                      /
               --+-+-+                 refactor_into_library
              /
    ---+--+--+                         master

Each sub-branch builds on its parent. In the example above, the first level branch is
a refactor to better organize the code, the second adds a feature, and the third extends
that feature.

This workflow allows the user to submit PRs for _each branch_, which means:
- Each PR is significantly smaller and more focused, and thus easier and quicker to review.
- Feedback from automated tests and colleagues arrives faster, because they can start
  testing/reviewing PRs earlier in development, vs waiting until the last branch is ready.

However the downside is that that this workflow requires the developer to carefully maintain
each branch. This document describes how to perform the common tasks.


## Creating a sub-branch from an existing branch

*Pattern:*

    git checkout -b <new branch> <parent branch>

*Example:*

    git checkout -b branch_03 branch_02

                              +      branch_03
                             /
                       --+--+        branch_02
                      /
               --+-+-+               branch_01
              /
    ---+--+--+                       master
 

## Rebasing after an intermediate branch changes

If commits are added to an intermediate branch (ex. code review feedback)
then these changes must be incorporated into the child branch(es).

*Example:*

Commits `A` and `B` were added on `branch_01`.

                       --+--+ branch_02
                      /
               --+-+-+--A-B   branch_01
              /
    ---+--+--+                master

To rebase `branch_02` to the tip of `branch_01`:

    git checkout branch_02
    git merge branch_01

                            C-+--+ branch_02
                           /
               --+-+-+--A-B        branch_01
              /
    ---+--+--+                     master

If the merge can't be simply fast-forwarded, then `C` _may_ be created as to store
any resolved conflicts.

*Alternative:* It's possibly to try rebasing `branch_02` on top of `branch_01`.
But doing so means that any merge conflicts must be resolved for _every commit_.
So `git merge` is the recommended way, since that will do it in one go.

    git checkout branch_02
    git rebase branch_01

                            --+--+ branch_02
                           /
               --+-+-+--A-B        branch_01
              /
    ---+--+--+                     master


## Re-parenting a branch after an intermediate branch was merged

We start with this layout.

                       --+--+ branch_02
                      /
               --+-+-X        branch_01
              /
    ---+--+--+                master

The `branch_01` PR is approved and landed upstream. So we do a `git pull` to bring it up-to-date:

    git checkout master
    git pull upstream master

                       --+--+ branch_02
                      /
               --+-+-X        branch_01
              /
    ---+--+--+-------Y        master      [Y here is the squashed merge of branch_01]


Alternatively, someone squashed and landed `branch_01` locally, which amounts to the same thing:

    git checkout master
    git merge --squash branch_01
    git commit


Now the contents of `branch_01` are on master, as commit `Y`, and `branch_01` is no longer
useful. `branch_02` needs to be re-parented onto its new parent, `master`:

*Pattern:*

    git rebase --onto <new parent> <old parent> <branch to re-parent>

*Example:*

    git rebase --onto master branch_01 branch_02

               --+-+-X        branch_01   [No longer useful]
              /
             |         --+--+ branch_02
             |        /
    ---+--+--+---+-+-Y        master

`branch_01` can now be deleted:

    git branch -D branch_01
