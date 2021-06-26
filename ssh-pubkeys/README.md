### OpenSSH pubkey initials

OpenSSH default public key format, like

`ssh-rsa AAAAB3…` ,

is somewhat redundant, meant also for humans.
The key type is present also in the binary data encoded with base64.

This is not detailed analysis of the pubkey structure and binary format,
just an attempt to determine safe common initial substring to determine
the type only from the b64 encoded key.

<pre>
dsa (ssh-dss):
  AAAAB3NzaC1kc3MAAACBA...
  <b>AAAAB3NzaC1kc3MA</b>AACB
  ...|.ss|h-d|ss.|...|
  ....ssh-dss....
  \x00\x00\x00\x07ssh-dss\x00\x00\x00\x81

rsa (ssh-rsa):
  AAAAB3NzaC1yc2EAAAADAQABAAABgQ...
  <b>AAAAB3NzaC1yc2EA</b>AAADAQABAAAB
  ...|.ss|h-r|sa.|...|...|...|
  ....ssh-rsa..........
  \x00\x00\x00\x07ssh-rsa\x00\x00\x00\x03\x01\x00\x01\x00\x00\x01

ecdsa (ecdsa-sha2-nistp256):
  AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBB...
  <b>AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYA</b>AAAIbmlzdHAyNTYAAABB
  ...|.ec|dsa|-sh|a2-|nis|tp2|56.|...|nis|tp2|56.|..A|
  ....ecdsa-sha2-nistp256....nistp256...A
  \x00\x00\x00\x13ecdsa-sha2-nistp256\x00\x00\x00\x08nistp256\x00\x00\x00A

ed25519 (ssh-ed25519):
  AAAAC3NzaC1lZDI1NTE5AAAAI...
  <b>AAAAC3NzaC1lZDI1NTE5</b>AAAA
  ...|.ss|h-e|d25|519|...|
  ....ssh-ed25519...
  \x00\x00\x00\x0Bssh-ed25519\x00\x00\x00
</pre>

First b64 line is the common initial substring,
below it's trimmed to full 3-byte (4 b64 symbols) groups,
and in bold font an example of usable recognizing prefix (can be disputed).
