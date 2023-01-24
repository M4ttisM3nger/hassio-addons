#!/usr/bin/env bashio

mkdir -p /share/snapfifo
mkdir -p /share/snapcast

declare streams
declare stream_bis
declare stream_ter
declare buffer
declare codec
declare muted
declare sampleformat
declare http
declare tcp
declare logging
declare threads
declare datadir
declare test

test=/usr/bin/snapserver

config=/etc/snapserver.conf

if ! bashio::fs.file_exists '/etc/snapserver.conf'; then
    touch /etc/snapserver.conf ||
        bashio::exit.nok "Could not create snapserver.conf file on filesystem"
fi
bashio::log.info "Populating snapserver.conf..."


bashio::log.info "Starting SnapServer..."


/usr/bin/snapserver #-c /etc/snapserver.conf
