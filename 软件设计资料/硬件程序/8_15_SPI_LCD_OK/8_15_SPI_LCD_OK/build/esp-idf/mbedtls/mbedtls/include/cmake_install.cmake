# Install script for directory: D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/Test_spi_lcd_touch")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "D:/Software/ESP_IDF/ESP_IDF5.1/tools/xtensa-esp32s3-elf/esp-12.2.0_20230208/xtensa-esp32s3-elf/bin/xtensa-esp32s3-elf-objdump.exe")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/mbedtls" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ FILES
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/aes.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/aria.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/asn1.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/asn1write.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/base64.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/bignum.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/build_info.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/camellia.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ccm.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/chacha20.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/chachapoly.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/check_config.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/cipher.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/cmac.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/compat-2.x.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/config_psa.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/constant_time.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ctr_drbg.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/debug.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/des.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/dhm.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ecdh.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ecdsa.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ecjpake.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ecp.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/entropy.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/error.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/gcm.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/hkdf.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/hmac_drbg.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/legacy_or_psa.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/lms.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/mbedtls_config.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/md.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/md5.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/memory_buffer_alloc.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/net_sockets.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/nist_kw.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/oid.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/pem.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/pk.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/pkcs12.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/pkcs5.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/pkcs7.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/platform.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/platform_time.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/platform_util.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/poly1305.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/private_access.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/psa_util.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ripemd160.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/rsa.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/sha1.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/sha256.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/sha512.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ssl.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ssl_cache.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ssl_ciphersuites.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ssl_cookie.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/ssl_ticket.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/threading.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/timing.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/version.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/x509.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/x509_crl.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/x509_crt.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/mbedtls/x509_csr.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/psa" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ FILES
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_builtin_composites.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_builtin_primitives.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_compat.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_config.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_driver_common.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_driver_contexts_composites.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_driver_contexts_primitives.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_extra.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_platform.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_se_driver.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_sizes.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_struct.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_types.h"
    "D:/Software/ESP_IDF/ESP_IDF5.1/esp-idf/components/mbedtls/mbedtls/include/psa/crypto_values.h"
    )
endif()

