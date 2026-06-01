# Agentic Reliability Pilot

A weekend-scale pilot testing a falsifiable thesis:

> **Tool-augmented LLMs produce statistically correct reliability analyses where unaugmented LLMs do not.**

The "correct" answer for each problem is whatever the canonical R packages
(`WeibullR`, `WeibullR.ALT`, `ReliaGrowR`) produce when driven correctly. We
compute it once and freeze it as an answer key (`ground_truth.json`). The
research question is whether the *agent* picks the right tool, passes correct
arguments (distribution, units, censoring), and reports the right numbers — not
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

A field passes if `abs(got - truth) / max(abs(truth), 1e-8) < tol`
(`DEFAULT_TOL = 0.05`; looser per-field overrides set in `problems.R`). A
problem passes only if **all** its fields pass. The grader extracts the last
parseable JSON object from the agent's reply, so the model is instructed to end
with a single JSON line such as `{"beta": 2.5, "eta": 80.0}`.

## What "pilot succeeded" means

- `ground_truth.json` reproduces known canonical values.
- `run_pilot.R` completes for C1 and C3 across both providers with no harness
  crashes.
- `results.csv` shows a **directional accuracy gap** (C3 > C1), plus visible
  recurring C1 error modes (wrong distribution, ignored censoring, the
  Arrhenius–Kelvin units trap, fabricated numbers instead of a tool call) —
  enough to decide whether the full benchmark study is worth building.
