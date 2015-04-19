package edu.plv.fes

import edu.plv.fes.constants.FESConstants
import grails.converters.JSON

class EvaluationCategoryController {
    def evaluationCategoryService

    static defaultAction = "view"

    def view() {
        render view: '/evaluationCategory/view'
    }

    def viewEvaluationCategoryList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = evaluationCategoryService.getAllEvaluationCategory(offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render  res as JSON
    }

    def viewEvaluationCategory(){
        def category = EvaluationCategory.get(params?.id)
        def jsonData = [id:category.id, description:category.description,percentage:category.percentage * 100, catIndex: category.catIndex, student:category?.evaluator?.contains(FESConstants.USER_TYPE_STUDENT),chair:category?.evaluator?.contains(FESConstants.USER_TYPE_CHAIR),super:category?.evaluator?.contains(FESConstants.USER_TYPE_SUPER), active:category.active]
        render jsonData as JSON
    }

    def addEvaluationCategory(){
        withForm{
            def model = [success:true]
            def message = null
            if(!EvaluationCategory.findByDescription(params?.cat_desc)){
                EvaluationCategory evalCat = new EvaluationCategory()
                evalCat.description = params.cat_desc
                evalCat.percentage = Double.valueOf(params?.cat_percent) / 100
                evalCat.catIndex = params.cat_index
                if(params?.cat_stud == 'on') evalCat.addToEvaluator(FESConstants.USER_TYPE_STUDENT)
                if(params?.cat_chair == 'on') evalCat.addToEvaluator(FESConstants.USER_TYPE_CHAIR)
                if(params?.cat_sv == 'on') evalCat.addToEvaluator(FESConstants.USER_TYPE_SUPER)
                evalCat.active = params.cat_active == 'on'
                if(evalCat.save(flush:true)){
                    message = '\"' + params.cat_desc + '\" successfully added!'
                }else{
                    model.success = false
                    message = 'There was a problem adding \"' + params.cat_desc + '\". Try submitting the form again.'
                    model.evalCat = evalCat
                }
            }else{
                model.success = false
                message = '\"' + params.cat_desc + '\" already exists!'
            }

            flash.message = message
            render view: '/evaluationCategory/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }

    def editEvaluationCategory(){
        withForm{
            def model = [success:true]
            def message = null
            EvaluationCategory evalCat = EvaluationCategory.get(params?.cat_id)
            if(evalCat?.description != params?.cat_desc) {
                def byDesc = EvaluationCategory.findAllByDescription(params?.cat_desc)
                if (byDesc.size() > 0) {
                    model.success = false
                    message = '\"' + params?.cat_desc + '\" already exists!'
                }else{
                    evalCat.description = params?.cat_desc
                }
            }

            if(model.success){
                evalCat.catIndex = params.cat_index
                evalCat.percentage = Double.valueOf(params?.cat_percent) / 100
                evalCat?.evaluator?.clear()
                if(params?.cat_stud == 'on') evalCat.addToEvaluator(FESConstants.USER_TYPE_STUDENT)
                if(params?.cat_chair == 'on') evalCat.addToEvaluator(FESConstants.USER_TYPE_CHAIR)
                if(params?.cat_sv == 'on') evalCat.addToEvaluator(FESConstants.USER_TYPE_SUPER)
                evalCat.active = params.cat_active == 'on'
                if(evalCat.save(flush:true)){
                    message = '\"' + params.cat_desc + '\" successfully updated!'
                }else{
                    model.success = false
                    message = 'There was a problem updating \"' + params.cat_desc + '\". Try submitting the form again.'
                    model.evalCat = evalCat
                }
            }

            flash.message = message
            render view: '/evaluationCategory/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }

}
