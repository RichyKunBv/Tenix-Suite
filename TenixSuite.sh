#!/bin/bash

# ##################################################################
# Tenix Suite - Fusion de Mantenix y Apptenix
# Creador: RichyKunBv
# Las unifique xdd
# ##################################################################

clear

set -o errexit
set -o pipefail
set -o nounset

# --- Versiones ---
VERSION_LOCAL="1.0.0" # Version de la suit (nota: cambiar esta version cuando se actualice el script)
MANTENIX_VERSION="3.0.6" # poner la version actual de mantenix
APPTENIX_VERSION="1.0.4" # poner la version actual de apptenix

# --- Colores ---
DEFAULT='\033[0m'
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMA='\033[0;33m'
ASUL='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'

# --- Variables Globales ---
DISTRO=""
DISTRO_FAMILIA=""

detectar_distribucion() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO="$ID"
        
        if [[ "$ID" == "debian" || "$ID_LIKE" == *"debian"* ]]; then
            DISTRO_FAMILIA="debian"
        elif [[ "$ID" == "fedora" || "$ID_LIKE" == *"fedora"* || "$ID" == "rhel" || "$ID" == "centos" ]]; then
            DISTRO_FAMILIA="fedora"
        elif [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* || "$ID" == "manjaro" ]]; then
            DISTRO_FAMILIA="arch"
        else
            DISTRO_FAMILIA="desconocida"
        fi
    elif [ -f /etc/redhat-release ]; then
        DISTRO="redhat"; DISTRO_FAMILIA="fedora"
    elif [ -f /etc/arch-release ]; then
        DISTRO="arch"; DISTRO_FAMILIA="arch"
    else
        DISTRO="desconocida"; DISTRO_FAMILIA="desconocida"
    fi
    
    echo -e "${VERDE}Distribución detectada: $DISTRO (Familia: $DISTRO_FAMILIA)${DEFAULT}"
}

# --- cositas de apptenix ---
info() { echo -e "${ASUL}INFO:${DEFAULT} $1"; }
success() { echo -e "${VERDE}ÉXITO:${DEFAULT} $1"; }
warn() { echo -e "${AMA}AVISO:${DEFAULT} $1"; }
error() { echo -e "${ROJO}ERROR:${DEFAULT} $1" >&2; return 1; }





# --- MANTENIX ---

function actualizar_sistema() {
    echo -e "\n${AMA}› Actualizando repositorios y paquetes del sistema...${DEFAULT}"
    case "$DISTRO_FAMILIA" in
        debian) apt-get update -qq && apt-get upgrade -y && echo -e "${VERDE}  APT actualizado.${DEFAULT}";;
        fedora) (if command -v dnf &>/dev/null; then dnf upgrade -y; else yum update -y; fi) && echo -e "${VERDE}  Sistema actualizado.${DEFAULT}";;
        arch)
            pacman -Syyu --noconfirm && echo -e "${VERDE}  Pacman actualizado.${DEFAULT}"
            if command -v yay &>/dev/null; then echo -e "\n${AMA}› Actualizando AUR con yay...${DEFAULT}"; yay -Syu --noconfirm && echo -e "${VERDE}  AUR actualizado.${DEFAULT}"; fi
            if command -v paru &>/dev/null; then echo -e "\n${AMA}› Actualizando AUR con paru...${DEFAULT}"; paru -Syu --noconfirm && echo -e "${VERDE}  AUR actualizado.${DEFAULT}"; fi
            ;;
        *) echo -e "${ROJO}  Distribución no soportada para actualización.${DEFAULT}";;
    esac
}

function actualizar_flatpak() {
    if ! command -v flatpak &>/dev/null; then return; fi
    echo -e "\n${AMA}› Actualizando paquetes Flatpak...${DEFAULT}"
    flatpak update -y
    echo -e "${VERDE}  Flatpak actualizado.${DEFAULT}"
}

function actualizar_snap() {
    if ! command -v snap &>/dev/null; then return; fi
    echo -e "\n${AMA}› Actualizando paquetes Snap...${DEFAULT}"
    snap refresh
    echo -e "${VERDE}  Snap actualizado.${DEFAULT}"
}

function limpiar_sistema() {
    echo -e "\n${AMA}› Limpiando sistema...${DEFAULT}"
    case "$DISTRO_FAMILIA" in
        debian) apt-get autoremove -y; apt-get autoclean; apt-get clean; if command -v purge-old-kernels &>/dev/null; then echo -e "${AMA}  Eliminando kernels antiguos...${DEFAULT}"; purge-old-kernels --keep 2; fi;;
        fedora) if command -v dnf &>/dev/null; then dnf autoremove -y; dnf clean all; else yum autoremove -y; yum clean all; fi;;
        arch) pacman -Sc --noconfirm; if pacman -Qtdq &>/dev/null; then pacman -Rns $(pacman -Qtdq) --noconfirm; fi;;
        *) echo -e "${ROJO}  Distribución no soportada para limpieza.${DEFAULT}";;
    esac
    if command -v journalctl &>/dev/null; then echo -e "${AMA}  Limpiando logs del sistema...${DEFAULT}"; journalctl --vacuum-time=7d >/dev/null 2>&1; fi
    echo -e "${VERDE}  Sistema limpiado.${DEFAULT}"
}

function actualizacion_profunda() {
    echo -e "\n${AMA}› Realizando ACTUALIZACIÓN PROFUNDA del sistema...${DEFAULT}"
    case "$DISTRO_FAMILIA" in
        debian) apt-get update -qq && apt-get full-upgrade -y;;
        fedora) if command -v dnf &>/dev/null; then dnf upgrade --refresh --best --allowerasing -y; else yum update --refresh -y; fi;;
        arch) pacman -Syyu --noconfirm;;
        *) echo -e "${ROJO}  Distribución no soportada.${DEFAULT}";;
    esac
    echo -e "${VERDE}  Actualización profunda completada.${DEFAULT}"
}

function optimizar_sistema() {
    echo -e "\n${AMA}› Optimizando el sistema...${DEFAULT}"
    case "$DISTRO_FAMILIA" in
        debian) echo -e "${AMA}  Verificando paquetes...${DEFAULT}"; apt-get check;;
        fedora) if command -v dnf &>/dev/null; then echo -e "${AMA}  Verificando paquetes...${DEFAULT}"; dnf check; fi;;
        arch) echo -e "${AMA}  Verificando archivos de paquetes...${DEFAULT}"; pacman -Qk;;
    esac
    echo -e "${VERDE}  Optimización completada.${DEFAULT}"
}

# --- APPTENIX ---

LOG_FILE="$HOME/.config/app-installer/install.log"

log() {
  mkdir -p "$(dirname "$LOG_FILE")"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

info()    { echo -e "${ASUL}INFO:${DEFAULT} $1";   log "INFO: $1"; }
success() { echo -e "${VERDE}ÉXITO:${DEFAULT} $1"; log "ÉXITO: $1"; }
warn()    { echo -e "${AMA}AVISO:${DEFAULT} $1";log "AVISO: $1"; }
error()   { echo -e "${ROJO}ERROR:${DEFAULT} $1" >&2; log "ERROR: $1"; exit 1; }

# Utilidades
clean_path() {
  local path="$1"
  path=$(echo "$path" | sed "s/^['\"]//; s/['\"]$//; s/^ *//; s/ *$//")
  echo "$path"
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    error "La herramienta '$cmd' no está instalada."
  fi
}

check_dependencies() {
  local deps=(tar unzip)
  for d in "${deps[@]}"; do require_cmd "$d"; done

  if ! command -v rsync >/dev/null 2>&1; then
    warn "No se encontró 'rsync'. Se usará 'cp' como alternativa."
  fi
}

# Extracción / Búsqueda
extract_file() {
  local file="$1"
  local dest="$2"

  case "$file" in
    *.zip)              unzip -q "$file" -d "$dest" || error "Fallo al descomprimir ZIP." ;;
    *.tar.gz|*.tgz)     tar -xzf "$file" -C "$dest" || error "Fallo al descomprimir TAR.GZ." ;;
    *.tar.xz)           tar -xf  "$file" -C "$dest" || error "Fallo al descomprimir TAR.XZ." ;;
    *.tar.bz2|*.tbz2)   tar -xjf "$file" -C "$dest" || error "Fallo al descomprimir TAR.BZ2." ;;
    *.7z)
      if command -v 7z >/dev/null 2>&1; then
        7z x "$file" -o"$dest" >/dev/null || error "Fallo al descomprimir 7Z."
      elif command -v 7za >/dev/null 2>&1; then
        7za x "$file" -o"$dest" >/dev/null || error "Fallo al descomprimir 7Z."
      else
        error "Se necesita '7z' o '7za' para extraer .7z. Instala p7zip-full o p7zip."
      fi
      ;;
    *) error "Formato de archivo no soportado." ;;
  esac
}

find_executables() {
  local dir="$1"
  cd "$dir" || error "No se pudo acceder al directorio temporal."
  find . -type f \( -perm -u=x -o -name "*.bin" -o -name "*.run" -o -name "*.sh" \) \
    -not -name "*.so*" -not -name "*.dll*" \
    -not -ipath "*uninstall*" -not -ipath "*setup*" \
    -not -ipath "*update*" -not -ipath "*crashpad*" \
    | head -20
}

find_icons() {
  local dir="$1"
  cd "$dir" || error "No se pudo acceder al directorio temporal."
  find . -type f \( -name "*.svg" -o -name "*.png" -o -name "*.xpm" \) \
    -ipath "*icon*" | sort -u | head -10
}

check_binary_dependencies() {
  local binary="$1"
  if command -v ldd >/dev/null 2>&1; then
    local missing_libs
    missing_libs=$(ldd "$binary" 2>/dev/null | grep 'not found' || true)
    if [ -n "${missing_libs}" ]; then
      warn "La aplicación podría necesitar las siguientes librerías que no se encontraron:"
      echo -e "${AMA}${missing_libs}${DEFAULT}"
      read -r -p "¿Deseas continuar con la instalación de todas formas? [S/n]: " continue_anyway
      if [[ "${continue_anyway:-S}" =~ ^[Nn]$ ]]; then
        error "Instalación cancelada por el usuario."
      fi
    else
      success "No se detectaron dependencias faltantes."
    fi
  else
    warn "No se encontró el comando 'ldd'. Omitiendo la verificación de dependencias."
  fi
}


# --- Instalar aplicación ---
instalar_aplicacion() {
  check_dependencies

  read -r -p "Arrastra un archivo (.zip, .tar.*, .7z o binario) y presiona Enter: " INPUT_FILE
  INPUT_FILE=$(clean_path "${INPUT_FILE}")

  [ -z "$INPUT_FILE" ] && error "No se proporcionó ninguna ruta."
  [ ! -e "$INPUT_FILE" ] && error "El archivo o directorio '$INPUT_FILE' no existe."

  local TEMP_DIR
  TEMP_DIR=$(mktemp -d -t install-app-XXXXXX)
  trap 'info "Limpiando archivos temporales..."; rm -rf "$TEMP_DIR"' EXIT

  local EXEC_PATH
  if [ -f "$INPUT_FILE" ] && [ -x "$INPUT_FILE" ] && ! [[ "$INPUT_FILE" =~ \.zip$|\.tar\..*$|\.tgz$|\.7z$ ]]; then
    info "Se detectó un archivo binario simple."
    cp "$INPUT_FILE" "$TEMP_DIR/"
    EXEC_PATH="./$(basename "$INPUT_FILE")"
  else
    info "Descomprimiendo '$INPUT_FILE'..."
    extract_file "$INPUT_FILE" "$TEMP_DIR"

    cd "$TEMP_DIR" || error "No se pudo acceder al directorio temporal."
    if [ "$(ls -1 . | wc -l)" -eq 1 ] && [ -d "$(ls -1 .)" ]; then
      info "El archivo contenía una sola carpeta, accediendo a ella."
      cd "$(ls -1 .)" || error "No se pudo acceder a la subcarpeta."
    fi

    info "Analizando el contenido de la aplicación..."
    mapfile -t EXECUTABLES < <(find_executables "$PWD")
    [ ${#EXECUTABLES[@]} -eq 0 ] && error "No se encontraron archivos ejecutables."

    info "Selecciona el ejecutable principal (se muestran los más probables primero):"
    PS3="Selecciona el número del ejecutable: "
    select EXEC_PATH in "${EXECUTABLES[@]}"; do
      if [[ -n "${EXEC_PATH:-}" ]]; then break; else warn "Selección inválida."; fi
    done
  fi

  check_binary_dependencies "$EXEC_PATH"

  local ICON_PATH=""
  if [ -f "$EXEC_PATH" ]; then
    mapfile -t ICONS < <(find_icons "$PWD")
    if [ ${#ICONS[@]} -gt 0 ]; then
      info "Selecciona un icono (opcional, se muestran los de alta resolución primero):"
      ICONS+=("No seleccionar ningún icono")
      PS3="Selecciona el número del icono: "
      select ICON_CANDIDATE in "${ICONS[@]}"; do
        if [[ -n "${ICON_CANDIDATE:-}" && "$ICON_CANDIDATE" != "No seleccionar ningún icono" ]]; then
          ICON_PATH="$ICON_CANDIDATE"; break
        elif [[ "$ICON_CANDIDATE" == "No seleccionar ningún icono" ]]; then
          info "Se omitió la selección de icono."; break
        else
          warn "Selección inválida."
        fi
      done
    else
      warn "No se encontraron archivos de icono."
    fi
  fi

  echo -e "\n${CYAN}--- Configuración de la Instalación ---${DEFAULT}"
  read -r -p "Introduce el nombre para la aplicación: " APP_NAME

  local REGISTRY_FILE="$HOME/.config/app-installer/registry.log"
  if [ -f "$REGISTRY_FILE" ] && grep -q "^${APP_NAME}|" "$REGISTRY_FILE"; then
    warn "Ya existe una aplicación registrada con el nombre '$APP_NAME'."
    read -r -p "¿Deseas continuar? Podrías sobreescribirla o crear un duplicado. [s/N]: " continue_duplicate
    if [[ ! "${continue_duplicate:-N}" =~ ^[sS]$ ]]; then
      error "Instalación cancelada por el usuario."
    fi
  fi

  local APP_DIR_NAME
  APP_DIR_NAME=$(echo "$APP_NAME" | sed 's/ /-/g')

  info "Elige una ubicación para la instalación:"
  local INSTALL_OPTIONS=(
    "Solo para el usuario actual (~/Applications) - Recomendado"
    "Para todos los usuarios del sistema (/opt) - Requiere Sudo"
    "Especificar una ruta personalizada"
  )
  local INSTALL_DIR BIN_LINK_DIR DESKTOP_DIR NEEDS_SUDO
  PS3="Selecciona una opción: "
  select opt in "${INSTALL_OPTIONS[@]}"; do
    case $REPLY in
      1) INSTALL_DIR="$HOME/Applications/$APP_DIR_NAME"; BIN_LINK_DIR="$HOME/.local/bin"; DESKTOP_DIR="$HOME/.local/share/applications"; NEEDS_SUDO=false; break ;;
      2) INSTALL_DIR="/opt/$APP_DIR_NAME"; BIN_LINK_DIR="/usr/local/bin"; DESKTOP_DIR="/usr/share/applications"; NEEDS_SUDO=true; break ;;
      3) read -r -p "Introduce la ruta de instalación (sin el nombre de la app): " CUSTOM_PATH
        INSTALL_DIR="${CUSTOM_PATH%/}/$APP_DIR_NAME"
        BIN_LINK_DIR="$HOME/.local/bin"; DESKTOP_DIR="$HOME/.local/share/applications"; warn "Los enlaces se crearán para el usuario actual."; NEEDS_SUDO=false; break ;;
      *) warn "Opción inválida." ;;
    esac
  done

  info "Preparando para instalar..."
  local COPY_CMD="cp -a"
  command -v rsync >/dev/null 2>&1 && COPY_CMD="rsync -a"

  local APP_COMMAND_NAME
  APP_COMMAND_NAME=$(basename "$EXEC_PATH" | sed 's/\.sh$//')

  local TERMINAL_FLAG="false"
  [[ "$EXEC_PATH" == *.sh ]] && TERMINAL_FLAG="true"

  if [ "${NEEDS_SUDO}" = true ] && [ "$EUID" -ne 0 ]; then
    info "Se requieren privilegios de administrador."
    sudo mkdir -p "$INSTALL_DIR" "$BIN_LINK_DIR" "$DESKTOP_DIR" || error "No se pudieron crear directorios."
    info "Copiando archivos de la aplicación a '$INSTALL_DIR'..."
    if [ -f "$EXEC_PATH" ]; then
      if [ -d "$PWD" ]; then
        sudo bash -lc "$COPY_CMD . \"$INSTALL_DIR/\"" || error "Fallo al copiar los archivos."
      else
        sudo cp "$EXEC_PATH" "$INSTALL_DIR/" || error "Fallo al copiar el binario."
      fi
    else
      sudo cp "$EXEC_PATH" "$INSTALL_DIR/" || error "Fallo al copiar el binario."
    fi

    info "Creando comando de terminal: '$APP_COMMAND_NAME'..."
    sudo ln -sf "$INSTALL_DIR/$(basename "$EXEC_PATH")" "$BIN_LINK_DIR/$APP_COMMAND_NAME"

    local DESKTOP_FILE_PATH="$DESKTOP_DIR/$APP_DIR_NAME.desktop"
    info "Creando archivo de menú en '$DESKTOP_FILE_PATH'..."
    sudo tee "$DESKTOP_FILE_PATH" >/dev/null <<EOL
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=$APP_NAME (Aplicacion instalada gracias a RichyKunBv <3)
Exec=$BIN_LINK_DIR/$APP_COMMAND_NAME
Terminal=$TERMINAL_FLAG
Type=Application
Categories=Utility;
EOL
    if [ -n "$ICON_PATH" ]; then echo "Icon=$INSTALL_DIR/$ICON_PATH" | sudo tee -a "$DESKTOP_FILE_PATH" >/dev/null; fi
    sudo chmod +x "$DESKTOP_FILE_PATH"

  else
    mkdir -p "$INSTALL_DIR" "$BIN_LINK_DIR" "$DESKTOP_DIR" || error "No se pudieron crear directorios."
    info "Copiando archivos de la aplicación a '$INSTALL_DIR'..."
    if [ -f "$EXEC_PATH" ]; then
      if [ -d "$PWD" ]; then
        bash -lc "$COPY_CMD . \"$INSTALL_DIR/\"" || error "Fallo al copiar los archivos."
      else
        cp "$EXEC_PATH" "$INSTALL_DIR/" || error "Fallo al copiar el binario."
      fi
    else
      cp "$EXEC_PATH" "$INSTALL_DIR/" || error "Fallo al copiar el binario."
    fi

    info "Creando comando de terminal: '$APP_COMMAND_NAME'..."
    ln -sf "$INSTALL_DIR/$(basename "$EXEC_PATH")" "$BIN_LINK_DIR/$APP_COMMAND_NAME"

    local DESKTOP_FILE_PATH="$DESKTOP_DIR/$APP_DIR_NAME.desktop"
    info "Creando archivo de menú en '$DESKTOP_FILE_PATH'..."
    cat > "$DESKTOP_FILE_PATH" <<EOL
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=$APP_NAME (Aplicacion instalada gracias a RichyKunBv <3)
Exec=$BIN_LINK_DIR/$APP_COMMAND_NAME
Terminal=$TERMINAL_FLAG
Type=Application
Categories=Utility;
EOL
    if [ -n "$ICON_PATH" ]; then echo "Icon=$INSTALL_DIR/$ICON_PATH" >> "$DESKTOP_FILE_PATH"; fi
    chmod +x "$DESKTOP_FILE_PATH"
  fi

  success "¡Instalación completada!"
  info "Guardando información en el registro..."
  mkdir -p "$(dirname "$REGISTRY_FILE")"
  echo "$APP_NAME|$INSTALL_DIR|$BIN_LINK_DIR/$APP_COMMAND_NAME|$DESKTOP_FILE_PATH" >> "$REGISTRY_FILE"

  echo "--------------------------------------------------"
  echo -e " Aplicación:      ${AMA}$APP_NAME${DEFAULT}"
  echo -e " Instalado en:    ${AMA}$INSTALL_DIR${DEFAULT}"
  echo -e " Comando:         ${AMA}$APP_COMMAND_NAME${DEFAULT}"
  echo "--------------------------------------------------"
}


# -- Desinstalación --
desinstalar_aplicacion() {
  local REGISTRY_FILE="$HOME/.config/app-installer/registry.log"
  if [ ! -f "$REGISTRY_FILE" ] || [ ! -s "$REGISTRY_FILE" ]; then error "No se encontró el registro o está vacío."; fi

  info "Selecciona la aplicación que deseas desinstalar:"
  mapfile -t installed_apps < "$REGISTRY_FILE"
  installed_apps+=("Cancelar")
  PS3="Selecciona el número de la aplicación a borrar: "
  local app_line
  select app_line in "${installed_apps[@]}"; do
    if [[ "$app_line" == "Cancelar" ]]; then info "Operación cancelada."; return 0; fi
    if [[ -n "${app_line:-}" ]]; then break; else warn "Selección inválida."; fi
  done

  local APP_TO_UNINSTALL DIR_TO_UNINSTALL LINK_TO_UNINSTALL DESKTOP_TO_UNINSTALL
  APP_TO_UNINSTALL=$(echo "$app_line" | cut -d'|' -f1)
  DIR_TO_UNINSTALL=$(echo "$app_line" | cut -d'|' -f2)
  LINK_TO_UNINSTALL=$(echo "$app_line" | cut -d'|' -f3)
  DESKTOP_TO_UNINSTALL=$(echo "$app_line" | cut -d'|' -f4)

  local APP_COMMAND_NAME
  APP_COMMAND_NAME=$(basename "$LINK_TO_UNINSTALL")

  info "Verificando si '${APP_TO_UNINSTALL}' está en ejecución..."
  local PIDS
  PIDS=$(pgrep -f "$APP_COMMAND_NAME" || true)
  if [ -n "$PIDS" ]; then
    warn "La aplicación '${APP_TO_UNINSTALL}' parece estar en ejecución (PIDs: $PIDS)."
    read -r -p "¿Deseas forzar el cierre de todos sus procesos? [s/N]: " force_close
    if [[ "${force_close:-N}" =~ ^[sS]$ ]]; then
      info "Cerrando procesos..."
      kill -9 $PIDS
      success "Procesos cerrados."
      sleep 1
    else
      error "Desinstalación cancelada."
    fi
  else
    success "La aplicación no está en ejecución."
  fi

  echo
  warn "Estás a punto de eliminar permanentemente lo siguiente:"
  echo -e "  - Aplicación:     ${AMA}$APP_TO_UNINSTALL${DEFAULT}"
  echo -e "  - Directorio:     ${AMA}$DIR_TO_UNINSTALL${DEFAULT}"
  echo -e "  - Comando:        ${AMA}$LINK_TO_UNINSTALL${DEFAULT}"
  echo -e "  - Acceso Directo: ${AMA}$DESKTOP_TO_UNINSTALL${DEFAULT}"
  read -r -p "¿Estás seguro? [s/N]: " confirmation
  if [[ ! "${confirmation:-N}" =~ ^[sS]$ ]]; then
    info "Desinstalación cancelada."
    return 0
  fi

  local SUDO_CMD=""
  if [[ "$DIR_TO_UNINSTALL" == /opt/* || "$LINK_TO_UNINSTALL" == /usr/* || "$DESKTOP_TO_UNINSTALL" == /usr/* ]]; then
    info "Se requieren privilegios de administrador."
    SUDO_CMD="sudo"
  fi

  info "Eliminando directorio..."
  $SUDO_CMD rm -rf "$DIR_TO_UNINSTALL"
  info "Eliminando comando..."
  $SUDO_CMD rm -f "$LINK_TO_UNINSTALL"
  info "Eliminando acceso directo..."
  $SUDO_CMD rm -f "$DESKTOP_TO_UNINSTALL"
  info "Actualizando el registro..."
  grep -vF "$app_line" "$REGISTRY_FILE" > "${REGISTRY_FILE}.tmp"
  mv "${REGISTRY_FILE}.tmp" "$REGISTRY_FILE"
  echo
  success "¡'$APP_TO_UNINSTALL' ha sido desinstalada!"
}

# -- Listado de aplicaciones instaladas --
listar_aplicaciones() {
  local REGISTRY_FILE="$HOME/.config/app-installer/registry.log"
  if [ ! -f "$REGISTRY_FILE" ] || [ ! -s "$REGISTRY_FILE" ]; then error "No se encontró el registro o está vacío."; fi

  echo -e "\n${CYAN}--- Aplicaciones Instaladas ---${DEFAULT}"
  echo "---------------------------------------------------------------------"
  printf "%-25s | %-20s | %s\n" "NOMBRE" "COMANDO" "RUTA DE INSTALACIÓN"
  echo "---------------------------------------------------------------------"
  while IFS='|' read -r name dir command desktop_file; do
    printf "%-25s | %-20s | %s\n" "$name" "$(basename "$command")" "$dir"
  done < "$REGISTRY_FILE"
  echo "---------------------------------------------------------------------"
}



# --- FUNCIONES UNIFICADAS ---

# --- easter egg xd ---

function XD() {
    echo -e "\n${MAGENTA}› Caiste xddddd ${DEFAULT}"; sleep 2
    local pkg_manager=""
    case "$DISTRO_FAMILIA" in
        debian) pkg_manager="apt-get install -y";;
        fedora) if command -v dnf &>/dev/null; then pkg_manager="dnf install -y"; else pkg_manager="yum install -y"; fi;;
        arch) pkg_manager="pacman -S --noconfirm";;
        *) echo -e "${ROJO}  Papi usa algo mas comun como Arch, Fedora o Debian.${DEFAULT}"; return 1;;
    esac
    $pkg_manager cmatrix >/dev/null 2>&1
    if command -v cmatrix &>/dev/null; then
        echo -e "${VERDE}  ¡viruz instalado! jijiji Ejecutando...${DEFAULT}"; sleep 1; cmatrix -b
    else
        echo -e "${ROJO}  Error: No se pudo instalar cmatrix.${DEFAULT}"
    fi
}

# --- Actualizar el script ---

actualizar_script() {
  echo -e "\n${AMA}› Verificando actualizaciones para el script...${DEFAULT}"

  local repos_posibles=("Tenix-Suite")
  local scripts_posibles=("TenixSuite.sh")

  local url_version_encontrada=""
  local url_script_encontrado=""
  local exito=false

  local download_tool=""
  if command -v curl >/dev/null 2>&1; then
    download_tool="curl -sfo"
  elif command -v wget >/dev/null 2>&1; then
    download_tool="wget -qO"
  else
    echo -e "${ROJO}  Error: Se necesita 'curl' o 'wget' para la auto-actualización.${DEFAULT}"
    return 1
  fi

  for repo in "${repos_posibles[@]}"; do
    local url_temp_version="https://raw.githubusercontent.com/RichyKunBv/${repo}/main/version.txt"
    if curl --output /dev/null --silent --head --fail "$url_temp_version"; then
      url_version_encontrada="$url_temp_version"
      for script_name in "${scripts_posibles[@]}"; do
        local url_temp_script="https://raw.githubusercontent.com/RichyKunBv/${repo}/main/${script_name}"
        if curl --output /dev/null --silent --head --fail "$url_temp_script"; then
          url_script_encontrado="$url_temp_script"
          exito=true
          break
        fi
      done
    fi
    [ "$exito" = true ] && break
  done

  if [ "$exito" = false ]; then
    echo -e "${ROJO}  Error: No se pudo encontrar un repositorio o script válido en GitHub.${DEFAULT}"
    return 1
  fi

  local version_remota
  version_remota=$($download_tool - "$url_version_encontrada")
  if [ -z "${version_remota}" ]; then
    echo -e "${ROJO}  Error: No se pudo obtener la versión remota.${DEFAULT}"
    return 1
  fi

  local version_es_nueva=false
  if [ "$(printf '%s\n' "$version_remota" "$VERSION_LOCAL" | sort -V | tail -n 1)" == "$version_remota" ] && [ "$version_remota" != "$VERSION_LOCAL" ]; then
    version_es_nueva=true
  fi

  if [ "$version_es_nueva" = true ]; then
    echo -e "${VERDE}  ¡Nueva versión ($version_remota) encontrada! La tuya es la $VERSION_LOCAL.${DEFAULT}"
    echo -e "${AMA}  Descargando actualización...${DEFAULT}"

    local script_actual="$0"
    local script_nuevo="${script_actual}.new"

    if $download_tool "$script_nuevo" "$url_script_encontrado"; then
      chmod +x "$script_nuevo"
      mv "$script_nuevo" "$script_actual"
      echo -e "${VERDE}  ¡Script actualizado con éxito!${DEFAULT}"
      echo -e "${AMA}  Por favor, vuelve a ejecutar el script para usar la nueva versión.${DEFAULT}"
      exit 0
    else
      echo -e "${ROJO}  Error al descargar el script actualizado.${DEFAULT}"
      rm -f "$script_nuevo"
      return 1
    fi
  else
    echo -e "${VERDE}  Ya tienes la última versión ($VERSION_LOCAL). No se necesita actualizar.${DEFAULT}"
  fi
}

function AD() {
    echo -e "\n${VERDE}----------------------------------${DEFAULT}"
    echo -e "\n${CYAN}---        Tenix Suite         ---${DEFAULT}"
    echo -e "\n${VERDE}----------------------------------${DEFAULT}"
    echo " Creador: RichyKunBv"
    echo " Version: $VERSION_LOCAL"
    echo ""
    echo -e "${AMA}Mantenix (v$MANTENIX_VERSION):${DEFAULT} Automatiza la actualización,"
    echo " limpieza y optimización de tu sistema Linux."
    echo ""
    echo -e "${AMA}Apptenix (v$APPTENIX_VERSION):${DEFAULT} Instala y gestiona aplicaciones"
    echo " desde archivos comprimidos o binarios fácilmente."
}

function web() {
    if [ -n "$SUDO_USER" ]; then
        sudo -u $SUDO_USER xdg-open https://github.com/RichyKunBv
    else
        xdg-open https://github.com/RichyKunBv
    fi
}

function menu_mantenix() {
    while true; do
        clear
        echo -e "\n${VERDE}--- Asistente de Mantenimiento (Mantenix v$MANTENIX_VERSION) ---${DEFAULT}"
        echo "  1. Actualización Estándar"
        echo "  2. Limpiar Sistema"
        echo "  3. Actualización Profunda del Sistema"
        echo "  4. Optimizar Sistema"
        echo -e "  ${MAGENTA}A. MODO DIOS (Todo en orden)${DEFAULT}"
        echo -e "  ${ROJO}V. Volver al menú principal${DEFAULT}"
        echo -e "  ${ROJO}X. Salir${DEFAULT}"
        read -p "  Selecciona una opción: " opcion
        
        case $opcion in
            1) clear; actualizar_sistema; actualizar_flatpak; actualizar_snap; success "--- Tarea Completada ---"; sleep 2;;
            2) clear; limpiar_sistema; success "--- Tarea Completada ---"; sleep 2;;
            3) clear; actualizacion_profunda; success "--- Tarea Completada ---"; sleep 2;;
            4) clear; optimizar_sistema; success "--- Tarea Completada ---"; sleep 2;;
            [aA])
                clear; echo -e "${MAGENTA}--- INICIANDO MODO DIOS ---${DEFAULT}"
                actualizacion_profunda; actualizar_flatpak; actualizar_snap; limpiar_sistema; optimizar_sistema
                echo -e "\n${MAGENTA}--- SECUENCIA COMPLETA FINALIZADA ---${DEFAULT}"; sleep 2;;
            [vV]) break;;
            [ñÑ]) clear; XD; sleep 2;;
            [xX]) echo -e "${CYAN}¡Adios baby!${DEFAULT}"; break;;
            *) warn "  Opción no válida."; sleep 1;;
        esac
    done
}

function menu_apptenix() {
    while true; do
        clear
        echo -e "${CYAN}===== Gestor de Aplicaciones (Apptenix v$APPTENIX_VERSION) =====${C_RESET}"
        echo "  1. Instalar aplicación"
        echo "  2. Desinstalar aplicación"
        echo "  3. Listar aplicaciones instaladas"
        echo -e "  ${ROJO}V. Volver al menú principal${DEFAULT}"
        echo -e "  ${ROJO}X. Salir${DEFAULT}"
        read -p "  Selecciona una opción: " opcion

        case $opcion in
    1) instalar_aplicacion; read -r -p "Presiona Enter para volver al menú..." _;;
    2) desinstalar_aplicacion; read -r -p "Presiona Enter para volver al menú..." _;;
    3) listar_aplicaciones; read -r -p "Presiona Enter para volver al menú..." _;;
            [vV]) break;;
            [ñÑ]) clear; XD; sleep 2;;
            [xX]) echo -e "${CYAN}¡Adios baby!${DEFAULT}"; break;;
            *) warn "Opción no válida."; sleep 2;;
        esac
    done
}

# --- INICIO DEL FIN (aqui arranca el escrip) ---

# --- SUDO obligatorio ---
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo -e "${ROJO}Error: Ejecuta este script con sudo.${DEFAULT}"
    exit 1
fi

detectar_distribucion

while true; do
    clear
    echo -e "\n${CYAN} ---          Suite v$VERSION_LOCAL          ---${DEFAULT}"
    echo -e "    Creado con <3 por ${AMA}RichyKunBv${DEFAULT}"
    echo ""
    echo "  1. MantenixL"
    echo "  2. Apptenix"
    echo ""
    echo "  A. Acerca De"
    echo "  G. Ir a mi GitHub"
    echo "  Y. Actualizar Script"
    echo -e "  ${ROJO}X. Salir${DEFAULT}"
    read -p "  Selecciona una opción: " opcion

    case $opcion in
        1) menu_mantenix;;
        2) menu_apptenix;;
        [ñÑ]) clear; XD; sleep 2;;
        [aA]) clear; AD; read -p "Presiona Enter para continuar...";;
        [gG]) web;;
        [yY]) actualizar_script; sleep 2;;
        [xX]) echo -e "${CYAN}¡Adios baby!${DEFAULT}"; break;;
        *) warn "Opción no válida."; sleep 1;;
    esac
done

exit 0
