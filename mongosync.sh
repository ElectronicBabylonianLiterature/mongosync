#!/bin/sh

DUMP_FOLDER=/tmp/pull-db/
RESTORE_FOLDER=/tmp/pull-db/ebl

MONGO_PASSWORD=$(cat $MONGO_PASSWORD_FILE)
MONGO_USER=$(cat $MONGO_USER_FILE)

if [[ "$MONGO_PRODUCTION_DB" == "$MONGO_DEVELOPMENT_DB" ]] || [[ "$MONGO_DEVELOPMENT_DB" == "ebl" ]]
  then
    echo "Error: MONGO_PRODUCTION_DB is equal to MONGO_DEVELOPMENT_DB"
    exit 1
  else
    echo "---------------STARTING---------------"
    echo "Time: $(date +'%T')"
    echo "Date: $(date +'%m/%d/%Y')"
    mongodump --host $MONGO_HOST \
    -d $MONGO_PRODUCTION_DB \
    --forceTableScan \
    --excludeCollectionsWithPrefix=cropped_sign_images \
    --excludeCollectionsWithPrefix=fragments_backup \
    --excludeCollectionsWithPrefix=fragments_bakcup \
    --excludeCollectionsWithPrefix=bibliography_backup \
    --excludeCollectionsWithPrefix=bibliography_backup \
    --excludeCollectionsWithPrefix=orphan \
    --excludeCollectionsWithPrefix=signs_backup \
    --excludeCollectionsWithPrefix=signs_with_invalid \
    --excludeCollectionsWithPrefix=texts_backup \
    --excludeCollectionsWithPrefix=words_backup \
    --excludeCollection=changelog \
    --excludeCollection=folios.files \
    --excludeCollection=folios.chunks \
    --excludeCollection=photos.files \
    --excludeCollection=photos.chunks \
    -u $MONGO_USER -p $MONGO_PASSWORD \
    --ssl --sslAllowInvalidCertificates \
    -o $DUMP_FOLDER

mongorestore --host $MONGO_HOST \
  -d $MONGO_DEVELOPMENT_DB \
   -u $MONGO_USER -p $MONGO_PASSWORD \
  --ssl --sslAllowInvalidCertificates \
  --authenticationDatabase ebl \
  --drop \
  $RESTORE_FOLDER

  rm -rf $RESTORE_FOLDER
  echo "---------------FINISHED---------------"
  echo "-"
  echo "-"
fi

unset MONGO_PASSWORD
unset MONGO_USER
