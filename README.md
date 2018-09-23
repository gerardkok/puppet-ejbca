
# ejbca

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with ejbca](#setup)
    * [What ejbca affects](#what-ejbca-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ejbca](#beginning-with-ejbca)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Description

This module installs. configures, and (partly) manages an [EJBCA](https://www.ejbca.org/) installation. EJBCA is an open-source Certificate Authority.

The module manages both the installation and configuration EJBCA, and provides a custom type that allows for managing end entities, using the SOAP API.

## Setup

### What ejbca affects

EJBCA runs on a JEE5 compliant Java application server (see https://www.ejbca.org/docs/Application_Servers.html). This module uses the [biemond/wildfly](https://forge.puppet.com/biemond/wildfly) module, which means that the choice is limited to JBoss or Wildfly.

EJBCA stores its data in a database (see the file `conf/database.properties.sample` from the distribution for a list). To simplify configuration of the database driver in the application server, this module can handle installation and configuration of the database service, but then the choice is limited to 'H2' (the EJBCA default), 'MariaDB', 'MySQL' or 'PostgresQL'. You can choose to use a different database, or manage the database yourself.

### Setup Requirements

Previous versions of EJBCA required an instance with 2 CPUs. I can't find that requirement anymore, so I'm not sure it still holds. However, if you're having trouble installing EJBCA using this module, consider trying installing it on a bigger instances, with (at least) 2 CPUs.

### Beginning with ejbca

Minimal usage:
```puppet
include ejbca
```

This installs the current open-source version of EJBCA with the default configuration:
* database: H2
* organization: 'EJBCA Sample'
* country: 'SE'

## Usage

If you don't want this module to manage the database, set `manage_database` to false.

## Reference

See [REFERENCE](REFERENCE.md).

## Limitations

In general, if you want to change a setting, it's best to start over entirely. Also, this module does not support automatic upgrading from one database to another, or from one application server to another, or to a newer version of EJBCA.

This module had only been tested on Ubuntu 16.04 and 18.04.
