# Instacart User Behavior Analysis

![Python](https://img.shields.io/badge/Python-3.10-blue?logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791?logo=postgresql&logoColor=white)
![scikit-learn](https://img.shields.io/badge/scikit--learn-1.3-F7931E?logo=scikitlearn&logoColor=white)
![Streamlit](https://img.shields.io/badge/Streamlit-1.28-FF4B4B?logo=streamlit&logoColor=white)

> **Pregunta central:** *&iquest;Qu&eacute; diferencia a un usuario leal de uno que abandona la plataforma?*

An&aacute;lisis exploratorio y modelo predictivo de churn sobre +3 millones de pedidos de Instacart. El proyecto combina SQL para extracci&oacute;n y transformaci&oacute;n de datos, Python para modelado estad&iacute;stico y Streamlit para visualizaci&oacute;n interactiva.

---

## Contexto de negocio

En grocery delivery, adquirir un nuevo usuario cuesta entre 5x y 7x m&aacute;s que retener uno existente. Identificar qu&eacute; comportamientos predicen el abandono permite al equipo de producto intervenir antes de perder al cliente: ofrecer incentivos en el momento correcto, personalizar la experiencia y priorizar recursos en los segmentos con mayor riesgo de churn.

Este proyecto traduce datos transaccionales en se&ntilde;ales accionables para retenci&oacute;n.

---

## Herramientas

| Herramienta | Uso |
|---|---|
| **PostgreSQL** | Almacenamiento, limpieza y consultas anal&iacute;ticas sobre el dataset |
| **Python** | An&aacute;lisis exploratorio, feature engineering y modelado |
| **scikit-learn** | Modelo de predicci&oacute;n de churn (Random Forest) |
| **Streamlit** | Dashboard interactivo de hallazgos y segmentaci&oacute;n |

---

## Estructura del proyecto

```
Instacart_Project/
├── sql/                   # Consultas de exploración, transformación y segmentación
├── churn_model.ipynb      # Modelo predictivo de churn (Random Forest)
├── dashboard.py           # Dashboard interactivo en Streamlit
└── README.md
```

---

## Hallazgos principales

### Retenci&oacute;n

- El usuario t&iacute;pico compra **cada 2 semanas** con un promedio de **16.59 &oacute;rdenes** en su ciclo de vida.
- Existe alta variabilidad: el 25% inferior no supera las 5 &oacute;rdenes, mientras que el cuartil superior acumula m&aacute;s de 23.

### Recompra

- El **59% de los productos comprados son re&oacute;rdenes**, lo que indica fuerte formaci&oacute;n de h&aacute;bito en la plataforma.
- Usuarios **VIP** reordenan el **74.8%** de sus productos vs. **20.9%** en usuarios Ocasionales.
- La tasa de reorden es el indicador m&aacute;s claro de lealtad sostenida.

### Patrones temporales

| Segmento | D&iacute;as preferidos | Horario pico |
|---|---|---|
| **VIP** | Lunes | 9:00 &ndash; 15:00 |
| **Ocasional** | Jueves &ndash; Viernes | Tarde-noche |

Los usuarios leales integran Instacart en su rutina semanal matutina; los ocasionales compran de forma reactiva al final de la semana.

### Segmentaci&oacute;n

| M&eacute;trica | VIP | Regular | Ocasional |
|---|---|---|---|
| Frecuencia de compra | Cada 5 d&iacute;as | Cada 11 d&iacute;as | Cada 20 d&iacute;as |
| Tasa de reorden | 74.8% | 55.2% | 20.9% |
| Riesgo de churn | Bajo | Medio | Alto |

### Predicci&oacute;n de churn

- Modelo: **Random Forest**
- Accuracy: **87%**
- **Predictor m&aacute;s importante:** frecuencia de compra, seguido de tasa de reorden y d&iacute;as desde la &uacute;ltima orden.
- El modelo permite identificar usuarios en riesgo antes de que abandonen, abriendo una ventana de intervenci&oacute;n de ~2 semanas.

---

## Recomendaciones de negocio

1. **Activar alertas tempranas de churn.** Cuando un usuario supera 1.5x su frecuencia habitual sin comprar, disparar un cupón personalizado basado en sus productos más reordenados. El modelo identifica estos casos con 87% de precisión.

2. **Diseñar onboarding orientado a hábito.** Los primeros 30 días son críticos: usuarios que no alcanzan 3 órdenes en ese periodo tienen alta probabilidad de abandono. Implementar recordatorios con listas sugeridas basadas en compras similares del segmento VIP.

3. **Diferenciar la experiencia por segmento.** Los VIP responden a conveniencia (slots matutinos prioritarios, reorden con un clic); los Ocasionales necesitan incentivos de precio y descubrimiento de productos para aumentar su engagement.

---

## Dataset

Los datos provienen del [Instacart Market Basket Analysis](https://www.kaggle.com/c/instacart-market-basket-analysis) publicado en Kaggle. Contiene m&aacute;s de 3 millones de pedidos de m&aacute;s de 200,000 usuarios, con informaci&oacute;n de productos, departamentos, pasillos y secuencia temporal de compras.

---

*Proyecto desarrollado como caso de an&aacute;lisis de datos aplicado a retenci&oacute;n de usuarios en e-commerce.*
