package edu.plv.fes

import grails.converters.JSON

class EvaluationQuestionController {

    def evaluationQuestionService

    static defaultAction = "view"

    def view() {
        render view: '/evaluationQuestion/view'
    }

    def viewEvaluationQuestionList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = evaluationQuestionService.getAllEvaluationQuestion(offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render res as JSON
    }

    def viewEvaluationQuestion(){
        def question = EvaluationQuestion.get(params?.id)
        def jsonData = [id:question.id, category:question.evaluationCategoryId, question: question.question, active:question.active]
        render jsonData as JSON
    }

    def addEvaluationQuestion(){
        withForm{
            def catList = EvaluationCategory.withCriteria {
                eq 'active', true
            }
            def model = [success:true, categoryList:catList]
            def message = null
            if(!EvaluationQuestion.findByQuestion(params?.question)){
                EvaluationQuestion evalQ = new EvaluationQuestion()
                evalQ.evaluationCategory = EvaluationCategory.get(params?.category)
                evalQ.question = params?.question
                evalQ.active = params?.q_active == 'on'
                if(evalQ.save(flush:true)){
                    message = '\"' + params?.question + '\" successfully added!'
                }else{
                    model.success = false
                    message = 'There was a problem adding \"' + params?.question + '\". Try submitting the form again.'
                    model.evalQ = evalQ
                }
            }else{
                model.success = false
                message = '\"' + params?.question + '\" already exists!'
            }

            flash.message = message
            render view: '/evaluationQuestion/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }

    def editEvaluationQuestion(){
        withForm{
            def model = [success:true]
            def message = null
            EvaluationQuestion evalQ = EvaluationQuestion.get(params?.q_id)
            if(evalQ?.question != params?.question) {
                def byQ = EvaluationQuestion.findAllByQuestion(params?.question)
                if (byQ.size() > 0) {
                    model.success = false
                    message = '\"' + params?.question + '\" already exists!'
                }else{
                    evalQ.question = params?.question
                }
            }

            if(model.success){
                evalQ.evaluationCategory = EvaluationCategory.get(params?.category)
                evalQ.active = params?.q_active == 'on'
                if(evalQ.save(flush:true)){
                    message = '\"' + params?.question + '\" successfully updated!'
                }else{
                    model.success = false
                    message = 'There was a problem updating \"' + params?.question + '\". Try submitting the form again.'
                    model.evalQ = evalQ
                }
            }

            flash.message = message
            render view: '/evaluationQuestion/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }
}
