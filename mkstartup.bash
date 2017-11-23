#!/bin/bash

mkpassword() {
 echo "import crypt; print(crypt.crypt('$1', 'hoge'))" | python
}

cat ./startup.bash.tpl | 
  sed  "s!{{public_key}}!$(cat $1)!" |
  sed  "s/{{password}}/$(mkpassword $2)/"
