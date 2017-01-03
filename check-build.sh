#!/bin/bash -e
. /etc/profile.d/modules.sh
module add ci
cd ${WORKSPACE}/${NAME}-${VERSION}

make install PREFIX=${SOFT_DIR}
cp -f  libbz2.so.${VERSION} ${SOFT_DIR}/lib
chmod a+r ${SOFT_DIR}/lib/libbz2.so.${VERSION}
ln -s ${SOFT_DIR}/lib/libbz2.so.${VERSION} ${SOFT_DIR}/lib/libbz2.so
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
  puts stderr "\\tAdds $NAME ($VERSION.) to your environment."
}
module-whatis "Sets the environment for using $NAME ($VERSION.) See https://github.com/SouthAfricaDigitalScience/bzlib-deploy"
setenv BZLIB_VERSION $VERSION
set BZLIB_DIR $::env(SOFT_DIR)
prepend-path CPATH ${BZLIB_DIR}/include
prepend-path LD_LIBRARY_PATH ${BZLIB_DIR}/lib
prepend-path LD_LIBRARY_PATH ${BZLIB_DIR}/lib64
MODULE_FILE
) > modules/${VERSION}
mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}
module avail
module add ${NAME}
which bzip2
