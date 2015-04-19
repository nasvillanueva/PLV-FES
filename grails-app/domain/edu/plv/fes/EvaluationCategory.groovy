package edu.plv.fes

class EvaluationCategory {

    static hasMany = [evaluationQuestion: EvaluationQuestion, evaluator:String]
    static constraints = {
    }

    String id
    String description
    BigDecimal percentage
    String catIndex
    boolean active
    Date dateCreated
    Date lastUpdated

    static auditable = true

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_evaluationCategory'
    }
    static transients = ['tableDisplay']

    String toString() {
        description
    }

    def getTableDisplay(){
        return [
                DT_RowId: id,
                id: id,
                description: description,
                percentage: percentage * 100,
                index: catIndex,
                evaluator: evaluator.toString(),
                active: (active) ? 'Yes':'No'
        ]
    }
}

