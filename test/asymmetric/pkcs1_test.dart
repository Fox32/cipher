// Copyright (c) 2013-present, Iván Zaera Avellón - izaera@gmail.com

// This library is dually licensed under LGPL 3 and MPL 2.0. See file LICENSE for more information.

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
// the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/.

library cipher.test.asymmetric.pkcs1_test;

import "package:cipher/cipher.dart";

import "../test/asymmetric_block_cipher_tests.dart";
import "../test/src/null_asymmetric_block_cipher.dart";
import "../test/src/null_secure_random.dart";

void main() {

  initCipher();
  SecureRandom.registry["Null"] = (name, params) => new NullSecureRandom();
  AsymmetricBlockCipher.registry["Null"] =
      (name, params) => new NullAsymmetricBlockCipher(params, 70, 70);

  runAsymmetricBlockCipherTests("Null/Null/PKCS1", {
    Param.PublicKey: new NullPublicKey()
  }, {
    Param.PrivateKey: new NullPrivateKey()
  },
      [
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit...",
          "020a010203040506070809004c6f72656d20697073756d20646f6c6f722073697420616d65742c20636f6e73"
              "656374657475722061646970697363696e6720656c69742e2e2e",
          "01ffffffffffffffffffff004c6f72656d20697073756d20646f6c6f722073697420616d65742c20636f6e73"
              "656374657475722061646970697363696e6720656c69742e2e2e",
          "En un lugar de La Mancha, de cuyo nombre no quiero acordarme",
          "020b0c0d0e0f10111200456e20756e206c75676172206465204c61204d616e6368612c206465206375796f20"
              "6e6f6d627265206e6f2071756965726f2061636f726461726d65",
          "01ffffffffffffffff00456e20756e206c75676172206465204c61204d616e6368612c206465206375796f20"
              "6e6f6d627265206e6f2071756965726f2061636f726461726d65",]);

}
