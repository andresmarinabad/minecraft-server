# Local Minecraft Server

A minimal local Minecraft setup running entirely with Docker.

It provides:

- A **Minecraft Java 1.21.4** server using Paper.
- A browser-based Minecraft client.
- Persistent world data in the local `data/` directory.
- No local Minecraft or Java installation required.

## Requirements

Only Docker with Docker Compose support is required.

## Start the server

From the repository directory:

```bash
docker compose up -d
```

If the web client image has not been built yet, or `Dockerfile.web` has changed:

```bash
docker compose up -d --build
```

## Check server startup

Follow the Minecraft server logs:

```bash
docker compose logs -f minecraft
```

Wait until you see:

```text
Done (...)! For help, type "help"
```

Press `Ctrl+C` to stop following the logs. This does not stop the server.

## Play

Open the web client in your browser:

```text
http://localhost:8080
```

Connect using:

```text
Server:   minecraft:25565
Proxy:    http://localhost:8080
Version:  1.21.4
Username: <your-name>
```

The Minecraft server and web client run on the same Docker network, so the web client can reach the server using the hostname `minecraft`.

## Stop

Stop and remove the containers:

```bash
docker compose down
```

Your world is not deleted. Minecraft data is stored in:

```text
./data
```

Start it again with:

```bash
docker compose up -d
```

## Restart

```bash
docker compose restart
```

## View logs

Minecraft server:

```bash
docker compose logs -f minecraft
```

Web client:

```bash
docker compose logs -f minecraft-web
```

## Server configuration

The local server intentionally runs in offline mode:

```yaml
ONLINE_MODE: "FALSE"
```

This allows the browser client to join using a local username without Microsoft/Mojang authentication.

Secure profiles and RCON are also disabled because they are not required for this local setup.

## World data

All Minecraft server data is persisted under:

```text
data/
```

Do not delete this directory unless you intentionally want to delete/reset the world.

A simple backup can therefore be made by stopping the server and copying the `data/` directory:

```bash
docker compose down
cp -a data data-backup
docker compose up -d
```

## Rebuild the web client

If the upstream web client changes or the local Dockerfile is modified:

```bash
docker compose build --no-cache minecraft-web
docker compose up -d
```

## Architecture

```text
Browser
   |
   | http://localhost:8080
   v
Minecraft Web Client
   |
   | minecraft:25565
   v
Paper Minecraft Server
   |
   v
./data
```
