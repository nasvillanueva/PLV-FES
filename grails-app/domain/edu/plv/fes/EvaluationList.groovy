package edu.plv.fes

import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent

class EvaluationList {

    static constraints = {
    }

    String id
    Professor professor
    FESUser evaluator
    int schoolYear
    int semester
    boolean active
    Date dateCreated

    static auditable = true


    String toString(){
        professor
    }

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_evaluationList'
    }
}
