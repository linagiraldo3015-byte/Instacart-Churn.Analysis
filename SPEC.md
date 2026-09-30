# Instacart Churn — Spec

> Qué se construye y cómo debe funcionar. El orden y las fechas van en `ROADMAP.md`.
> Los hallazgos y sus cifras están en `README.md`, que manda sobre este archivo si difieren.

## 1. Qué es
Un análisis de comportamiento de usuarios de grocery delivery y un modelo que predice cuáles están por abandonar, con un dashboard para explorarlo.

## 2. Para quién
Un equipo de producto o retención que necesita saber **a quién** buscar y **cuándo**, no solo cuánta gente se va. También funciona como pieza de portafolio: muestra el camino completo de SQL a modelo a dashboard.

## 3. Qué debe tener
- Pipeline en PostgreSQL, numerado y en orden, que se pueda volver a correr desde cero.
- Métricas por usuario: frecuencia, recencia, tamaño de canasta, recompra.
- Un modelo de churn (Random Forest) con las variables que más pesan, visibles.
- Un dashboard publicado, abierto a cualquiera con el enlace.
- Recomendaciones de negocio, no solo gráficos.

## 4. Cómo debe verse
Dashboard de Streamlit: cada pantalla responde una pregunta y la respuesta se lee antes que el gráfico.

## 5. Qué NO debe tener
- **No es un sistema en producción**: no se conecta a datos vivos ni dispara acciones.
- No usa datos de una empresa real: el dataset de Instacart es público, de Kaggle.
- No promete ahorros en dinero: las cifras de negocio del README son del análisis, no proyecciones de una implementación.

## 6. Comportamiento
- El dataset no trae fechas calendario, sino días desde el pedido anterior. Todo lo temporal se calcula sobre esa base, y así debe leerse.
- Un usuario con un solo pedido no tiene frecuencia: entra como caso aparte, no como frecuencia cero.
- El dashboard no lee la base: lee los tres CSV agregados de la raíz. Si un CSV cambia de nombre o de sitio, el dashboard publicado deja de funcionar.

## 7. Criterio de terminado
- El pipeline corre en orden de `01` a `08` sobre una base vacía y deja las tablas de análisis listas.
- El dashboard abre desde su enlace público sin nada instalado.
- Cada hallazgo del README se puede rastrear hasta la consulta o la celda que lo produjo.
