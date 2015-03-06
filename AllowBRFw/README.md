# AllowBRFw

Blocks network connections that are not allocated to Brazil

### Installation

    git clone https://github.com/lborguetti/scripts-utils.git
    cd scripts-utils/AllowBRFw
    sudo make install

### Configuration

    /opt/AllowBRFw/
    ├── etc
    │   ├── AllowBRFw.cfg
    │   ├── ports.txt
    │   └── whitelist.txt

* AllowBRFw.cfg

    Disable debug, file paths, url for update db, etc.

* ports.txt

    List of ports that are blocked

* whitelist.txt

List of networks and hosts that are allowed

### Usage

    /opt/AllowBRFw/bin/AllowBRFw.sh <start|stop|restart|update>

    start   - drop conections for don't BR networks
    stop    - stop /opt/AllowBRFw/bin/AllowBRFw.sh
    update  - update delegated lacnic BR networks 

    * Example:
    /opt/AllowBRFw/bin/AllowBRFw.sh start
