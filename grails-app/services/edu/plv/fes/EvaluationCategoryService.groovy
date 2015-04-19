package edu.plv.fes

import grails.transaction.Transactional

@Transactional
class EvaluationCategoryService {

    static transactional = true

    def getAllEvaluationCategory(offset, max) {
        def c = EvaluationCategory.createCriteria()
        def evalCat = c.list(max:max,offset:offset){
            order 'catIndex', 'ASC'
        }
        def display = evalCat.collect {it.tableDisplay}
        return [totalCount: evalCat.totalCount, display: display]
    }

    def getAllActiveCategoryForSelect(){
        return EvaluationCategory.withCriteria {
            eq('active',true)
            order 'catIndex','asc'
        }
    }

    def retrieveEvaluationCategories(questions){
        EvaluationCategory.withCriteria{
            evaluationQuestion{
                if(questions){
                    inList 'id', questions.id
                }else{
                    eq 'id',''
                }
            }
            order 'catIndex', 'ASC'
        }
    }
}
