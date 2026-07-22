# F3_DENSITY_CAPTURE_GATE — EXPEDIENTE DE AUDITORÍA v1

Fuente: texto entregado por el usuario el 2026-07-21. Se conserva aquí sin
promover ninguna observación empírica a teorema.

Estado global: RESEARCH_GRADE_UNKNOWN. Empírico, no probado.

Semántica: pi*(a,x) = #{n∈[1,x] : órbita T alcanza a, intermedios ≤ x},
BFS árbol inverso (padres 2z; (2z−1)/3 si ≡0 mod 3). Validada 3-way, 0 fallos.

E1 — DENSIDAD DEL OBJETO. Método: pi*(1,x)/x, x=2^12..2^20.
Resultado: estabiliza 0.589–0.598 (~0.596). Check interno: pi*(8,x)/x
idéntico (todo salvo {1,2,4} pasa por 8). CLAIM: el árbol ventanado de 1
tiene densidad empírica positiva ≈0.596. LÍMITE: x≤2^20.

E2 — COLAPSO DEL ÍNFIMO. Método: d_a = pi*(a,2^10·a)/(2^10·a),
a≡8 mod 9, a≤900. Resultado: media 10 primeras=0.234, 10 últimas=0.028,
mín=0.0017 (a=764), dispersión 369×. E2b: d_764 a R=2^7..2^13 clavada
~0.002 (no converge). CLAIM: φ_m=inf decae sin fondo; árboles
estructuralmente flacos existen. El inf es el asesino de la densidad.

E3 — TASA DE SUMAS. Método: S_m(y)=Σ_{a≡m,a<300} pi*(a,2^y·a),
y=9..12, m∈{2,5,8}. Resultado: ratios por duplicación 1.989–2.016,
exponente ≈1.00 las tres clases. CLAIM: el funcional suma crece a
tasa 2 (denso), vs λ del esquema inf.

E4 — COLA FLACA ACOTADA + FIRMA. Método: 222 raíces clase 8 ≤2000,
R=2^9, masa=Σd_a·a. Resultado: 25% más flaco aporta 4.92%; 10%→1.40%.
Firma: las 5 más flacas tienen c=(2a−1)/3 ≡ 5 mod 9 (heredan pasillo
D2-estéril). CLAIM: cola despreciable en agregado; riqueza conjeturable
desde prefijo de cascada mod 9.

E5 — CIERRE DEL SISTEMA. Método: Σ[1+pi*(4a,x)+pi*(c,xAdv)] / Σpi*(a,x),
a≡8≤1200, x=2^9·a, xAdv=x−⌈x/(2a)⌉ (ventanas del esquema probado).
Resultado: 99.9013%. CLAIM: la descomposición dos-ramas sumada se
cierra con fuga ~0.1%.

CONJETURA F3 (abierta, enunciable): existe sistema auto-consistente de
desigualdades entre S_m con error ≤ (0.1% cierre + 5% cola) certificando
tasa ρ>λ₁₁=1.7922. Premios: ρ=2 ⇒ densidad positiva; ρ∈(λ₁₁,2) ⇒
exponente >0.84 por vía nueva. OBSTÁCULO TEÓRICO: la inducción actual
hereda peor→peor; sumas exigen control de redistribución rica/flaca
al descender — no existe en literatura.

CONTRATO PARA CODEX: (1) custodiar este expediente + los 4 scripts con
outputs/manifiestos; (2) NO Lean hasta página-de-papel de la desigualdad
de sumas con contrato de aceptación estilo D3; (3) hooks member-wise
obligatorios en toda claim; (4) NO-CLAIMS: no densidad probada, no
casi-todos, no Collatz; (5) prioridad de cola intacta: k=11 preflight,
doblete, hold Eliahou. F3 corre en carril exploración.

