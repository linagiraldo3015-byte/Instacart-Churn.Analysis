# Instacart Churn — Roadmap

> Este archivo cambia a medida que avanza el proyecto. Actualízalo cuando se cierre algo o se tome una decisión.
> El contexto estable está en `CLAUDE.md`; qué se construye, en `SPEC.md`.

**Fase actual:** terminado. Dashboard publicado en Streamlit Cloud, sin trabajo en curso
**Bloqueante principal:** —
**Última revisión:** 29 sep 2026

---

## Fase 1 — Base de datos ✅
Dataset de Instacart (+3 millones de pedidos) cargado en PostgreSQL. Pipeline en `sql/01…08_*.sql`, en orden: schemas → staging → analytics → análisis.

## Fase 2 — Exploración y métricas ✅
Consultas de comportamiento por usuario, patrones de pedido y recompra por departamento. Salen los tres CSV agregados que alimentan el dashboard.

## Fase 3 — Modelo de churn ✅
`churn_model.ipynb`: Random Forest sobre las métricas por usuario.

## Fase 4 — Dashboard ✅
`dashboard.py` en Streamlit, publicado. Lee los tres CSV agregados desde la raíz del proyecto.

---

## Pendientes menores
- [x] Comprobado el 29 sep 2026: `.venv/`, `anaconda_projects/` y `data/raw/` están en `.gitignore` y no hay nada de eso rastreado
- [ ] Si algún día se rehace el dashboard, revisar primero la regla de los CSV en la raíz (abajo): moverlos rompe lo publicado

---

## Decisiones tomadas
| Fecha | Decisión | Por qué |
|---|---|---|
| may 2026 | SQL para transformar, Python solo para modelar y graficar | Con +3 millones de filas, agregar en la base es más rápido que cargar todo en memoria |
| may 2026 | Los tres CSV agregados viven en la raíz, no en `data/` | `dashboard.py` los lee con esa ruta y el dashboard publicado depende de eso. **Moverlos lo rompe** |
| may 2026 | `data/raw/` (~700 MB de Kaggle) no va a git | Es público y se vuelve a bajar; el repositorio se queda liviano |
