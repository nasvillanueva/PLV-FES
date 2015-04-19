package edu.plv.fes

class Interpretation {

    static constraints = {
    }

    String id
    BigInteger scale
    String rating
    String description
    boolean active
    Date dateCreated
    Date lastUpdated
    static auditable = true

    String toString(){
        description
    }

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_interpratation'
    }

    static transients = ['tableDisplay']

    def getTableDisplay(){
        return [
                DT_RowId: id,
                id: id,
                scale: scale,
                rating: rating,
                description: description,
                active: (active) ? 'Yes':'No'
        ]
    }

}
