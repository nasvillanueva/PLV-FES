package edu.plv.fes

import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent

class EvaluationComment {

    static constraints = {
        semester maxSize: 1
    }

    String id
    Professor professor
    String comment
    boolean selected = false
    int semester
    int schoolYear
    Date dateCreated

    static auditable = true


    String toString(){
        comment
    }

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_evaluationComment'
    }
}
