# XIV PERFORMANCE
Scripts for parsing XIV Performance Statistics
## Scripts to parse output of statsitics_get command and import data into influxdb.
### How to run
Clone the repo & make sure the scripts are executeable 

```
git clone https://github.com/mcaleavya/XIV-Performance.git
cd XIV-Performance
chmod 755 xiv_host xiv_vol xiv_port xiv_hba graph_xiv_data.pl
vi the xiv_ files and enter your <username> & <password> for the storage array and your influxdb details

```

## Gather Host based performance data
```
./xiv_host <ARRAY> <DAY> <MONTH>
i.e.
./xiv_host TESTXIV 03 11
```
## Gather Volume based performance data
```
./xiv_vol <ARRAY> <DAY> <MONTH>
i.e.
./xiv_vol TESTXIV 03 11
```

## Gather Array Port performance data
```
./xiv_port <ARRAY> <DAY> <MONTH>
i.e.
./xiv_port TESTXIV 03 11
```
## Gather Host Port performance data (HBA)
```
./xiv_hba <ARRAY> <DAY> <MONTH>
i.e.
./xiv_hba TESTXIV 03 11
```
## Gather Array Overall performance data (HBA)
```
./xiv_array <ARRAY> <DAY> <MONTH>
i.e.
./xiv_array TESTXIV 03 11
```
### If using the array overall view you will need to create a influxdb named ARRAYS and also run hosts.
### Please make sure you have UDP port 8086 open to allow the data to get into influx.
### The wrapper scripts call the main perl script with a tag based on the stat i.e. Host,Hport,Vol,Port
### Grafana Views are also included
