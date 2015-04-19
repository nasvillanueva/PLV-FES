package edu.plv.fes

import edu.plv.fes.constants.FESConstants
import grails.transaction.Transactional
import org.apache.shiro.SecurityUtils
import sun.org.mozilla.javascript.internal.debug.DebuggableObject

@Transactional
class ProfessorService {

    def systemConfigurationService

    def getAllProfessorWithParams(params,offset, max) {
        def p = Professor.createCriteria()
        def globalSearch = ('%' + params.get('search[value]') + '%').toLowerCase()
        def departmentList = Department.findAllByDepartmentNameIlike(globalSearch)
        def collegeList = College.findAllByCollegeNameIlike(globalSearch)
        def prof = p.list(max:max,offset:offset){
            if(params.get('search[value]')) {
                or {
                    if(departmentList){
                        'in'('department', departmentList)
                    }
                    if(collegeList){
                        'in'('college', collegeList)
                    }
                    ilike('firstname', globalSearch)
                    ilike('middlename', globalSearch)
                    ilike('surname', globalSearch)
                }

            }
            order('surname','ASC')
        }
        def display = prof.collect {it.tableDisplay}
        return [totalCount: prof.totalCount, display: display]
    }

    //for peer
    def getAvailablePeerList(params){
        def sy = systemConfigurationService.getConfig('schoolyear')
        def semester = systemConfigurationService.getConfig('semester')

        def department = FESUser.get(params?.id).department
        def selectedPeerList = EvaluationList.withCriteria {
            createAlias('professor','p')
            createAlias('evaluator','e')
            eq('p.department',department)
            eq('schoolYear',sy)
            eq('semester',semester)
            eq('e.usertype', FESConstants.USER_TYPE_CHAIR)
            eq 'p.active',true
            projections{
                distinct('professor')
            }
        }
        def peerList = Professor.withCriteria {
            eq 'department',department
            if(selectedPeerList){
                not{
                    'in' 'id', selectedPeerList.id
                }
            }
            eq 'active',true
            order 'surname','ASC'
        }
        return peerList.collect{
            [
                id:it.id,
                name:it.toString()
            ]
        }
    }

    def getSelectedPeerList(params){
        def sy = systemConfigurationService.getConfig('schoolyear')
        def semester = systemConfigurationService.getConfig('semester')

        def department = FESUser.get(params?.id).department
        def selectedPeerList = EvaluationList.withCriteria {
            createAlias('professor','p')
            createAlias('evaluator','e')
            eq('evaluator',FESUser.get(params?.id))
            eq('p.department',department)
            eq('e.usertype', FESConstants.USER_TYPE_CHAIR)
            eq('schoolYear',sy)
            eq('semester',semester)
            eq 'p.active',true
            order 'p.surname','ASC'
        }
        return selectedPeerList.professor.unique().collect{
            [
                    id:it.id,
                    name:it.toString()
            ]
        }
    }

    //for supervisor
    def getAvailableSupervisorList(params){
        def sy = systemConfigurationService.getConfig('schoolyear')
        def semester = systemConfigurationService.getConfig('semester')

        def selectedSupervisorList = EvaluationList.withCriteria {
            createAlias('evaluator','e')
            eq('schoolYear',sy)
            eq('semester',semester)
            eq('e.usertype', FESConstants.USER_TYPE_SUPER)
            projections{
                distinct('professor')
            }
        }
        def supervisorList = Professor.withCriteria {
            if(selectedSupervisorList){
                not{
                    'in' 'id', selectedSupervisorList.id
                }
            }
            eq 'active',true
            order 'surname','ASC'
        }
        return supervisorList.collect{
            [
                    id:it.id,
                    name:it.toString()
            ]
        }
    }

    def getSelectedSupervisorList(params){
        def sy = systemConfigurationService.getConfig('schoolyear')
        def semester = systemConfigurationService.getConfig('semester')

        def selectedSupervisorList = EvaluationList.withCriteria {
            createAlias('evaluator','e')
            createAlias('professor','p')
            eq('evaluator',FESUser.get(params?.id))
            eq('e.usertype', FESConstants.USER_TYPE_SUPER)
            eq('schoolYear',sy)
            eq('semester',semester)
            eq 'p.active',true
            order 'p.surname','ASC'
        }
        return selectedSupervisorList.professor.unique().collect{
            [
                    id:it.id,
                    name:it.toString()
            ]
        }
    }
}
