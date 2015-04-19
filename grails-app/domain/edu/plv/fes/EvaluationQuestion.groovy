package edu.plv.fes

class EvaluationQuestion {

    static belongsTo = [evaluationCategory: EvaluationCategory]

    static constraints = {
    }

    static auditable = true

    static transients = ['tableDisplay']

    String id
    String question
    boolean active
    Date dateCreated
    Date lastUpdated

    String toString(){
        question
    }

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_evaluationQuestion'
    }

    def getTableDisplay(){
        return [
                DT_RowId: id,
                id: id,
                category: evaluationCategory.toString(),
                question: question,
                active: (active) ? 'Yes':'No'
        ]
    }

}
