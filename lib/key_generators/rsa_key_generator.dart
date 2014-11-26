// Copyright (c) 2013-present, Iván Zaera Avellón - izaera@gmail.com

// This library is dually licensed under LGPL 3 and MPL 2.0. See file LICENSE for more information.

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
// the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0/.

library cipher.key_generators.rsa_key_generator;

import "package:bignum/bignum.dart";

import "package:cipher/api.dart";
import "package:cipher/algorithm/base_algorithm.dart";
import "package:cipher/asymmetric/api.dart";
import "package:cipher/key_generators/api.dart";

class RSAKeyGenerator extends BaseParameterizedNamedAlgorithm implements KeyGenerator {

  final SecureRandom _random;

  final int _bitStrength;
  final BigInteger _publicExponent;
  final int _certainty;

  RSAKeyGenerator(Map<Param, dynamic> params, this._random)
      : super("RSA", params),
        _bitStrength = params[Param.BitStrength],
        _publicExponent = params[RSAKeyGeneratorParam.PublicExponent],
        _certainty = params[RSAKeyGeneratorParam.Certainty] {

    if (_bitStrength < 12) {
      throw new ArgumentError("Key bit strength cannot be smaller than 12");
    }

    if (!_publicExponent.testBit(0)) {
      throw new ArgumentError("Public exponent cannot be even");
    }
  }

  AsymmetricKeyPair generateKeyPair() {
    var p, q, n, e;

    // p and q values should have a length of half the strength in bits
    var strength = _bitStrength;
    var pbitlength = (strength + 1) ~/ 2;
    var qbitlength = strength - pbitlength;
    var mindiffbits = strength ~/ 3;

    e = _publicExponent;

    // TODO Consider generating safe primes for p, q (see DHParametersHelper.generateSafePrimes)
    // (then p-1 and q-1 will not consist of only small factors - see "Pollard's algorithm")

    // generate p, prime and (p-1) relatively prime to e
    for ( ; ; ) {
      p = generateProbablePrime(pbitlength, 1, _random);

      if (p.mod(e) == 1) {
        continue;
      }

      if (!p.isProbablePrime(_certainty)) {
        continue;
      }

      if (e.gcd(p - BigInteger.ONE) == 1) {
        break;
      }
    }

    // generate a modulus of the required length
    for ( ; ; ) {

      // generate q, prime and (q-1) relatively prime to e, and not equal to p
      for ( ; ; ) {
        q = generateProbablePrime(pbitlength, 1, _random);

        if ((q - p).abs().bitLength() < mindiffbits) {
          continue;
        }

        if (q.mod(e) == 1) {
          continue;
        }

        if (!q.isProbablePrime(_certainty)) {
          continue;
        }

        if (e.gcd(q - BigInteger.ONE) == 1) {
          break;
        }
      }

      // calculate the modulus
      n = p.multiply(q);

      if (n.bitLength() == _bitStrength) {
        break;
      }

      // if we get here our primes aren't big enough, make the largest of the two p and try again
      p = p.max(q);
    }

    // Swap p and q if necessary
    if (p < q) {
      var swap = p;
      p = q;
      q = swap;
    }

    // calculate the private exponent
    var pSub1 = (p - BigInteger.ONE);
    var qSub1 = (q - BigInteger.ONE);
    var phi = (pSub1 * qSub1);
    var d = e.modInverse(phi);

    return new AsymmetricKeyPair(new RSAPublicKey(n, e), new RSAPrivateKey(n, d, p, q));
  }

}

BigInteger generateProbablePrime(int bitLength, int certainty, SecureRandom rnd) {
  var candidate;

  if (bitLength < 2) {
    candidate = new BigInteger(1);
  } else {
    candidate = rnd.nextBigInteger(bitLength);

    // force MSB set
    if (!candidate.testBit(bitLength - 1)) {
      candidate.bitwiseTo(BigInteger.ONE.shiftLeft(bitLength - 1), (x, y) => x | y, candidate);
    }

    // force odd
    if (candidate.isEven()) {
      candidate.dAddOffset(1, 0);
    }

    while (!candidate.isProbablePrime(certainty)) {
      candidate.dAddOffset(2, 0);
      if (candidate.bitLength() > bitLength) {
        candidate.subTo(BigInteger.ONE.shiftLeft(bitLength - 1), candidate);
      }
    }
  }

  return candidate;
}
