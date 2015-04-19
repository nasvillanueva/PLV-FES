package edu.plv.fes

class FESRole {
    String id
    String name
    String description
    boolean active = true
    static auditable = true
    
    String toString(){
        name
    }

    static hasMany = [ users: FESUser, permissions: String ]
    static belongsTo = FESUser

    static constraints = {
        name(nullable: false, blank: false, unique: true)
    }

    static transients = ['tableDisplay']

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_role'
    }

    def getTableDisplay(){
        return [
                DT_RowId: id,
                id: id,
                name: name,
                description: description,
                active: (active) ? 'Yes':'No'
        ]
    }
}
