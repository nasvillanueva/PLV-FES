package edu.plv.fes

import grails.transaction.Transactional

@Transactional
class EvaluationQuestionService {

    def getAllEvaluationQuestion(offset, max) {
        def q = EvaluationQuestion.createCriteria()
        def evalQuestion = q.list(max:max,offset:offset){
            createCriteria('evaluationCategory','c')

            order 'c.catIndex','asc'
            order 'question', 'asc'
        }
        def display = evalQuestion.collect {
            it.tableDisplay
        }
        return [totalCount: evalQuestion.totalCount, display: display]
    }

    def retrieveEvaluationQuestions(int schoolYear, int semester, String evaluator){
        def res = Evaluation.withCriteria{
            eq 'schoolYear', schoolYear
            eq 'semester', semester
            eq 'evaluator', evaluator
            order 'question','asc'
            projections {
                distinct 'question'
            }
        }
        return res
    }
}
