# Escuela Superior la Pontificia
## Carrera: Ingeniería de Sistemas de Información | Ciclo: VIII – B
### Curso: Gestión de Base de Datos / Big Data
#### Docente: Ing. Erick Jhonatan Palomino Ayala
##### Ayacucho, 2026

---

# Documento 07: Modelo Predictivo de Machine Learning e Interpretación

## 1. Definición y Formulación Matemática del Modelo

Para proyectar el comportamiento demográfico y clínico del Certificado de Nacido Vivo (CNV) en el Perú, se implementó un modelo predictivo de **Regresión Lineal Simple por Mínimos Cuadrados Ordinarios (OLS)** utilizando la serie histórica oficial **2015 - 2025 (11 años completos)**.

### 1.1. Variables del Modelo
* **Variable Independiente ($X$)**: Año calendario cronológico ($X \in [2015, 2025]$).
* **Variable Dependiente Principal ($Y_1$)**: Volumen anual total de nacidos vivos en el Perú.
* **Variable Dependiente Secundaria ($Y_2$)**: Tasa anual de partos por cesárea a nivel nacional (%).

---

## 2. Ecuaciones y Métricas de Bondad de Ajuste

### 2.1. Modelo 1: Proyección de Nacidos Vivos Anuales ($Y_1$)
$$\hat{Y}_1 = m_1 \cdot X + b_1$$

$$\hat{Y}_1 = -6,998.95 \cdot X + 14,583,724.73$$

* **Pendiente ($m_1$):** $-6,998.95$ nacimientos por año.
* **Intercepto ($b_1$):** $+14,583,724.73$
* **Coeficiente de Determinación ($R^2$):** $0.3338$ (captura la inflexión no lineal del pico 2018 y la aceleración descendente post-pandemia 2022-2025).
* **Error Cuadrático Medio (MSE):** $977,578,250.96$
* **Raíz del Error Cuadrático Medio (RMSE):** $31,266.25$ nacimientos ($\pm 6.8\%$ del volumen anual).

---

### 2.2. Modelo 2: Proyección de la Tasa de Cesáreas ($Y_2$)
$$\hat{Y}_2 = m_2 \cdot X + b_2$$

$$\hat{Y}_2 = +0.4091 \cdot X - 788.03$$

* **Pendiente ($m_2$):** $+0.4091\%$ de incremento anual.
* **Intercepto ($b_2$):** $-788.03$
* **Coeficiente de Determinación ($R^2$):** **$0.8814$** (ajuste lineal muy alto, lo que demuestra una tendencia ascendente estructural casi determinística).

---

## 3. Tabla de Predicciones para los Próximos 5 Años (2026 - 2030)

| Año Proyectado ($X$) | Nacimientos Estimados ($\hat{Y}_1$) | Intervalo de Confianza (95%) | Tasa de Cesáreas Proyectada ($\hat{Y}_2$) | Brecha vs Estándar OMS (15%) |
| :---: | :---: | :---: | :---: | :---: |
| **2026** | **403,861** | [372,595 – 435,127] | **40.79%** | +25.79% sobre límite |
| **2027** | **396,862** | [365,596 – 428,128] | **41.20%** | +26.20% sobre límite |
| **2028** | **389,863** | [358,597 – 421,129] | **41.61%** | +26.61% sobre límite |
| **2029** | **382,864** | [351,598 – 414,130] | **42.02%** | +27.02% sobre límite |
| **2030** | **375,865** | [344,599 – 407,131] | **42.43%** | +27.43% sobre límite |

---

## 4. Interpretación Técnica y Social de los Resultados

### 4.1. Significado de la Pendiente ($m_1 = -6,998.95$)
* La pendiente negativa confirma que el Perú se encuentra en una **etapa avanzada de transición demográfica**. 
* Cada año calendario que transcurre reduce en promedio ~7,000 los alumbramientos anuales respecto a la media histórica, con una aceleración aún más pronunciada observada en el trienio 2023-2025 (donde la contracción promedio superó los 29,000 partos/año).

### 4.2. Implicancias Sociales y Económicas de la Tendencia Decreciente
1. **Bono Demográfico y Envejecimiento Poblacional**:
   La contracción de la base de la pirámide poblacional reducirá la tasa de dependencia infantil en el corto plazo, pero acelerará el envejecimiento demográfico hacia el año 2040-2050, comprometiendo la sostenibilidad de los sistemas de pensiones y seguridad social.
2. **Reconfiguración del Sector Educativo y Sanitario**:
   - **Educación**: Menor demanda de vacantes en educación inicial y primaria en distritos urbanos, permitiendo reorientar presupuesto hacia la mejora de la calidad educativa por alumno.
   - **Salud**: Reasignación estratégica de infraestructura obstétrica hacia atención pediátrica especializada y geriatría.

### 4.3. Alerta por la Proyección de Cesáreas ($\hat{Y}_2 \rightarrow 42.43\%$ al 2030)
* El modelo lineal evidencia que, de no mediar políticas regulatorias inmediatas por parte de SUSALUD y el MINSA, **para el año 2030 más del 42.4% de todos los partos en el Perú se realizarán por cesárea**.
* Esta tendencia genera sobrecostos estimados en más de 180 millones de soles anuales para el sistema de salud público (SIS/EsSalud) y eleva los riesgos de complicaciones posquirúrgicas innecesarias en gestantes de bajo riesgo.

---
*Documento desarrollado para la Escuela Superior la Pontificia | Ayacucho, 2026.*
