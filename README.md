# Unofficial htmx skills pack for Grok

This is my packaging of the skill files that ship in the htmx repo. It is
**not** an official Big Sky or htmx product.

htmx publishes agent skills as flat markdown in
[`dist/skills/`](https://github.com/bigskysoftware/htmx/tree/v4.0.0/dist/skills).
Those files have the right frontmatter, but they are not named `SKILL.md`, so
`npx skills add bigskysoftware/htmx` and Grok’s plugin updater cannot track
them.

This repo copies those files into the layout both tools expect:

```
skills/
  htmx-guidance/SKILL.md
  htmx-debugging/SKILL.md
  htmx-extension-authoring/SKILL.md
  htmx-upgrade-from-htmx2/SKILL.md
```

I do not edit the skill bodies. I only rename them into folders and record the
upstream ref in `UPSTREAM`.

## Install in Grok

After you push this repo to GitHub (replace `filippov-au` if needed):

```bash
# Skills CLI — tracked, so check/update work
npx skills add filippov-au/htmx-skills -g -a grok -y

# or Grok plugin
grok plugin install filippov-au/htmx-skills --trust
```

From a local clone, before it is on GitHub:

```bash
npx skills add /Users/sun/work/htmx-skills -g -a grok -y
# or
grok plugin install /Users/sun/work/htmx-skills --trust
```

Pick **one** of those two install paths. Installing both copies the same skills
twice.

If you already installed the raw GitHub URLs into `~/.grok/skills/`, remove
those copies first so names do not collide:

```bash
npx skills remove htmx-guidance htmx-debugging -g -a grok -y
```

## Update

```bash
# Skills CLI install
npx skills check
npx skills update

# Grok plugin install
grok plugin update htmx-skills
```

Those commands pull **this** repo. They pick up new upstream text only after
this repo is synced (script or GitHub Action below).

## Sync from the htmx repo

```bash
scripts/sync.sh           # ref from UPSTREAM, or v4.0.0
scripts/sync.sh v4.0.0    # pin a release
scripts/sync.sh master    # follow the default branch
```

Each upstream `*.md` becomes `skills/<name>/SKILL.md`. Commit and push; then
`npx skills update` / `grok plugin update` sees the change.

`.github/workflows/sync.yml` runs weekly (and on demand) and commits if
upstream changed. After you create the GitHub repo, enable Actions.

## Publish the GitHub repo

From this directory:

```bash
gh repo create htmx-skills --public --source . --remote origin --push
```

Then install from `filippov-au/htmx-skills` as above.

Optional TUI marketplace:

```bash
grok plugin marketplace add filippov-au/htmx-skills
```

## License

Skill bodies are copied from [htmx](https://github.com/bigskysoftware/htmx)
(0BSD). Packaging in this repo is also 0BSD. Not affiliated with Big Sky
Software.
