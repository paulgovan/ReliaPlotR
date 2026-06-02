# Agentic Reliability Pilot

A weekend-scale pilot testing a thesis framed around **verifiability**, not raw
accuracy:

> **Tool-augmented reliability analysis is verifiable, reproducible, and
> auditable by construction; unaugmented LLM analysis is not — regardless of how
> capable the base model becomes.**

Why this framing: a raw accuracy gap between tool-augmented (C3) and LLM-alone
(C1) conditions shrinks as base models improve, so a finding pinned to it has a
short shelf life. The durable contrast is that a C3 answer is *provably* the
canonical `WeibullR`/`WeibullR.ALT`/`ReliaGrowR` output, carries a full
tool-call audit trail (which distribution, which units, which censoring), and
reproduces deterministically — whereas a C1 answer is unverifiable and
unreproducible even when it happens to be numerically right. In certification /
safety-critical contexts (aerospace, medical, nuclear) an unverifiable
computation is disqualifying, so this contrast strengthens rather than decays as
models improve.

Accuracy is still measured — as a secondary, capability-dependent *symptom* —
but the headline is the verifiability axis.

The "correct" answer for each problem is whatever the canonical R packages
produce when driven correctly. We compute it once and freeze it as an answer key
(`ground_truth.json`). The research question is whether the *agent* picks the
right tool, passes correct arguments, and reports a *traceable* number — not
whether the underlying statistics are right.

This directory is `.Rbuildignore`d and never ships in the package or affects
`R CMD check`.

## Layout

| File | Role |
|------|------|
| `problems.R` | 10 problem definitions (data + question + answer-key spec + canonical `truth_fun`) |
| `make_ground_truth.R` | Runs each `truth_fun`, writes `ground_truth.json` |
| `ground_truth.json` | Frozen answer key (generated) |
| `harness.R` | Drives `ellmer` chats across conditions × providers for each problem |
| `grade.R` | Parses agent answers, scores relative error vs ground truth |
| `run_pilot.R` | Orchestrates harness + grader, writes `results.csv` |
| `results.csv` | Per-run scores (generated) |
| `responses.jsonl` | Raw per-run JSON, one line each (generated) |

## Conditions

- **C1 — LLM alone:** no tools; the model must reason/compute from the raw data.
- **C3 — tool-augmented:** the `ReliaPlotR`/`ReliaGrowR` `ellmer::tool()` objects
  are registered, so the model drives the canonical pipeline via tool calls.
- **C2 — LLM + code** *(optional, OFF by default):* registers a single R-eval
  tool so the model can write and run its own R. Executes model-written code, so
  it is only enabled with `PILOT_ENABLE_C2=1` in a trusted environment.

C1-vs-C3 is the clean headline contrast.

## Prerequisites

```r
install.packages(c("ellmer", "jsonlite"))   # ellmer >= 0.4.0
# plus the package stack: WeibullR, WeibullR.ALT, ReliaGrowR, plotly
```

The harness loads `ReliaPlotR` from the installed package or, failing that, via
`devtools::load_all(".")` on the local source tree.

## Run

From the repo root, with API keys exported:

```bash
export ANTHROPIC_API_KEY=...
export OPENAI_API_KEY=...

Rscript benchmark/make_ground_truth.R   # writes ground_truth.json
Rscript benchmark/run_pilot.R           # runs harness + grader -> results.csv
```

`run_pilot.R` prints accuracy by condition × provider and mean tool calls by
condition. The pilot is small: ~10 problems × 2 conditions × 2 providers ≈ 40
runs.

### Environment overrides

| Variable | Default | Meaning |
|----------|---------|---------|
| `PILOT_PROVIDERS` | `anthropic,openai` | comma list of providers |
| `PILOT_CONDITIONS` | `C1,C3` | comma list of conditions |
| `PILOT_ENABLE_C2` | unset | set to `1` to enable the code-execution condition |
| `ANTHROPIC_MODEL` | `claude-sonnet-4-6` | Anthropic model id |
| `OPENAI_MODEL` | `gpt-4o` | OpenAI model id |
| `PILOT_PROBLEMS` | (all) | comma list of problem ids to restrict to |

Example — Anthropic only, two problems, all three conditions:

```bash
PILOT_PROVIDERS=anthropic PILOT_CONDITIONS=C1,C2,C3 PILOT_ENABLE_C2=1 \
  PILOT_PROBLEMS=01_weibull_mle,09_crow_amsaa \
  Rscript benchmark/run_pilot.R
```

## Problems

| id | domain | task | answer key |
|----|--------|------|------------|
| `01_weibull_mle` | life | Weibull 2p MLE, complete data | beta, eta |
| `02_weibull_rr` | life | Weibull rank regression (`rr-xony`) | beta, eta, r2 |
| `03_weibull_susp` | life | Weibull MLE with suspensions | beta, eta |
| `04_lognormal_mle` | life | Lognormal MLE | mulog, sigmalog |
| `05_weibull3p` | life | 3-parameter Weibull MLE | beta, eta, gamma |
| `06_b10_life` | life | B10 life derived from a Weibull MLE fit | b10 |
| `07_alt_arrhenius` | alt | Weibull + Arrhenius life-stress (Kelvin) | coef1, coef2 |
| `08_alt_power` | alt | Weibull + inverse power law life-stress | coef1, coef2 |
| `09_crow_amsaa` | growth | Crow-AMSAA (Power Law NHPP), least squares | lambda, beta |
| `10_duane` | repairable | Duane log-log MTBF regression | slope, intercept |

## Grading

Two axes per run.

**Accuracy (symptom).** A field passes if
`abs(got - truth) / max(abs(truth), 1e-8) < tol` (`DEFAULT_TOL = 0.05`; looser
per-field overrides set in `problems.R`). A problem passes only if **all** its
fields pass. The grader extracts the last parseable JSON object from the agent's
reply, so the model is instructed to end with a single JSON line such as
`{"beta": 2.5, "eta": 80.0}`.

**Verifiability (durable).** Each row also records:

- `grounded` — the reported answer is backed by an actual tool call
  (`n_tool_calls > 0`). Always `FALSE` for C1 (no tools); a correct-but-ungrounded
  C3 answer (model guessed instead of calling the tool) is flagged here.
- `reproducible` — `TRUE` for grounded runs, which carry the version stamp +
  `tool_trace` and reproduce by construction.
- `tool_trace` — the ordered `{name, arguments}` audit trail (the evidence of
  which distribution / method / units / censoring the agent passed).
- `model_version` — model id plus pinned `WeibullR` / `WeibullR.ALT` /
  `ReliaGrowR` / `ReliaPlotR` / `ellmer` versions, for provenance.

`run_pilot.R` prints the verifiability table first (grounded/reproducible rate
by condition), then the accuracy table.

## What "pilot succeeded" means

- `ground_truth.json` reproduces known canonical values.
- `run_pilot.R` completes for C1 and C3 across both providers with no harness
  crashes; every C3 row is `grounded`/`reproducible`, every C1 row is not.
- The **verifiability table** shows the structural contrast (C3 ≈ 100%
  reproducible vs C1 = 0%) that holds independent of model capability; the
  accuracy gap (C3 > C1) is reported as a secondary symptom, with recurring C1
  error modes visible in the `tool_trace` (wrong distribution, ignored
  censoring, the Arrhenius–Kelvin units trap, fabricated numbers instead of a
  tool call) — enough to decide whether the full study is worth building.
