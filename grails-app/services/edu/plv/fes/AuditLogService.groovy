package edu.plv.fes

import grails.transaction.Transactional
import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent

@Transactional
class AuditLogService {

    def getAllAuditLog(params,offset, max) {
        def a = AuditLogEvent.createCriteria()
        def auditLog = a.list(offset:offset,max:max) {
            if(params?.dateFrom && params?.dateFrom != '')
                ge 'dateCreated', new Date(params?.dateFrom)
            if(params?.dateTo && params?.dateTo != '')
                le 'dateCreated', new Date(params?.dateTo)
            if(params?.actor && params?.actor != '')
                eq 'actor', params?.actor
            if(params?.event && params?.event != '')
                eq 'eventName', params?.event
            if(params?.module && params?.module != '')
                eq 'className', params?.module
            order 'dateCreated', 'desc'
        }
        def display = auditLog.collect {it.tableDisplay}
        return [totalCount: auditLog.totalCount, display: display]
    }
}
