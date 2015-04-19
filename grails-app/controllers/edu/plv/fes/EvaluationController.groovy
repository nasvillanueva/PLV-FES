package edu.plv.fes

import grails.converters.JSON
import org.apache.shiro.SecurityUtils

class EvaluationController {
    def evaluationService
    def evaluationListService

    static defaultAction = "view"

    def view() {
        if (params?.id) {
            def availableProf = evaluationListService.getEvaluationList()
            if(availableProf.contains(Professor.get(params?.id))){
                def category = EvaluationCategory.withCriteria {
                    createAlias('evaluator','e')
                    sizeGe('evaluationQuestion',1)
                    eq 'active', true
                    ilike 'e.elements', FESUser.findByUsername(SecurityUtils.subject.principal.toString()).usertype

                    order 'catIndex', 'ASC'
                }
                def question = EvaluationQuestion.withCriteria {
                    inList 'evaluationCategory', category
                    eq 'active', true
                    order 'question','asc'
                }
                def interpretation = Interpretation.withCriteria {
                    eq 'active', true
                    order 'scale', 'desc'
                }
                def prof = Professor.get(params.id)
                render view: '/evaluation/view', model: [category: category, question: question, interpretation: interpretation, prof: prof]
            }else{
                flash.errors = "The selected professor is not on the user's evaluation list."
                redirect controller:'evaluationList',action:'view'
            }
        }else{
            redirect controller:'evaluationList',action:'view'
        }
    }

    def addEvaluation() {
        def qString = params?.questionString
        def evalAnsMap = [:]
        if(qString){
            def qList = qString.split(',')*.toString()*.trim()*.replaceAll(/[\[\]]/,"")
            qList.each { qId ->
                evalAnsMap.put(qId , params.int(qId))
            }
            evaluationService.saveEvaluation(evalAnsMap, params?.comment, params?.prof_id)
        }
        redirect controller: 'evaluationList', action: 'view'
    }

    def viewProfessorEvaluation(){
        def professor = Professor.get(params?.id)
        def jsonData = [id:professor.id,name:professor.toString()]
        render jsonData as JSON
    }
}
