#!/bin/bash -e
. /etc/profile.d/modules.sh
module add deploy
cd ${WORKSPACE}/${NAME}-${VERSION}
make distclean
make -f Makefile-libbz2_so
make install PREFIX=${SOFT_DIR}
cp -f  libbz2.so.${VERSION} ${SOFT_DIR}/lib
chmod a+r ${SOFT_DIR}/lib/libbz2.so.${VERSION}
if [ ! -h ${SOFT_DIR}/lib/libbz2.so ] ; then
  ln -s ${SOFT_DIR}/lib/libbz2.so.${VERSION} ${SOFT_DIR}/lib/libbz2.so
fi
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
setenv BZLIB_DIR $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path CPATH $::env(BZLIB_DIR)/include
prepend-path LD_LIBRARY_PATH $::env(BZLIB_DIR)/lib
prepend-path LD_LIBRARY_PATH $::env(BZLIB_DIR)/lib64
prepend-path PATH $::en(BZLIB_DIR)/path
MODULE_FILE
) > modules/${VERSION}
mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}
module avail
module add ${NAME}
which bzip2
