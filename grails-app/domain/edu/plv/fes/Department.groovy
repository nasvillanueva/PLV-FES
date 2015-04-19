package edu.plv.fes

class Department {

    static constraints = {
    }

    String id
    String departmentName
    boolean active
    Date dateCreated
    Date lastUpdated

    static auditable = true

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_department'
    }

    String toString(){
        departmentName
    }

    static transients = ['tableDisplay']

    def getTableDisplay(){
        return [
                DT_RowId: id,
                id: id,
                name: departmentName,
                active: (active) ? 'Yes':'No'
        ]
    }
}