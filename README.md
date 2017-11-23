# sakura_vps_init_config

さくらVPSの初期設定用のカスタムスクリプトを生成し、クリップボードにコピー(pbcopyは標準入力をクリップボードにコピーするMacのコマンド)。
my_secret_passwordは初期設定時に作られるadminのパスワードになります。インストールするOSはCentOS 6を選んでください。

```bash
$ ssh-keygen -t rsa
Enter file in which to save the key (/path/to/.ssh/id_rsa): /path/to/.ssh/sakuravps
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
$ ./mkstartup.bash /path/to/.ssh/sakuravps.pub my_secret_password | pbcopy 
```
あとは、さくらVPSのカスタムスクリプトを登録し、OSのインストール時にカスタムスクリプトが走るように設定するだけです。
