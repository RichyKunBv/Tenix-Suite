# Tenix Suite Scripts

![Versión](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Licencia](https://img.shields.io/badge/licencia-GPL-blue.svg)
![Shell](https://img.shields.io/badge/language-Shell%20Script-red.svg)

**La navaja suiza definitiva para el mantenimiento y gestión de aplicaciones en tu sistema Linux.**

Tenix Suite es la fusión de dos potentes herramientas: **Mantenix**, para el mantenimiento integral del sistema, y **Apptenix**, para instalar y gestionar aplicaciones de forma sencilla.

---

## ✨ Características Principales

Tenix Suite combina lo mejor de dos mundos en un solo script interactivo y fácil de usar.

### 🔧 Módulo 1: Mantenix (Mantenimiento del Sistema)

Mantén tu sistema operativo funcionando a máximo rendimiento con el mínimo esfuerzo.

-   **Multi-Distro:** Soporte nativo para las familias de distribuciones más populares:
    -   Debian (Ubuntu, Mint, etc.)
    -   Fedora (RHEL, CentOS)
    -   Arch Linux (Manjaro, EndeavourOS)
-   **Actualización Universal:** Actualiza repositorios, sistema, paquetes Flatpak y Snap con un solo comando.
-   **Soporte para AUR:** Integración con helpers como `yay` y `paru` para usuarios de Arch.
-   **Limpieza Profunda:** Elimina paquetes huérfanos, limpia la caché y borra kernels antiguos de forma segura.
-   **Modo DIOS:** Ejecuta una secuencia completa de actualización profunda, limpieza y optimización con una sola opción.

### 📦 Módulo 2: Apptenix (Gestor de Aplicaciones)

Instala aplicaciones que no están en los repositorios oficiales de una forma limpia y organizada.

-   **Instalación Flexible:** Instala software desde casi cualquier formato: `.zip`, `.tar.gz`, `.tar.xz`, `.tar.bz2`, `.7z` o binarios ejecutables.
-   **Detección Inteligente:** Analiza los archivos y te ayuda a seleccionar el ejecutable principal y el icono de la aplicación.
-   **Integración con el Sistema:** Crea automáticamente un lanzador en el menú de aplicaciones (`.desktop`) y un comando de terminal para un acceso fácil.
-   **Análisis de Dependencias:** Revisa el binario con `ldd` para advertirte sobre posibles librerías faltantes antes de instalar.
-   **Gestión Limpia:** Registra todas las aplicaciones instaladas, permitiéndote listarlas y desinstalarlas de forma segura, eliminando todos los archivos asociados.
-   **Registro de Actividad:** Guarda un log detallado de todas las instalaciones y errores en `~/.config/app-installer/install.log`.

---

## 🚀 Instalación

Puedes instalar Tenix Suite con un simple comando en tu terminal.

```bash
curl -sL [https://raw.githubusercontent.com/RichyKunBv/Tenix-Suite/main/TenixSuite.sh](https://raw.githubusercontent.com/RichyKunBv/Tenix-Suite/main/TenixSuite.sh) -o TenixSuite.sh && chmod +x TenixSuite.sh
```

O si prefieres usar `wget`:

```bash
wget -qO TenixSuite.sh [https://raw.githubusercontent.com/RichyKunBv/Tenix-Suite/main/TenixSuite.sh](https://raw.githubusercontent.com/RichyKunBv/Tenix-Suite/main/TenixSuite.sh) && chmod +x TenixSuite.sh
```

---

## 🛠️ Uso

El script requiere permisos de superusuario para gestionar paquetes del sistema y realizar instalaciones a nivel de sistema (`/opt`).

Ejecútalo con `sudo`:

```bash
sudo ./TenixSuite.sh
```

Aparecerá un menú interactivo donde podrás elegir entre el módulo de **Mantenix** o **Apptenix**, además de otras opciones como actualizar el propio script o ver la información del proyecto.

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Si tienes ideas para mejorar Tenix Suite, por favor abre un *issue* para discutirlo o envía un *pull request* con tus cambios.

1.  Haz un Fork del proyecto.
2.  Crea tu rama de funcionalidades (`git checkout -b feature/AmazingFeature`).
3.  Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`).
4.  Haz push a la rama (`git push origin feature/AmazingFeature`).
5.  Abre un Pull Request.

---

## 📜 Licencia

Distribuido bajo la **GNU General Public License**. Ver `LICENSE` para más información.

---

**Creado con ❤️ por RichyKunBv**
**Unificado por Gemini 🤖**