KB
========

| ERREUR | SOLUTION |
| --- | --- |
| ce service n est ni actif ni passif | Le message de retour du plugin ne doit pas depasser 4096 caracteres. |
| fatal: qmgr_move: update active/A05DB56D535 time stamps: Operation not permitted | Supprimer de Active le mail A05DB56D535 et redemarrer postfix |
| CHECK_NRPE: Error - Could not complete SSL handshake | /etc/nagios/nrpe.cfg Allowed_host |
| json_encode(): Invalid UTF-8 sequence in argument | Un des textes de retour d un services contient des caractères UTF-8 inexistants. Desactiver le service permet de re afficher la carte. |
| Hotes supprimer perssistant | Centreon > configuration > Centreon > NDO > Purge NDO |
| impossible d acquitter les pollers hors ligne | desactiver ndomod |
| Hotes supprimer toujours visible | Identifier le Poller, dans supervision parcourir la liste des collecteur un par un. Pour le Poller qui possede l hote : Purg NDO + Regenerer config |
| Ntpstat unsynchronised ntpdc -c peers : OK | mv /var/lib/ntp/drift ~ |
| Error Service description, host name, or check command is NULL | Un service ne possède plus de commande. Cela peut ce produire lors de la suppression d un modèle de service.  Il faut remettre un modèle de service sur le service. |
| Service Process-Centreon CRITICAL | (Configuration > centreon > purge NDO) Recharger conf central |
| crond: (*system*) BAD FILE MODE | Chown root.root /etc/cron.d/nagios Chmod 0644  /etc/cron.d/nagios Touch  /etc/cron.d/nagios |
| ERROR: Could not get data for XX perhaps we don t collect data this far back? | [Check System] CPUBufferSize=2h (lodctr /r) |
| NSClient - ERROR: Could not get data for  perhaps we don"t collect data this far back? | Dans le fichier NSC.ini Remplacer  "CPUBufferSize=1h" par "CPUBufferSize=3h" |
| (Return code of 127 is out of bounds - plugin may be missing) | Dans les arguments d une commande remplacer   &#039|   par   "   |
| Nagios NRPE: Unable to read output | Droits d execution chmod ug+rx /usr/local/nagios/libexec/* chown  nagios:nagios /usr/local/nagios chown nagios:nagios /usr/local/nagios/libexec  –R  Droit visudo nagios ALL=(ALL) NOPASSWD:/usr/local/nagios/libexec/* Defaults:nagios !requiretty  Desactiver SElinux cat /etc/sysconfig/selinux : SELINUX=disabled |
| CHECK_NRPE: Received 0 bytes from daemon.  Check the remote server logs for error messages. | Dans NSClient il manque l adresse IP dans les allow_hosts |
| warning: LI_ALARM bit is set NTP CRITICAL: Server not synchronized | server 1.1.1.1 true restrict 127.0.0.1 fudge   127.127.1.0 stratum 10 driftfile /var/lib/ntp/drift keys /etc/ntp/keys tinker panic 0 |
| UNKNOWN: No handler for that command | La commande n est pas defini dans le fichier NSC.ini |
| Host 2731 unknown ! centAcl.log | http://1.1.1.1/centreon/main.php?p=60101&o=c&host_id=2731 remplir les champs manquants pour creer l hote, ensuite le desactiver |
| (Return code of 255 is out of bounds) | Le plugin retourne avec le exit code 255 Problème de fonctionnement interne au plugin. Par ex. libraire absente. |
| Plus de mise a jour des donnees | SI dans /var/log/syslog ou /var/log/messages : "Dropping packet with future timestamp" Le host n est plus a l heure. Problème NTP. |
| Dans /var/log/maillog Host or domain name not found. Name service error for  | Postfix cherche à resoudre le nom via le DNS sans passer par le systeme. Ajouter "disable_dns_lookups = yes" dans /etc/postfix/main.cf |
| NTP Unable to check time (command error)  The following error occurred: No such service is known. The service cannot be found in the specified name space. (0x8007277C) | Une variable "ressource" n est pas defini pour le poller. ($USER14$)  |
| Error: Could not open CGI config file  /usr/local/nagios/etc/cgi.cfg  for reading! | Centreon > configuration > moteur de config > cgi Aucun CGI n est configurer pour l instance du poller. Ouvrir le CGI et dans instance choisir le poller. |
| Confiugration > Centreon Tous les pollers sont en jaune (colonne Dernière mise à jour) | Le nombre maximum de session mysql est atteint (?) Ssh 1.1.1.1 > ssh 1.1.1.1 /etc/init.d/mysqld restart |
| Confiugration > Centreon Un poller en "jaune" | Le poller ne communique plus avec le central - ping sur le poller, si OK connexion en SSH dessus - verifier ping vers le central ping poller-maitre - verifier communication reseau nc -zv poller-maitre 5668 (puis les ports 21, 25) - SI port ferme, traceroute  :   traceroute -T -n -m 10 -w 2 -p 5666  poller-maitre La dernier IP qui apparait est le parfeu qui bloque ! |
| Centstorage Don t have righs on file  /usr/local/nagios/var/service-perfdata_2.bckp  (or the directory) | chown centreon.centreon /usr/local/nagios/var/service-perfdata_* |
| Absense d eventlog dans Centreon + fichier qui s acumule dans nagioslog | chmod 777 -R /var/lib/centreon/log/* |
| Sauvegarde d un hôte ne fonctionne pas | Supprime la macro HOST_ID + remplir tous les champs obligatoires |
| Impossible d obtenir l information depuis le serveur | Dans NSClient il manque l adresse IP dans les allow_hosts (pour [NSClient] 12489) |
| centstorage est mort mais le fichier pid existe | rm /var/run/centreon/centstorage.pid rm /usr/local/nagios/var/service-perfdata_*.bckp |
| Nombre de session NDO augmente Hote POLLER_CENTRAL Service ndo2db | Un poller se reconnecte regulièrement (nouvelle session tcp/NDO), sans fermer les anciennes. Un par feu reset les sessions.  Identifier le par feu et le redemarrer. |
| unsynchronised, polling server every 64 s | Poller sur ESX qui ne synchronise pas en NTP A la fin de ntp.conf ajouter :  tinker panic 0 |
| Service description, host name, or check command is NULL | Cause possible : Un des services n’a pas de commande defini |
| 0 data packet(s) sent to host successfully | Send_nsca : Problème avec le delimiteur (option –d) |
| The command (cscript.exe) returned an invalid return code 255 | Code sortie aleatoirement en erreur. Desactive le scan antivirus des scripts. |
| The Windows PowerShell snap-in  VeeamPSSnapin  is not installed on this computer | Le snap-in est installe pour powershell.exe x64. Desinstaller NSClient++, installer une version x64. |
| Error while loading xml configuration. | Le fichier XML n’existe pas. Verifier le nom dans nsci.ici. |
| Censtorage option is  0 . Don t have to start (centstorage.log) | Dans la base de donnee Centreon, table options, modifier centstorage à 1. (Toutes modifications d’options centreon met centstorage à 0) |
| only one usage of each socket adress is normally permitted socket did not start propoerly, we will now do nothing | Redemarrer la machine. Lors de l’arrêt de NSClient le port n’a pas ete libere. Il faut redemarrer la machine pour pouvoir a nouveau ouvrir une socket sur le port. |
| Could not open the 1 event log: 1717: Interface inconnue. Windows n a pas pu demarrer le service Journal d evènements Window. Erreur 5 : Accès refuse | modifier les droits sur le dossier C:\Windows\System32\winevt\Logs Proprietes > securite > modifier... > Ajouter... > Avance > Rechercher > choisir "eventlog" ou "service" > OK > cocher tous les droits dans Autoriser (http://support.microsoft.com/kb/971256) |
