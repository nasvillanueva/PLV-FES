package edu.plv.fes

class College {

    static constraints = {
    }


    String id
    String collegeName
    boolean active
    Date dateCreated
    Date lastUpdated

    static auditable = true

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_college'
    }

    String toString(){
        collegeName
    }

    static transients = ['tableDisplay']

    def getTableDisplay(){
        return [
                DT_RowId: id,
                id: id,
                name: collegeName,
                active: (active) ? 'Yes':'No'
        ]
    }

}