import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

# ─── Configuración de página ────────────────────────────────────────────────

st.set_page_config(
    page_title="Instacart User Behavior Analysis",
    page_icon="🛒",
    layout="wide",
)

# ─── Paleta y orden de segmentos ────────────────────────────────────────────

COLORS = {
    "VIP": "#4F8EF7",
    "Frecuente": "#00C896",
    "Regular": "#FF8C42",
    "Ocasional": "#FF4B6E",
}
ORDER = ["VIP", "Frecuente", "Regular", "Ocasional"]

DAY_LABELS = {
    0: "Domingo", 1: "Lunes", 2: "Martes", 3: "Miércoles",
    4: "Jueves", 5: "Viernes", 6: "Sábado",
}

# ─── Estilos CSS ────────────────────────────────────────────────────────────

st.markdown("""
<style>
.stApp {background-color:#FFFFFF;}
html,body,[class*="css"]{font-family:'Inter','Segoe UI',sans-serif;color:#1a1a2e;}

.kpi-card{
    background:#F7F8FA;border:1px solid #E8EBF0;border-radius:12px;
    padding:22px 16px;text-align:center;
}
.kpi-value{font-size:2rem;font-weight:700;color:#1a1a2e;margin:4px 0 2px;}
.kpi-label{font-size:.82rem;color:#6b7280;text-transform:uppercase;letter-spacing:.5px;}

.section-title{
    font-size:1.25rem;font-weight:700;color:#1a1a2e;
    margin-top:2.5rem;margin-bottom:.3rem;
    border-left:4px solid #4F8EF7;padding-left:12px;
}
.insight{
    background:#F0F5FF;border-left:3px solid #4F8EF7;border-radius:6px;
    padding:14px 18px;margin-top:8px;font-size:.9rem;color:#374151;line-height:1.55;
}
.rec-card{
    background:#F7F8FA;border:1px solid #E8EBF0;border-radius:12px;
    padding:24px 22px;margin-top:8px;line-height:1.6;
}
.rec-card h4{margin:0 0 8px;color:#1a1a2e;}
.rec-card p{margin:0;color:#374151;font-size:.92rem;}
</style>
""", unsafe_allow_html=True)

# ─── Carga de datos ────────────────────────────────────────────────────────

@st.cache_data
def load_metrics():
    df = pd.read_csv("user_metrics.csv")
    df["user_segment"] = pd.Categorical(df["user_segment"], categories=ORDER, ordered=True)
    return df

@st.cache_data
def load_patterns():
    return pd.read_csv("orders_patterns.csv")

@st.cache_data
def load_department():
    return pd.read_csv("department_reorder.csv")

df = load_metrics()
df_patterns = load_patterns()
df_dept = load_department()

# ─── Sidebar ────────────────────────────────────────────────────────────────

with st.sidebar:
    st.markdown("### Filtros")
    segments = st.multiselect("Segmentos", options=ORDER, default=ORDER)
    st.markdown("---")
    st.caption("Datos: Instacart Market Basket Analysis · Kaggle")

data = df[df["user_segment"].isin(segments)].copy()
cmap = {s: COLORS[s] for s in segments}

# ─── Helpers ────────────────────────────────────────────────────────────────

def section(text):
    st.markdown(f'<div class="section-title">{text}</div>', unsafe_allow_html=True)

def insight(text):
    st.markdown(f'<div class="insight">{text}</div>', unsafe_allow_html=True)

# ─── Header ─────────────────────────────────────────────────────────────────

st.markdown(
    "<h1 style='text-align:center;font-size:2.8rem;font-weight:800;"
    "color:#0f172a;margin-bottom:0;letter-spacing:-0.5px'>"
    "Instacart User Behavior Analysis</h1>",
    unsafe_allow_html=True,
)
st.markdown(
    "<p style='text-align:center;font-size:1.1rem;color:#6b7280;margin-top:6px'>"
    "¿Qué diferencia a un usuario leal de uno que abandona la plataforma?</p>",
    unsafe_allow_html=True,
)
st.markdown("---")

# ─── KPIs ───────────────────────────────────────────────────────────────────

k1, k2, k3, k4 = st.columns(4)

kpis = [
    (f"{len(data):,}",                                  "Total usuarios"),
    (f"{data['total_orders'].mean():.1f}",               "Promedio órdenes"),
    (f"{data['avg_days_between_orders'].mean():.1f}",    "Días entre órdenes"),
    (f"{data['churn'].mean() * 100:.1f}%",               "Tasa de churn"),
]

for col, (val, lab) in zip([k1, k2, k3, k4], kpis):
    col.markdown(
        f'<div class="kpi-card"><div class="kpi-label">{lab}</div>'
        f'<div class="kpi-value">{val}</div></div>',
        unsafe_allow_html=True,
    )

# ─── Distribución de usuarios (pie chart) ──────────────────────────────────

section("Distribución de usuarios por segmento")

seg_counts = (
    data["user_segment"]
    .value_counts()
    .reindex([s for s in ORDER if s in segments])
    .reset_index()
)
seg_counts.columns = ["Segmento", "Usuarios"]

fig_pie = px.pie(
    seg_counts, names="Segmento", values="Usuarios",
    color="Segmento", color_discrete_map=cmap,
    template="plotly_white",
    hole=0.4,
)
fig_pie.update_traces(
    textinfo="percent+label",
    hovertemplate="<b>%{label}</b><br>Usuarios: %{value:,}<br>Proporción: %{percent}<extra></extra>",
)
fig_pie.update_layout(height=400, margin=dict(t=20, b=20))
st.plotly_chart(fig_pie, use_container_width=True)

# ─── 1 · Retención ─────────────────────────────────────────────────────────

section("Retención — Promedio de días entre órdenes por segmento")

ret_agg = (
    data.groupby("user_segment", observed=True)["avg_days_between_orders"]
    .mean()
    .reindex([s for s in ORDER if s in segments])
    .reset_index()
)
ret_agg.columns = ["Segmento", "Promedio días"]

fig_ret = px.bar(
    ret_agg, x="Segmento", y="Promedio días",
    color="Segmento", color_discrete_map=cmap,
    text="Promedio días", template="plotly_white",
)
fig_ret.update_traces(
    texttemplate="%{text:.1f} días", textposition="outside",
    hovertemplate="<b>%{x}</b><br>Promedio: %{y:.1f} días entre órdenes<extra></extra>",
)
fig_ret.update_layout(showlegend=False, height=430, margin=dict(t=20, b=40))
st.plotly_chart(fig_ret, use_container_width=True)

# ─── 2 · Recompra ──────────────────────────────────────────────────────────

section("Recompra — Tasa de reorden por segmento")

col_box, col_tbl = st.columns([3, 1])

with col_box:
    fig_reo = px.box(
        data, x="user_segment", y="reorder_rate",
        color="user_segment", color_discrete_map=cmap,
        category_orders={"user_segment": ORDER},
        labels={"user_segment": "Segmento", "reorder_rate": "Tasa de reorden"},
        template="plotly_white",
    )
    fig_reo.update_layout(showlegend=False, height=430, margin=dict(t=20, b=40), yaxis_tickformat=".0%")
    fig_reo.update_traces(hovertemplate="<b>%{x}</b><br>Reorden: %{y:.1%}<extra></extra>")
    st.plotly_chart(fig_reo, use_container_width=True)

with col_tbl:
    st.markdown("<br><br>", unsafe_allow_html=True)
    med = (
        data.groupby("user_segment", observed=True)["reorder_rate"]
        .median()
        .reindex([s for s in ORDER if s in segments])
        .reset_index()
    )
    med.columns = ["Segmento", "Mediana"]
    med["Mediana"] = med["Mediana"].map("{:.1%}".format)
    st.dataframe(med, hide_index=True, use_container_width=True)

# ─── Recompra por departamento ──────────────────────────────────────────────

dept_filtered = df_dept[df_dept["user_segment"].isin(segments)].copy()

st.markdown("<br>", unsafe_allow_html=True)

col_top10, col_seg = st.columns(2)

with col_top10:
    st.markdown("**Top 10 departamentos — mayor tasa de reorden general**")
    general = (
        dept_filtered.groupby("department")
        .agg(bought=("total_bought", "sum"), reordered=("total_reordered", "sum"))
        .reset_index()
    )
    general["reorder_rate"] = general["reordered"] / general["bought"]
    top10 = general.nlargest(10, "reorder_rate").sort_values("reorder_rate")

    fig_top = px.bar(
        top10, x="reorder_rate", y="department", orientation="h",
        text="reorder_rate", template="plotly_white",
        labels={"reorder_rate": "Tasa de reorden", "department": "Departamento"},
        color_discrete_sequence=["#4F8EF7"],
    )
    fig_top.update_traces(
        texttemplate="%{text:.1%}", textposition="outside",
        hovertemplate="<b>%{y}</b><br>Reorden: %{x:.1%}<extra></extra>",
    )
    fig_top.update_layout(height=420, margin=dict(t=10, b=30, l=10, r=60), showlegend=False)
    st.plotly_chart(fig_top, use_container_width=True)

with col_seg:
    st.markdown("**Reorden por segmento — Top 5 departamentos**")
    top5_depts = general.nlargest(5, "reorder_rate")["department"].tolist()
    dept_seg = dept_filtered[dept_filtered["department"].isin(top5_depts)].copy()
    dept_seg["department"] = pd.Categorical(dept_seg["department"], categories=top5_depts, ordered=True)

    fig_dseg = px.bar(
        dept_seg, x="department", y="reorder_rate",
        color="user_segment", color_discrete_map=COLORS,
        barmode="group", text="reorder_rate", template="plotly_white",
        category_orders={"user_segment": ORDER},
        labels={"department": "Departamento", "reorder_rate": "Tasa de reorden", "user_segment": "Segmento"},
    )
    fig_dseg.update_traces(
        texttemplate="%{text:.0%}", textposition="outside",
        hovertemplate="<b>%{x}</b> — %{data.name}<br>Reorden: %{y:.1%}<extra></extra>",
    )
    fig_dseg.update_layout(
        height=420, margin=dict(t=10, b=30),
        yaxis_tickformat=".0%", legend_title_text="",
    )
    st.plotly_chart(fig_dseg, use_container_width=True)

insight(
    "<b>Insight:</b> El 59% de los productos comprados son reórdenes. "
    "Los VIP reordenan el 74.8% de sus productos vs. 20.9% en Ocasionales. "
    "La tasa de reorden es el indicador más claro de lealtad sostenida."
)

# ─── 3 · Patrones temporales ───────────────────────────────────────────────

section("Patrones temporales — Heatmaps de actividad por día y hora")

def make_heatmap(segment_name, color_scale, title_text=""):
    seg_data = df_patterns[df_patterns["user_segment"] == segment_name].copy()
    pivot = seg_data.pivot_table(
        index="order_hour_of_day", columns="order_dow",
        values="total_orders", aggfunc="sum", fill_value=0,
    )
    pivot = pivot.reindex(index=range(0, 24), columns=range(0, 7), fill_value=0)

    day_names = [DAY_LABELS[d] for d in range(7)]
    hour_labels = [f"{h}:00" for h in range(24)]

    fig = go.Figure(data=go.Heatmap(
        z=pivot.values,
        x=day_names,
        y=hour_labels,
        colorscale=color_scale,
        hovertemplate="<b>%{x}</b> a las %{y}<br>Órdenes: %{z:,}<extra></extra>",
    ))
    fig.update_layout(
        height=480, template="plotly_white",
        margin=dict(t=40, b=30),
        title=dict(text=title_text, font=dict(size=15, color="#FFFFFF"), x=0.5, xanchor="center"),
        yaxis=dict(title="Hora del día", autorange="reversed"),
        xaxis=dict(title="Día de la semana"),
    )
    return fig

col_vip, col_oca = st.columns(2)

with col_vip:
    st.plotly_chart(
        make_heatmap("VIP", [[0, "#f0f5ff"], [1, "#4F8EF7"]], "Comportamiento de compra — Usuarios VIP"),
        use_container_width=True,
    )

with col_oca:
    st.plotly_chart(
        make_heatmap("Ocasional", [[0, "#fff0f3"], [1, "#FF4B6E"]], "Comportamiento de compra — Usuarios Ocasionales"),
        use_container_width=True,
    )

insight(
    "<b>Insight:</b> Los usuarios VIP concentran su actividad los <b>lunes de 9 am a 3 pm</b>, "
    "integrando Instacart en su rutina semanal. Los Ocasionales compran "
    "<b>jueves y viernes en la tarde-noche</b>, de forma reactiva antes del fin de semana."
)

# ─── 4 · Churn — Feature Importance ────────────────────────────────────────

section("Churn — Importancia de variables en el modelo Random Forest")

feat_data = pd.DataFrame({
    "Feature": [
        "avg_days_between_orders",
        "total_products_bought",
        "reorder_rate",
        "max_days_between_orders",
    ],
    "Importancia": [35.6, 32.8, 27.1, 4.5],
    "Label": [
        "Días promedio entre órdenes",
        "Total productos comprados",
        "Tasa de reorden",
        "Máx. días entre órdenes",
    ],
})
feat_data = feat_data.sort_values("Importancia")

fig_feat = px.bar(
    feat_data, x="Importancia", y="Label", orientation="h",
    text="Importancia", template="plotly_white",
    labels={"Label": "", "Importancia": "Importancia (%)"},
    color_discrete_sequence=["#4F8EF7"],
)
fig_feat.update_traces(
    texttemplate="%{text:.1f}%", textposition="outside",
    hovertemplate="<b>%{y}</b><br>Importancia: %{x:.1f}%<extra></extra>",
)
fig_feat.update_layout(
    height=380, margin=dict(t=20, b=40, l=10, r=60),
    showlegend=False,
    xaxis=dict(range=[0, 42]),
)
st.plotly_chart(fig_feat, use_container_width=True)

insight(
    "<b>Insight:</b> La <b>frecuencia de compra</b> (días promedio entre órdenes) es el "
    "predictor más importante de churn con un 35.6% de importancia en el modelo Random Forest. "
    "Junto con el total de productos comprados (32.8%) y la tasa de reorden (27.1%), "
    "estas tres variables explican el 95.5% de la capacidad predictiva del modelo. "
    "Un usuario que aumenta el intervalo entre compras es la señal más temprana de abandono."
)

# ─── 5 · Recomendaciones ───────────────────────────────────────────────────

section("Recomendaciones de negocio")

r1, r2 = st.columns(2)

with r1:
    st.markdown(
        '<div class="rec-card">'
        "<h4>📲 Estimular compra en momentos clave</h4>"
        "<p>Enviar notificaciones push a usuarios Ocasionales los <b>jueves y viernes "
        "en la tarde</b> para activarlos antes del fin de semana. Los datos muestran "
        "que este es su momento natural de compra — alinear la comunicación con su "
        "patrón incrementa la tasa de conversión.</p>"
        "</div>",
        unsafe_allow_html=True,
    )

with r2:
    st.markdown(
        '<div class="rec-card">'
        "<h4>🔁 Fidelizar con productos de uso diario</h4>"
        "<p>Diseñar campañas para que usuarios Ocasionales reordenen productos de "
        "departamentos <b>dairy, pets y bakery</b> — los de mayor recompra en usuarios VIP. "
        "Ofrecer descuentos en la segunda compra de estas categorías reduce la barrera "
        "de entrada al hábito de reorden.</p>"
        "</div>",
        unsafe_allow_html=True,
    )

# ─── Footer ─────────────────────────────────────────────────────────────────

st.markdown("---")
st.markdown(
    "<p style='text-align:center;font-size:.8rem;color:#9ca3af'>"
    "Datos: Instacart Market Basket Analysis (Kaggle) · Streamlit + Plotly</p>",
    unsafe_allow_html=True,
)
