FROM golang:bookworm AS builder

WORKDIR /tmp/launcher

RUN apt update \
    && apt install -y \
        git \
    && mkdir -p /server \
    && git clone "https://github.com/K4rian/kfdsl.git" /tmp/launcher \
    && go mod download \
    && CGO_ENABLED=0 go build -a -o kfdsl . \
    && cp /tmp/launcher/kfdsl /server/kfdsl \
    && chmod +x /server/kfdsl \
    && rm -R /tmp/launcher

FROM k4rian/steamcmd:latest

ENV KF_CONFIG="KillingFloor.ini"
ENV KF_SERVERNAME="KF Server"
ENV KF_SHORTNAME="KFS"
ENV KF_PORT=7707
ENV KF_WEBADMINPORT=8075
ENV KF_GAMESPYPORT=7717
ENV KF_GAMEMODE="survival"
ENV KF_MAP="KF-BioticsLab"
ENV KF_DIFFICULTY="hard"
ENV KF_LENGTH="medium"
ENV KF_FRIENDLYFIRE=0.0
ENV KF_MAXPLAYERS=6
ENV KF_MAXSPECTATORS=6
ENV KF_PASSWORD=""
ENV KF_REGION=1
ENV KF_ADMINNAME=""
ENV KF_ADMINMAIL=""
ENV KF_ADMINPASSWORD=""
ENV KF_MOTD=""
ENV KF_SPECIMENTYPE="default"
ENV KF_MUTATORS=""
ENV KF_SERVERMUTATORS=""
ENV KF_REDIRECTURL=""
ENV KF_MAPLIST="all"
ENV KF_WEBADMIN="false"
ENV KF_MAPVOTE="false"
ENV KF_MAPVOTE_REPEATLIMIT=1
ENV KF_ADMINPAUSE="false"
ENV KF_NOWEAPONTHROW="false"
ENV KF_NOWEAPONSHAKE="false"
ENV KF_THIRDPERSON="false"
ENV KF_LOWGORE="false"
ENV KF_UNCAP="false"
ENV KF_UNSECURE="false"
ENV KF_NOSTEAM="false"
ENV KF_NOVALIDATE="false"
ENV KF_AUTORESTART="false"
ENV KF_MUTLOADER="false"
ENV KF_KFPATCHER="false"
ENV KF_HIDEPERKS="false"
ENV KF_NOZEDTIME="false"
ENV KF_BUYEVERYWHERE="false"
ENV KF_ALLTRADERS="false"
ENV KF_ALLTRADERS_MESSAGE="\"^wAll traders are ^ropen^w!\""
ENV KF_LOG_TO_FILE="false"
ENV KF_LOG_LEVEL="info"
ENV KF_LOG_FILE="./kfdsl.log"
ENV KF_LOG_FILE_FORMAT="text"
ENV KF_LOG_MAX_SIZE=10
ENV KF_LOG_MAX_BACKUPS=5
ENV KF_LOG_MAX_AGE=28
ENV KF_EXTRAARGS=""

ENV STEAMCMD_ROOT=$STEAMCMDDIR
ENV STEAMCMD_APPINSTALLDIR=$SERVERDIR
ENV STEAMACC_USERNAME="anonymous"
ENV STEAMACC_PASSWORD=""

COPY --from=builder --chown=$USERNAME /server/* $USERHOME/
#COPY --chown=$USERNAME ./container_files $USERHOME

WORKDIR $USERHOME

ENTRYPOINT ["./kfdsl"]