# Tenix Suite Scripts

![Versión](https://img.shields.io/badge/version-1.1.0-green.svg)
![Licencia](https://img.shields.io/badge/licencia-Apache-blue.svg)
![Shell](https://img.shields.io/badge/language-Shell%20Script-red.svg)

**La navaja suiza definitiva para el mantenimiento y gestión de aplicaciones en tu sistema Linux.**

Tenix Suite es la fusión de dos potentes herramientas: **Mantenix**, para el mantenimiento integral del sistema, y **Apptenix**, para instalar y gestionar aplicaciones de forma sencilla.

---

## ✨ Características Principales

Tenix Suite combina lo mejor de dos mundos en un solo script interactivo y fácil de usar.
<img width="827" height="615" alt="imagen" src="https://github.com/user-attachments/assets/935e1605-32c0-4240-b479-71d0e15f6bb1" />


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
<img width="827" height="615" alt="imagen" src="https://github.com/user-attachments/assets/58aab812-c138-4fe5-b166-602126bd6805" />


### 📦 Módulo 2: Apptenix (Gestor de Aplicaciones)

Instala aplicaciones que no están en los repositorios oficiales de una forma limpia y organizada.

-   **Instalación Flexible:** Instala software desde casi cualquier formato: `.zip`, `.tar.gz`, `.tar.xz`, `.tar.bz2`, `.7z` o binarios ejecutables.
-   **Detección Inteligente:** Analiza los archivos y te ayuda a seleccionar el ejecutable principal y el icono de la aplicación.
-   **Integración con el Sistema:** Crea automáticamente un lanzador en el menú de aplicaciones (`.desktop`) y un comando de terminal para un acceso fácil.
-   **Análisis de Dependencias:** Revisa el binario con `ldd` para advertirte sobre posibles librerías faltantes antes de instalar.
-   **Gestión Limpia:** Registra todas las aplicaciones instaladas, permitiéndote listarlas y desinstalarlas de forma segura, eliminando todos los archivos asociados.
-   **Registro de Actividad:** Guarda un log detallado de todas las instalaciones y errores en `~/.config/app-installer/install.log`.
<img width="827" height="615" alt="imagen" src="https://github.com/user-attachments/assets/f84d57c2-33e8-4174-a084-8b79967acf80" />


### 🔍 Módulo 3: Revision completa de la PC (Una pequeña mezcla de CPU-Z, Crystal Disk Info y la salud de bateria de Apple)

Haz una revision mas facil de tu sistema con unos pocos clics.

-   **Especificaciones:** Con la opcion "E" puedes ver los nucleos de procesador, la ram, los graficos de tu pc y tu kernel actual
<img width="827" height="615" alt="imagen" src="https://github.com/user-attachments/assets/0f154aa0-211b-48bf-af5b-005db8a93009" />

-   **Revision de Disco Duro:** Con la opcion "D" puedes ver la lista de los discos duros instalados y ahi encuentras las especificaciones del disco y informacion de su S.M.A.R.T (Temperatura, porcentaje usado, cliclos, etc.)

| Lista de Discos Duros | Especificaciones del Disco | Datos S.M.A.R.T |
| :---: | :---: | :---: |
|<img width="827" height="615" alt="imagen" src="https://github.com/user-attachments/assets/e2fde063-e46c-4246-acd8-2362519b071e" /> | <img width="827" height="615" alt="imagen" src="https://github.com/user-attachments/assets/84140a32-64fe-4102-a4eb-e1682668a5b8" /> | <img width="827" height="615" alt="imagen" src="https://github.com/user-attachments/assets/49556f1c-65dd-4e51-a6ec-14995b36fc00" />

-   **Informacion de tu bateria:** Pulsando "B" puedes ver su estado, ciclos de carga, duracion estimada, porcentaje y su capacidad maxima (lo tipo Apple)
<img width="827" height="615" alt="imagen" src="https://github.com/user-attachments/assets/87604b6f-dad7-45f5-bcb4-26a7ea14167b" />

  
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

Distribuido bajo la **Apache License 2.0**. Ver `LICENSE` para más información.

---

**Creado con ❤️ por RichyKunBv**

**Unificado por Gemini 🤖**
