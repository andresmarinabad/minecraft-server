# Servidor de Minecraft

Un servidor en Docker Compose, con el mundo en `./data`. Para jugar abres Minecraft como una aplicación normal en tu PC. El servidor no tiene una página web.

## Qué necesitas

| Componente | Para qué sirve | Cómo se prepara |
| --- | --- | --- |
| Docker y Docker Compose | Ejecutar el servidor | En tu PC ya funcionan. |
| Prism Launcher y Java | Descargar y ejecutar Minecraft Java | Los proporciona el `flake.nix` de este repositorio. |
| Cuenta Microsoft con Minecraft Java Edition | Iniciar sesión y jugar | Debes tener acceso al juego; Prism es gratis, pero no incluye una licencia de Minecraft. |

El servidor no depende de NixOS. El flake es una comodidad opcional para jugar desde Linux / NixOS, con las dependencias gráficas y Java incluidos.

## 1. Arrancar el servidor

Desde este repositorio:

```bash
docker compose up -d
docker compose logs -f minecraft
```

Espera a que aparezca `Done`. Ctrl+C cierra los logs sin parar el servidor. El primer arranque descarga Paper y los plugins Geyser/Floodgate para admitir también jugadores Bedrock.

La configuración contiene `EULA: "TRUE"`: al arrancar aceptas la [EULA de Minecraft](https://www.minecraft.net/eula).

## 2. Abrir Minecraft en tu NixOS

Desde una terminal de tu escritorio, en este repositorio:

```bash
nix run path:. -- --dir "$PWD/.minecraft-client"
```

Nix descarga Prism Launcher, Java 25/21 y sus bibliotecas. No necesitas instalar Java a mano, usar `nix profile install` ni modificar tu NixOS. El `flake.lock` fija las versiones de las dependencias.

Prism guarda los ajustes, la cuenta y el juego en **`.minecraft-client/`**, dentro del repositorio y fuera de Git. Usa siempre el comando anterior para abrir esa misma instalación.

**Solo la primera vez, dentro de Prism:**

1. Completa el asistente inicial. En la selección de Java, usa la detección automática y elige **Java 25** para Minecraft 26.2.
2. En **Ajustes → Cuentas → Añadir Microsoft**, inicia sesión con la cuenta que tenga Minecraft Java. Sigue el enlace y el código que muestre Prism.
3. Pulsa **Añadir instancia**, elige **Minecraft 26.2**, sin mods, y acepta. Esa es la versión del servidor comprobada en sus logs.
4. Abre la instancia. Prism descarga automáticamente Minecraft y sus archivos.
5. En el juego: **Multijugador → Conexión directa → `localhost:25565`**.

Nix automatiza la preparación del lanzador y Java; Prism automatiza la descarga del juego. El inicio de sesión y la selección inicial de instancia los haces en la aplicación. Después basta con abrir Prism y lanzar la instancia guardada.

Si actualizas el servidor, comprueba su versión en `docker compose logs minecraft`, en la línea `Starting minecraft server version`, y usa esa misma versión en Prism.

## NixOS: configuración del sistema solo si falta Docker o flakes

En tu PC no hace falta aplicar esto ahora: Docker y Nix con flakes ya están funcionando. Para preparar otro NixOS, añade estas opciones a su configuración existente:

```nix
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  virtualisation.docker.enable = true;
  users.users.TU_USUARIO.extraGroups = [ "docker" ];

  # Para que entren otros dispositivos de tu red:
  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 19132 ];
}
```

Sustituye `TU_USUARIO` y aplica la configuración con tu comando habitual de `nixos-rebuild switch` (si tu sistema usa flakes, conserva su ruta y nombre de host en `--flake`). Cierra sesión y vuelve a entrar si acabas de añadir tu usuario al grupo `docker`.

## Jugar desde otros dispositivos

Los demás jugadores necesitan su propio juego y cuenta. Usa la IP local del PC servidor, visible en sus ajustes de red:

- **Java en otro PC:** `IP-DEL-SERVIDOR:25565`.
- **Bedrock / iPhone / iPad:** añade un servidor con dirección `IP-DEL-SERVIDOR` y puerto `19132`.

Todos deben estar en la misma red doméstica. Si hay un cortafuegos activo, permite TCP 25565 y UDP 19132. En el propio PC servidor, el cliente Java usa `localhost:25565`.

## Parar, guardar y eliminar

Para parar el servidor y quitar el contenedor y la red del proyecto:

```bash
docker compose down
```

El mundo permanece en **`data/`**. Para una copia manual, para el servidor y copia esa carpeta a otro lugar. El cliente se cierra desde su ventana.

Si quieres retirar el montaje:

1. `docker compose down --rmi all` quita también la imagen del servidor si no la usa otro contenedor.
2. Borra `.minecraft-client/` para eliminar la sesión y el juego descargado por Prism.
3. Borra `data/` solo si quieres eliminar definitivamente el mundo.

`nix run` no añade Prism a tu configuración del sistema ni a un perfil permanente. Los paquetes descargados quedan en la caché de Nix y se pueden liberar con `nix store gc` cuando no estén en uso ni referenciados. Ese comando recoge todos los paquetes sin referencias, no solo los de este proyecto.

## Configuración y primeros pasos

En `compose.yaml` puedes cambiar la memoria del servidor (por defecto `2G`). La imagen está fijada a [2026.9.0](https://github.com/itzg/docker-minecraft-server/releases/tag/2026.9.0), sin el tag `latest`. La versión del juego se controla por separado con `VERSION`; sin esa variable, el servidor descarga la versión estable actual. Los plugins usan sus descargas actuales.

Para aprender a jugar, lee la [guía breve de primeros pasos](GUIA-JUEGO.md).
