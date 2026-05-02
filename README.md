# SwKey
A simple tool to replace and automatically backup your `~/.ssh/` keys and `~/.gitconfig` with new configurations.

### Requirements
- perl

### Installation
```bash
cd /opt
git clone https://github.com/Blziko/swkey
chmod +x swkey/swkey.pl
ln -sf swkey/swkey.pl /usr/bin/swkey
cd
```

### Usage
```bash
swkey --key=<ssh_key_path> --gitconfig=<gitconfig_path> --type=<type>
```