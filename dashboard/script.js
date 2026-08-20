/**
 * ==========================================================================================
 * PROYECTO ACADÉMICO: Big Data con Datos Abiertos Reales (MINSA / RENIEC - CNV Perú)
 * CURSO: Gestión de Base de Datos / Big Data | Escuela Superior la Pontificia
 * ARCHIVO: script.js
 * DESCRIPCIÓN: Lógica interactiva en Vanilla JavaScript (Carga JSON, Filtros, Gráficos y Tabla)
 * ==========================================================================================
 */

document.addEventListener('DOMContentLoaded', () => {
    // Estado Global de la Aplicación
    const state = {
        data: null,
        filteredDepartamentos: [],
        selectedDepartamento: 'TODOS',
        selectedRegionNatural: 'TODOS',
        selectedAnio: 'TODOS',
        sortColumn: 'nacimientos',
        sortAsc: false,
        charts: {}
    };

    // Elementos del DOM
    const elements = {
        loadingOverlay: document.getElementById('loadingOverlay'),
        errorContainer: document.getElementById('errorContainer'),
        errorMessage: document.getElementById('errorMessage'),
        filterDepartamento: document.getElementById('filterDepartamento'),
        filterRegionNatural: document.getElementById('filterRegionNatural'),
        filterAnio: document.getElementById('filterAnio'),
        btnResetFilters: document.getElementById('btnResetFilters'),
        tableSearchInput: document.getElementById('tableSearchInput'),
        tbodyMatrizRegional: document.getElementById('tbodyMatrizRegional'),
        tbodyProyecciones: document.getElementById('tbodyProyecciones'),
        kpiTotalNacimientos: document.getElementById('kpiTotalNacimientos'),
        kpiTasaCesareas: document.getElementById('kpiTasaCesareas'),
        kpiPesoPromedio: document.getElementById('kpiPesoPromedio'),
        kpiCoberturaSis: document.getElementById('kpiCoberturaSis'),
        kpiSubtextNacimientos: document.getElementById('kpiSubtextNacimientos')
    };

    // Configuración Base de Chart.js
    if (window.Chart) {
        Chart.defaults.color = '#9ca3af';
        Chart.defaults.font.family = "'Inter', sans-serif";
        Chart.defaults.plugins.tooltip.padding = 10;
        Chart.defaults.plugins.tooltip.cornerRadius = 8;
        Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(15, 23, 42, 0.95)';
        Chart.defaults.plugins.tooltip.borderColor = 'rgba(255, 255, 255, 0.1)';
        Chart.defaults.plugins.tooltip.borderWidth = 1;
    }

    // Inicialización: Cargar datos desde datos.json
    cargarDatos();

    /**
     * Carga asíncrona del archivo datos.json mediante fetch
     */
    async function cargarDatos() {
        try {
            mostrarCarga(true);
            const response = await fetch('datos.json');
            if (!response.ok) {
                throw new Error(`Error de red HTTP: ${response.status} (${response.statusText})`);
            }
            state.data = await response.json();
            state.filteredDepartamentos = [...state.data.departamentos];

            inicializarFiltros();
            renderizarKPIs();
            renderizarProyeccionesML();
            renderizarGraficos();
            renderizarTablaRegional();
            mostrarCarga(false);
        } catch (error) {
            console.error('Error al cargar datos.json:', error);
            mostrarError(`No se pudo cargar el archivo de datos: ${error.message}. Verifique que el archivo datos.json esté en la misma carpeta.`);
            mostrarCarga(false);
        }
    }

    /**
     * Inicializa los controles de selección (dropdowns)
     */
    function inicializarFiltros() {
        // Poblado de Departamentos
        const selectDep = elements.filterDepartamento;
        selectDep.innerHTML = '<option value="TODOS">Todos los Departamentos (Nacional)</option>';
        state.data.departamentos.forEach(dep => {
            const option = document.createElement('option');
            option.value = dep.nombre;
            option.textContent = `${dep.nombre} (${dep.region_natural})`;
            selectDep.appendChild(option);
        });

        // Poblado de Años
        const selectAnio = elements.filterAnio;
        selectAnio.innerHTML = '<option value="TODOS">Histórico Consolidado (2015 - 2025)</option>';
        state.data.serie_temporal.historica.forEach(item => {
            const option = document.createElement('option');
            option.value = item.anio;
            option.textContent = `Año ${item.anio}`;
            selectAnio.appendChild(option);
        });

        // Eventos de Filtrado Reactivo
        selectDep.addEventListener('change', (e) => {
            state.selectedDepartamento = e.target.value;
            aplicarFiltros();
        });

        elements.filterRegionNatural.addEventListener('change', (e) => {
            state.selectedRegionNatural = e.target.value;
            aplicarFiltros();
        });

        selectAnio.addEventListener('change', (e) => {
            state.selectedAnio = e.target.value;
            aplicarFiltros();
        });

        elements.btnResetFilters.addEventListener('click', () => {
            state.selectedDepartamento = 'TODOS';
            state.selectedRegionNatural = 'TODOS';
            state.selectedAnio = 'TODOS';
            elements.filterDepartamento.value = 'TODOS';
            elements.filterRegionNatural.value = 'TODOS';
            elements.filterAnio.value = 'TODOS';
            elements.tableSearchInput.value = '';
            aplicarFiltros();
        });

        elements.tableSearchInput.addEventListener('input', (e) => {
            const term = e.target.value.toLowerCase().trim();
            filtrarTablaPorTermino(term);
        });

        // Ordenamiento interactivo de columnas en la tabla
        document.querySelectorAll('#matrizRegionalTable th[data-sort]').forEach(th => {
            th.addEventListener('click', () => {
                const col = th.getAttribute('data-sort');
                if (state.sortColumn === col) {
                    state.sortAsc = !state.sortAsc;
                } else {
                    state.sortColumn = col;
                    state.sortAsc = false;
                }
                ordenarTabla();
            });
        });
    }

    /**
     * Aplica la combinación de filtros seleccionada y actualiza la vista
     */
    function aplicarFiltros() {
        let deps = [...state.data.departamentos];

        if (state.selectedRegionNatural !== 'TODOS') {
            deps = deps.filter(d => d.region_natural.toUpperCase() === state.selectedRegionNatural.toUpperCase());
        }

        if (state.selectedDepartamento !== 'TODOS') {
            deps = deps.filter(d => d.nombre.toUpperCase() === state.selectedDepartamento.toUpperCase());
        }

        state.filteredDepartamentos = deps;

        renderizarKPIs();
        actualizarGraficos();
        ordenarTabla();
    }

    /**
     * Actualiza las tarjetas superiores de métricas (KPIs)
     */
    function renderizarKPIs() {
        if (!state.data) return;

        let totalNac = 0;
        let tasaCes = 0;

        if (state.selectedDepartamento !== 'TODOS') {
            const depMatch = state.data.departamentos.find(d => d.nombre === state.selectedDepartamento);
            if (depMatch) {
                totalNac = depMatch.nacimientos;
                tasaCes = depMatch.tasa_cesareas;
                elements.kpiSubtextNacimientos.textContent = `Región ${depMatch.nombre} (${depMatch.region_natural})`;
            }
        } else if (state.selectedRegionNatural !== 'TODOS') {
            const deps = state.filteredDepartamentos;
            totalNac = deps.reduce((acc, curr) => acc + curr.nacimientos, 0);
            tasaCes = deps.length > 0 ? (deps.reduce((acc, curr) => acc + curr.tasa_cesareas, 0) / deps.length) : 0;
            elements.kpiSubtextNacimientos.textContent = `Región Natural: ${state.selectedRegionNatural}`;
        } else if (state.selectedAnio !== 'TODOS') {
            const anioMatch = state.data.serie_temporal.historica.find(item => item.anio == state.selectedAnio);
            if (anioMatch) {
                totalNac = anioMatch.nacimientos;
                tasaCes = anioMatch.tasa_cesareas;
                elements.kpiSubtextNacimientos.textContent = `Nivel Nacional - Año ${state.selectedAnio}`;
            }
        } else {
            totalNac = state.data.kpis_globales.total_nacimientos;
            tasaCes = state.data.kpis_globales.tasa_cesareas_nacional;
            elements.kpiSubtextNacimientos.textContent = 'Consolidado Nacional (2015 - 2025)';
        }

        elements.kpiTotalNacimientos.textContent = totalNac.toLocaleString('es-PE');
        elements.kpiTasaCesareas.textContent = `${Number(tasaCes).toFixed(2)}%`;
        elements.kpiPesoPromedio.textContent = `${state.data.kpis_globales.peso_promedio_gramos.toLocaleString()} g`;
        elements.kpiCoberturaSis.textContent = `${state.data.kpis_globales.cobertura_sis_pct}%`;
    }

    /**
     * Construye los 4 gráficos interactivos con Chart.js
     */
    function renderizarGraficos() {
        crearGraficoEvolucionPredictiva();
        crearGraficoPartosDona();
        crearGraficoDepartamentosBarra();
        crearGraficoEstacionalidad();
    }

    /**
     * Gráfico 1: Serie Temporal Histórica + Proyección de Regresión Lineal
     */
    function crearGraficoEvolucionPredictiva() {
        const ctx = document.getElementById('chartEvolucionPredictiva').getContext('2d');
        const histData = state.data.serie_temporal.historica;
        const projData = state.data.serie_temporal.proyectada;

        const labels = [...histData.map(d => d.anio), ...projData.map(d => d.anio)];
        
        // Histórico con nulls en el futuro
        const valoresHistoricos = [...histData.map(d => d.nacimientos), ...projData.map(() => null)];
        
        // Proyección que empalma con el último histórico (2025)
        const ultimoHistorico = histData[histData.length - 1];
        const valoresProyectados = [
            ...histData.slice(0, -1).map(() => null),
            ultimoHistorico.nacimientos,
            ...projData.map(d => d.nacimientos)
        ];

        state.charts.evolucion = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Datos Históricos Reales',
                        data: valoresHistoricos,
                        borderColor: '#38bdf8',
                        backgroundColor: 'rgba(56, 189, 248, 0.1)',
                        borderWidth: 3,
                        pointBackgroundColor: '#38bdf8',
                        pointBorderColor: '#ffffff',
                        pointRadius: 4,
                        fill: true,
                        tension: 0.3
                    },
                    {
                        label: 'Proyección Predictiva ML (2026-2030)',
                        data: valoresProyectados,
                        borderColor: '#f59e0b',
                        backgroundColor: 'rgba(245, 158, 11, 0.05)',
                        borderWidth: 3,
                        borderDash: [6, 6],
                        pointBackgroundColor: '#f59e0b',
                        pointBorderColor: '#ffffff',
                        pointRadius: 5,
                        fill: false,
                        tension: 0.1
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                if (context.parsed.y !== null) {
                                    return ` ${context.dataset.label}: ${context.parsed.y.toLocaleString('es-PE')} nacimientos`;
                                }
                                return '';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        grid: { color: 'rgba(255, 255, 255, 0.05)' },
                        ticks: {
                            callback: value => (value / 1000) + 'k'
                        }
                    },
                    x: {
                        grid: { color: 'rgba(255, 255, 255, 0.05)' }
                    }
                }
            }
        });
    }

    /**
     * Gráfico 2: Vía de Parto (Doughnut)
     */
    function crearGraficoPartosDona() {
        const ctx = document.getElementById('chartPartosDona').getContext('2d');
        const dist = state.data.distribucion_parto;

        state.charts.dona = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Parto Eutócico (Natural)', 'Parto por Cesárea', 'Instrumentado / Otros'],
                datasets: [{
                    data: [dist.eutocico, dist.cesarea, dist.otros],
                    backgroundColor: ['#10b981', '#f43f5e', '#64748b'],
                    borderWidth: 0,
                    hoverOffset: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '68%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { boxWidth: 12, padding: 12, font: { size: 11 } }
                    }
                }
            }
        });
    }

    /**
     * Gráfico 3: Departamentos (Bar Chart)
     */
    function crearGraficoDepartamentosBarra() {
        const ctx = document.getElementById('chartDepartamentosBarra').getContext('2d');
        const deps = state.filteredDepartamentos.slice(0, 10);

        state.charts.barra = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: deps.map(d => d.nombre),
                datasets: [{
                    label: 'Nacimientos Totales',
                    data: deps.map(d => d.nacimientos),
                    backgroundColor: 'rgba(129, 140, 248, 0.85)',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        grid: { color: 'rgba(255, 255, 255, 0.05)' },
                        ticks: { callback: v => (v / 1000) + 'k' }
                    },
                    x: { grid: { display: false } }
                }
            }
        });
    }

    /**
     * Gráfico 4: Estacionalidad Mensual
     */
    function crearGraficoEstacionalidad() {
        const ctx = document.getElementById('chartEstacionalidadMeses').getContext('2d');
        const est = state.data.estacionalidad;

        state.charts.estacionalidad = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: est.map(e => e.nombre.substring(0, 3)),
                datasets: [{
                    label: 'Nacimientos Acumulados',
                    data: est.map(e => e.nacimientos),
                    backgroundColor: 'rgba(56, 189, 248, 0.75)',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        grid: { color: 'rgba(255, 255, 255, 0.05)' },
                        ticks: { callback: v => (v / 1000) + 'k' }
                    },
                    x: { grid: { display: false } }
                }
            }
        });
    }

    /**
     * Actualiza los gráficos en tiempo real ante cambios en los filtros
     */
    function actualizarGraficos() {
        if (!state.charts.barra) return;

        // Actualizar gráfico de departamentos
        const deps = state.filteredDepartamentos.slice(0, 10);
        state.charts.barra.data.labels = deps.map(d => d.nombre);
        state.charts.barra.data.datasets[0].data = deps.map(d => d.nacimientos);
        state.charts.barra.update();
    }

    /**
     * Renderiza la tabla de proyecciones quinquenales del modelo ML
     */
    function renderizarProyeccionesML() {
        const tbody = elements.tbodyProyecciones;
        tbody.innerHTML = '';

        state.data.serie_temporal.proyectada.forEach(proj => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td><strong>${proj.anio}</strong></td>
                <td>${proj.nacimientos.toLocaleString('es-PE')} nacimientos</td>
                <td><span style="color: #fca5a5; font-weight: 600;">${proj.tasa_cesareas.toFixed(2)}%</span></td>
                <td><span class="badge-tag">Tendencia Decreciente</span></td>
            `;
            tbody.appendChild(tr);
        });
    }

    /**
     * Renderiza la tabla detallada de matriz regional
     */
    function renderizarTablaRegional() {
        const tbody = elements.tbodyMatrizRegional;
        tbody.innerHTML = '';

        state.filteredDepartamentos.forEach(dep => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td><strong>${dep.nombre}</strong></td>
                <td><span class="badge-tag">${dep.region_natural}</span></td>
                <td>${dep.nacimientos.toLocaleString('es-PE')}</td>
                <td>${dep.pct.toFixed(2)}%</td>
                <td><span style="color: ${dep.tasa_cesareas > 40 ? '#f87171' : '#f3f4f6'}; font-weight: 600;">${dep.tasa_cesareas.toFixed(1)}%</span></td>
                <td>${dep.tasa_bajo_peso.toFixed(1)}%</td>
                <td>${dep.tasa_adolescente.toFixed(1)}%</td>
            `;
            tbody.appendChild(tr);
        });
    }

    /**
     * Ordena la tabla regional según la columna seleccionada
     */
    function ordenarTabla() {
        const col = state.sortColumn;
        const asc = state.sortAsc;

        state.filteredDepartamentos.sort((a, b) => {
            let valA = a[col];
            let valB = b[col];
            if (typeof valA === 'string') {
                return asc ? valA.localeCompare(valB) : valB.localeCompare(valA);
            }
            return asc ? (valA - valB) : (valB - valA);
        });

        renderizarTablaRegional();
    }

    /**
     * Filtrado dinámico por término de búsqueda en la tabla
     */
    function filtrarTablaPorTermino(term) {
        if (!term) {
            state.filteredDepartamentos = [...state.data.departamentos];
        } else {
            state.filteredDepartamentos = state.data.departamentos.filter(d => 
                d.nombre.toLowerCase().includes(term) ||
                d.region_natural.toLowerCase().includes(term)
            );
        }
        renderizarTablaRegional();
    }

    /**
     * Control del estado de carga visual
     */
    function mostrarCarga(mostrar) {
        if (mostrar) {
            elements.loadingOverlay.classList.remove('hidden');
        } else {
            elements.loadingOverlay.classList.add('hidden');
        }
    }

    /**
     * Muestra mensaje de error amigable en pantalla
     */
    function mostrarError(mensaje) {
        elements.errorMessage.textContent = mensaje;
        elements.errorContainer.style.display = 'flex';
    }
});
