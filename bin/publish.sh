#!/usr/bin/env bash

ROOT="$(dirname "$0")/.."
SCHEME="https:"

allItems=""

process () {
    SWAGGER_FILE=$1
    LOGIN=$2
    PASSW=$3

    if [ ! -e "${SWAGGER_FILE}" ]; then
        echo "No swagger file !"
        return 1
    fi

    SWAGGER_DIRECTORY=$(dirname "${SWAGGER_FILE}")
    NAME=$(basename "${SWAGGER_DIRECTORY}")
    TITLE=$(jq .info.title < "${SWAGGER_FILE}")
    if [ "${TITLE:-null}" = "null" ]
    then
        logger -s "${NAME} - ERROR: swagger has no title !"
        return 2
    fi
    SUMMARY=$(jq .info.summary < "${SWAGGER_FILE}")
    if [ "${SUMMARY:-null}" = "null" ]
    then
        logger -s "${NAME} - ERROR: swagger has no summary !"
        return 3
    fi
	SERVERS=$(jq -r ".servers" < "${SWAGGER_FILE}")
    if [ "${SERVERS:-null}" = "null" ]
    then
        logger -s "${NAME} - ERROR: swagger has no servers!"
        return 4
    fi
	URL=$(jq -r ".servers[] | select(.\"x-profil\").url" < "${SWAGGER_FILE}" | sed -e "s/^/                    - url: /")
	if [ "${URL:-null}" = "null" ]
	then
		logger -s "${NAME} - ERROR: swagger has no url !"
		return 5
	fi
	# First profil will be used for all url
	PROFIL=$(jq -r ".servers[] | select(.\"x-profil\").\"x-profil\"" < "${SWAGGER_FILE}" | head -n 1)
	case ${PROFIL} in
		Standard | Deprecated | Reserved | Administrator )
			echo -n "${NAME} - ${PROFIL} - "
			;;
		* )
			logger -s "${NAME} - ERROR: swagger has no valid x-profil !"
			return 6
			;;
	esac
	CURL_OUTFILE=$(mktemp)
    cat <<EOF | curl --silent --user "${LOGIN}:${PASSW}" -T - "http://vpdaf.intra.inist.fr:35270/internal-proxy-1/data/${NAME}.yml" --digest  --write-out %{http_code} --output /dev/null > "${CURL_OUTFILE}"
http:
    routers:
        Router-${NAME}:
            entryPoints:
                - "web"
            middlewares:
                - "Middleware-${PROFIL}"
            service: "Service-${NAME}"
            rule: "Host(\`${NAME}.services.istex.fr\`, \`${NAME}.services.inist.fr\`)"
    services:
        Service-${NAME}:
            loadBalancer:
                servers:
${URL}

EOF
	HTTP_CODE=$(cat "${CURL_OUTFILE}"; rm "${CURL_OUTFILE}")
	echo -n "${HTTP_CODE} - "

	CURL_OUTFILE=$(mktemp)
	cat <<EOF | curl --silent --user "${LOGIN}:${PASSW}" -T - "http://vpdaf.intra.inist.fr:35270/internal-metrics-1/data/config/${NAME}.yml" --digest  --write-out %{http_code} --output /dev/null > "${CURL_OUTFILE}"
  - job_name: '${NAME}'
    scrape_interval: 10s
    scheme: https
    static_configs:
      - targets: ['${NAME}.services.istex.fr']
EOF
	HTTP_CODE=$(cat "${CURL_OUTFILE}"; rm "${CURL_OUTFILE}")
	echo "${HTTP_CODE}"
	allItems+="{ url: \"${SCHEME}//${NAME}.services.istex.fr\", name: ${TITLE} },"
    return 0
}

FILES=$(ls "${ROOT}"/*/swagger.json)

echo -n "Login: "
read -r login
echo -n "Password: "
read -rs  passw
echo " "

for swagger in ${FILES}
do
    process "$swagger" "$login" "$passw"
done


echo -n "open-api - Swagger - "
CURL_OUTFILE=$(mktemp)
cat <<EOF | curl --silent --user "${login}:${passw}" -T - "http://vpdaf.intra.inist.fr:35270/open-api-1/data/swagger-initializer.js" --digest   --write-out %{http_code} --output /dev/null > "${CURL_OUTFILE}"
window.onload = function() {
  //<editor-fold desc="Changeable Configuration Block">

  // the following lines will be replaced by docker/configurator, when it runs in a docker-container
  window.ui = SwaggerUIBundle({
    urls: [
		${allItems}
	],
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: "StandaloneLayout"
  });

  //</editor-fold>
};
EOF
HTTP_CODE=$(cat "${CURL_OUTFILE}"; rm "${CURL_OUTFILE}")
echo "${HTTP_CODE}"
