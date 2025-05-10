# Experts Live NL 2025

## Summary rules

```bash
sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/syslog-to-aux.conf
```

```bash
cd /home/logstashadmin/go/pkg/mod/github.com/kfortney/fakelogit@v0.0.5 && go run main.go syslog --source fidelis --server 0.0.0.0:514 --count 100
```

```bash
cd /home/logstashadmin/go/pkg/mod/github.com/kfortney/fakelogit@v0.0.5 && go run main.go print --source fidelis --count 5
```


```bash
# Same SOURCE - 173.71.181.15
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<121>ay 02 13:22:01 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|2| act=alert cn1=0 cn1Label=compression cn2=3567 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=catharinebahringer@gerlach.net cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=443 dst=173.71.181.15 duser=timmyskiles@kiehn.name dvc=192.168.1.1 dvchost=fid-sensor fileHash=tBXJTsgvTpXzTRbLF5s39PGTNZrAVqng fname=random_file_4635336214.pdf msg=FakeLog: Alert signature for testing proto=SMTP reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (X11; Linux i686) AppleWebKit/5330 (KHTML, like Gecko) Chrome/40.0.827.0 Mobile Safari/5330 requestMethod=<n/a> rt=May 02 13:22:01 sev=1 spt=32528 src=255.15.145.69 suser=alibreitenberg@beatty.io target=SMTP:<mattvolkman@daugherty.io> url=http://www.investore-business.com/leading-edge/aggregate"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<16>May 02 13:22:02 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|3| act=alert cn1=0 cn1Label=compression cn2=1875 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=aftonconsidine@zulauf.io cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=25 dst=173.71.181.15 duser=martinadaniel@leffler.com dvc=192.168.1.1 dvchost=fid-sensor fileHash=rAwxGCcgfr2vUgUcKUC5wUZZvKA4Ewzs fname=random_file_2751306064.pdf msg=FakeLog: Alert signature for testing proto=SMTP reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (X11; Linux i686) AppleWebKit/5351 (KHTML, like Gecko) Chrome/36.0.851.0 Mobile Safari/5351 requestMethod=<n/a> rt=May 02 13:22:02 sev=4 spt=32528 src=221.163.129.65 suser=enriquekoelpin@kunde.io target=SMTP:<mackenziebailey@white.io> url=<n/a>"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<144>May 02 13:22:03 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|1| act=alert cn1=0 cn1Label=compression cn2=3168 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=vivienschaefer@stracke.io cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=443 dst=173.71.181.15 duser=allenehackett@wisozk.info dvc=192.168.1.1 dvchost=fid-sensor fileHash=U2ZLbX2fC67e3FinJbVVP5N6U6HWbwYx fname=random_file_9545258290.pdf msg=FakeLog: Alert signature for testing proto=WEB reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (Windows 95) AppleWebKit/5321 (KHTML, like Gecko) Chrome/37.0.880.0 Mobile Safari/5321 requestMethod=<n/a> rt=May 02 13:22:03 sev=2 spt=32528 src=238.69.141.126 suser=stephaniesenger@quitzon.org target=SMTP:<fernmarquardt@deckow.org> url=<n/a>"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<58>May 02 13:22:04 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|1| act=alert cn1=0 cn1Label=compression cn2=1653 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=miguelweber@reynolds.info cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=80 dst=173.71.181.15 duser=hoytfunk@mohr.org dvc=192.168.1.1 dvchost=fid-sensor fileHash=GeNtQFCumPHrCGXm3QqE8JdT26d5hf9f fname=random_file_1817210862.pdf msg=FakeLog: Alert signature for testing proto=WEB reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (Windows CE) AppleWebKit/5332 (KHTML, like Gecko) Chrome/38.0.881.0 Mobile Safari/5332 requestMethod=GET rt=May 02 13:22:04 sev=3 spt=32528 src=79.189.252.254 suser=macibernier@hayes.info target=SMTP:<zoeyhermiston@krajcik.biz> url=https://www.leadworld-class.name/rich/sticky/robust/productize"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<121>May 02 13:22:05 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|1| act=alert cn1=0 cn1Label=compression cn2=3954 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=terrellschneider@bode.biz cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=80 dst=173.71.181.15 duser=patrickmcdermott@williamson.org dvc=192.168.1.1 dvchost=fid-sensor fileHash=uibgz3vBShst52mdCHwPtFPmnLjmsjwS fname=random_file_8400254892.pdf msg=FakeLog: Alert signature for testing proto=WEB reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (Windows NT 5.01) AppleWebKit/5350 (KHTML, like Gecko) Chrome/37.0.895.0 Mobile Safari/5350 requestMethod=GET rt=May 02 13:22:05 sev=1 spt=32528 src=225.136.158.33 suser=carafahey@shields.com target=SMTP:<casimirbins@wolf.com> url=https://www.internalone-to-one.info/synergies/dynamic"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<122>May 02 13:22:06 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|3| act=alert cn1=0 cn1Label=compression cn2=3173 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=fosterratke@zemlak.io cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=80 dst=173.71.181.15 duser=gilbertkling@schulist.com dvc=192.168.1.1 dvchost=fid-sensor fileHash=hQG6YHeDfvNxr25TgcnyKXhYmLDgjFYL fname=random_file_8159540373.pdf msg=FakeLog: Alert signature for testing proto=SMTP reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (Windows 95) AppleWebKit/5332 (KHTML, like Gecko) Chrome/36.0.866.0 Mobile Safari/5332 requestMethod=POST rt=May 02 13:22:06 sev=3 spt=32528 src=107.195.141.182 suser=winfielddaniel@hoeger.info target=SMTP:<zionmcdermott@shields.io> url=https://www.investorinnovate.com/embrace/magnetic"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<146>May 02 13:22:07 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|1| act=alert cn1=0 cn1Label=compression cn2=2965 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=jackmuller@monahan.net cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=443 dst=173.71.181.15 duser=briannemiller@friesen.info dvc=192.168.1.1 dvchost=fid-sensor fileHash=Nry7pLxB8u5nTX2aSFnLQrgQWeLuvPCG fname=random_file_6305513101.pdf msg=FakeLog: Alert signature for testing proto=WEB reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (Windows NT 5.2) AppleWebKit/5340 (KHTML, like Gecko) Chrome/37.0.858.0 Mobile Safari/5340 requestMethod=<n/a> rt=May 02 13:22:07 sev=3 spt=32528 src=23.119.152.101 suser=ettiegoldner@sipes.name target=SMTP:<edmundstanton@boehm.name> url=http://www.directsynergies.org/scale"
# Same DESTINATION - 54.255.218.11
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<31>May 02 13:22:08 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|1| act=alert cn1=0 cn1Label=compression cn2=2605 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=catalinamoore@trantow.com cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=443 dst=4.186.80.222 duser=hailiebailey@hermiston.biz dvc=192.168.1.1 dvchost=fid-sensor fileHash=fVNPtKLqv97qytrZqrmiXY8TXncvvbi3 fname=random_file_2012904861.pdf msg=FakeLog: Alert signature for testing proto=SMTP reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/5310 (KHTML, like Gecko) Chrome/39.0.878.0 Mobile Safari/5310 requestMethod=GET rt=May 02 13:22:08 sev=2 spt=32528 src=54.255.218.11 suser=osvaldocremin@graham.org target=SMTP:<sophieborer@fahey.org> url=https://www.forwardseamless.com/iterate"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<111>May 02 13:22:09 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|3| act=alert cn1=0 cn1Label=compression cn2=3933 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=dallasweimann@hegmann.name cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=443 dst=237.213.114.176 duser=kalifeest@bednar.io dvc=192.168.1.1 dvchost=fid-sensor fileHash=A4zpSM3FqrjLeMfHDJqy5eLP4FFiNuMu fname=random_file_7692351802.pdf msg=FakeLog: Alert signature for testing proto=SMTP reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_7_1) AppleWebKit/5312 (KHTML, like Gecko) Chrome/39.0.810.0 Mobile Safari/5312 requestMethod=<n/a> rt=May 02 13:22:09 sev=3 spt=32528 src=54.255.218.11 suser=cristalcronin@lang.biz target=SMTP:<rosalynpfeffer@friesen.com> url=<n/a>"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<3>May 02 13:22:10 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|4| act=alert cn1=0 cn1Label=compression cn2=2156 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=jillianlangworth@ferry.info cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=25 dst=126.105.157.9 duser=tanyaratke@zulauf.info dvc=192.168.1.1 dvchost=fid-sensor fileHash=N5w24mjJeVhaN3svcHbe4H6pWLMK5FKp fname=random_file_1427924423.pdf msg=FakeLog: Alert signature for testing proto=WEB reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_9) AppleWebKit/5352 (KHTML, like Gecko) Chrome/38.0.815.0 Mobile Safari/5352 requestMethod=GET rt=May 02 13:22:10 sev=3 spt=32528 src=54.255.218.11 suser=georgiannaokuneva@conn.io target=SMTP:<halleokuneva@gislason.net> url=<n/a>"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<169>May 02 13:22:11 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|1| act=alert cn1=0 cn1Label=compression cn2=2772 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=jimmielangworth@nader.net cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=25 dst=15.31.151.86 duser=danialcorkery@rolfson.com dvc=192.168.1.1 dvchost=fid-sensor fileHash=srg7QmG3pRF57XbA5Qjkyi5m4NfRGmys fname=random_file_7628614029.pdf msg=FakeLog: Alert signature for testing proto=WEB reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (Windows 98; Win 9x 4.90) AppleWebKit/5321 (KHTML, like Gecko) Chrome/36.0.880.0 Mobile Safari/5321 requestMethod=POST rt=May 02 13:22:11 sev=4 spt=32528 src=54.255.218.11 suser=trishawiza@kautzer.com target=SMTP:<deliarunte@maggio.name> url=<n/a>"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<177>May 02 13:22:12 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|3| act=alert cn1=0 cn1Label=compression cn2=2105 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=vanfriesen@barrows.com cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=443 dst=164.218.46.6 duser=maxiewelch@carroll.com dvc=192.168.1.1 dvchost=fid-sensor fileHash=JMBurbehz2YRaC9Vd5u9UeKHGBQ66Xt9 fname=random_file_7070443543.pdf msg=FakeLog: Alert signature for testing proto=WEB reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (X11; Linux i686) AppleWebKit/5340 (KHTML, like Gecko) Chrome/38.0.803.0 Mobile Safari/5340 requestMethod=POST rt=May 02 13:22:12 sev=3 spt=32528 src=54.255.218.11 suser=reidbergnaum@funk.info target=SMTP:<marciabins@bashirian.net> url=<n/a>"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<19>May 02 13:22:13 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|4| act=alert cn1=0 cn1Label=compression cn2=3771 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=rylanmurray@stracke.org cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=25 dst=87.192.48.252 duser=delbertwilkinson@ullrich.com dvc=192.168.1.1 dvchost=fid-sensor fileHash=iWPRgSGz36kyPB2AxB47Abq7X7pMr7Tr fname=random_file_6173580477.pdf msg=FakeLog: Alert signature for testing proto=WEB reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/5352 (KHTML, like Gecko) Chrome/40.0.843.0 Mobile Safari/5352 requestMethod=POST rt=May 02 13:22:13 sev=2 spt=32528 src=54.255.218.11 suser=gildahowe@kirlin.biz target=SMTP:<maxwellcrona@funk.name> url=<n/a>"
logger -P 514 -n 127.0.0.1 --rfc3164 -t CEF "<103>May 02 13:22:14 fid-mgr CEF:0|Fidelis Cybersecurity|Direct|9.9|DLP Signature ID|DLP Signature Name|4| act=alert cn1=0 cn1Label=compression cn2=2419 cn2Label=vlan_id cs1=Customer DLP Policy cs1Label=policy cs2=https://fid-mgr/j/alert.html cs2Label=linkback cs3=<n/a> cs3Label=malware_name cs4=yesseniamacejkovic@bernier.biz cs4Label=from cs5=<n/a> cs5Label=malware_type cs6=Customer Management Group cs6Label=group dpt=80 dst=230.123.158.212 duser=greysoncollier@champlin.net dvc=192.168.1.1 dvchost=fid-sensor fileHash=tyJf3z3CQA9KzmHMiUSyfx3fi3yxrWPS fname=random_file_2685058324.pdf msg=FakeLog: Alert signature for testing proto=WEB reason=[{'F.PII'}] requestClientApplication=Mozilla/5.0 (Windows 98) AppleWebKit/5351 (KHTML, like Gecko) Chrome/39.0.885.0 Mobile Safari/5351 requestMethod=<n/a> rt=May 02 13:22:14 sev=2 spt=32528 src=54.255.218.11 suser=ethylrippin@ruecker.name target=SMTP:<bentonharvey@rowe.biz> url=<n/a>"
```

### Lookup Fidelis destination IPs in ThreatIntelligenceIndicator

Thus summary will try and match Fidelis destination IPs with TI indicators

Sum_FidelisTIMatches_CL

```kql
CommonSecurityLog_CL
| extend sourceAddress = tostring(parse_json(Message).source.ip), destinationAddress = tostring(parse_json(Message).destination.ip), destinationPort = tostring(parse_json(Message).destination.port)
| where isnotempty(sourceAddress) or isnotempty(destinationAddress)
| summarize LastSeen = arg_max(TimeGenerated, *), FirstSeen= arg_min(TimeGenerated, *), Count=count() by sourceAddress, destinationAddress
| project Vendor=tostring(parse_json(Message).observer.vendor), Hostname=tostring(parse_json(Message).observer.hostname), sourceAddress, destinationAddress, destinationPort, Count, FirstSeen, LastSeen, User=tostring(parse_json(Message).source.user.name), Agent=tostring(parse_json(Message).user_agent.original)
| lookup kind=inner (ThreatIntelligenceIndicator | where Active == true ) on $left.destinationAddress == $right.NetworkIP
```

#### Sample indicators

destinationAddress
78.98.220.92
5.248.255.44
56.76.102.169
153.55.174.196
76.137.173.39
137.20.179.79
189.122.190.237
21.42.7.16
211.196.9.14
209.135.204.103

### Collect Fidelis source and destination IPs

This summary will collect all source and destination IPs from traffic logs for further matching with TI feeds.

Sum_FidelisIpAddresses_CL

```kql
CommonSecurityLog_CL
| extend sourceAddress = tostring(parse_json(Message).source.ip), destinationAddress = tostring(parse_json(Message).destination.ip), destinationPort = tostring(parse_json(Message).destination.port)
| where isnotempty(sourceAddress) or isnotempty(destinationAddress)
| summarize LastSeen = arg_max(TimeGenerated, *), FirstSeen= arg_min(TimeGenerated, *), Count=count() by sourceAddress, destinationAddress
| project Vendor=tostring(parse_json(Message).observer.vendor), Hostname=tostring(parse_json(Message).observer.hostname), sourceAddress, destinationAddress, destinationPort, Count, FirstSeen, LastSeen, User=tostring(parse_json(Message).source.user.name), Agent=tostring(parse_json(Message).user_agent.original)
```

## Analytic rules

### Fidelis destination IP was matched with TI Indicator

This detection triggers whenever a Summary rule matching TI indicators on Fidelis traffic found a match

## Demo commands

### Run logstash

sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/syslog-to-aux.conf

### Run fakelogit

cd /home/logstashadmin/go/pkg/mod/github.com/kfortney/fakelogit@v0.0.5 && go run main.go syslog --source fidelis --server 0.0.0.0:514 --count 100

https://github.com/kfortney/fakelogit
