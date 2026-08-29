# Official htmx skills, packaged for Grok

Big Sky ships htmx 4 agent skills as flat markdown files in
[`dist/skills/`](https://github.com/bigskysoftware/htmx/tree/v4.0.0/dist/skills).
Those files have the right frontmatter, but they are **not** named `SKILL.md`,
so `npx skills add bigskysoftware/htmx` and Grok’s plugin updater cannot track
them.

This repo copies those official files into the layout both tools expect:

```
skills/
  htmx-guidance/SKILL.md
  htmx-debugging/SKILL.md
  htmx-extension-authoring/SKILL.md
  htmx-upgrade-from-htmx2/SKILL.md
```

Content stays official. This repo only repacks it and records the upstream ref
in `UPSTREAM`.

## Install in Grok

After you push this repo to GitHub (replace `filippov-au` if needed):

```bash
# Skills CLI — tracked, so check/update work
npx skills add filippov-au/htmx-official-skills -g -a grok -y

# or Grok plugin
grok plugin install filippov-au/htmx-official-skills --trust
```

From a local clone, before it is on GitHub:

```bash
npx skills add /Users/sun/work/htmx-official-skills -g -a grok -y
# or
grok plugin install /Users/sun/work/htmx-official-skills --trust
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
grok plugin update htmx-official-skills
```

Those commands pull **this** repo. They pick up new official text only after
this repo is synced (script or GitHub Action below).

## Sync official files

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
git init
git add .
git commit -m "Package official htmx 4 skills"
gh repo create htmx-official-skills --public --source . --remote origin --push
```

Then install from `filippov-au/htmx-official-skills` as above.

Optional TUI marketplace:

```bash
grok plugin marketplace add filippov-au/htmx-official-skills
```

## License

Skill bodies are from [htmx](https://github.com/bigskysoftware/htmx) (0BSD).
Packaging in this repo is also 0BSD.
