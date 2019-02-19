# docker-rsync-ssh-alpine

This container allows rsync over ssh with public key usage. This is mainly a tool for myself, but maybe you need it too.

## example with public key and passphrase
1. Set your key passphrase `-e KEY_PASSPHRASE=YourKeyPassword`
2. Set valid known_hosts entry `-e KNOWN_HOSTS="sub.domain.com,123.45.67.8 exdsa-sha2-xxx ..."`
3. Mount your private key file `-v /home/user/backup/backup.priv:/root/key:ro` 
4. Mount data you want to sync `-v /home/user/backup/data:/home/data:ro`
5. Define rsync command `rsync -altDv --delete -e 'ssh -i /root/.ssh/id_rsa' "/home/data" sub.domain.com:/data`

```
docker run -ti --rm --name backup \
 -e KEY_PASSPHRASE=YourKeyPassword -e KNOWN_HOSTS="sub.domain.com,123.45.67.8 exdsa-sha2-nistp256 ..." \
 -v /home/user/backup/backup.priv:/root/key:ro \
 -v /home/user/backup/data:/home/data:ro \
 jusito/rsync-ssh \
 rsync -altDv --delete -e 'ssh -i /root/.ssh/id_rsa' "/home/data" sub.domain.com:/data
```
 
## Enironment variables
|Name|Default|Description|
|-|-|-|
|KNOWN\_HOSTS||sets .ssh/known\_hosts.|
|KEY_FILE|/root/key|Location where you can mount your key. You can change it if bind mount is disabled|
|KEY\_TARGET|/root/.ssh/id\_rsa|Don't change please. Key is copied to this location.|
|KNOWN\_HOSTS\_FILE|/root/.ssh/known\_hosts|Don't change please, location for known hosts|
|KEY\_PASSPHRASE||Can't be empty, passphrase for KEY\_FILE|

## KEY_PASSPHRASE security
Passwords in environment variable and in particular in run is insecure. You should use at least --env-file. Keep in mind, if this key is compro
