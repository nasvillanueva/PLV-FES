package edu.plv.fes

class Evaluation {

    static constraints = {
        semester maxSize: 1
    }

    String id
    Professor professor
    EvaluationQuestion question
    Interpretation interpretation
    int semester
    String evaluator
    int schoolYear
    Date dateCreated

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_evaluation'
    }
}
