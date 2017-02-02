---
tag: [ "codenvy" ]
title: LDAP Configuration
excerpt: ""
layout: docs
permalink: /:categories/admin-ldap-config/
---
{% include base.html %}

This page outlines how to set up LDAP synchronization and authentication with different configurations. LDAP configuration should be done by an administrator who is familiar with the setting and internals of your LDAP system.

# Authentication

## Authentication Types
Codenvy supports several types of authentication.

### Direct type

This is the simplest type of authentication, it requires a configuration of 2 propeties, but it's restricted to a certain `dn` pattern.

For the following directory structure:
```
dc=codenvy,dc=com
  ou=developers
    cn=mike:
      -objectCategory=Person
      -sAMAccountName=mike
      -cn=mike
      -userPassword=hash
    cn=john
      -objectCategory=Person
      -sAMAccountName=john
      -cn=john
      -userPassword=hash
  ou=managers
    cn=ivan:
      -objectCategory=Person
      -sAMAccountName=ivan
      -cn=ivan
      -userPassword=hash
```

**Example**: So there are 3 users, 2 developers and 1 manager, their DNs are:

```
cn=mike,ou=developers,dc=codenvy,dc=com
cn=john,ou=developers,dc=codenvy,dc=com
cn=ivan,ou=managers,dc=codenvy,dc=com
```

If you want to set up authentication for the users who 
are developers the following configuration is your choice:  

```properties
ldap.auth.authentication_type=DIRECT
ldap.auth.dn_format=cn=%s,ou=developers,cn=codenvy,dc=com
```

Basically the value used as login goes as _%s_ in `ldap.auth.dn_format` property.
Moreover it allows you to apply java formatting features on entered login,
but you can't authenticate all the users from the example above using described authentication type.

##### Authenticated type

This authentication type is more flexible and provides more configuration opionts for
searching users.

For the previous directory structure:
```
dc=codenvy,dc=com
  ou=developers
    cn=mike:
      -objectCategory=Person
      -sAMAccountName=mike
      -cn=mike
      -userPassword=hash
    cn=john
      -objectCategory=Person
      -sAMAccountName=john
      -cn=john
      -userPassword=hash
  ou=managers
    cn=ivan:
      -objectCategory=Person
      -sAMAccountName=ivan
      -cn=ivan
      -userPassword=hash
```

when all the users developers and managers should be able to login the 
following configuration is the right one:

```properties
ldap.auth.authentication_type=AUTHENTICATED
ldap.auth.user.filter=(&(cn={user})(objectCategory=Person))
ldap.auth.subtree_search=true
ldap.auth.allow_multiple_dns=false
```

- `ldap.auth.user.filter` property defines how to search users in the subtree of configured base dn, 
it should be used with _{user}_ placeholder which is replaced with entered login value.
- `ldap.auth.sutree_search` property defines the scope of the search, whether users are located 
directly in configured base dn or somewhere "deeper" in the directory structure. In the example above
if subtree search property was set to false authentication wouldn't work for any of users.
- `ldap.auth.allow_multiple_dns` if the filter is not strict enough, more than 1 LDAP entry
may match it, this property allows or dissallows such behaviour. If it's false and more than one entity found
than authentication fails.

Technically authenticator searches for an entry that matches corresponding filter and then 
performs BIND request using found DN & entered password.


#### How to know when authentication is correctly configured?

Well, first thing that may go wrong is that you missed some configuration options, then 
Codenvy server won't start and you'll see appropriate error message logged.
Example:
```
Selected authentication type requires property 'ldap.base_dn' value to be not null or empty
```

If authentication is completed successfully INFO message is logged.
Example:
```
[INFO ] [o.ldaptive.auth.Authenticator 266] - Authentication succeeded 
for dn: cn=Yevhenii,ou=developers,dc=codenvy,dc=com
```

If authentication is configured successfully BUT synchornization is 
not configured right or hasn't been performed/finished yet then warning message is logged. 
Example:
```
[WARN ] [.c.a.d.a.AuthenticationDaoImpl 94] - User 'Yevhenii' is not found in the system. 
But ldap successfully completed authentication

```

### Synchronization

While authentication allows Codenvy to login users using
directory service, synchronization creates & keeps users fresh in Codenvy
database according to data stored by the directory service. These are two separate
phrases of LDAP integration which require separate configurations.
User can start using product only when both authentication and
synchronization configured properly.

#### How ldap entries become users?

There are 3 required fields for codenvy user:

- _id_ - must be unique, not updatable
- _name_ - must be unique
- _email_ - must be unique

For the following LDAP entry:
```
objectCategory=Person
cn=mike
sn=adams
mail=mike@codenvy.com
sAMAccountName=mike
objectGUID=00000000-0000-0000-0000-000000000000
```

The right fields mapping will be:
```properties
ldap.sync.user.attr.id=objectGUID
ldap.sync.user.attr.name=cn
ldap.sync.user.attr.email=mail
```

Different directory services provide different types of attributes sets for
entries so it's up to you to choose what attributes are mapped to user fields.

Often used attributes:
- for id: _uid_, _objectGUID_, _cn_
- for name: _cn_, _sAMAccountName_
- for email: _mail_

It's also possible to use an attribute like _sAMAccountName_ for all the user
fields and everything will work fine, but then synchronization may be tricky
when conflict updates are made to LDAP entries e.g. if the value of the attribute
_sAMAccountName_ changed then the user with id equal to previous _sAMAccountName_
value will be removed from Codenvy database and a new user with id, name & email equal
to the new attribute value will be created.
So it's generally better to follow user fields contract(uniqueness & mutability)
and use appropriate LDAP attributes.

For LDAP entry that doesn't contain any of required attributes e.g. 
user email is mapped to _mail_ attribute but there is no such attribute 
provided by the entry Codenvy user won't be created & warn message printed:

```
[WARN ] [c.c.ldap.sync.LdapSynchronizer 390]  - Cannot find out user's email. 
Please, check configuration `ldap.sync.user.attr.email` parameter correctness.
```

#### Who become Codenvy users?

Authenticated users are not synchornized ones.
There are several possible ways to configure synchornizer to track 
those users whom you want to use the product.

##### Simple filtering(no explicit user groups)

The simplest configuration is based on a single user filter which 
may be configured by `ldap.sync.user.filter` property.
Let's try and configure synchronization for the following directory structure:

```
dc=codenvy,dc=com
  ou=developers
    cn=mike:
      -objectCategory=Person
      -sAMAccountName=mike
      -cn=mike
      -memberOf=Codenvy
    cn=john
      -objectCategory=Person
      -sAMAccountName=john
      -cn=john
      -memberOf=Codenvy
  ou=managers
    cn=brad:
      -objectCategory=Person
      -sAMAccountName=brad
      -cn=brad
      -memberOf=Codenvy
    cn=ivan:
      -objectCategory=Person
      -sAMAccountName=ivan
      -cn=ivan
```

If we want to synchronize developers only(mike and john) the 
next configuration will be the right one:

```properties
ldap.base_dn=ou=developers,dc=codenvy,dc=com
ldap.sycn.user.filter=(objectCategory=Person)
```

So basically it says to synchronize all the entries from the directory _ou=developers_
that have _objectClass=Person_. There is an alternative way to achive the same result
e.g. if `ldap.base_dn` is configured to _dc=codenvy,dc=com_ value then the optional 
property `ldap.sync.user.additional_dn` should be used, so the syncrhonizer will
search in base_dn + additional_dn:

```properties
ldap.base_dn=dc=codenvy,dc=com
ldap.sync.user.additional_dn=ou=developers
ldap.sycn.user.filter=(objectCategory=Person)

```

If the entries we want to be synchronized have an attribute in common 
we can reach synchronization filter and search in base dn e.g.

```properties
ldap.base_dn=dc=codenvy,dc=com
ldap.sycn.user.filter=(&(objectCategory=Person)(memberOf=Codenvy))
```

The configuration above will synchronize 3 users(mike, john, brad) as 
all those entries match the filter. 

Sometimes(really ofthen) this configuration is not flexible enough so 
ldap user groups are used.

##### Users group configuration

User groups allow to manage users dynamically.
If you have many users but you want only some of them to use the product
users group is the right and the most common solution here.

Codenvy provides flexible configuration options for LDAP user groups. 

Let's say we have 5 users 2 of them are developers 2 of them are managers 
and one is an admin. We want to synchronize 1 admin 1 developer(mike) and 1 manager(brad), 
so first what we should do is to create a group for these users let's name it CodenvyUsers.

```
dc=codenvy,dc=com
  ou=developers
    cn=mike:
      -objectCategory=Person
      -sAMAccountName=mike
      -cn=mike
    cn=john
      -objectCategory=Person
      -sAMAccountName=john
      -cn=john
      -memberOf=Codenvy
  ou=managers
    cn=brad:
      -objectCategory=Person
      -sAMAccountName=brad
      -cn=brad
    cn=ivan:
      -objectCategory=Person
      -sAMAccountName=ivan
      -cn=ivan
  ou=admins
    cn=admin
      -objectCategory=Person
      -sAMAccountName=admin
      -cn=admin
  ou=groups
    cn=CodenvyUsers
      -objectCategory=Group
      -cn=CodenvyUsers
      -member=cn=mike,ou=developers,dc=codenvy,dc=com
      -member=cn=brad,ou=managers,dc=codenvy,dc=com
      -member=cn=admin,ou=admins,dc=codenvy,dc=com
```

The minimal configuration required for synchornization described below:

```properties
ldap.base_dn=dc=codenvy,dc=com
ldap.sync.group.additional_dn=ou=groups
ldap.sync.group.filter=(&(objectCategory=Group)(cn=CodenvyUsers))
ldap.sync.group.attr.members=member
ldap.sync.user.filter=(objectCategory=Person)
```

The configuration says to search for groups in `base_dn` + `additional_dn` 
groups must have _Group_ object category and _cn_ equal to _CodenvyUsers_, 
go for each found group(the only one in the example)  and retrieve user dns 
using attribute _member_, use only those members whose object category is _Person_.

If `ldap.sync.group.filter` property is set then groups search is used.


#### When synchronization is performed?

Synchronization is done at least once on bootstrap.
There are several attributes that allow to configure synchronization delay and period.

Delay configuration is required. If it's 0 then synchronization is performed 
on boot, otherwise the syncrhonizer is waiting for configured duration until LDAP 
components are initialized and delay is reached. 
If you don't care about such low level set up just use the default value it's _10000_(10 seconds).

```properties
ldap.sync.init_delay_ms=10000
```

Synchronization period configuration is not required, if it's set then synchronization is 
rescheduled each Nms. By default this configuration parameter is disabled(value set to _-1_)
which means that synchronization is performed once on bootstrap. You may want to change 
synchronization period to make sure that Codenvy database keeps fresh users data.
Let's say you added a new user into the LDAP group and you want to allow him to 
use the product, so you have serveral options availalble:

- configure synchronization period with a value proper for you e.g.

```properties
# 10minutes
ldap.sync.period_ms=36000000
```
then the new user will be synchronized to Codenvy database in a period between now and 10minutes after

- call the API method using swagger, go to _host:port/swagger_ and then call ldap -> sync.
So synchronization is performed immediately

- restart codenvy server, this is the worst option here, but still possible, 
synchronization is performed after _ldap.sync.initial_delay_ms_.


Along with that LDAP synchronizer keeps tracking removals and updates of existing 
users unless it's not configured to do so.


#### How to know whether synchronization is successful?

If the synchronizer is not configured properly some required properties 
are missing or values are wrong then Codenvy server won't start, otherwise 
the synchronizer will print process result each time synchronization is performed.
It will be like the following:

```
[INFO ] [c.c.ldap.sync.LdapSynchronizer 250]  - Synchronization result: processed = '3', created = '1', 
updated = '1', removed = '1', failed = '0', up-to-date = '1', skipped = '0', fetched = '3'
```

- _created_ - how many users were created in Codenvy database
- _updated_ - how many users were updated in Codenvy database, which probably means that LDAP entries 
were updated as well
- _removed_ - how many users were removed from Codenvy database
- _failed_ - how many were not either created or removed, or updated due to some violation, 
an appropriate warning or error will be logged before
- _up-to-date_ - how many users are up-to-date
- _skipped_ - how many users were skipped due to synchronization configuration
- _fetched_ - how many users were fetched from LDAP storage
- _processed_ - how many users were processed it's _created + updated + up-to-date + failed + skipped_


### Configuration example

Let's configure authentication and synchronization for the users in group _CodenvyUsers_ described below:

```
dc=codenvy,dc=com
  ou=developers
    cn=mike:
      -objectClass=Person
      -sAMAccountName=mike
      -cn=mike
      -mail=mike@codenvy.com
      -objectGUID=00000000-0000-0000-0000-000000000000
    cn=john
      -objectClass=Person
      -sAMAccountName=john
      -cn=john
      -memberOf=Codenvy
      -mail=john@codenvy.com
      -objectGUID=00000000-0000-0000-0000-000000000001
  ou=managers
    cn=brad:
      -objectClass=Person
      -sAMAccountName=brad
      -cn=brad
      -mail=brad@codenvy.com
      -objectGUID=00000000-0000-0000-0000-000000000002
    cn=ivan:
      -objectClass=Person
      -sAMAccountName=ivan
      -cn=ivan
      -mail=ivan@codenvy.com
      -objectGUID=00000000-0000-0000-0000-000000000003
  ou=admins
    cn=admin
      -objectClass=Person
      -sAMAccountName=admin
      -cn=admin
      -mail=admin@codenvy.com
      -objectGUID=00000000-0000-0000-0000-000000000004
  ou=groups
    cn=CodenvyUsers
      -objectClass=Group
      -cn=CodenvyUsers
      -member=cn=mike,ou=developers,dc=codenvy,dc=com
      -member=cn=brad,ou=managers,dc=codenvy,dc=com
      -member=cn=admin,ou=admins,dc=codenvy,dc=com
```

Configuration example:
```properties

# general configuration
ldap.url=ldap://codenvy.com:389
ldap.connection.bind.dn=cn=admin,ou=admins,dc=codenvy,dc=com
ldap.connection.bind.password=admin

# common for auth & sync
ldap.base_dn=dc=codenvy,dc=com

# turn on ldap auth
auth.handler.default=ldap

# auth
ldap.auth.authentication_type=AUTHENTICATED
ldap.auth.user.filter=(&(sAMAccountName={user})(objectClass=Person))
ldap.auth.subtree_search=true
ldap.auth.allow_multiple_dns=false

# sync selection
ldap.base_dn=dc=codenvy,dc=com
ldap.sync.group.additional_dn=ou=groups
ldap.sync.group.filter=(&(objectClass=Group)(cn=CodenvyUsers))
ldap.sync.group.attr.members=member
ldap.sync.user.filter=(objectClass=Person)

# sync scheduling
ldap.sync.initial_delay_ms=10000
ldap.sync.period_ms=-1

# sync strategy
ldap.sync.remove_if_missing=true
ldap.sync.update_if_exists=true

# attributes to user mapping
ldap.sync.user.attr.id=objectGUID
ldap.sync.user.attr.name=cn
ldap.sync.user.attr.email=mail

```

So 3 users are synchronized and can use the product, they are
```
cn=mike,ou=developers,dc=codenvy,dc=com
cn=brad,ou=managers,dc=codenvy,dc=com
cn=admin,ou=admins,dc=codenvy,dc=com
```

### Getting help

If you read the doc and tried to configure Codenvy to work with your directory service
and it didn't work out, feel free to ask support about help sending us email on _info@codenvy.com_. 

Kind of data that we need to help you with configuration:

- Directory service structure. Different organizations have different structure, types, attributes
there is no single way to configure LDAP integration without clear picture of where users are located 
and what attributes they consist of.

- Server logs. Logs contain synchronization/authentication results and errors, so nothing is as useful as logs =)
