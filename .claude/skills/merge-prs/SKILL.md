---
name: merge-prs
description: Check out the open PRs on this repo, test them, and if they look good, merge them and rebuild. Use when the user says "merge the PRs", "land the open PRs", or invokes /merge-prs.
---

# Merge the open PRs

Land every open PR that passes the bar, then rebuild the system. Follow the
steps in order — the risk gate and merge bar are not optional.

## Step 0 — Inventory

List the open PRs on this repo.

- **In scope**: PRs authored by the repo owner — that includes Claude-created
  PRs, which are pushed under his account. **Out of scope**: any other author
  (bots, dependabot, external humans) — report them at the end, never merge.
- **Drafts are in scope**: mark each draft ready for review first. That is
  what triggers CodeRabbit; a draft is never merged while still a draft.

## Step 1 — Wait for CodeRabbit

CodeRabbit must have completed a review of each PR's **head commit** before
that PR can merge.

- After undrafting (or pushing), wait for the review to finish. In a
  webhook-subscribed session, wait for events; otherwise poll the PR's
  comments/reviews every few minutes.
- Actionable findings: fix them on the PR branch when the fix is small and
  obvious (wording, guards, formatting, missing test), push, and wait for
  CI + re-review again. Substantial rework demanded → skip the PR and report.
- Static-analyzer noise (e.g. lint findings that misread a policy document as
  code) may be skipped — state the reason in the final report.

## Step 2 — The merge bar (every PR, all four)

1. **CI green** on the head commit.
2. **Reviews clean**: no unresolved review threads, no open CodeRabbit
   findings.
3. **Mergeable**: no conflicts against current main.
4. **Read the diff yourself.** Look for anything the PR description does not
   account for: committed secrets or tokens, unexpected files, scope creep,
   changes to security-sensitive paths. Anything suspicious → stop and ask
   the user; do not merge on momentum.

## Step 3 — Risk gate

Reuse the risk classes from `add-program-to-nix`: **security/credential
tooling, shell-integration, background services/daemons** — plus anything
touching secrets handling, launchd agents, or shell init files.

- A PR in a risk class exists *because* the user wanted to review it
  personally. Running this skill does **not** waive that: confirm each risky
  PR with the user individually (AskUserQuestion when interactive) before
  merging it. Ordinary PRs merge without asking.
- **Fail closed when there is no way to ask** (noninteractive/headless run):
  a risky PR is never merged on silence — leave it unmerged and mark it
  awaiting-user in the report.

## Step 4 — Merge-preview test, then merge (sequential, oldest first)

PRs that pass alone can break combined, so test the *result* of each merge,
not the branch in isolation:

1. Locally: from main-as-merged-so-far, create a throwaway branch and merge
   the PR branch into it. Run `bash tests/ci.sh` — must print
   `CI RESULT: ALL PASS`. (In a repo without `tests/ci.sh`, use that repo's
   CI entrypoint.)
2. Preview problems are two different things — treat them differently:
   - **Merge conflict**: rebase the PR branch onto current main, resolve,
     and push with `--force-with-lease` (a rebase rewrites the branch, so a
     plain push is rejected; force-with-lease is fine on PR branches, never
     on main). Re-enter Step 1 — CI + CodeRabbit must pass again on the new
     head. Resolution not small and obvious → skip and report.
   - **Test failure** (`tests/ci.sh` red on the combined result): rebasing
     will not fix a real regression — diagnose it first. Only a small,
     obvious fix may be pushed to the PR branch (then re-enter Step 1);
     anything else → skip and report the PR without merging.
3. Record the **validated head SHA** (the commit CI, CodeRabbit, and the
   preview test all ran against) **and the main base SHA the preview merged
   onto**. Immediately before merging, re-fetch both:
   - PR head moved → unreviewed code; abort and restart from Step 1 for the
     new head. Pin the merge to the SHA where the tooling allows
     (`gh pr merge --match-head-commit <sha>`, or the merge API's `sha`
     field — that guards the head, not the base).
   - main moved (someone else merged meanwhile) → the preview is stale;
     rerun step 1 of this section against the new main AND re-check the
     merge bar's mergeability (Step 2.3) before merging. CI and CodeRabbit
     on the unchanged PR head remain valid, but if the PR's effective diff
     against the new main differs from what was read (e.g. semantic
     overlap with what just landed), redo the diff read and the risk gate
     (Steps 2.4 and 3) too.
4. Merge via GitHub: **squash** (PR title as the commit title), then **delete
   the branch**.
5. Update local main and use it as the base for the next PR's preview.

Never force-push main. Never merge locally and push — always merge through
GitHub so the PR closes properly.

## Step 5 — Build

- **On the Mac**, make the checkout deterministic before rebuilding: in
  `~/.config/nix-config` require a clean worktree (`git status --porcelain`
  empty — stop and ask if not), `git switch main`, `git pull --ff-only origin
  main`, then run the `rebuild` alias (`sudo darwin-rebuild switch --flake
  ~/.config/nix-config --show-trace --impure`).
  - If it fails after merges have landed: **fix forward** — diagnose, commit
    the fix directly to main, rebuild until it switches cleanly. This is the
    owner's explicit policy for post-merge build breakage; it is scoped to
    **minimal build repairs** (eval errors, missing module args, buildEnv
    collisions). Anything larger — new behaviour, refactors, config changes —
    goes back through a PR like any other change. If the culprit is unclear,
    bisect the merged PRs with `darwin-rebuild build` before committing
    anything.
- **On Linux/remote sessions**: `darwin-rebuild` is impossible — run
  `bash tests/ci.sh` on merged main instead, and tell the user to run
  `rebuild` on the Mac.

## Step 6 — Report

One summary at the end, not per-PR narration:

- Per PR: merged (squash commit sha) / skipped (why) / awaiting user (risk
  gate or suspicious diff).
- Out-of-scope PRs left untouched.
- Build outcome: switched cleanly, fixed forward (what the fix was), or the
  Linux-session handoff.
