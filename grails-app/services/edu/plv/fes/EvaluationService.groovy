package edu.plv.fes

import grails.transaction.Transactional
import org.apache.shiro.SecurityUtils

@Transactional
class EvaluationService {

    def systemConfigurationService

    def getEvaluatedProfessors(params,max,offset,evaluator,dateRequired){
        def schoolyear = params?.int('schoolyear') ?: SystemConfiguration.findByConfigName('schoolyear').configValue
        def semester = params?.int('semester') ?: SystemConfiguration.findByConfigName('semester').configValue
        def evaluatedProf = Evaluation.withCriteria {
            eq 'evaluator', evaluator
            if(dateRequired){
                eq 'schoolYear', schoolyear
                eq 'semester', semester
            }
            projections {
                distinct 'professor.id'
            }
        }
        def p = Professor.createCriteria()
        def globalSearch = ('%' + params.get('search[value]') + '%').toLowerCase()
        def departmentList = Department.findAllByDepartmentNameIlike(globalSearch)
        def collegeList = College.findAllByCollegeNameIlike(globalSearch)
        def profList = p.list(max:max,offset:offset){
            if(evaluatedProf){
                'in'('id',evaluatedProf)
            }else{
                eq 'id',''
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

    def saveEvaluation(evalAns,comment,prof_id) {
        def semester = systemConfigurationService.getConfig('semester')
        def sy = systemConfigurationService.getConfig('schoolyear')
        def prof = Professor.get(prof_id)
        def evaluator = FESUser.findByUsername(SecurityUtils.subject.principal.toString()).usertype

        evalAns.each{key, value ->
            def evalQuestion = EvaluationQuestion.get(key)
            def ans = Interpretation.findByScale(Double.valueOf(value))
            def evaluation = new Evaluation(professor: prof,question: evalQuestion, interpretation: ans,semester: semester,schoolYear: sy,evaluator: evaluator)
            evaluation.save(flush:true)
        }

        if(comment && comment?.trim()){
            def evalComment = new EvaluationComment(professor: prof,comment: comment.toString().trim(),semester: semester,schoolYear: sy)
            evalComment.save(flush:true)
        }

        def evaluation = EvaluationList.find{
            eq 'professor',prof
            eq 'schoolYear',sy
            eq 'semester',semester
            eq 'evaluator', FESUser.findByUsername(SecurityUtils.subject.principal.toString())
        }
        if(evaluation){
            evaluation.delete(flush:true)
        }
    }

    def retrieveEvaluationScore(prof, schoolYear, semester, evaluator,withPercent){
        def evaluationResult = Evaluation.withCriteria {
            createAlias('question','q')
            createAlias('q.evaluationCategory','c')
            createAlias('interpretation','i')
            eq 'semester', semester
            eq 'schoolYear', schoolYear
            eq 'professor', prof
            eq 'evaluator', evaluator
            if(withPercent){
                gt 'c.percentage', 0.0
            }else{
                eq 'c.percentage', 0.0
            }
            projections {
                groupProperty 'c.id', 'category'
                avg 'i.scale','score'
                groupProperty 'c.catIndex', 'catIndex'
                groupProperty 'c.percentage'
                order 'c.catIndex','ASC'
            }
        }
        return evaluationResult.collect{
            [
                    category: EvaluationCategory.get(it[0]),
                    score: it[1],
                    catIndex: it[2]
            ]
        }
    }





}
