#!/usr/bin/env sh

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}

userExists=$(getent passwd ${USER_ID} | cut -d':' -f 1)
groupExists=$(getent group ${GROUP_ID} | cut -d':' -f 1)

if [ "${groupExists}" == "" ]; then
    addgroup \
      --gid ${GROUP_ID} \
      developmentlocal
else
  groupmod --new-name developmentlocal ${groupExists}
fi

if [ "${userExists}" == "" ]; then
    adduser \
      --shell /bin/sh \
      --uid ${USER_ID} \
      --gid ${GROUP_ID} \
      --system \
      development
else
  usermod -l development ${userExists}
fi
