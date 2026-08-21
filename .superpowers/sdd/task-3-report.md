# Task 3 Report: Fix diagnostico_modelo() Graphic Print

## Status: ✅ COMPLETED

## Commit SHA
`12a37e0`

## Problem
`diagnostico_modelo(model, plot=TRUE)` stored the `performance::check_model()` result in `grafico` but never printed it. The user saw no graphic output.

## Fix Applied

### File: `R/diagnosticos-modelos.R` (line 80)
Added `print(grafico)` after the grafico assignment, inside the `if (requireNamespace("performance", ...))` block:

```r
grafico <- if (isTRUE(plot)) .safe_call(performance::check_model(model)) else NULL
if (isTRUE(plot) && !is.null(grafico)) print(grafico)   # <-- NEW LINE
```

The function still returns `grafico` in the output list invisibly, so programmatic access is unchanged.

## Tests Added

### File: `tests/testthat/test-diagnosticos-novas.R`
Two new test cases appended:

1. **`diagnostico_modelo returns grafico=NULL when plot=FALSE`** — Confirms `grafico` is `NULL` when `plot=FALSE`.
2. **`diagnostico_modelo returns non-NULL grafico when plot=TRUE`** — Confirms `grafico` is a non-NULL object when `plot=TRUE` (skips if `performance` is not installed).

## Test Summary
```
══ DONE ══
🥇 Your tests deserve a gold medal 🥇
```
- **Failures: 0**
- **Warnings: 4** (pre-existing, unrelated to this change)
- All 15 test files pass.

## Files Changed
- `R/diagnosticos-modelos.R` — 1 line added
- `tests/testthat/test-diagnosticos-novas.R` — 14 lines added (2 test blocks)

## Verification
- `pkgload::load_all('.')` — successful
- `testthat::test_local(path='.', reporter='summary')` — 0 failures
