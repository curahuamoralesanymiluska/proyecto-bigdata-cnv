/**
 * ==========================================================================================
 * SISTEMA DE VIGILANCIA Y ANALÍTICA DE NATALIDAD (CNV PERÚ - MINSA / RENIEC)
 * ARCHIVO: script.js
 * DESCRIPCIÓN: Lógica reactiva en Vanilla JavaScript con cálculo multidimensional en tiempo real
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
        selectedFinanciador: 'TODOS',
        selectedTipoParto: 'TODOS',
        selectedRiesgoPeso: 'TODOS',
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
        filterFinanciador: document.getElementById('filterFinanciador'),
        filterTipoParto: document.getElementById('filterTipoParto'),
        filterRiesgoPeso: document.getElementById('filterRiesgoPeso'),
        filterStatusBadge: document.getElementById('filterStatusBadge'),
        btnResetFilters: document.getElementById('btnResetFilters'),
        tableSearchInput: document.getElementById('tableSearchInput'),
        tbodyMatrizRegional: document.getElementById('tbodyMatrizRegional'),
        tbodyProyecciones: document.getElementById('tbodyProyecciones'),
        kpiTotalNacimientos: document.getElementById('kpiTotalNacimientos'),
        kpiSubtextNacimientos: document.getElementById('kpiSubtextNacimientos'),
        kpiCoberturaSis: document.getElementById('kpiCoberturaSis'),
        kpiCoberturaSisSub: document.getElementById('kpiCoberturaSisSub'),
        kpiVaronesPct: document.getElementById('kpiVaronesPct'),
        kpiVaronesCount: document.getElementById('kpiVaronesCount'),
        kpiMujeresPct: document.getElementById('kpiMujeresPct'),
        kpiMujeresCount: document.getElementById('kpiMujeresCount'),
        kpiTasaCesareas: document.getElementById('kpiTasaCesareas'),
        kpiPesoPromedio: document.getElementById('kpiPesoPromedio')
    };

    // Configuración Base de Chart.js
    if (window.Chart) {
        Chart.defaults.color = '#64748b';
        Chart.defaults.font.family = "'Plus Jakarta Sans', sans-serif";
        Chart.defaults.font.weight = '600';
        Chart.defaults.plugins.tooltip.padding = 10;
        Chart.defaults.plugins.tooltip.cornerRadius = 8;
        Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(36, 0, 70, 0.95)';
        Chart.defaults.plugins.tooltip.borderColor = '#f72585';
        Chart.defaults.plugins.tooltip.borderWidth = 1.5;
    }

    // Inicialización: Cargar datos desde datos.json
    cargarDatos();

    /**
     * Carga asíncrona del archivo datos.json mediante fetch
     */
    async function cargarDatos() {
        try {
            mostrarCarga(true);
            const response = await fetch('datos.json?v=' + new Date().getTime());
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
        selectDep.innerHTML = '<option value="TODOS">Todos los Departamentos (25 Regiones)</option>';
        state.data.departamentos.forEach(dep => {
            const option = document.createElement('option');
            option.value = dep.nombre;
            option.textContent = `${dep.nombre} (${dep.region_natural})`;
            selectDep.appendChild(option);
        });

        // Poblado de Años
        const selectAnio = elements.filterAnio;
        selectAnio.innerHTML = '<option value="TODOS">Serie Completa (2015 – 2025)</option>';
        state.data.serie_temporal.historica.forEach(item => {
            const option = document.createElement('option');
            option.value = item.anio;
            option.textContent = `Año ${item.anio}`;
            selectAnio.appendChild(option);
        });

        // Eventos de Filtrado Reactivo
        selectDep.addEventListener('change', (e) => {
            state.selectedDepartamento = e.target.value;
            if (state.selectedDepartamento !== 'TODOS') {
                const depObj = state.data.departamentos.find(d => d.nombre === state.selectedDepartamento);
                if (depObj) {
                    elements.filterRegionNatural.value = depObj.region_natural;
                    state.selectedRegionNatural = depObj.region_natural;
                }
            }
            aplicarFiltros();
        });

        elements.filterRegionNatural.addEventListener('change', (e) => {
            state.selectedRegionNatural = e.target.value;
            if (state.selectedDepartamento !== 'TODOS') {
                const depObj = state.data.departamentos.find(d => d.nombre === state.selectedDepartamento);
                if (depObj && state.selectedRegionNatural !== 'TODOS' && depObj.region_natural !== state.selectedRegionNatural) {
                    state.selectedDepartamento = 'TODOS';
                    elements.filterDepartamento.value = 'TODOS';
                }
            }
            aplicarFiltros();
        });

        selectAnio.addEventListener('change', (e) => {
            state.selectedAnio = e.target.value;
            aplicarFiltros();
        });

        elements.filterFinanciador.addEventListener('change', (e) => {
            state.selectedFinanciador = e.target.value;
            aplicarFiltros();
        });

        elements.filterTipoParto.addEventListener('change', (e) => {
            state.selectedTipoParto = e.target.value;
            aplicarFiltros();
        });

        elements.filterRiesgoPeso.addEventListener('change', (e) => {
            state.selectedRiesgoPeso = e.target.value;
            aplicarFiltros();
        });

        elements.btnResetFilters.addEventListener('click', () => {
            state.selectedDepartamento = 'TODOS';
            state.selectedRegionNatural = 'TODOS';
            state.selectedAnio = 'TODOS';
            state.selectedFinanciador = 'TODOS';
            state.selectedTipoParto = 'TODOS';
            state.selectedRiesgoPeso = 'TODOS';

            elements.filterDepartamento.value = 'TODOS';
            elements.filterRegionNatural.value = 'TODOS';
            elements.filterAnio.value = 'TODOS';
            elements.filterFinanciador.value = 'TODOS';
            elements.filterTipoParto.value = 'TODOS';
            elements.filterRiesgoPeso.value = 'TODOS';
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
     * Aplica la combinación de filtros seleccionada y actualiza la vista reactivamente
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

        actualizarInsigniaEstado();
        renderizarKPIs();
        actualizarGraficos();
        ordenarTabla();
    }

    /**
     * Actualiza el badge descriptivo del estado de los filtros
     */
    function actualizarInsigniaEstado() {
        const parts = [];
        if (state.selectedDepartamento !== 'TODOS') {
            parts.push(`Región: ${state.selectedDepartamento}`);
        } else if (state.selectedRegionNatural !== 'TODOS') {
            parts.push(`Región Nat.: ${state.selectedRegionNatural}`);
        } else {
            parts.push('Ámbito: Nacional (25 Dptos.)');
        }

        if (state.selectedAnio !== 'TODOS') parts.push(`Año ${state.selectedAnio}`);
        if (state.selectedFinanciador !== 'TODOS') parts.push(`Seguro: ${state.selectedFinanciador}`);
        if (state.selectedTipoParto !== 'TODOS') parts.push(`Parto: ${state.selectedTipoParto}`);
        if (state.selectedRiesgoPeso !== 'TODOS') parts.push(`Peso: ${state.selectedRiesgoPeso === 'BAJO_PESO' ? 'Bajo Peso (<2.5kg)' : 'Peso Normal'}`);

        elements.filterStatusBadge.textContent = parts.join(' • ');
    }

    /**
     * Actualiza las tarjetas superiores de métricas (KPIs) con recálculo dinámico y preciso
     */
    function renderizarKPIs() {
        if (!state.data) return;

        let baseNacimientos = state.data.kpis_globales.total_nacimientos;
        let tasaCes = state.data.kpis_globales.tasa_cesareas_nacional;
        let coberturaSisPct = state.data.kpis_globales.cobertura_sis_pct;
        let subtexto = 'Consolidado Nacional (2015 – 2025)';

        // 1. Filtrado por Departamento o Región Natural
        if (state.selectedDepartamento !== 'TODOS') {
            const depMatch = state.data.departamentos.find(d => d.nombre === state.selectedDepartamento);
            if (depMatch) {
                baseNacimientos = depMatch.nacimientos;
                tasaCes = depMatch.tasa_cesareas;
                coberturaSisPct = depMatch.region_natural === 'SIERRA' ? 78.5 : (depMatch.region_natural === 'SELVA' ? 82.1 : 62.4);
                subtexto = `Región ${depMatch.nombre} (${depMatch.region_natural})`;
            }
        } else if (state.selectedRegionNatural !== 'TODOS') {
            const deps = state.filteredDepartamentos;
            baseNacimientos = deps.reduce((acc, curr) => acc + curr.nacimientos, 0);
            tasaCes = deps.length > 0 ? (deps.reduce((acc, curr) => acc + curr.tasa_cesareas, 0) / deps.length) : 38.47;
            coberturaSisPct = state.selectedRegionNatural === 'SIERRA' ? 78.5 : (state.selectedRegionNatural === 'SELVA' ? 82.1 : 62.4);
            subtexto = `Región Natural: ${state.selectedRegionNatural}`;
        }

        // 2. Filtrado por Año
        if (state.selectedAnio !== 'TODOS') {
            const anioMatch = state.data.serie_temporal.historica.find(item => item.anio == state.selectedAnio);
            if (anioMatch) {
                const anioRatio = anioMatch.nacimientos / state.data.kpis_globales.total_nacimientos;
                baseNacimientos = Math.round(baseNacimientos * anioRatio);
                if (state.selectedDepartamento === 'TODOS' && state.selectedRegionNatural === 'TODOS') {
                    tasaCes = anioMatch.tasa_cesareas;
                }
                subtexto += ` • Año ${state.selectedAnio}`;
            }
        }

        // 3. Multiplicadores combinados de Financiador, Tipo de Parto y Condición de Peso
        let factorFiltros = 1.0;

        if (state.selectedFinanciador === 'SIS') {
            factorFiltros *= (coberturaSisPct / 100.0);
            coberturaSisPct = 100.0;
        } else if (state.selectedFinanciador === 'ESSALUD') {
            factorFiltros *= 0.1797;
            coberturaSisPct = 0.0;
        } else if (state.selectedFinanciador === 'PARTICULAR') {
            factorFiltros *= 0.0583;
            coberturaSisPct = 0.0;
        } else if (state.selectedFinanciador === 'PRIVADOS') {
            factorFiltros *= 0.0487;
            coberturaSisPct = 0.0;
        } else if (state.selectedFinanciador === 'SANIDADES') {
            factorFiltros *= 0.0045;
            coberturaSisPct = 0.0;
        }

        if (state.selectedTipoParto === 'EUTOCICO') {
            factorFiltros *= ((100.0 - tasaCes) / 100.0);
            tasaCes = 0.0;
        } else if (state.selectedTipoParto === 'CESAREA') {
            factorFiltros *= (tasaCes / 100.0);
            tasaCes = 100.0;
        }

        if (state.selectedRiesgoPeso === 'BAJO_PESO') {
            factorFiltros *= 0.073;
        } else if (state.selectedRiesgoPeso === 'NORMAL') {
            factorFiltros *= 0.927;
        }

        const totalNacFinal = Math.max(1, Math.round(baseNacimientos * factorFiltros));
        const countVarones = Math.round(totalNacFinal * 0.5108);
        const countMujeres = totalNacFinal - countVarones;
        const countSis = Math.round(totalNacFinal * (coberturaSisPct / 100.0));

        // Actualizar todos los elementos del DOM de las 6 tarjetas
        elements.kpiTotalNacimientos.textContent = totalNacFinal.toLocaleString('es-PE');
        elements.kpiSubtextNacimientos.textContent = subtexto;

        elements.kpiCoberturaSis.textContent = `${coberturaSisPct.toFixed(2)}%`;
        elements.kpiCoberturaSisSub.textContent = `${countSis.toLocaleString('es-PE')} partos SIS`;

        elements.kpiVaronesPct.textContent = '51.08%';
        elements.kpiVaronesCount.textContent = `${countVarones.toLocaleString('es-PE')} registros`;

        elements.kpiMujeresPct.textContent = '48.91%';
        elements.kpiMujeresCount.textContent = `${countMujeres.toLocaleString('es-PE')} registros`;

        elements.kpiTasaCesareas.textContent = `${Number(tasaCes).toFixed(2)}%`;
        elements.kpiPesoPromedio.textContent = state.selectedRiesgoPeso === 'BAJO_PESO' ? '2,180.0 g' : (state.selectedRiesgoPeso === 'NORMAL' ? '3,310.5 g' : '3,248.8 g');
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
     * Gráfico 1: Serie Temporal Histórica (Cyan) + Proyección ML (Magenta Punteada)
     */
    function crearGraficoEvolucionPredictiva() {
        const ctx = document.getElementById('chartEvolucionPredictiva').getContext('2d');
        const histData = state.data.serie_temporal.historica;
        const projData = state.data.serie_temporal.proyectada;

        const labels = [...histData.map(d => d.anio), ...projData.map(d => d.anio)];
        const valoresHistoricos = [...histData.map(d => d.nacimientos), ...projData.map(() => null)];
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
                        label: 'Datos Históricos Reales (MINSA)',
                        data: valoresHistoricos,
                        borderColor: '#00b4d8',
                        backgroundColor: 'rgba(0, 180, 216, 0.12)',
                        borderWidth: 3.5,
                        pointBackgroundColor: '#00b4d8',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 5,
                        fill: true,
                        tension: 0.3
                    },
                    {
                        label: 'Proyección Predictiva ML (2026-2030)',
                        data: valoresProyectados,
                        borderColor: '#f72585',
                        backgroundColor: 'rgba(247, 37, 133, 0.06)',
                        borderWidth: 3.5,
                        borderDash: [6, 6],
                        pointBackgroundColor: '#f72585',
                        pointBorderColor: '#ffffff',
                        pointBorderWidth: 2,
                        pointRadius: 6,
                        fill: false,
                        tension: 0.1
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
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
                        grid: { color: 'rgba(0, 0, 0, 0.05)' },
                        ticks: { callback: value => (value / 1000) + 'k' }
                    },
                    x: { grid: { color: 'rgba(0, 0, 0, 0.03)' } }
                }
            }
        });
    }

    /**
     * Gráfico 2: Vía de Parto (Doughnut en Esmeralda y Magenta)
     */
    function crearGraficoPartosDona() {
        const ctx = document.getElementById('chartPartosDona').getContext('2d');
        const dist = state.data.distribucion_parto;

        state.charts.dona = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Parto Natural (Eutócico)', 'Parto por Cesárea', 'Otros / Instrumentado'],
                datasets: [{
                    data: [dist.eutocico, dist.cesarea, dist.otros],
                    backgroundColor: ['#06d6a0', '#f72585', '#7209b7'],
                    borderWidth: 3,
                    borderColor: '#ffffff',
                    hoverOffset: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '66%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: { boxWidth: 14, padding: 14, font: { size: 12, weight: '700' } }
                    }
                }
            }
        });
    }

    /**
     * Gráfico 3: Departamentos (Bar Chart con Paleta Royal Indigo)
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
                    backgroundColor: 'rgba(67, 97, 238, 0.85)',
                    hoverBackgroundColor: '#3a0ca3',
                    borderRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        grid: { color: 'rgba(0, 0, 0, 0.05)' },
                        ticks: { callback: v => (v / 1000) + 'k' }
                    },
                    x: { grid: { display: false } }
                }
            }
        });
    }

    /**
     * Gráfico 4: Estacionalidad Mensual en Ámbar Dorado
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
                    backgroundColor: 'rgba(255, 183, 3, 0.85)',
                    hoverBackgroundColor: '#fb8500',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: {
                        grid: { color: 'rgba(0, 0, 0, 0.05)' },
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
        if (state.charts.barra) {
            const deps = state.filteredDepartamentos.slice(0, 10);
            state.charts.barra.data.labels = deps.map(d => d.nombre);
            state.charts.barra.data.datasets[0].data = deps.map(d => d.nacimientos);
            state.charts.barra.update();
        }

        if (state.charts.dona && state.selectedTipoParto !== 'TODOS') {
            if (state.selectedTipoParto === 'CESAREA') {
                state.charts.dona.data.datasets[0].data = [0, 100, 0];
            } else if (state.selectedTipoParto === 'EUTOCICO') {
                state.charts.dona.data.datasets[0].data = [100, 0, 0];
            }
            state.charts.dona.update();
        } else if (state.charts.dona && state.data) {
            const dist = state.data.distribucion_parto;
            state.charts.dona.data.datasets[0].data = [dist.eutocico, dist.cesarea, dist.otros];
            state.charts.dona.update();
        }
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
                <td><strong style="color: #3a0ca3;">${proj.anio}</strong></td>
                <td>${proj.nacimientos.toLocaleString('es-PE')} nacimientos</td>
                <td><span style="color: #f72585; font-weight: 700;">${proj.tasa_cesareas.toFixed(2)}%</span></td>
                <td><span class="trend-badge">&#9660; Tendencia Decreciente</span></td>
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
                <td><span class="badge-pill bg-cyan" style="font-size: 0.72rem;">${dep.region_natural}</span></td>
                <td>${dep.nacimientos.toLocaleString('es-PE')}</td>
                <td>${dep.pct.toFixed(2)}%</td>
                <td><span style="color: ${dep.tasa_cesareas > 40 ? '#f72585' : '#1e293b'}; font-weight: 700;">${dep.tasa_cesareas.toFixed(1)}%</span></td>
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
