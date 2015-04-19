package edu.plv.fes

import grails.transaction.Transactional
import groovy.sql.Sql

@Transactional
class InterpretationService {
    def getAllInterpretation(offset, max) {
        def i = Interpretation.createCriteria()
        def interpret = i.list(max:max,offset:offset){
            order 'scale','desc'
        }
        def display = interpret.collect {it.tableDisplay}
        return [totalCount: interpret.totalCount, display: display]
    }
}
