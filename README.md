# Botones de ventana para Hyprland Lua

Correcciones para los scripts de maximizar/restaurar de hyprbars en Hyprland
0.57.2. Son scripts de usuario, independientes del proyecto oficial Hyprland.

## Problema y solución

El selector anterior comparaba las coordenadas del ratón con todas las ventanas,
incluidas las que estaban en escritorios ocultos. Una ventana minimizada podía
ganar esa selección y el botón cuadrado actuaba sobre ella.

Ahora el selector considera el monitor del cursor, su escritorio visible y el
escritorio especial abierto. Entre ventanas solapadas prioriza la capa especial
visible y después el historial de foco.

El botón enfoca y verifica la ventana seleccionada antes de alternar el maximizado
una sola vez. Una segunda pulsación restaura esa ventana. Un bloqueo evita dos
acciones simultáneas. Los errores se muestran en vez de repetir silenciosamente
la operación sobre otra ventana.

## Instalación

Requiere Python 3, Hyprland con API Lua y una configuración existente de hyprbars
que ejecute `~/.config/hypr/winbuttons/maximizar.sh` desde el botón cuadrado.
El instalador reemplaza únicamente ese script y su selector; guarda copias de
seguridad e imprime dónde encontrarlas. No recarga Hyprland.

```bash
git clone https://github.com/pilahito/hyprland-window-buttons.git
cd hyprland-window-buttons
./install.sh
```

Para otra ubicación, define `HYPR_BUTTONS_DIR` al ejecutar el instalador. No hace
falta sudo. Si el directorio todavía no existe, configura primero el botón de
hyprbars; el instalador no crea botones nuevos.

## Pruebas

```bash
python3 -m unittest discover -s tests -v
```

Las pruebas reproducen ventanas ocultas con coordenadas idénticas, capas especiales,
monitores con escalado y ausencia de ventanas bajo el cursor. También se comprobó
en una sesión real con Hyprland 0.57.2 que una ventana pasa de normal a maximizada
y vuelve a normal. No se ha probado en otras versiones de la API Lua.

Se aceptan issues y pull requests con pasos para reproducir, versión de Hyprland
y resultados esperados. Evita adjuntar configuraciones completas con datos privados.

## English

User-side hyprbars maximize/restore fixes for Hyprland's Lua dispatcher API.
The selector excludes hidden workspaces and prioritizes visible special overlays.
The maximize action verifies focus and toggles exactly once. These are standalone
scripts, not a patch to the compositor. Contributions and reproducible reports
are welcome.
