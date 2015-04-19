dataSource {
    pooled = true
    jmxExport = true
    driverClassName = "net.sourceforge.jtds.jdbc.Driver"
}
dataSource_PLVSys{
    pooled = true
    jmxExport = true
    driverClassName = "net.sourceforge.jtds.jdbc.Driver"

}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
//    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory' // Hibernate 3
    cache.region.factory_class = 'org.hibernate.cache.ehcache.EhCacheRegionFactory' // Hibernate 4
    singleSession = true // configure OSIV singleSession mode
}

// environment specific settings
environments {
    development {
        dataSource {
            username = "sa"
            password = "password0"
            dialect = org.hibernate.dialect.SQLServerDialect
            dbCreate = "create-drop" // one of 'create', 'create-drop', 'update', 'validate', ''
            url = "jdbc:jtds:sqlserver://localhost:1433/PLVFESDB_DEV"
        }
        dataSource_PLVSys {
            username = "sa"
            password = "password0"
            dialect = org.hibernate.dialect.SQLServerDialect
            url = 'jdbc:jtds:sqlserver://localhost:1433/PLV System'
//            url = 'jdbc:jtds:sqlserver://PLV-SERVER:1433/PLV System'
//            jndiName = 'java:comp/env/jdbc/plvSysConnector'
        }
    }
    test {
        dataSource {
            username = "sa"
            password = "password0"
            dbCreate = "update"
            url = "jdbc:jtds:sqlserver://localhost:1433/PLVFESDB_DEV;"
        }
        dataSource_PLVSys {
            username = "sa"
            password = "password0"
            dialect = org.hibernate.dialect.SQLServerDialect
            url = 'jdbc:jtds:sqlserver://localhost:1433/PLV System'
        }
    }
    production {
        dataSource {
            jndiName = 'java:comp/env/jdbc/plvFesConnector'
            properties {
                // See http://grails.org/doc/latest/guide/conf.html#dataSource for documentation
                jmxEnabled = true
                initialSize = 5
                maxActive = 50
                minIdle = 5
                maxIdle = 25
                maxWait = 10000
                maxAge = 10 * 60000
                timeBetweenEvictionRunsMillis = 5000
                minEvictableIdleTimeMillis = 60000
                validationQuery = "SELECT 1"
                validationQueryTimeout = 3
                validationInterval = 15000
                testOnBorrow = true
                testWhileIdle = true
                testOnReturn = false
                jdbcInterceptors = "ConnectionState"
                defaultTransactionIsolation = java.sql.Connection.TRANSACTION_READ_COMMITTED
            }
        }
        dataSource_PLVSys {
            dialect = org.hibernate.dialect.SQLServerDialect
            jndiName = 'java:comp/env/jdbc/plvSysConnector'

            properties {
                // See http://grails.org/doc/latest/guide/conf.html#dataSource for documentation
                jmxEnabled = true
                initialSize = 5
                maxActive = 50
                minIdle = 5
                maxIdle = 25
                maxWait = 10000
                maxAge = 10 * 60000
                timeBetweenEvictionRunsMillis = 5000
                minEvictableIdleTimeMillis = 60000
                validationQuery = "SELECT 1"
                validationQueryTimeout = 3
                validationInterval = 15000
                testOnBorrow = true
                testWhileIdle = true
                testOnReturn = false
                jdbcInterceptors = "ConnectionState"
                defaultTransactionIsolation = java.sql.Connection.TRANSACTION_READ_COMMITTED
            }
        }
    }
}
