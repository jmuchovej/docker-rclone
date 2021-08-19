## RClone Builder ############################################################
FROM golang AS builder

RUN git clone https://github.com/rclone/rclone /rclone
WORKDIR /rclone/

ENV CGO_ENABLED=0
RUN make
RUN ./rclone version

## RClone Container ##########################################################
FROM lsiodev/ubuntu:focal

COPY root/ /
COPY --from=builder /rclone/rclone /usr/local/bin/

RUN    apt update -y \
    && apt install -y ca-certificates fuse tzdata \
    && echo "user_allow_other" >> /etc/fuse.conf

RUN    groupadd -g 1009 rclone \
    && useradd -u 1009 -s /bin/sh -g rclone rclone

ENTRYPOINT [ "rclone" ]
WORKDIR /data
