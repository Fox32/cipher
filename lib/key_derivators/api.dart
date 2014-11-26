// Copyright (c) 2013-present, Iván Zaera Avellón - izaera@gmail.com

// This library is dually licensed under LGPL 3 and MPL 2.0. See file LICENSE for more information.

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
// the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/.

library cipher.key_derivators.api;

import "dart:typed_data";

import "package:cipher/api.dart";

class Pbkdf2Param<T> extends Param<T> {

  static const IterationCount = const Pbkdf2Param<int>("iterationCount");

  const Pbkdf2Param(String name) : super(name);

}

class ScryptParam<T> extends Param<T> {

  static const N = const Pbkdf2Param<int>("N");
  static const r = const Pbkdf2Param<int>("r");
  static const p = const Pbkdf2Param<int>("p");

  const ScryptParam(String name) : super(name);

}

/// [CipherParameters] used by PBKDF2.
class Pbkdf2Parameters extends CipherParameters {

  final Uint8List salt;
  final int iterationCount;
  final int desiredKeyLength;

  Pbkdf2Parameters(this.salt, this.iterationCount, this.desiredKeyLength);

}

/// [CipherParameters] for the scrypt password based key derivation function.
class ScryptParameters implements CipherParameters {

    final int N;
    final int r;
    final int p;
    final int desiredKeyLength;
    final Uint8List salt;

    ScryptParameters( this.N, this.r, this.p, this.desiredKeyLength, this.salt );

}
