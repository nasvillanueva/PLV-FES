package edu.plv.fes

class SystemConfiguration {

    static constraints = {
    }

    static auditable = true

    String id
    String configName
    int configValue
    Date dateCreated
    Date lastUpdated

    String toString(){
        configName.toLowerCase()
    }

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_config'
    }
}
