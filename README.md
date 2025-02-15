<p align="center">
 <img alt="docker-killingfloor logo" src="https://raw.githubusercontent.com/K4rian/docker-killingfloor/refs/heads/assets/icons/logo-docker-killingfloor.svg" width="25%" align="center">
</p>

A Docker image for the __Killing Floor Dedicated Server__, packaged with the custom launcher **[KFDSL][1]** and based on [Debian][2] (bookworm-slim).<br>
This image allows you to deploy a KF server with minimal configuration - no manual file editing required.

---
<div align="center">

Docker Tag  | Version | Platform  | Description
---         | ---     | ---       | ---
[latest][3] | 1.0     | amd64     | Latest release
[1.0][3]    | 1.0     | amd64     | v1.0
</div>

---
<p align="center"><a href="#environment-variables">Environment variables</a> &bull; <a href="#steam-authentication">Steam Authentication</a> &bull; <a href="#usage">Usage</a> &bull; <a href="#using-compose">Using Compose</a> &bull; <a href="#manual-build">Manual build</a> &bull; <a href="#see-also">See also</a> &bull; <a href="#license">License</a></p>

---
## Environment variables
Environment variables can be provided when creating a container to configure Steam, the server, and the launcher:

<details>
<summary>Click to expand</summary>

### Steam
Variable               | Default Value                   | Description
---                    | ---                             | ---
STEAMACC_USERNAME      | `anonymous`                     | **(Required)** Steam account username. 
STEAMACC_PASSWORD      |                                 | **(Required)** Steam account password *(⚠️ **NOT** recommended, see the section below)*. 

### Server/Launcher
Variable               | Default Value                   | Description
---                    | ---                             | ---
KF_CONFIG              | `KillingFloor.ini`              | Server configuration file. 
KF_SERVERNAME          | `KF Server`                     | Name of the server. 
KF_SHORTNAME           | `KFS`                           | Short name (alias) for the server. 
KF_PORT                | `7707`                          | Game server port. 
KF_WEBADMINPORT        | `8075`                          | Web admin panel port. 
KF_GAMESPYPORT         | `7717`                          | GameSpy query port. 
KF_GAMEMODE            | `survival`                      | Game mode (`survival, objective, toymaster`). 
KF_MAP                 | `KF-BioticsLab`                 | Map to start the server on. 
KF_DIFFICULTY          | `hard`                          | Game difficulty level (`easy, normal, hard, suicidal, hell`). 
KF_LENGTH              | `medium`                        | Game length (`short, medium, long`). 
KF_FRIENDLYFIRE        | `0.0`                           | Friendly fire multiplier (`0.0` = off, `1.0` = full damage). 
KF_MAXPLAYERS          | `6`                             | Maximum number of players. 
KF_MAXSPECTATORS       | `6`                             | Maximum number of spectators. 
KF_PASSWORD            |                                 | Server Password (`empty` = no password). 
KF_REGION              | `1`                             | Server region. 
KF_ADMINNAME           |                                 | Administrator name. 
KF_ADMINMAIL           |                                 | Administrator email address. 
KF_ADMINPASSWORD       |                                 | Administrator password. 
KF_MOTD                |                                 | Message of the day. 
KF_SPECIMENTYPE        | `default`                       | ZEDs type (`default, summer, halloween, christmas`). 
KF_MUTATORS            |                                 | Command-line mutators list. 
KF_SERVERMUTATORS      |                                 | Server-side mutators list (`ServerActors`). 
KF_REDIRECTURL         |                                 | URL for fast download redirection. 
KF_MAPLIST             | `all`                           | List of available maps for the current game (`all` = all available maps). 
KF_WEBADMIN            | `false`                         | Enable or disable the web admin panel. 
KF_MAPVOTE             | `false`                         | Enable or disable map voting. 
KF_MAPVOTE_REPEATLIMIT | `1`                             | Number of maps to be played before a repeat. 
KF_ADMINPAUSE          | `false`                         | Allow administrators to pause the game. 
KF_NOWEAPONTHROW       | `false`                         | Prevent weapons from being thrown on the ground. 
KF_NOWEAPONSHAKE       | `false`                         | Disable weapon shake effect. 
KF_THIRDPERSON         | `false`                         | Enable third-person view (F4). 
KF_LOWGORE             | `false`                         | Disable gore system (no dismemberment). 
KF_UNCAP               | `false`                         | Uncap the framerate (requires client-side tweaks too). 
KF_UNSECURE            | `false`                         | Start the server without Valve Anti-Cheat (VAC). 
KF_NOSTEAM             | `false`                         | Bypass SteamCMD and start the server immediately. 
KF_NOVALIDATE          | `false`                         | Skip server files integrity check. 
KF_AUTORESTART         | `false`                         | Automatically restart the server if it crashes. 
KF_MUTLOADER           | `false`                         | Enable MutLoader (inline mutator). 
KF_KFPATCHER           | `false`                         | Enable KFPatcher (server mutator). 
KF_HIDEPERKS           | `false`                         | KFPatcher: Hide perks. 
KF_NOZEDTIME           | `false`                         | KFPatcher: Disable slow-motion during ZED Time. 
KF_BUYEVERYWHERE       | `false`                         | KFPatcher: Allow buying weapons anywhere. 
KF_ALLTRADERS          | `false`                         | KFPatcher: Keep all traders open. 
KF_ALLTRADERS_MESSAGE  | `"^wAll traders are ^ropen^w!"` | KFPatcher: Message displayed when all traders are open. 
KF_LOG_TO_FILE         | `false`                         | Enable logging to a file. 
KF_LOG_LEVEL           | `info`                          | Logging level (`info, debug, warn, error`). 
KF_LOG_FILE            | `./kfdsl.log`                   | Path to the log file. 
KF_LOG_FILE_FORMAT     | `text`                          | Format of the log file (`text, json`). 
KF_LOG_MAX_SIZE        | `10`                            | Maximum log file size in MB. 
KF_LOG_MAX_BACKUPS     | `5`                             | Maximum number of old log files to retain. 
KF_LOG_MAX_AGE         | `28`                            | Maximum log file age in days. 
KF_EXTRAARGS           |                                 | Extra arguments passed to the server. 

</details>

## Steam Authentication
To download and update the server files, it is required to provide both a valid Steam username and password.  
It is **strongly recommended** to create a secondary Steam account **without Steam Guard** specifically for the server.  
Using your **main Steam account is NOT recommended**.

### Providing Steam Credentials
Steam credentials can be provided by using:

1. **Environment Variables** (⚠️ **NOT Recommended**)  
  - `STEAMACC_USERNAME`: Your Steam login username.  
  - `STEAMACC_PASSWORD`: Your Steam login password.  
  - **Credentials stored as environment variables may be exposed in logs or container metadata.**

2. **Docker Secrets** (✅ **Recommended**)  
  - Using Docker secrets ensures that your credentials are securely stored and not exposed in environment variables.  
  - To use Docker secrets, create a secret file and pass it to the container. 
  - Your username secret must be named `steamacc_username` and your password `steamacc_password`.
  - Example command to create a Docker secret for the password:  
```bash
echo "<YOUR_STEAM_PASSWORD>" | docker secret create steamacc_password -
```

3. **Docker Compose Secrets** (✅ **Recommended**)  
  - If using **Docker Compose**, you can mount secrets from a file to keep credentials secure.
  - Create a `steam_username.txt` file containing only the account username.
  - Create a `steam_password.txt` file containing only the account password.
  - See the <a href="#using-compose">Compose section</a>.

## Usage
> *In all examples, the Steam `username` is set using an `environment variable`, while the `password` is stored in the `steam_password.txt` file located in the current working directory.*

__Example 1:__<br>
Run a public `Survival` server with custom `names`, set to `Suicidal` difficulty on a `long-length` game, and starting on `KF-WestLondon`: 
```bash
docker run -d \
  --name kfserver \
  -p 7707:7707/udp \
  -p 7708:7708/udp \
  -p 28852:28852/udp \
  -p 28852:28852/tcp \
  -p 20560:20560/tcp \
  -p 20560:20560/udp \
  -e STEAMACC_USERNAME="<STEAM_USERNAME>" \
  -e KF_SERVERNAME="KF Server [Suidical] [Long]" \
  -e KF_SHORTNAME="KFS" \
  -e KF_MAP="KF-WestLondon" \
  -e KF_DIFFICULTY="suicidal" \
  -e KF_LENGTH="long" \
  -v $(pwd)/steam_password.txt:/run/secrets/steamacc_password \
  -i k4rian/killingfloor
```

__Example 2:__<br>
Run a password-protected server in `Objective` mode, with `map voting` enabled, set to `Hard` difficulty on a `medium-length` game, and starting on `KFO-Steamland`:
```bash
docker run -d \
  --name kfserver-objective \
  -p 7707:7707/udp \
  -p 7708:7708/udp \
  -p 28852:28852/udp \
  -p 28852:28852/tcp \
  -p 20560:20560/tcp \
  -p 20560:20560/udp \
  -e STEAMACC_USERNAME="<STEAM_USERNAME>" \
  -e KF_SERVERNAME="KF Server [Objective] [Hard] [Medium]" \
  -e KF_SHORTNAME="OKFS" \
  -e KF_GAMEMODE="objective" \
  -e KF_MAP="KFO-Steamland" \
  -e KF_DIFFICULTY="hard" \
  -e KF_LENGTH="medium" \
  -e KF_PASSWORD="<16_CHARACTERS_MAX_PASSWORD>" \
  -e KF_MAPVOTE="true" \
  -v $(pwd)/steam_password.txt:/run/secrets/steamacc_password \
  -i k4rian/killingfloor
```

__Example 3:__<br />
Run a public `Toy Master` server using a custom `configuration file`, `map voting` and `web admin panel` enabled, set to `Hell on Earth` difficulty on a `short-length` game:
```bash
docker run -d \
  --name kfserver-toymaster \
  -p 7707:7707/udp \
  -p 7708:7708/udp \
  -p 28852:28852/udp \
  -p 28852:28852/tcp \
  -p 8075:8075/tcp \
  -p 20560:20560/tcp \
  -p 20560:20560/udp \
  -e STEAMACC_USERNAME="<STEAM_USERNAME>" \
  -e KF_CONFIG="ToyGame.ini" \
  -e KF_SERVERNAME="KF Server [Toy Master] [HoE] [Short]" \
  -e KF_SHORTNAME="TMKFS" \
  -e KF_GAMEMODE="toymaster" \
  -e KF_MAP="TOY-DevilsDollhouse" \
  -e KF_DIFFICULTY="hell" \
  -e KF_LENGTH="short" \
  -e KF_MAPVOTE="true" \
  -v $(pwd)/steam_password.txt:/run/secrets/steamacc_password \
  -i k4rian/killingfloor
```

## Using Compose
See [compose/README.md][4]

## Manual build
__Requirements__:<br>
— Docker >= __18.09.0__<br>
— Git *(optional)*

Like any Docker image the building process is pretty straightforward: 

- Clone (or download) the GitHub repository to an empty folder on your local machine:
```bash
git clone --depth 1 https://github.com/K4rian/docker-killingfloor.git .
```

- Then run the following command inside the newly created folder:
```bash
docker build --no-cache -t k4rian/killingfloor .
```

## See also
- **[docker-steamcmd][5]**: The base image used by this project.
- **[kfdsl][1]**: A custom launcher for the KF server, written in Go.
- **[kfrs][6]**: A secure HTTP redirect server for the KF server, written in Go.

## License
[MIT][7]

[1]: https://github.com/K4rian/kfdsl "Killing Floor Dedicated Server Launcher (KFDSL)"
[2]: https://hub.docker.com/_/debian "Debian Docker Image on Docker Hub"
[3]: https://github.com/K4rian/docker-killingfloor/blob/main/Dockerfile "Latest Dockerfile"
[4]: https://github.com/K4rian/docker-killingfloor/tree/main/compose "Compose Files"
[5]: https://github.com/K4rian/docker-steamcmd "SteamCMD Docker Image"
[6]: https://github.com/K4rian/kfrs "Killing Floor Redirect Server (KFRS)"
[7]: https://github.com/K4rian/docker-killingfloor/blob/main/LICENSE