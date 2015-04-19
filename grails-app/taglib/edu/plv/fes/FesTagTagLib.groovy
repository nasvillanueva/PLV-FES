package edu.plv.fes

import edu.plv.fes.constants.FESConstantMaps
import edu.plv.fes.constants.FESConstants
import org.codehaus.groovy.grails.plugins.orm.auditable.AuditLogEvent

class FesTagTagLib {
//    static defaultEncodeAs = [taglib:'html']
    static namespace = 'fesSelect'
//    static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]

    def collegeService
    def departmentService
    def evaluationCategoryService
    def roleService
    def rankingService

    def college = { attrs ->
        attrs.from = collegeService.getAllActiveCollegeForSelect()
        attrs.optionKey = "id"
        attrs.optionValue = "collegeName"
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }

    def department = { attrs ->
        attrs.from = departmentService.getAllActiveDepartmentForSelect()
        attrs.optionKey = "id"
        attrs.optionValue = "departmentName"
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }

    def ranking = { attrs ->
        attrs.from = rankingService.getAllActiveRankingForSelect()
        attrs.optionKey = "id"
        attrs.optionValue = "rankName"
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }

    def title = { attrs ->
        attrs.from = [
                [title:'Mr.'],
                [title:'Ms.'],
                [title:'Mrs.'],
                [title:'Dr.'],
                [title:'Engr.'],
                [title:'Atty.']
        ]
        attrs.optionKey = "title"
        attrs.optionValue = "title"
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }

    def usertype = { attrs ->
        attrs.from = [
                [usertype:FESConstants.USER_TYPE_ADMIN],
                [usertype:FESConstants.USER_TYPE_CHAIR],
                [usertype:FESConstants.USER_TYPE_SUPER]
        ]
        attrs.optionKey = "usertype"
        attrs.optionValue = "usertype"
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }

    def category = { attrs ->
        attrs.from = evaluationCategoryService.getAllActiveCategoryForSelect()
        attrs.optionKey = "id"
        attrs.optionValue = "description"
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }

    def roles = { attrs ->
        attrs.from = roleService.getAllActiveRolesForSelect()
        attrs.optionKey = "id"
        attrs.optionValue = "name"
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }

    def filterType = { attrs ->
        attrs.from = ['College','Department']
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }

    def evalType = { attrs ->
        attrs.from = [
                [usertype:FESConstants.USER_TYPE_STUDENT],
                [usertype:FESConstants.USER_TYPE_CHAIR],
                [usertype:FESConstants.USER_TYPE_SUPER]
        ]
        attrs.optionKey = "usertype"
        attrs.optionValue = "usertype"
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }

    def auditUsers = { attrs ->
        attrs.from = AuditLogEvent.withCriteria {
            order 'actor','asc'
            projections {
                distinct 'actor'
            }
        }
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }
    def auditEvents = { attrs ->
        attrs.from = AuditLogEvent.withCriteria {
            order 'eventName','asc'
            projections {
                distinct 'eventName'
            }
        }
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }
    def auditModules = { attrs ->
        def classNames = AuditLogEvent.withCriteria {
            order 'className','asc'
            projections {
                distinct 'className'
            }
        }
        attrs.from = classNames.collect{
            [
                value : FESConstantMaps.allModulesAuditLogs[it],
                key : it
            ]
        }
        attrs.optionKey = "key"
        attrs.optionValue = "value"
        attrs.noSelection = ['': 'Select One...']
        out << g.select(attrs)
    }
}
