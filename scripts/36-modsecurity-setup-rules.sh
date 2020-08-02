#!/bin/sh

set -e

if [ "$MANAGE_RULES" != "Yes" ];
then
  echo "Told to not manage rules, exiting"
  exit 0
fi

ls -1 /usr/local/owasp-modsecurity-crs/rules/*.conf | xargs -n1 echo "Include" >> /tmp/rules.conf

for exclusion in $MODSECURITY_RULE_EXCLUSIONS
do
  grep -v "/$exclusion.conf$" /tmp/rules.conf > /tmp/rules.conf.grep
  echo "Excluding $exclusion.conf".
  mv /tmp/rules.conf.grep /tmp/rules.conf
done

mv /tmp/rules.conf /etc/modsecurity/conf.d
echo -e "$MODSECURITY_SNIPPET" >> /etc/modsecurity/conf.d/rules.conf
echo "Final ruleset:"
cat /etc/modsecurity/conf.d/rules.conf



exit 0