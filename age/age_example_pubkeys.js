"use strict";
let { bech32 } = require('bech32');

const bech32map_a = Array.from("qpzry9x8gf2tvdw0s3jn54khce6mua7l"); // from spec
// .sort() => "023456789acdefghjklmnpqrstuvwxyz"

// generate functional "vanity" "low-entropy" example age pubkeys
// use with caution! may be nonsense points, may break in future
// noone will be ever able to derive privkey (hopefully)
function age1pkexample(str, pad, altend) {
  str = str || "x";
  pad = pad || "x";
  let idx, s, w, r;
  s = (str + pad.repeat(52)).substring(0, 52);
  w = Array.from(s).map(
    x => (idx = bech32map_a.indexOf(x)) >= 0 ? idx : 6 /* "x" if invalid */
  );
  w[51] = 0;
  if (altend) w[51] = 16;
  r = bech32.encode("age", w);
  return r;
}

if (typeof(exports) === "object")
  exports.age1pkexample = age1pkexample;

// examples
console.assert( age1pkexample() ==
  "age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxqc7t598");
console.assert( age1pkexample("23456789", "0") ==
  "age1234567890000000000000000000000000000000000000000000qxhgrlr");
console.assert( age1pkexample("23456789", "0", true) ==
  "age1234567890000000000000000000000000000000000000000000snkqm2s");
console.assert( age1pkexample("foobar1") ==  // includes invalid chars "bo1"
  "age1fxxxarxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxqh55d3e");

if (0) {
  let k = age1pkexample("f00baz", "x");
  console.log(k);
}
