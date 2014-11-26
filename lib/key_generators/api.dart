// Copyright (c) 2013-present, Iván Zaera Avellón - izaera@gmail.com

// This library is dually licensed under LGPL 3 and MPL 2.0. See file LICENSE for more information.

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
// the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/.

library cipher.key_generators.api;

import "package:bignum/bignum.dart";

import "package:cipher/api.dart";
import "package:cipher/ecc/api.dart";

class ECKeyGeneratorParam<T> extends Param<T> {

  static const DomainParameters = const ECKeyGeneratorParam<ECDomainParameters>("domainParameters");

  const ECKeyGeneratorParam(String name) : super(name);

}

class RSAKeyGeneratorParam<T> extends Param<T> {

  static const PublicExponent = const RSAKeyGeneratorParam<BigInteger>("publicExponent");
  static const Certainty = const RSAKeyGeneratorParam<int>("certainty");

  const RSAKeyGeneratorParam(String name) : super(name);

}

/// Abstract [CipherParameters] to init an ECC key generator.
class ECKeyGeneratorParameters extends KeyGeneratorParameters {

  ECDomainParameters _domainParameters;

  ECKeyGeneratorParameters(ECDomainParameters domainParameters)
      : super(domainParameters.n.bitLength()) {
    _domainParameters = domainParameters;
  }

  ECDomainParameters get domainParameters => _domainParameters;

}

/// Abstract [CipherParameters] to init an RSA key generator.
class RSAKeyGeneratorParameters extends KeyGeneratorParameters {

  final BigInteger publicExponent;
  final int certainty;

  RSAKeyGeneratorParameters(this.publicExponent, int bitStrength, this.certainty)
      : super(bitStrength);

}
