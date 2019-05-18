#!/usr/bin/env bash

echo "Replacing Magento's public and secret key..."

sed -i "s/MAGENTO_PUBLIC_KEY/${MAGENTO_PUBLIC_KEY}/g; s/MAGENTO_SECRET_KEY/${MAGENTO_SECRET_KEY}/g;" ~/.composer/auth.json

echo "...Done"

if [ "$1" = "magento-init" ]; then
  echo "magento-init"

  MAGENTO_ROOT=.
  downloaded_file="$MAGENTO_ROOT/__downloaded__"

  if [ ! -f "$downloaded_file" ]; then
    echo "$downloaded_file does not exist."
    echo "Starting to create Magento project in $MAGENTO_ROOT via Composer..."
    echo "Removing all files in current directory for Magento..."

    # see: https://unix.stackexchange.com/questions/77127/rm-rf-all-files-and-all-hidden-files-without-error
    find $MAGENTO_ROOT -name . -o -prune -exec rm -rf -- {} +
    composer create-project --repository=https://repo.magento.com/ magento/project-community-edition "$MAGENTO_ROOT"

    if [ "$?" != "0" ]; then
      echo "Failed to create Magento project, exit"
      exit 1
    fi

    echo "Magento project has been created!" > $downloaded_file

    echo "Changing Magento files permission..."
    # see: https://devdocs.magento.com/guides/v2.3/install-gde/prereq/nginx.html
    cd $MAGENTO_ROOT
    find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
    find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
    chown -R www-data:www-data . # Ubuntu
    chmod u+x bin/magento
    echo "...Done"

    echo "Installing Magento 2..."
    echo ">> base-url=${MAGENTO_BASE_URL}"
    echo ">> db-host=${MAGENTO_DB_HOST}"
    echo ">> db-name=${MAGENTO_DB_NAME}"
    echo ">> db-user=${MAGENTO_DB_USER}"
    echo ">> db-password=******"
    echo ">> backend-frontname=${MAGENTO_BACKEND_FRONTNAME}"
    echo ">> admin-firstname=${MAGENTO_ADMIN_FIRSTNAME}"
    echo ">> admin-lastname=${MAGNETO_ADMIN_LASTNAME}"
    echo ">> admin-email=${MAGENTO_ADMIN_EMAIL}"
    echo ">> admin-user=${MAGENTO_ADMIN_USER}"
    echo ">> admin-password=******"
    echo ">> language=${MAGENTO_LANGUAGE:-en_US}"
    echo ">> currency=${MAGENTO_CURRENCY:-USD}"
    echo ">> timezone=${MAGENTO_TIMEZONE:-"Asia/Bangkok"}"
    echo ">> use-rewrites=1"

    bin/magento setup:install \
      --base-url=${MAGENTO_BASE_URL} \
      --db-host=${MAGENTO_DB_HOST} \
      --db-name=${MAGENTO_DB_NAME} \
      --db-user=${MAGENTO_DB_USER} \
      --db-password=${MAGENTO_DB_PASSWORD} \
      --backend-frontname=${MAGENTO_BACKEND_FRONTNAME} \
      --admin-firstname=${MAGENTO_ADMIN_FIRSTNAME} \
      --admin-lastname=${MAGNETO_ADMIN_LASTNAME} \
      --admin-email=${MAGENTO_ADMIN_EMAIL} \
      --admin-user=${MAGENTO_ADMIN_USER} \
      --admin-password=${MAGENTO_ADMIN_PASSWORD} \
      --language=${MAGENTO_LANGUAGE:-en_US} \
      --currency=${MAGENTO_CURRENCY:-USD} \
      --timezone=${MAGENTO_TIMEZONE:-"Asia/Bangkok"} \
      --use-rewrites=1

    echo "...Done"
  else
    echo "Magento has already been installed"
  fi

  shift;
fi

echo "Executing $@"

exec "$@"