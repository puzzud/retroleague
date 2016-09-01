printf '%x\n' "$(cksum $1 | awk '{print $1}')"
