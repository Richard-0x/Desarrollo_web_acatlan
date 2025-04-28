<?php
session_start();
include 'conexion.php';

if (!isset($_SESSION['user_id'])) {
    header("Location: index.html");
    exit();
}

// Datos para el gráfico
$sql = "SELECT fecha, SUM(volumen_total_m3) AS total_agua 
        FROM riegos 
        WHERE fecha >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
        GROUP BY fecha 
        ORDER BY fecha ASC";
$result = $conn->query($sql);

$labels = [];
$data = [];

while ($row = $result->fetch_assoc()) {
    $labels[] = date("d M", strtotime($row['fecha']));
    $data[] = $row['total_agua'];
}

// Datos para los módulos
$pendientes_mantenimiento = $conn->query("SELECT COUNT(*) as total FROM mantenimientos WHERE estado = 'Pendiente'")->fetch_assoc()['total'];
$stock_bajo = $conn->query("SELECT COUNT(*) as total FROM insumos WHERE cantidad <= 10")->fetch_assoc()['total'];
$atrasados_muestreo = $conn->query("SELECT COUNT(*) as total FROM muestreos WHERE estado = 'Atrasado'")->fetch_assoc()['total'];
$incidentes_criticos = $conn->query("SELECT COUNT(*) as total FROM incidentes WHERE severidad = 'Crítica' AND estado != 'Resuelto'")->fetch_assoc()['total'];
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | PTAR</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            background: linear-gradient(to right, rgb(0,178,169) , rgb(0,62,91));
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
        }
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(to right,  rgb(0,62,91), rgb(0,178,169));
            color: white;
            position: fixed;
            width: 250px;
        }
        .sidebar a {
            color: white;
            text-decoration: none;
            padding: 12px 15px;
            display: block;
            transition: all 0.3s;
        }
        .sidebar a:hover, .sidebar a.active {
            background:rgb(215,165,50);
            color: white;
        }
        .main-content {
            margin-left: 250px;
            padding: 25px;
        }
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .module-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        .alert-badge {
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 0.9rem;
        }
        .chart-container {
            height: 300px;
            position: relative;
        }
        .btn-module {
            padding: 10px 15px;
            border-radius: 8px;
            font-weight: 500;
        }
    </style>
</head>

<body>
    <div class="sidebar">
        <div class="p-3">
            <h4 class="text-center mb-4">
                <i class="bi bi-droplet"></i> PTAR Control
            </h4>
            <hr>
            <ul class="nav nav-pills flex-column">
                <li class="nav-item">
                    <a href="#" class="nav-link active">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="ver_riegos.php" class="nav-link">
                        <i class="bi bi-clipboard-data"></i> Registros
                    </a>
                </li>
                <?php if ($_SESSION['user_rol'] === 'admin'): ?>
                <li>
                    <a href="ver_usuarios.php" class="nav-link">
                        <i class="bi bi-people"></i> Usuarios
                    </a>
                </li>
                <li>
                    <a href="configuracion.php" class="nav-link">
                        <i class="bi bi-gear"></i> Configuración
                    </a>
                </li>
                <?php endif; ?>
            </ul>
            <hr>
            <div class="text-center">
                <img src="https://via.placeholder.com/80" alt="Usuario" class="rounded-circle mb-2">
                <p class="mb-1"><?php echo $_SESSION['user_nombre']; ?></p>
                <small class="text-muted"><?php echo ucfirst($_SESSION['user_rol']); ?></small>
            </div>
        </div>
    </div>

    <div class="main-content">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold">Bienvenido, <span class="text-primary"><?php echo htmlspecialchars($_SESSION['user_nombre']); ?></span></h2>
            <a href="logout.php" class="btn btn-outline-danger">
                <i class="bi bi-box-arrow-right"></i> Cerrar Sesión
            </a>
        </div>

        <!-- Gráfico principal -->
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="module-title"><i class="bi bi-bar-chart"></i> Consumo de Agua (Últimos 7 días)</h5>
                <div class="chart-container">
                    <canvas id="waterChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Módulos principales -->
        <div class="row g-4">
            <!-- Módulo Riegos -->
            <div class="col-md-6 col-lg-4">
                <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="module-title"><i class="bi bi-droplet-half"></i> Riegos</h5>
                        <div class="d-grid gap-2">
                            <a href="agregar_riego.php" class="btn btn-success btn-module">
                                <i class="bi bi-plus-circle"></i> Nuevo Registro
                            </a>
                            <a href="ver_riegos.php" class="btn btn-primary btn-module">
                                <i class="bi bi-list"></i> Ver Registros
                            </a>
                            <?php if ($_SESSION['user_rol'] === 'admin'): ?>
                            <a href="exportar_riegos.php" class="btn btn-info btn-module">
                                <i class="bi bi-file-earmark-excel"></i> Exportar
                            </a>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Módulo Mantenimientos -->
            <div class="col-md-6 col-lg-4">
                <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="module-title"><i class="bi bi-tools"></i> Mantenimientos</h5>
                        <?php if ($pendientes_mantenimiento > 0): ?>
                        <div class="alert alert-warning alert-badge mb-3">
                            <i class="bi bi-exclamation-triangle"></i> <?= $pendientes_mantenimiento ?> pendientes
                        </div>
                        <?php endif; ?>
                        <div class="d-grid gap-2">
                            <a href="agregar_mantenimiento.php" class="btn btn-success btn-module">
                                <i class="bi bi-plus-circle"></i> Nuevo
                            </a>
                            <a href="ver_mantenimientos.php" class="btn btn-primary btn-module">
                                <i class="bi bi-list-task"></i> Ver Listado
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Módulo Incidentes -->
            <div class="col-md-6 col-lg-4">
                <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="module-title"><i class="bi bi-exclamation-octagon"></i> Incidentes</h5>
                        <?php if ($incidentes_criticos > 0): ?>
                        <div class="alert alert-danger alert-badge mb-3">
                            <i class="bi bi-exclamation-triangle-fill"></i> <?= $incidentes_criticos ?> críticos
                        </div>
                        <?php endif; ?>
                        <div class="d-grid gap-2">
                            <a href="reportar_incidente.php" class="btn btn-danger btn-module">
                                <i class="bi bi-plus-circle"></i> Reportar
                            </a>
                            <a href="ver_incidentes.php" class="btn btn-primary btn-module">
                                <i class="bi bi-list"></i> Ver Todos
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Módulo Calidad del Agua -->
            <div class="col-md-6 col-lg-4">
                <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="module-title"><i class="bi bi-beaker"></i> Calidad</h5>
                        <div class="d-grid gap-2">
                            <a href="agregar_calidad.php" class="btn btn-success btn-module">
                                <i class="bi bi-plus-circle"></i> Nuevo Análisis
                            </a>
                            <a href="ver_calidad.php" class="btn btn-primary btn-module">
                                <i class="bi bi-graph-up"></i> Reportes
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Módulo Insumos -->
            <div class="col-md-6 col-lg-4">
                <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="module-title"><i class="bi bi-box-seam"></i> Insumos</h5>
                        <?php if ($stock_bajo > 0): ?>
                        <div class="alert alert-warning alert-badge mb-3">
                            <i class="bi bi-exclamation-triangle"></i> <?= $stock_bajo ?> bajos en stock
                        </div>
                        <?php endif; ?>
                        <div class="d-grid gap-2">
                            <a href="agregar_insumo.php" class="btn btn-success btn-module">
                                <i class="bi bi-plus-circle"></i> Nuevo
                            </a>
                            <a href="ver_insumos.php" class="btn btn-primary btn-module">
                                <i class="bi bi-boxes"></i> Inventario
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Módulo Muestreos -->
            <div class="col-md-6 col-lg-4">
                <div class="card h-100">
                    <div class="card-body d-flex flex-column">
                        <h5 class="module-title"><i class="bi bi-calendar-week"></i> Muestreos</h5>
                        <?php if ($atrasados_muestreo > 0): ?>
                        <div class="alert alert-danger alert-badge mb-3">
                            <i class="bi bi-clock-history"></i> <?= $atrasados_muestreo ?> atrasados
                        </div>
                        <?php endif; ?>
                        <div class="d-grid gap-2">
                            <a href="calendario_muestreos.php" class="btn btn-primary btn-module">
                                <i class="bi bi-calendar"></i> Calendario
                            </a>
                            <a href="agregar_muestreo.php" class="btn btn-success btn-module">
                                <i class="bi bi-plus-circle"></i> Programar
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Configuración del gráfico
        const ctx = document.getElementById('waterChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: <?php echo json_encode($labels); ?>,
                datasets: [{
                    label: 'Consumo (m³)',
                    data: <?php echo json_encode($data); ?>,
                    backgroundColor: '#4facfe',
                    borderColor: '#3498db',
                    borderWidth: 2,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Metros cúbicos (m³)'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Fecha'
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>