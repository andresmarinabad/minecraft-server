# Servidor de Minecraft

Servidor local con Docker Compose, Paper, Geyser y Floodgate para jugar desde Java y Bedrock (incluidos iPhone/iPad).

## Requisitos

Docker instalado y en ejecución, con `docker compose` disponible. Funciona en Linux, macOS y Windows con contenedores Linux.

## Arrancar y parar

Desde la carpeta del repositorio:

```bash
docker compose up -d
docker compose logs -f minecraft
```

El primer arranque descarga el servidor y los plugins. Espera a que aparezca `Done` en los logs. Sal con Ctrl+C; el servidor seguirá funcionando.

La configuración incluye `EULA: "TRUE"`: al arrancar aceptas la [EULA de Minecraft](https://www.minecraft.net/eula).

Para parar:

```bash
docker compose down
```

Para volver a arrancar, usa `docker compose up -d`.

## Conectarse

Usa la IP local del ordenador que ejecuta Docker, visible en los ajustes de red. Todos los dispositivos deben estar en la misma red doméstica.

- **Java:** Multijugador → Añadir servidor → `IP-DEL-SERVIDOR:25565`. En el propio ordenador puedes usar `localhost:25565`.
- **Bedrock / iPhone / iPad:** Jugar → Servidores → Añadir servidor. Dirección: `IP-DEL-SERVIDOR`; puerto: `19132`.

Si hay un cortafuegos activo, permite TCP 25565 y UDP 19132 para la red local.

## Datos y configuración

El mundo, los jugadores y los ajustes se guardan en **`./data`**, dentro de este repositorio, mediante el montaje `./data:/data`. Se conservan al parar o recrear el contenedor. Su contenido queda excluido de Git.

Para guardar una copia manual, para el servidor y copia la carpeta `data` a otro lugar. Para cambiar ajustes generados, para el servidor, edita los archivos de `data` y arráncalo de nuevo.

Puedes cambiar la memoria en `compose.yaml` (por defecto `2G`).

La imagen está fijada a `itzg/minecraft-server:2026.9.0`, la [última release publicada](https://github.com/itzg/docker-minecraft-server/releases/tag/2026.9.0) comprobada el 10 de septiembre de 2026. El tag corresponde a la imagen Docker; la versión de Minecraft se controla por separado con la variable `VERSION`. Sin ella, se descarga la versión estable actual, y los plugins también usan sus descargas actuales.

## Aprender a jugar

Lee la [guía breve de primeros pasos](GUIA-JUEGO.md).
