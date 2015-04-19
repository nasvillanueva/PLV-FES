package edu.plv.fes

import edu.plv.fes.constants.FESConstantMaps
import edu.plv.fes.constants.FESConstants
import grails.converters.JSON
import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent

import java.text.SimpleDateFormat

class AuditLogController {

    static defaultAction = "view"

    def auditLogService
    def pdfRenderingService

    def view() {

        AuditLogEvent.withCriteria {
            not{
                'in' 'actor', FESUser.findAllByUsertype(FESConstants.USER_TYPE_ADMIN).username
            }
            ne 'actor', 'system'
        }.collect {it.delete(flush:true)}


        def actor = AuditLogEvent.withCriteria {
            order 'actor','asc'
            projections {
                distinct 'actor'
            }
        }
        render view: '/auditLog/view', model: [actor:actor]
    }

    def viewAuditLogList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = auditLogService.getAllAuditLog(params,offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render  res as JSON
    }

    def viewPrintAuditLog(){
        def auditLog = AuditLogEvent.withCriteria {
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
        def dateFrom = params?.dateFrom && params?.dateFrom != '' ? params?.dateFrom : new SimpleDateFormat('MM/dd/yyyy').format(auditLog.min { it.dateCreated }.dateCreated)
        def dateTo = params?.dateFrom && params?.dateFrom != '' ? params?.dateFrom : new SimpleDateFormat('MM/dd/yyyy').format(auditLog.max { it.dateCreated }.dateCreated)
        def message = "Audit Logs for"
        def previous = false
        if(params?.actor && params?.actor != ''){
            message += " Actor: " + params?.actor
            previous = true
        }
        if(params?.event && params?.event != ''){
            if(previous) message += ","
            message += " Event: " + params?.event
            previous = true
        }
        if(params?.module && params?.module != ''){
            if(previous) message += ","
            message += " Module: " + FESConstantMaps.allModulesAuditLogs[params?.module]
            previous = true
        }
        if(message == "Audit Logs for")
            message += " All"


        def newAuditLog = auditLog.subList(0, params?.limit ? params.int('limit') : auditLog.size())
        def auditHolder = []
        for(int x = 0;x< newAuditLog.size() ;x+=30){
            def tmp = []
            def toIndex = (x+30) < newAuditLog.size() ? x+30 : newAuditLog.size()
            newAuditLog.subList(x,toIndex).each{
                tmp << it.tableDisplay
            }
            auditHolder << tmp
        }

        def plvlogo = new File(servletContext.getRealPath('images/plv_logo.jpg'));
        def args = [template:"reports/auditLogReport",
                    controller:this,
                    model:[auditLog: auditHolder,
                           message:message,
                           dateFrom:dateFrom,
                           dateTo:dateTo,
                           plvlogo:plvlogo.bytes
                    ]]
        pdfRenderingService.render(args,response)
    }
}
