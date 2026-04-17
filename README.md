# SwKey
A simple tool to replace and automatically backup your `~/.ssh/` keys and `~/.gitconfig` with new configurations.

### Requirements
- perl

### Installation
```bash
git clone https://github.com/Blziko/swkey
chmod +x swkey/swkey.pl
sudo ln -sf $HOME/swkey/swkey.pl /usr/bin/swkey
```

### Usage
```bash
swkey --key=/myssh/key/path/ --gitconfig=/myconfig/path/ --type=ed25519
```