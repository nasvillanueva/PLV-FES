package edu.plv.fes

import edu.plv.fes.constants.FESConstants
import grails.transaction.Transactional
import org.apache.shiro.SecurityUtils

@Transactional
class EvaluationListService {
    def systemConfigurationService


    def getProfessors(params, max, offset) {
        def studSched = StudentSchedule.withCriteria {
            projections {
                distinct('professor.id')
            }
        }
        def p = Professor.createCriteria()
        def globalSearch = ('%' + params.get('search[value]') + '%').toLowerCase()
        def departmentList = Department.findAllByDepartmentNameIlike(globalSearch)
        def collegeList = College.findAllByCollegeNameIlike(globalSearch)
        def profList = p.list(max:max,offset:offset){
            if(studSched){
                'in'('id',studSched)
            }
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
            eq 'active',true
            order('surname','ASC')
        }
        def display = profList.collect{it.tableDisplay}
        return [totalCount: profList.totalCount, display: display]
    }

    def getAvailableSectionList(params){
        def sy = systemConfigurationService.getConfig('schoolyear')
        def semester = systemConfigurationService.getConfig('semester')

        def professor = Professor.get(params?.id)
        def evaluatingSectionList = EvaluationList.withCriteria {
            eq('professor',professor)
            eq('schoolYear',sy)
            eq('semester',semester)
        }
        def sectionList = StudentSchedule.withCriteria {
            eq('professor',professor)
            if(evaluatingSectionList){
                not{
                    'in'('section',evaluatingSectionList.evaluator.section.unique())
                }
            }
            order 'section','ASC'
            projections{
                distinct('section')
            }
        }
        return sectionList
    }

    def getEvaluatingSectionList(params){
        def sy = systemConfigurationService.getConfig('schoolyear')
        def semester = systemConfigurationService.getConfig('semester')

        def professor = Professor.get(params?.id)
        def sectionList = EvaluationList.withCriteria {
            createAlias('evaluator','e')
            eq('professor',professor)
            eq('schoolYear',sy)
            eq('semester',semester)
            order 'e.section','ASC'
        }
        return sectionList.evaluator.section.unique()
    }

    def getEvaluationList() {
        def sy = systemConfigurationService.getConfig('schoolyear')
        def semester = systemConfigurationService.getConfig('semester')
        def respondentLimit = systemConfigurationService.getConfig('respondentLimit')
        def excludedProf = []
        def usertype = FESUser?.findByUsername(SecurityUtils.subject.principal.toString())?.usertype

        if(usertype == FESConstants.USER_TYPE_STUDENT ){
            def tmp =  EvaluationComment.withCriteria{
                projections {
                    groupProperty 'professor'
                    count 'id'
                }
            }
            tmp.each{
                if(it[1] > respondentLimit){
                    excludedProf << it[0].id
                }
            }
        }

        def evaluationList = EvaluationList.withCriteria{
            createAlias('evaluator','s')
            createAlias('professor','p')
            eq('schoolYear',sy)
            eq('p.active',true)
            eq('semester', semester)
            eq('s.username', SecurityUtils.subject.principal)
            if(usertype == FESConstants.USER_TYPE_STUDENT && excludedProf.size() > 0 ) {
                not{
                    'in'('p.id',excludedProf)
                }
            }
            order 'p.surname','ASC'
        }
        return evaluationList?.professor
    }

}
