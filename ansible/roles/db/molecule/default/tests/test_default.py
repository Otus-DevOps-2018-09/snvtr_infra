import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'

# check if MongoDB is enabled and running
def test_mongo_running_and_enabled( host ):
    mongo = host.service( "mongodb" )
    assert mongo.is_running
    assert mongo.is_enabled

# check if configuration file contains the required line
def test_config_file( File ):
    config_file = host.file ( '/etc/mongodb.conf' )
    assert config_file.contains( 'bindIp: 0.0.0.0' )
    assert config_file.is_file
    
# check if mongo is listening 
def test_mongo_listens( host, port ):
    url = "tcp://0.0.0.0:" + str( port )
    assert host.socket( url ).is_listening 

