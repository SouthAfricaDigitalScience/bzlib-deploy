#!/bin/bash -e
# Copyright 2016 C.S.I.R. Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
  ln -s ${SOFT_DIR}/lib/libbz2.so.${VERSION} ${SOFT_DIR}/lib/libbz2.so.1.0
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
prepend-path PATH $::env(BZLIB_DIR)/bin
MODULE_FILE
) > modules/${VERSION}
mkdir -p ${LIBRARIES}/${NAME}
cp modules/${VERSION} ${LIBRARIES}/${NAME}
module avail
module add ${NAME}
which bzip2
echo "Checking ${BZLIB_DIR}"
ls -lht ${BZLBI_DIR}/lib
ls -lht ${BZLIB_DIR}/bin

echo "LD_LIBRARY_PATH is ${LD_LIBRARY_PATH
