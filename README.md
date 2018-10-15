# snvtr_infra
snvtr Infra repository

Подключение к someinternalhost одной командой осуществляется через следующую конфигурацию ssh на исходной машине:

файл ~/.ssh/config:

Host 10.132.0.*
    User user
    IdentityFile ~/.ssh/id_rsa
    ProxyCommand ssh user@35.210.249.208 -W %h:%p

Где 35.210.249.208 - вирт машина в gcp в режиме bastion host 

команда для попадания на внутренний хост: ssh 10.132.0.3

---
bastion_IP = 35.210.249.208
someinternalhost_IP = 10.132.0.3
