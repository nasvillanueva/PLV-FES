package edu.plv.fes

import grails.transaction.Transactional

@Transactional
class ReportsService {

    def retrieveEvaluationScore(prof, schoolYear, semester, evaluator){
        def evaluationResult = Evaluation.withCriteria {
            createAlias('question','q')
            createAlias('q.evaluationCategory','c')
            createAlias('interpretation','i')
            eq 'semester', semester
            eq 'schoolYear', schoolYear
            eq 'professor', prof
            eq 'evaluator', evaluator
            projections {
                groupProperty 'c.id', 'category'
                avg 'i.scale','score'
                groupProperty 'c.catIndex', 'catIndex'
                order 'c.catIndex','ASC'
            }
        }
        def resHolder = [:]
        evaluationResult.collect{
            resHolder.put("${it[2]}",it[1])
        }
        return resHolder
    }
}
