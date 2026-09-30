# Instacart Churn — Contexto del proyecto

> **Estado: terminado.** Dashboard publicado en Streamlit Cloud.
> Hallazgos y contexto de negocio en `README.md`.

## Qué es
Análisis exploratorio y modelo predictivo de churn sobre +3 millones de pedidos de Instacart. Pregunta central: ¿qué diferencia a un usuario leal de uno que abandona?

## Mapa de la carpeta
| Ruta | Qué contiene | Cuándo leerlo |
|---|---|---|
| `ROADMAP.md` | Fases cerradas, pendientes menores y decisiones | Siempre, al empezar |
| `SPEC.md` | Qué se construye y qué NO | Antes de cambiar algo |
| `README.md` | Hallazgos y contexto de negocio (manda sobre el SPEC si difieren) | Para las cifras |
| `sql/01…08_*.sql` | Pipeline en PostgreSQL, en orden: schemas → staging → analytics → análisis | Para reproducir o extender el análisis |
| `churn_model.ipynb` | Modelo de churn (Random Forest) | Al tocar el modelo |
| `dashboard.py` | Dashboard en Streamlit | Al tocar el dashboard |
| `user_metrics.csv`, `orders_patterns.csv`, `department_reorder.csv` | Datos agregados que lee el dashboard | Al analizar |
| `data/raw/` | Dataset original de Kaggle (~700 MB). No va a git | Solo para recargar la base |

## Reglas
- **Los 3 CSV agregados se quedan en la raíz**: `dashboard.py` los lee con esa ruta y el dashboard publicado depende de eso.
- No cargar los CSV de `data/raw/` completos en memoria para explorar; usar SQL o muestras.
