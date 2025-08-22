# Server Bootstrap

Colección de scripts de instalación y configuración para preparar entornos Linux (Ubuntu Server 20.04/22.04).  
Este repositorio facilita la instalación de dependencias esenciales para proyectos de desarrollo y despliegue, permitiendo entornos consistentes y fácilmente reproducibles.

---

## 🚀 Características
- Scripts organizados por áreas (base system, databases, ERP, network tools).
- Comandos seguros y actualizados.
- Compatible con Ubuntu Server (20.04, 22.04).
- Enfoque reproducible para DevOps y despliegues.

---

## 📂 Estructura (Ejemplo de estructura)
```

server-bootstrap/
│── scripts/
│   ├── base.sh          # Actualización del sistema y utilidades básicas
│   ├── postgres.sh      # Instalación y configuración de PostgreSQL
│   ├── odoo.sh          # Dependencias de Odoo ERP
│   ├── genieacs.sh      # Instalación de GenieACS y dependencias
│   └── custom.sh        # Ejemplo de script personalizado
│
└── README.md

````

---

## ⚙️ Requisitos
- Distribución: **Ubuntu Server 20.04 o 22.04**
- Usuario con privilegios `sudo`

---

## 🔧 Uso

1. Clona este repositorio:
   
   ```bash
   git clone https://github.com/Jeremias0618/server-bootstrap.git
   cd server-bootstrap
   ````

2. Dale permisos de ejecución al script deseado:

   ```bash
   chmod +x install_fiberops.sh
   ```

3. Ejecútalo:

   ```bash
   ./install_fiberops.sh
   ```

---

## 📌 Ejemplos de scripts incluidos

* **base.sh** → Actualiza el sistema, instala `curl`, `wget`, `git`, `unzip`, etc.
* **postgres.sh** → Instala y configura PostgreSQL con usuario y base de datos por defecto.
* **odoo.sh** → Prepara dependencias para Odoo ERP (Python, wkhtmltopdf, etc).
* **genieacs.sh** → Instala dependencias de Node.js, MongoDB y Redis.