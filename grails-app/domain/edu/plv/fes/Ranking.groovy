package edu.plv.fes

class Ranking {


    String id
    String rankName
    boolean active
    Date dateCreated
    Date lastUpdated

    static auditable = true

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_rank'
    }

    String toString(){
        rankName
    }

    static transients = ['tableDisplay']

    def getTableDisplay(){
        return [
                DT_RowId: id,
                id: id,
                name: rankName,
                active: (active) ? 'Yes':'No'
        ]
    }

}
