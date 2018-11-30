#!/bin/bash
arbaUser=""
arbaPassword=""

#Genero el archivo
filename="DFEServicioDescargaPadron"
cat > $filename <<- EOF
<?xml version='1.0' encoding='ISO-8859-1'?>
<DESCARGA-PADRON>
    <fechaDesde>$(date +%Y%m01)</fechaDesde>
    <fechaHasta>$(date -d "$(date -d "+ 1 month" +%Y%m01) -1 day" +%Y%m%d)</fechaHasta>
</DESCARGA-PADRON>
EOF

#calculo el hash MD5
md5hash=`md5sum ${filename} | awk '{ print $1 }'`

#renombro el archivo
filenameHashed=$filename'_'$md5hash'.xml'
mv $filename $filenameHashed

#bajo el Padron
curl -X post \
  --insecure \
  -O \
  -F "user=$arbaUser" \
  -F "password=$arbaPassword" \
  -F "file=@./$filenameHashed" \
  https://dfe.arba.gov.ar/DomicilioElectronico/SeguridadCliente/dfeServicioDescargaPadron.do 

#renombro formato conocido
mv dfeServicioDescargaPadron.do "PadronRGS"$(date +%m%Y)".zip"

#borro el xml
rm $filenameHashed