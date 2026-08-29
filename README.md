# Unofficial htmx skills pack

This is my packaging of the skill files that ship in the htmx repo. It is
**not** an official Big Sky or htmx product.

The folders follow the [Agent Skills](https://agentskills.io) layout
(`skills/<name>/SKILL.md`). Any coding agent that loads that format can use
them: Grok, Claude Code, Codex, Pi, and others.

htmx publishes those files as flat markdown in
[`dist/skills/`](https://github.com/bigskysoftware/htmx/tree/v4.0.0/dist/skills).
They have the right frontmatter, but they are not named `SKILL.md`, so skill
installers cannot track the upstream repo directly.

This repo only copies them into folders and records the upstream ref in
`UPSTREAM`. The skill bodies are unchanged.

```
skills/
  htmx-guidance/SKILL.md
  htmx-debugging/SKILL.md
  htmx-extension-authoring/SKILL.md
  htmx-upgrade-from-htmx2/SKILL.md
```

Replace `filippov-au` in the commands below if you fork the repo.

## Install (any harness)

The [skills CLI](https://www.npmjs.com/package/skills) writes each skill into
the directory your agent already scans:

```bash
# all four skills, user-wide, for the agents you name
npx skills add filippov-au/htmx-skills -g -a grok -a claude-code -a codex -a pi -y

# one agent
npx skills add filippov-au/htmx-skills -g -a claude-code -y
```

From a local clone, before GitHub exists:

```bash
npx skills add /Users/sun/work/htmx-skills -g -a grok -a claude-code -a codex -a pi -y
```

Omit `-g` to install into the current project instead of your home directory.

Then:

```bash
npx skills check
npx skills update
npx skills remove htmx-guidance htmx-debugging htmx-extension-authoring htmx-upgrade-from-htmx2
```

If you previously installed the raw htmx URLs into `~/.grok/skills/`, remove
those copies first so names do not collide:

```bash
npx skills remove htmx-guidance htmx-debugging -g -a grok -y
```

Native plugin commands below are optional. Prefer **one** path per agent
(skills CLI *or* that agent's plugin installer).

## Grok

**Install**

```bash
npx skills add filippov-au/htmx-skills -g -a grok -y
# or
grok plugin install filippov-au/htmx-skills --trust
```

**Update**

```bash
npx skills update
# or
grok plugin update htmx-skills
```

**Use**

- `/htmx-guidance`
- `/htmx-debugging`
- `/htmx-extension-authoring`
- `/htmx-upgrade-from-htmx2`

Or ask in chat (Grok also loads a skill when the description matches). Optional
marketplace: `grok plugin marketplace add filippov-au/htmx-skills`.

## Claude Code

**Install**

```bash
npx skills add filippov-au/htmx-skills -g -a claude-code -y
```

That writes `~/.claude/skills/<name>/`. Or as a plugin:

```
/plugin marketplace add filippov-au/htmx-skills
/plugin install htmx-skills@htmx-skills
```

Same from a shell: `claude plugin marketplace add filippov-au/htmx-skills`
then `claude plugin install htmx-skills@htmx-skills`.

**Update**

```bash
npx skills update
```

For a plugin install, re-run `/plugin install htmx-skills@htmx-skills` or use
Claude's plugin update UI.

**Use**

- `/htmx-guidance` (and the other three names)
- Plugin installs may show as `/htmx-skills:htmx-guidance`
- Or ask in chat; Claude loads the skill when the task matches the description

## Codex

**Install**

```bash
npx skills add filippov-au/htmx-skills -g -a codex -y
```

That writes `~/.codex/skills/<name>/`. For this repo only, omit `-g` (project
path is `.agents/skills/`).

Manual copy:

```bash
git clone https://github.com/filippov-au/htmx-skills /tmp/htmx-skills
mkdir -p ~/.codex/skills
cp -R /tmp/htmx-skills/skills/* ~/.codex/skills/
```

**Update**

```bash
npx skills update
```

Manual installs: `git pull` in the clone, then copy `skills/*` again.

**Use**

- `$htmx-guidance` (and the other three names)
- Or mention the skill in the prompt, e.g. "use htmx-guidance"

## Pi

**Install**

```bash
npx skills add filippov-au/htmx-skills -g -a pi -y
```

That writes `~/.pi/agent/skills/<name>/`. Project path is `.pi/skills/`.

Manual copy (Pi discovers `SKILL.md` recursively):

```bash
git clone https://github.com/filippov-au/htmx-skills ~/.pi/agent/skills/htmx-skills
```

**Update**

```bash
npx skills update
```

Manual installs: `git -C ~/.pi/agent/skills/htmx-skills pull`.

**Use**

- `/skill:htmx-guidance` (and the other three names)
- Or ask in chat; Pi loads the skill when the description matches

## Sync from the htmx repo

```bash
scripts/sync.sh           # ref from UPSTREAM, or v4.0.0
scripts/sync.sh v4.0.0    # pin a release
scripts/sync.sh master    # follow the default branch
```

Each upstream `*.md` becomes `skills/<name>/SKILL.md`. Commit and push; then
`npx skills update` (or the native plugin update) sees the change.

`.github/workflows/sync.yml` runs weekly (and on demand) and commits if
upstream changed. After you create the GitHub repo, enable Actions.

## Publish

```bash
gh repo create htmx-skills --public --source . --remote origin --push
```

## License

Skill bodies are copied from [htmx](https://github.com/bigskysoftware/htmx)
(0BSD). Packaging in this repo is also 0BSD. Not affiliated with Big Sky
Software.
