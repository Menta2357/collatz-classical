# ELIAHOU1993_LOCAL_STATEMENT_FIDELITY_AUDIT_v1

Fecha: 2026-07-05, Europe/Madrid.

Estado: auditoria local privada de fidelidad de statement. No publicada en Forum. No registrada como audit report en CC Challenge.

## Guardarrailes

- NO_FORUM_POST: no se publico ni creo Discussion.
- NO_AUDIT_LINK: no se creo audit link ni se hizo POST/PATCH en CC Challenge.
- NO_OFFICIAL_CC_CLAIM: esto no es una auditoria oficial ni una recomendacion publica.
- NO_GLOBAL_COLLATZ_CLAIM: no se afirma ningun resultado global de Collatz.
- NO_OVERCLAIM_IF_PARTIAL: el resultado se clasifica como formalizacion parcial/plausible, no como Theorem 1.1 completo.
- NO_BUILD: no se ejecuto `lake build`, `lake env`, ni `lake exe cache get`; esta fase fue statement-only.

## Base leida

- `docs/ELIAHOU1993_AUDIT_PHASE1_PREP_v1.md`
- `docs/COORDINATED_VERDICT_2026_07_05_v1.md`
- `audits/ADVERSARIAL_AUDIT_CHECKLIST_v1.md`
- Formalizacion: `https://github.com/tangentstorm/eliahou-collatz-bounds`

Decision de coordinacion aplicada:
- `FORUM_ANNOUNCEMENT_DEFERRED`.
- No publicar Forum todavia.
- No crear audit link.
- No claim de auditoria oficial.

## Commit auditado

Repositorio local inspeccionado:
- path: `/Users/MoiTam/Documents/Codex/2026-07-05/tarea-cc-challenge-audit-entry-phase0/work/eliahou-collatz-bounds`
- remote: `https://github.com/tangentstorm/eliahou-collatz-bounds.git`
- commit: `fdb0b2e1ac0d774f4e288ffa2106785efd351563`
- fecha: `2026-04-09 20:43:12 -0400`
- subject: `removed unused/unproven 'precise' reformulation`
- Lean toolchain: `leanprover/lean4:v4.28.0`
- Mathlib rev: `v4.28.0`

Archivos inspeccionados:
- `README.md`
- `ARISTOTLE_SUMMARY.md`
- `Collatz/README.md`
- `Collatz/Defs.lean`
- `Collatz/ProductFormula.lean`
- `Collatz/Sandwich.lean`
- `Collatz/ContinuedFractions.lean`

## Resumen ejecutivo

La formalizacion id 6 debe tratarse como `consequence-only`: formaliza la consecuencia

```lean
17087915 <= L
```

para una estructura `CollatzCycle L` con `minElem > 2^40` y `0 < numOdd`. No contiene la forma lineal completa de Eliahou Theorem 1.1

```text
Card Omega = 301994 a + 17087915 b + 85137581 c
```

con las condiciones sobre `a,b,c`.

El principal punto semantico no es la aritmetica de la cota, sino el puente `Card Omega` del paper vs el parametro `L` de `CollatzCycle L`. La estructura Lean representa una orbita periodica indexada; no exige `Nodup`, inyectividad ni periodo minimo. Por tanto, `L` puede estar inflado si se recorre el mismo ciclo varias veces. Para recuperar el statement del paper hace falta suministrar o construir una instancia de periodo exacto para cada ciclo del paper. Ese puente no aparece en el repo.

La hipotesis extra `hk : 0 < c.numOdd` parece matematicamente derivable para ciclos positivos reales de `T`, pero esta derivacion no esta incluida como lemma y queda como hipotesis agregada en el theorem central.

Veredicto local:
- `CONSEQUENCE_ONLY_STATUS_CONFIRMED`.
- `PARTIAL_FORMALIZATION_PLAUSIBLE`.
- No hay base para presentarla como formalizacion completa del Theorem 1.1 lineal.
- Antes de audit link publico conviene preguntar si el scope registrado pretendido es "lower-bound consequence" y no "full Theorem 1.1".

## Tabla paper statement vs Lean statement

| Item | Paper statement | Lean statement inspected | Classification | Notes |
|---|---|---|---|---|
| Definicion de `T` | `T : N -> N`, `T(n)=n/2` si `n` par, `T(n)=(3n+1)/2` si `n` impar, con `N={1,2,...}`. | `collatzComp (n : Nat) := if n % 2 = 0 then n / 2 else (3 * n + 1) / 2` in `Defs.lean:18-21`; `CollatzCycle.pos` excludes 0. | MATCH | Domain is `Nat`, but cycle objects require positive entries, so the domain mismatch is benign for cycle statements. |
| Definicion de ciclo | Paper cycle `Omega` is a trajectory/orbit set with finite cardinality `Card Omega` and `T^k(x)=x` for all `x in Omega`, with `k=Card Omega`. | `structure CollatzCycle (L : Nat)` has `seq : Fin L -> Nat`, positivity, and one-step periodicity `T(seq i)=seq(i+1 mod L)` in `Defs.lean:40-46`. | PARTIAL | Lean represents periodic indexed sequences, not orbit sets. No distinctness or minimal-period condition is required. |
| Longitud `Card Omega` vs `L` | Paper length is set cardinality / period of the cycle. | The theorem concludes about the type parameter `L`; `Finset.card_fin` is used internally for index count, not orbit cardinality. | AMBIGUOUS | `L` matches `Card Omega` only for an exact-period/no-duplication instance. The repo lacks a bridge theorem from paper cycles to exact `CollatzCycle L`. |
| No trivialidad | Theorem 1.1 starts with a nontrivial cycle and the proviso `min Omega > 2^40`. | `isNontrivial c := 2 < c.minElem` exists in `Defs.lean:89-93`, but `eliahou_bound` does not use it; it assumes `2^40 < c.minElem`. | MATCH | For Theorem 1.1 with the `min > 2^40` proviso, explicit `isNontrivial` is unnecessary because `2^40 < minElem` implies nontriviality. |
| Theorem 1.1 forma lineal | If `Omega` is nontrivial and `min Omega > 2^40`, then `Card Omega = 301994 a + 17087915 b + 85137581 c`, with `a,b,c >= 0`, `b > 0`, `a c = 0`. | No theorem with this conclusion exists in current code. README/Summary mention `eliahou_precise`, but current commit removed the unused/unproven precise reformulation. | GAP | Full linear form is not formalized. This is the clearest scope limitation. |
| Consecuencia `17087915 <= L` | The linear form implies the smallest admissible `Card Omega` is at least `17087915`. | `eliahou_bound` in `ContinuedFractions.lean:200-211`: `(hmin : 2^40 < c.minElem) (hk : 0 < c.numOdd) : 17087915 <= L`. | PARTIAL | Correctly targets the lower-bound consequence for indexed cycles. Needs exact-period bridge and derivation of `hk` to match paper cycles. |
| Theorem 2.1 | `log_2(3+1/M) < Card Omega / Card Omega_1 <= log_2(3+1/m)`, plus a sharper right inequality. | `eliahou_sandwich` gives non-strict lower `<=` and upper `<=` in `Sandwich.lean:95-101`; `log2_three_lt_ratio` gives `log_2 3 < L/numOdd` in `Sandwich.lean:103-113`. | PARTIAL | Enough for the main lower-bound route, but not a literal formalization of the strict lower inequality nor the sharper right inequality. |
| Lemma 2.2 | Product over odd elements `Omega_1`: `prod_{n in Omega_1}(3+n^-1)=2^k`, where `k=Card Omega`. | `eliahou_product_formula_real` proves product over odd indices equals `(2 : R)^L` in `ProductFormula.lean:127-133`. | PARTIAL | Algebra matches for an exact no-duplicate cycle. With repeated indexed cycles, Lean product is over odd indices with multiplicity, not over the paper's set `Omega_1`. |
| Corollary 2.3 | Defines `K(m)` and `L(m)` from the approximation interval and derives lower bounds for `Card Omega` and `Card Omega_1`. | No `K(m)`/`L(m)` definitions or Corollary 2.3 theorem found. `rational_approx_bound` gives the numerical route directly. | GAP | Corollary structure is not formalized; only the downstream numerical lower-bound path is present. |
| Hipotesis `min Omega > 2^40` | Explicit proviso in Theorem 1.1. The unconditional nontrivial-cycle consequence uses external computation below `2^40`. | `hmin : (2 : Nat)^40 < c.minElem` is explicit in `eliahou_bound`. | MATCH | The theorem matches the conditional statement, not the external computational bridge to all nontrivial cycles. |
| Hipotesis Lean `hk : 0 < c.numOdd` | Not stated as an explicit hypothesis in paper; cycles of `T` necessarily have odd elements. | `hk` is required by `ratio_le_log`, `log_le_ratio`, `eliahou_sandwich`, `log2_three_lt_ratio`, and `eliahou_bound`. | WEAKENING | Added hypothesis. Likely derivable from positivity and periodicity, but missing as a lemma. |
| Computation below `2^40` | Paper cites verification of the conjecture up to `2^40` to rule out small nontrivial cycles. | Comment mentions Yoneda verification but no formal theorem/certificate for all `n <= 2^40`. | PARTIAL | Not needed for the conditional `min > 2^40` theorem. Needed for an unconditional nontrivial-cycle bound claim. |

## `L` vs `Card Omega` analysis

L_VS_CARDOMEGA_ANALYZED: yes.

### Finding

`CollatzCycle L` does not encode "cardinality of the orbit set". It encodes a length-`L` cyclic list satisfying the step relation. There is no field or lemma requiring:
- `Function.Injective c.seq`;
- `List.Nodup`/`Finset` cardinality equality;
- `L` minimal among periods;
- every paper orbit set has been converted to an exact-period instance.

### Inflation mechanism

If a genuine cycle has exact period `p`, then traversing it `r` times gives a periodic indexed sequence of length `r * p`. The step equation still holds. Thus the type admits inflated periods. The trivial cycle `{1,2}` can be represented at length `2`, but also as the indexed sequence `1,2,1,2` at length `4` in the same style. For a hypothetical nontrivial cycle, the same repetition construction would preserve `minElem`.

Consequence:
- Proving `17087915 <= L` for an arbitrary periodic sequence does not by itself prove `17087915 <= Card Omega` if `L` is an inflated traversal.
- To use `eliahou_bound` for the paper's `Card Omega`, one must instantiate `CollatzCycle L` with `L = Card Omega`, i.e. an exact one-pass enumeration.

### Exact-period instance status

No generic exact-period construction was found in the repo. There is no type for paper cycles as finite orbit sets and no bridge theorem:

```lean
paperCycle Omega -> exists c : CollatzCycle (Fintype.card Omega), ...
```

Meta-mathematically, such an instance should be constructible from the paper definition: choose an element of the finite cycle, enumerate its successive iterates until first return, and use the fact that the cycle has cardinality `k`. But that bridge is not present in Lean.

Classification:
- `L` can be inflated: confirmed by the shape of the structure.
- Exact-period instance: plausible externally, not formalized locally.
- Statement fidelity impact: `PARTIAL` / `AMBIGUOUS` until the bridge is made explicit.

## `hk : 0 < c.numOdd` analysis

HK_ADDED_HYPOTHESIS_ANALYZED: yes.

`hk` is an added Lean hypothesis in the central theorem. It should be derivable for positive cycles:

1. Suppose `numOdd = 0`.
2. Then all entries in the finite cycle are even.
3. Let `m = minElem`, achieved by some index `j`.
4. Since `m` is positive and even, `T(m) = m / 2 < m`.
5. But `T(m)` is the successor entry in the same cycle.
6. This contradicts minimality of `m`.

Thus every positive `CollatzCycle` should contain an odd element. The repo does not include a lemma such as:

```lean
theorem CollatzCycle.numOdd_pos {L : Nat} (c : CollatzCycle L) :
    0 < c.numOdd
```

Classification:
- As a paper-vs-Lean statement, `hk` is a `WEAKENING` because it is an extra assumption.
- As mathematical risk, it is likely benign and removable.
- As audit action, request or add/verify a lemma deriving `hk` before treating the statement as fully aligned.

## Consequence-only status

CONSEQUENCE_ONLY_STATUS_CONFIRMED: yes.

Evidence:
- Current code has `eliahou_bound` for `17087915 <= L`.
- Current code has no theorem proving the linear form with coefficients `301994`, `17087915`, `85137581`.
- `ARISTOTLE_SUMMARY.md` says `eliahou_precise` had one remaining sorry.
- Current commit message says the unused/unproven precise reformulation was removed.
- `rg` found no current `eliahou_precise` declaration in Lean files.

Interpretation:
- The formalization is plausibly a partial formalization of a lower-bound consequence of Eliahou1993.
- It should not be described as a full formalization of Theorem 1.1 unless the registry/author explicitly scopes "Theorem 1.1" to the lower-bound consequence.

## Other statement-level observations

### Theorem 2.1 strictness

The paper's lower bound is strict:

```text
log_2(3 + 1/M) < Card Omega / Card Omega_1
```

Lean's `eliahou_sandwich` records:

```lean
Real.logb 2 (3 + 1 / c.maxElem) <= L / c.numOdd
```

The strictness is not fatal for `eliahou_bound`, because the proof separately uses `log2_three_lt_ratio : log_2 3 < L / numOdd`. But it means `eliahou_sandwich` is not a literal match to the theorem as printed.

Likely missing lemma: in a positive cycle, the maximum cannot be odd, since if `M` were odd then `T(M)=(3M+1)/2 > M`; hence `M` is not an odd-cycle factor and the lower product bound can be strict. This is not formalized.

Classification: `PARTIAL`.

### Lemma 2.2 multiplicity

Lean's product formula is indexed by odd indices, not by distinct odd elements. This is fine for exact cycles. For inflated cycles it counts repetitions. This is another manifestation of the `L` vs `Card Omega` bridge issue.

Classification: `PARTIAL`.

### `native_decide`

The statement-fidelity phase did not audit trusted computation. `native_decide` appears in numerical facts in `ContinuedFractions.lean`. This belongs to the later mechanical audit phase under the adversarial checklist, not to this private statement-only report.

## Local verdict

LOCAL_STATEMENT_FIDELITY_AUDIT_DONE: yes.

Verdict by category:

- Definitional core of `T`: `MATCH`.
- Cycle representation: `PARTIAL`, because exact-cardinality/minimal-period semantics are not encoded.
- Main lower-bound consequence: `PARTIAL`, plausible after exact-period bridge and `hk` lemma.
- Full Theorem 1.1 linear form: `GAP`.
- Theorem 2.1: `PARTIAL`, enough for route used but not literal strict/sharper statement.
- Lemma 2.2: `PARTIAL`, exact if no-duplicate exact-cycle instance is supplied.
- Corollary 2.3: `GAP`.

Net statement supported by Lean as written, without build verification:

```text
For any positive indexed periodic orbit c : CollatzCycle L of the compressed Collatz map,
if minElem(c) > 2^40 and c has at least one odd indexed element, then 17087915 <= L.
```

Statement not supported as written:

```text
For every nontrivial paper cycle Omega, Card Omega has the full Eliahou linear form
301994 a + 17087915 b + 85137581 c with b > 0 and a c = 0.
```

Recommended private next steps before any Forum/audit-link action:

1. Ask/confirm intended scope: "Is id 6 intended as the lower-bound consequence only?"
2. Add or request a statement-level note in the formalization README making consequence-only scope explicit.
3. Add or request a lemma deriving `0 < c.numOdd`.
4. Add or request either:
   - a `Nodup`/exact-period condition to `CollatzCycle`, or
   - a bridge theorem from paper cycles to exact `CollatzCycle (Card Omega)`.
5. Only after this statement scope is clear, proceed to mechanical audit (`lake build`, axiom/sorry audit, native_decide trust review).

## Classifications

- LOCAL_STATEMENT_FIDELITY_AUDIT_DONE: yes
- CONSEQUENCE_ONLY_STATUS_CONFIRMED: yes
- L_VS_CARDOMEGA_ANALYZED: yes
- HK_ADDED_HYPOTHESIS_ANALYZED: yes
- PARTIAL_FORMALIZATION_PLAUSIBLE: yes
- FORUM_ANNOUNCEMENT_DEFERRED: yes
- AUDIT_LINK_NOT_CREATED: yes
- NO_GLOBAL_COLLATZ_CLAIM: yes
