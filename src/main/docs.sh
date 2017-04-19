#
#  2012-2017 Codenvy, S.A.
#  All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of Codenvy S.A. and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to Codenvy S.A.
# and its suppliers and may be covered by U.S. and Foreign Patents,
# patents in process, and are protected by trade secret or copyright law.
# Dissemination of this information or reproduction of this material
# is strictly forbidden unless prior written permission is obtained
# from Codenvy S.A..
#


# Hardcoded for windows right now.
# Need to make this configurable for our CI systems and to work on windows or linux.
# 
# Optionally - you can run 'jekyll/jekyll jekyll serve' to get a local server on port 9080
# NOTE - these files will not work without a hosted server right now - they are not static stand alone 
GLOBAL_HOST_ARCH=$(docker version --format {{.Client}} | cut -d" " -f5)

docker() {
  if has_docker_for_windows_client; then
    MSYS_NO_PATHCONV=1 docker.exe "$@"
  else
    "$(which docker)" "$@"
  fi
}

has_docker_for_windows_client(){
  if [ "${GLOBAL_HOST_ARCH}" = "windows" ]; then
    return 0
  else
    return 1
  fi
}


BUILD_OR_RUN=${1:-"--build"}

if [ "$BUILD_OR_RUN" = "--build" ]; then
	COMMAND="jekyll build --incremental"
  echo ""
	echo "Outputting site contents into /_site"
  echo ""
elif [ "$BUILD_OR_RUN" = "--run" ]; then
	COMMAND="jekyll serve -w --force_polling --incremental"	

  echo ""
	echo "View generated docs at http://localhost:9080/docs/"
  echo ""
fi

docker rm -f jekyll > /dev/null 2>&1
docker run --rm -it -p 9080:4000 --name jekyll \
       -v "${PWD}":/srv/jekyll \
       -v "${PWD}"/_site:/srv/jekyll/_site \
           jekyll/jekyll $COMMAND

