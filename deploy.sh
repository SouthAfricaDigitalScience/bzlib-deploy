#!/bin/bash -e
module add deploy
cd ${WORKSPACE}/${NAME}-${VERSION}
make distclean
./configure --prefix=${SOFT_DIR}
make install
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
set BZLIB_DIR $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
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
