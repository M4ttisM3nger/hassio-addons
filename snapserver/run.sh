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

CONFIG=/etc/snapserver.conf

threads=$(bashio::config 'server_threads')
streams=$(bashio::config 'streams|join(", ")')
buffer=$(bashio::config 'buffer')
codec=$(bashio::config 'codec')
muted=$(bashio::config 'send_to_muted')
sampleformat=$(bashio::config 'sampleformat')
http=$(bashio::config 'http_enabled')
datadir=$(bashio::config 'server_datadir')
tcp=$(bashio::config 'tcp_enabled')
logging=$(bashio::config 'logging_enabled')

if ! bashio::fs.file_exists '/etc/snapserver.conf'; then
    touch /etc/snapserver.conf ||
        bashio::exit.nok "Could not create snapserver.conf file on filesystem"
fi
bashio::log.info "Populating snapserver.conf..."

{
    echo "[server]"
    echo "threads = ${threads}"
    
    echo "[stream]"
    echo "${streams}"
    
    echo "buffer = ${buffer}"
    echo "codec = ${codec}"
    echo "send_to_muted = = ${muted}"
    echo "sampleformat = ${sampleformat}"


    echo "[http]"
    echo "enabled = ${http}"
    echo "bind_to_address = 127:0:0:1"
    echo "doc_root = ${datadir}"
    
    echo "[tcp]"
    echo "enabled = ${tcp}" 
    
    echo "[logging]"
    echo "debug = ${logging}"
    
   } > "${CONFIG}"
    

# Stream bis and ter
#if bashio::config.has_value 'stream_bis'; then
#    stream_bis=$(bashio::config 'stream_bis')
#    echo "${stream_bis}" >> "${config}"
#fi
#if bashio::config.has_value 'stream_ter'; then
#    stream_ter=$(bashio::config 'stream_ter')
#    echo "${stream_ter}" >> "${config}"
#fi

cat ${CONFIG}
bashio::log.info "Starting SnapServer..."

/usr/bin/snapserver -c /etc/snapserver.conf
