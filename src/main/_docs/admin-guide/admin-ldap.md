---
tag: [ "codenvy" ]
title: LDAP Integration
excerpt: ""
layout: docs
permalink: /:categories/ldap/
---
{% include base.html %}


The Codenvy LDAP integration has two major roles: synchronization and authentication.

Codenvy is compatible with `InetOrgPerson.schema`. For other schemas please contact us at info@codenvy.com. We support user authentication, LDAP connections, SSL, SASL, and various synchronization strategies.

For a user to successfully login, they must first be synchronized with Codenvy. Only after syncing is authorization possible:

Synchronization

* Synchronizer gets all users based on the configured groups/filters.
* Synchronizer creates a Codenvy User and persists the necessary fields from LDAP into the Codenvy database (passwords are not persisted).
* Each time the synchronizer runs the groups/filters are re-evaluated: Users that no longer match the group/filters are removed; Users that match are updated or added as needed.

Authentication

* When a user enters their name and password, the system authenticates them against the remote LDAP.
* If authentication is successful the user gains access to Codenvy.

# LDAP Authentication
User authentication is implemented as follows:

1. Search for for user DN according to the provided name. It can be performed in two ways: either by
   a given DN format, or based on a user search query.
2. To verify the user's password two functions can be used: `ldap bind` or `ldap compare`.
3. If username and password match, the LDAP entry is taken and transformed to obtain UserID (this is where synchronization configuration mechanism is applied).
4. Checks if the user with a given ID already exists in the Codenvy database. If it doesn't user is authenticated.

| Authentication Type | DN Resolution | Password Check | Entry Resolver | Mandatory Properties |
|--- |--- |--- |--- |--- 
| AD | Format | Bind | User filter search | `ldap.auth.dn_format`
| AUTHENTICATED | Search | Bind or Compare if `ldap.auth.user_password_attribute` is set | User filter search | `ldap.auth.user.filter`
| ANONYMOUS | Search | Bind or Compare if `ldap.auth.user_password_attribute` is set | User filter search | `ldap.auth.user.filter`
| DIRECT | Format | Bind | DN format search | `ldap.auth.dn_format`
| SASL | Search | Bind | User filter search | `ldap.auth.user.filter`

## Configuration
There are several types of configuration covered in the tables below:

- Authentication configuration
- Connection configuration
- SSL configuration
- SASL configuration

### Authentication Configuration

| Configuration Item   | Description   
| --- | ---
| `ldap.auth.authentication_type` | Type of authentication to use:  <br/><br/>AD - Active Directory. Users authenticate with `sAMAccountName`. Requires the `ldap.auth.dn_format` property to be correctly configured. <br/><br/> AUTHENTICATED - Authenticated Search.  Manager bind/search followed by user simple bind. Properties:<br/>- `ldap.base_dn`<br/>- `ldap.auth.subtree_search`<br/>- `dap.auth.allow_multiple_dns`<br/>- `ldap.auth.user.filter`<br/>- `ldap.auth.user_password_attribute`<br/><br/> ANONYMOUS -  Anonymous search followed by user simple bind. Properties:<br/>- `ldap.base_dn`<br/>- `ldap.auth.subtree_search`<br/>- `dap.auth.allow_multiple_dns`<br/>- `ldap.auth.user.filter`<br/>- `ldap.auth.user_password_attribute` <br/><br/> DIRECT -  Direct Bind. Compute user DN from format string and perform simple bind. Requires `ldap.base_dn` property to be correctly configured.<br/><br/>SASL - SASL bind search. Properties: <br/>- `ldap.base_dn`<br/>- `ldap.auth.subtree_search`<br/>- `ldap.auth.allow_multiple_dns`<br/>- `ldap.auth.user.filter`   
| `ldap.auth.dn_format` | Resolves an entry DN by using `String#format`. This resolver is typically used when an entry DN can be formatted directly from the user identifier. For instance, entry DNs of the form  `uid=dfisher,ou=people,dc=ldaptive,dc=org` could be formatted from `uid=%s,ou=people,dc=ldaptive,dc=org`. <br/><br/>Example:  <br/>-`CN=%1$s,CN=Users,DC=ad,DC=codenvy-dev,DC=com`<br/><br/>Parameters:<br/>- First parameter - user name provided for password validation.   
| `ldap.auth.subtree_search`   | Indicates whether subtree search will be used (boolean). When set to true, allows to search authenticating DN out of the `base_dn` tree.   
| `ldap.auth.allow_multiple_dns`   | Indicates whether DN resolution should fail if multiple DNs are found (boolean). When false, exception will be thrown if multiple DNs is found during search. When true, the first entry will be used for authentication attempt.   
| `ldap.auth.user.filter`   |  Defines the [LDAP search filter](https://docs.oracle.com/cd/E19693-01/819-0997/gdxpo/index.html) parameters applied during search for the user (string).<br><br>It must contain an `{user}` variable and, unlike similar property from synchronization, cannot contain wildcard ('*') values (because it is supposed to search for single entity).<br><br>Examples:<br> - OpenLDAP: `cn={user}`<br> - ActiveDirectory: `(&(objectCategory=Person)(sAMAccountName={user}))`<br><br>Variables:<br>- user - user name provided for password validation.   
| `ldap.auth.user_password_attribute`   | Defines the LDAP attribute name, which value will be interpreted as the password during authentication (string).   

### Connection Configuration

| Configuration Item   | Description   
| --- | ---
| `ldap.url` | URL of the directory server (URL).<br/><br/>Example: `ldap://codenvy.com:389`   |    
| `ldap.connection.connect_timeout_ms`   | Time to wait for a connection to be established (milliseconds).<br/><br/>Example: `30000`   
| `ldap.connection.response_timeout_ms`  | Restricts all the connection to wait for a response not more than specified value (milliseconds).<br/><br/>Example: `60000`  
| `ldap.connection.pool.min_size`  | Size of minimum available connections in the pool (integer).<br/><br/>Example: `3`   
| `ldap.connection.pool.max_size`  | Size of maximum available connections in<br/>the pool (integer).<br/><br/>Example: `10`
| `ldap.connection.pool.validate.on_checkout`   | Indicates whether connections will be validated before being picked from the pool (boolean). Connections that fail validation are evicted from the pool.   
| `ldap.connection.pool.validate.on_checkin`   | Indicates whether connections will be validated before being returned to the pool (boolean). Connections that fail validation are evicted from the pool.   
| `ldap.connection.pool.validate.periodically`   | Indicates whether connections should be validated periodically when the pool is idle (boolean). Connections that fail validation are evicted from the pool.   
| `ldap.connection.pool.validate.period_ms`   | Period at which pool should be validated (milliseconds). Default value is 30 min.   
| `ldap.connection.pool.idle_ms`   | Time at which a connection should be considered idle and become a candidate for removal from the pool (milliseconds).   
| `ldap.connection.pool.prune_ms`   | Period between connection pool prunes - when idle connections are removed (milliseconds).   
| `ldap.connection.pool.fail_fast`   | Indicates whether an exception should be thrown during pool initialization when the pool does not contain at least one connection and it's minimum size is greater than zero (boolean).
| `ldap.connection.pool.block_wait_ms`   | Time during which a pool which has reached maximum size will block new requests - during this time a `BlockingTimeoutException` will be thrown (milliseconds). Default time is `infinite`.
| `ldap.connection.bind.dn`  | Since connections are initialized by performing a bind operation, this property indicates the DN to make this bind with (string).<br><br>Example: `userX`<br><br>On Active Directory, a special mode called [FastBind](https://msdn.microsoft.com/en-us/library/cc223503) can be activated by setting both `ldap.connection.bind.dn` and `ldap.connection.bind.password` to a value of "*". In this mode, no group evaluation is done, so it can be used only to verify a client's credentials.
| `ldap.connection.bind.password` | Credential for the initial connection bind (string).<br><br>Example: `password`<br><br>On Active Directory, a special mode called [FastBind](https://msdn.microsoft.com/en-us/library/cc223503) can be activated by setting both `ldap.connection.bind.dn` and `ldap.connection.bind.password` to a value of "*". In this mode, no group evaluation is done, so it can be used only to verify a client's credentials.

### SSL Configuration
SSL can be configured in two ways - using trust certificate or using secure keystore.

Certificates from a trusted certificate authority (CA) do not need any additional actions like manual import. It's enough to just turn SSL on.

Self-signed certificates must be imported into the Java keystore or used separately. See https://docs.oracle.com/javase/tutorial/security/toolsign/rstep2.html for keystore import instructions.

| Configuration Item   | Description   
| --- | ---
| `ldap.connection.use_ssl`   | Indicates whether the secured protocol will be used for connections (boolean).   
| `ldap.connection.use_start_tls`   | Indicates whether TLS (Transport Layer Security) should be established on connections (boolean).   
| `ldap.connection.ssl.trust_certificates`   | Path to the certificates file (string). <br><br>Example: `file:///etc/ssl/mycertificate.cer`   
| `ldap.connection.ssl.keystore.name`  | Defines name of the keystore to use (string). <br><br>Example: `file:///usr/local/jdk/jre/lib/security/mycerts`   
| `ldap.connection.ssl.keystore.password`   | Defines keystore password (string).   
| `ldap.connection.ssl.keystore.type`   | Defines keystore type (string).   

### SASL Configuration
The Simple Authentication and Security Layer (SASL) is a method for adding authentication support to connection-based protocols. To use this specification, a protocol includes a command for identifying and authenticating a user to a server and for optionally negotiating a security layer for subsequent protocol interactions.

As an example, if the client and server both uses TLS, and have trusted certificates, they may use  SASL / EXTERNAL, and for client requests the server can derive its identity from credentials provided at a lower (TLS) level.

| Configuration Item   | Description   
| --- | ---
| `ldap.connection.sasl.mechanism`   | Defines SASL mechanism. Supported values are `DIGEST_MD5`, `CRAM_MD5`, `GSSAPI` and `EXTERNAL`.<br/><br/>See [AD explanation](https://msdn.microsoft.com/en-us/library/cc223371.aspx)<br/>See [OpenLDAP explanation](http://www.openldap.org/doc/admin24/sasl.html)   
| `ldap.connection.sasl.realm`   | SASL realm value (string). <br/><br/>Example: `example.com`   
| `ldap.connection.sasl.authorization_id`   | Defines the SASL authorization ID.   
| `ldap.connection.sasl.security_strength`   | Specifies the client's preferred privacy protection strength (ciphers and key lengths used for encryption). <br/><br/>The value of this property is a comma-separated list of strength values, the order of which specifies the preference order. The three possible strength values are "low" "medium" and "high". Defaults is `high,medium,low`.   
| `ldap.connection.sasl.mutual_auth`   | SASL mutual authentication on supported mechanisms (boolean). For some applications, it is equally important that the LDAP server's identity be verified. The process by which both parties participating in the exchange authenticate each other is referred to as mutual authentication. Defaults to `false`.   
| `ldap.connection.sasl.quality_of_protection`   | Defines integrity and privacy protection of the communication channel. It is negotiated during the authentication phase of the SASL exchange.<br/><br/>Possible values are `auth` (default),`auth-inf` and `auth-conf`.   

## Authentication Configuration Examples

### DIRECT Authentication Type
This is the simplest type of authentication, it requires a configuration of 2 propeties, but it's restricted to a specific `dn` pattern.

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

For example, imagine there are 3 users (2 developers and 1 manager) and their DNs are:

```
cn=mike,ou=developers,dc=codenvy,dc=com
cn=john,ou=developers,dc=codenvy,dc=com
cn=ivan,ou=managers,dc=codenvy,dc=com
```

If you want to set up authentication for the developers use the following configuration:  

```properties
ldap.auth.authentication_type=DIRECT
ldap.auth.dn_format=cn=%s,ou=developers,cn=codenvy,dc=com
```

In the above, the value used as the login is represented as `%s` in the `ldap.auth.dn_format` property. You can also apply Java formatting features for the login but you can't authenticate all the users from the example above this way.

### AUTHENTICATED Authentication Type

With this authentication type the authenticator searches for an entry that matches corresponding filter and then performs a BIND request using found DN & entered password. This authentication type is more flexible and provides more configuration opionts for searching users.

Using the same directory structure as in the DIRECT authentication type example:

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

To allow all users (developers and managers) to login use the following configuration:

```properties
ldap.auth.authentication_type=AUTHENTICATED
ldap.auth.user.filter=(&(cn={user})(objectCategory=Person))
ldap.auth.subtree_search=true
ldap.auth.allow_multiple_dns=false
```

- `ldap.auth.user.filter` property defines how to search users in the subtree of the configured base dn, it should be used with the _{user}_ placeholder which is replaced with the entered login value.
- `ldap.auth.sutree_search` property defines the scope of the search, whether users are located directly in the configured base dn or somewhere "deeper" in the directory structure. In the example above if the subtree search property was set to _false_ authentication wouldn't work for any of users.
- `ldap.auth.allow_multiple_dns` if the filter is not strict enough, more than 1 LDAP entry may match it, this property allows or dissallows such behaviour. If it's false and more than one entity is found than authentication fails.

### Confirming Authentication is Correctly Configured
If authentication is completed successfully an INFO message is logged when the Codenvy server starts up:

```
[INFO ] [o.ldaptive.auth.Authenticator 266] - Authentication succeeded 
for dn: cn=Yevhenii,ou=developers,dc=codenvy,dc=com
```

If you forget to set mandatory configuration options the Codenvy server will fail to start and you'll see an error message like the following:

```
Selected authentication type requires property 'ldap.base_dn' value to be not null or empty
```

If authentication is configured successfully BUT synchornization is misconfigured or hasn't finished then a warning message is logged by the Codenvy server:

```
[WARN ] [.c.a.d.a.AuthenticationDaoImpl 94] - User 'Yevhenii' is not found in the system. 
But ldap successfully completed authentication

```


# LDAP Synchronization
Once authentication is correctly setup, the synchronizer keeps users in the Codenvy database properly synchronized with LDAP. Synchronization itself is unidirectional, requiring only a READ restricted connection to the LDAP server.

## Terminology

- LDAP storage - third party directory server considered as primary users storage.
- LDAP cache - a storage in Codenvy database, which basically is a mirror of LDAP storage.
- Synchronized user - a user who is present in LDAP cache.
- Synchronization candidate - a user present in LDAP storage matching all the filters and groups, the user who is going to be synchronized.
- Codenvy User - entity in Codenvy API. A user is stored in Codenvy database (PosgreSQL).

## Synchronization Strategy
There are 2 possible strategies for synchronization:

1. Synchronization period is configured and synchronization is periodical.
2. Synchronization period is set to `-1` then synchronization is executed once per server start after the configured initial delay.

Synchronization can also be triggered by a REST API call:

```
POST <host>/api/sync/ldap
```

This won't change the execution of a periodic synchronization, but it is guaranteed that 2 parallel synchronizations won't be executed. 

- If the synchronizer can't retrieve users from LDAP storage, it fails.
- If the synchronizer can't store/update a user in LDAP cache it prints a warning with a reason and continues synchronization.
- If synchronization candidate is missing from LDAP cache, an appropriate User and Profile will be created.
- If synchronization candidate is present in LDAP cache, the User and Profile will be refreshed with data from LDAP storage(replacing the entity in the LDAP cache).
- If LDAP cache contains synchronized users who are missing from LDAP storage those users will be removed by the next synchronization iteration.


## Configuration

| Configuration Item   | Description   
| --- | ---
| `ldap.sync.period_ms` (optional)   | How often to synchronize users and profiles (milliseconds).<br/><br/>The period property must be specified in milliseconds e.g. `86400000` is daily.<br/><br/>If the synchronization should be done only when the server starts set property to `-1`.   
| `ldap.sync.initial_delay_ms`   | When to synchronize the first time (milliseconds). The delay<br/>property must be specified in milliseconds.<br/><br/>Unlike period, delay must be a non-negative<br/>integer value, if it is set to `0` then synchronization will be performed immediately<br/>on sever startup.   

### Users Selection Configuration

| Configuration Item   | Description   
| --- | ---
| `ldap.base_dn`   | The root distinguished name to search LDAP entries, serves as a base point for searching users (string).<br/><br/>Example: `dc=codenvy,dc=com`   
| `ldap.sync.user.additional_dn` (optional)   | If set will be used in addition to `ldap.base_dn` for searching users (string).<br/><br/>Example: `ou=CodenvyUsers`   
| `ldap.sync.user.filter`   | The filter used to search users, only those users<br/>who match the filter will be synchronized (string).<br/><br/>Example: `(objectClass=inetOrgPerson)`   
| `ldap.sync.page.size` (optional)   | Number of LDAP entries per-page,<br/>if set to <= 0 then `1000` is used by default (integer).   
| `ldap.sync.page.read_timeout_ms` (optional)   | Time to wait for a page (milliseconds)<br/><br/>Default: `30000`   

### Group Configuration

| Configuration Item   | Description   
| --- | ---
| `ldap.sync.group.additional_dn` (optional)   | If set will be used in addition to `ldap.base_dn` for searching groups (string).<br/><br/>Example: `ou=groups`   
| `ldap.sync.group.filter` (optional)   | Filter used to search groups (string). The synchronizer will use this filter to find all the groups and then<br/>`ldap.sync.group.attr.members` attribute for retrieving DNs of those users who should be synchronized, please note that if this parameter is set then `ldap.sync.group.attr.members` must be also set.<br/><br/>All the users who are members of found groups will be filtered by `ldap.sync.user.filter`.<br/><br/>Example: <br/>`(&(objectClass=groupOfNames)(cn=CodenvyMembers))`   
| `ldap.sync.group.attr.members` (optional)   | The name of the attribute which identifies group members distinguished names (string). The  synchronizer considers this a multi-value attribute and values are user DNs.<br/><br/>This attribute is ignored if `ldap.sync.group.filter` is not set.<br/><br/>Example: `member`   

### Synchronized Data Configuration

| Configuration Item   | Description   
| --- | ---
| `ldap.sync.user.attr.id`   |  LDAP attribute name which defines unique mandatory user identifier, the value of this attribute will be used as Codenvy User/Profile identifier (string). <br><br> All the characters which are not in `a-zA-Z0-9-_` will be removed from user identifier during synchronization, for instance if the ID of the user is `{0-1-2-3-4-5}` he will be synchronized as a user with ID `0-1-2-3-4-5`.<br><br>Common values for this property: `cn, uid, objectGUID`.  
| `ldap.sync.user.attr.name`   | LDAP attribute name which defines unique user name, this attribute will be used as Condevy User name (string).<br/><br/>Common values for this property: `cn`.    
| `ldap.sync.profile.attrs` (optional)   | Comma-separated application-to-LDAP<br/>attribute mapping pairs. Available application attributes:<br/>- firstName<br/>- phone<br/>- lastName<br/>- employer<br/>- country<br/>- jobtitle<br/><br/>Common values for the attributes above in the described format:<br/><code>firstName=givenName,phone=telephoneNumber,<br/>lastName=sn,employer=o,country=st,jobtitle=title</code>.
| `ldap.sync.user.attr.email`   | LDAP attribute name which defines unique user email,<br/> the value of this attribute will be used as Codenvy<br/> User email. If there is no such analogue you can simply<br/> use the same attribute used for name (string).<br/><br/>Common values for this property: `mail`.   
| `ldap.sync.page.size` (optional)  | Number of LDAP entries per-page,<br/>if set to <= 0 then `1000` is used by default (integer).   
| `ldap.sync.page.read_timeout_ms` (optional)  | Time to wait for a page (milliseconds) <br/>Default: `30000`  

## Required Codenvy Fields
There are 3 required fields for a Codenvy user:

- _id_ - must be unique, cannot be updated
- _name_ - must be unique
- _email_ - must be unique

For example, in the following LDAP entry:

```
objectCategory=Person
cn=mike
sn=adams
mail=mike@codenvy.com
sAMAccountName=mike
objectGUID=00000000-0000-0000-0000-000000000000
```

The right field mapping would be:

```properties
ldap.sync.user.attr.id=objectGUID
ldap.sync.user.attr.name=cn
ldap.sync.user.attr.email=mail
```

Different directory services provide different types of attributes sets for entries so attribute mapping is unique to the directory and situation.

Frequently used attributes:
- for id: `uid`, `objectGUID`, `cn`
- for name: `cn`, `sAMAccountName`
- for email: `mail`

It's possible to use an attribute like _sAMAccountName_ for all the user fields and everything will work fine, however synchronization may produce unexpected results when conflicting updates are made in LDAP. For example, if the value of the attribute _sAMAccountName_ changed then the user with id equal to previous _sAMAccountName_ value will be removed from Codenvy database and a new user with id, name & email equal to the new attribute value will be created.

For LDAP entries that don't contain all of required attributes the Codenvy user won't be created & warn message printed. In this example an LDAP user doesn't have an email in the directory:

```
[WARN ] [c.c.ldap.sync.LdapSynchronizer 390]  - Cannot find out user's email. 
Please, check configuration `ldap.sync.user.attr.email` parameter correctness.
```

## Authenticated vs Synchronized Users

It's possible that not all authenticated users will be synchronized. There are several ways to configure the synchornizer to track 
only those users you want to access the product.

### Simple Filtering (No Explicit User Groups)
The simplest configuration is based on a single user filter which may be configured by the `ldap.sync.user.filter` property.

In this example we'll use the same directory structure used in our authentication examples:

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

If we want to synchronize the developers only (Mike and John) then the configuration should be:

```properties
ldap.base_dn=ou=developers,dc=codenvy,dc=com
ldap.sycn.user.filter=(objectCategory=Person)
```

This configurtion will synchronize all the entries from the directory _ou=developers_ that have _objectClass=Person_.

You can get the same result by setting `ldap.base_dn` to _dc=codenvy,dc=com_ and using the optional property `ldap.sync.user.additional_dn`. This will cause the syncrhonizer to search in both the base_dn and additional_dn:

```properties
ldap.base_dn=dc=codenvy,dc=com
ldap.sync.user.additional_dn=ou=developers
ldap.sycn.user.filter=(objectCategory=Person)

```

If the entries we want to be synchronized have an attribute in common we can use the synchronization filter:

```properties
ldap.base_dn=dc=codenvy,dc=com
ldap.sycn.user.filter=(&(objectCategory=Person)(memberOf=Codenvy))
```

The configuration above will synchronize 3 users(Mike, John and Brad) as all those entries match the filter. 

However, this configuration is often not flexible enough for larger directories so explicit LDAP user groups must be used.

### Users Group Configuration
User groups allow users to be managed dynamically. If you have many users but you want only some of them to use the product, user groups is the most common solution. Codenvy provides flexible configuration options for LDAP user groups. 

#### User Group Example
Imagine our company has 5 users: 2 of them are developers; 2 of them are managers; 1 is an admin. We want to synchronize the admin, one of the developers (Mike) and one of the managers (Brad).

First we should create a group for these users - let's name it `CodenvyUsers`.

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

The minimal configuration required for synchornization is:

```properties
ldap.base_dn=dc=codenvy,dc=com
ldap.sync.group.additional_dn=ou=groups
ldap.sync.group.filter=(&(objectCategory=Group)(cn=CodenvyUsers))
ldap.sync.group.attr.members=member
ldap.sync.user.filter=(objectCategory=Person)
```

This configuration tells the synchronizer to search for groups in `base_dn` + `additional_dn` that have the _Group_ object category and a _cn_ equal to _CodenvyUsers_. For all matching groups (there's only one matching in this example) the synchronizer retrieves the user dns 
using the _member_ attribute for all members whose object category is _Person_.

The `ldap.sync.group.filter` property must be set for group search to be used.

### Synchronization Timing
Synchronization is done at least once on Codenvy server startup. There are several attributes that allow admins to configure synchronization delay and period.

The delay configuration is required. If it's 0 then synchronization is performed on startup, otherwise the syncrhonizer waits for the configured duration before initializing LDAP components.

If you don't have a reason to change the interval the default value of _10000_(10 seconds) should work in most situations.

```properties
ldap.sync.init_delay_ms=10000
```

Configuring the synchronization period is not required, if it's set then synchronization is rescheduled each Nms. By default this configuration parameter is disabled (value of _-1_) which means that synchronization is performed once on startup. You may want to change the synchronization period to make sure that the Codenvy database stays updated with LDAP during the day.

```properties
# 10minutes
ldap.sync.period_ms=36000000
```

We suggest setting the sync period to a reasonable period - too frequent and the system will be frequently performing unnecessary syncs; too infrequent and new users will have to wait for a long time to get Codenvy access.

Alternatively you can set a longer sync period (perhaps 4 or 8 hours) and use the Codenvy API to manually trigger an LDAP sync when needed:

- Open the Codenvy API in your browser at `host:port/swagger`
- Call the LDAP > Sync API

### Confirming Synchronization is Correctly Configured
When correctly configured the synchronizer will print process result each time synchronization is performed, similar to the following:

```
[INFO ] [c.c.ldap.sync.LdapSynchronizer 250]  - Synchronization result: processed = '3', created = '1', 
updated = '1', removed = '1', failed = '0', up-to-date = '1', skipped = '0', fetched = '3'
```

In the above:
- _created_: Number of users created in the Codenvy database.
- _updated_: Number of users updated in the Codenvy database (usually this reflects changes in the LDAP directory itself).
- _removed_: Number of users removed from the Codenvy database.
- _failed_: Number of users where create/update/removal was not performed due to some problem. In this case an appropriate warning or error will be logged.
- _up-to-date_: Number of users that are up-to-date.
- _skipped_: Number of users that were skipped due to synchronization configuration.
- _fetched_: Number of users that were fetched from LDAP storage.
- _processed_: Number of users that were processed. Equals _created + updated + up-to-date + failed + skipped_

If the synchronizer is not configured properly the Codenvy server won't start and an error message will be printed to logs.

# Full Configuration Example
An example authentication and synchronization configuration for the users in group _CodenvyUsers_ described in the directory below:

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

LDAP configuration:

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

This will give the following three users access to Codenvy:

```
cn=mike,ou=developers,dc=codenvy,dc=com
cn=brad,ou=managers,dc=codenvy,dc=com
cn=admin,ou=admins,dc=codenvy,dc=com
```

# Active Directory Example

Properties to be configured in `/etc/puppet/manifests/nodes/codenvy/codenvy.pp`

Commented items must be changed.

```shell  
ldap.url=ldap://???? <--- Change this

ldap.base_dn=DC=ad,DC=codenvy-dev,DC=com <--- Change this
ldap.auth.user.filter=(&(objectCategory=Person)(sAMAccountName=*)) <--- Change this
ldap.auth.authentication_type=AD <--- Change this

ldap.auth.dn_format=CN=%1$s,CN=Users,DC=ad,DC=codenvy-dev,DC=com <--- Change this
ldap.auth.user_password_attribute=NULL
ldap.auth.allow_multiple_dns=false
ldap.auth.subtree_search=true

ldap.connection.provider=NULL
ldap.connection.bind.dn=CN=skryzhny,CN=Users,DC=ad,DC=codenvy-dev,DC=com <--- Change this
ldap.connection.bind.password=????? <--- Change this
ldap.connection.use_ssl=false
ldap.connection.use_start_tls=false
ldap.connection.pool.min_size=3
ldap.connection.pool.max_size=10
ldap.connection.pool.validate.on_checkout=false
ldap.connection.pool.validate.on_checkin=false
ldap.connection.pool.validate.period_ms=180000
ldap.connection.pool.validate.periodically=true
ldap.connection.pool.fail_fast=true
ldap.connection.pool.idle_ms=5000
ldap.connection.pool.prune_ms=10000
ldap.connection.pool.block_wait_ms=30000
ldap.connection.connect_timeout_ms=30000
ldap.connection.response_timeout_ms=120000

ldap.connection.ssl.trust_certificates=NULL
ldap.connection.ssl.keystore.name=NULL
ldap.connection.ssl.keystore.password=NULL
ldap.connection.ssl.keystore.type=NULL

ldap.connection.sasl.realm=NULL
ldap.connection.sasl.mechanism=NULL
ldap.connection.sasl.authorization_id=NULL
ldap.connection.sasl.security_strength=NULL
ldap.connection.sasl.mutual_auth=false
ldap.connection.sasl.quality_of_protection=NULL

ldap.sync.initial_delay_ms=10000
ldap.sync.period_ms=-1
ldap.sync.page.size=1000
ldap.sync.page.read_timeout_ms=30000
ldap.sync.user.additional_dn=NULL
ldap.sync.user.filter=(&(objectCategory=Person)(sAMAccountName=*)) <--- Change this
ldap.sync.user.attr.email=cn <--- Change this
ldap.sync.user.attr.id=objectGUID <--- Change this
ldap.sync.user.attr.name=cn <--- Change this
ldap.sync.profile.attrs=firstName=sAMAccountName <--- Change this
ldap.sync.group.additional_dn=NULL
ldap.sync.group.filter=NULL
ldap.sync.group.attr.members=NULL\
```
