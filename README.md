# Minecraft on NixOS

Local Minecraft Java server using Docker, Paper, Geyser and Floodgate.

- Java clients: `<NIXOS-LAN-IP>:25565`
- Bedrock/iPhone/iPad: `<NIXOS-LAN-IP>:19132`
- Persistent server/world data: `./data`
- Configuration: Git
- World backups: Restic

## First start

Make sure Docker is enabled in NixOS, for example:

```nix
virtualisation.docker.enable = true;
users.users.<your-user>.extraGroups = [ "docker" ];
```

Then:

```bash
cp .env.example .env
printf '%s\n' 'choose-a-long-backup-password' > .restic-password
chmod 600 .restic-password

direnv allow
mc-up
mc-logs
```

The first start downloads the Minecraft server and plugins.

## Where does Restic store the backup?

Restic itself is only the backup program. `RESTIC_REPOSITORY` tells it where the
encrypted backup repository lives.

The example `.env.example` uses:

```text
/mnt/backup-disk/restic/minecraft
```

That is useful only if `/mnt/backup-disk` is actually another disk/NAS mount.
Putting the Restic repository on the same PC/disk protects against accidental
world changes, but NOT against losing or breaking that PC.

For surviving a PC change, point `RESTIC_REPOSITORY` at storage outside the PC:
a NAS, another machine, or a supported cloud/object-storage backend.

## Initialize Restic

After choosing the destination in `.env`:

```bash
set -a; source .env; set +a
restic init
```

Only once.

Then:

```bash
mc-backup
```

List snapshots:

```bash
set -a; source .env; set +a
restic snapshots
```

Restore:

```bash
mc-restore
```

## Git vs data

`data/` is physically inside this project directory, but ignored by Git.
That gives you the convenient layout you wanted without filling Git history
with Minecraft region files.

If you explicitly want GitHub to contain the world too, remove the `data/*`
rules from `.gitignore`; for a small personal world it can work, but Restic is
the safer long-term backup mechanism.

## LAN access

Run:

```bash
mc-ip
```

Use that LAN IP from devices on the same home network.

Your NixOS firewall must allow TCP 25565 and UDP 19132 if the firewall is enabled.
For example:

```nix
networking.firewall.allowedTCPPorts = [ 25565 ];
networking.firewall.allowedUDPPorts = [ 19132 ];
```
