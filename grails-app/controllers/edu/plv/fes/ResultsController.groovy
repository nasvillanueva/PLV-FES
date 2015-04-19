package edu.plv.fes

import edu.plv.fes.constants.FESConstants
import grails.converters.JSON

import java.text.DecimalFormat

class ResultsController {

    def evaluationService
    def systemConfigurationService

    static defaultAction = "view"

    def view() {
        def evalYear = []
        Evaluation.withCriteria{
            order 'schoolYear','asc'
            projections{
                distinct 'schoolYear'
            }
        }.collect{
            if(systemConfigurationService.getConfig('schoolyear') != it){
                evalYear << it
            }
        }
        render view: '/results/view', model: [evalYear:evalYear]
    }

    def viewEvaluatedProfessorList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = evaluationService.getEvaluatedProfessors(params, max, offset,params?.usertype,false)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render res as JSON
    }

    def viewProfScoreList() {
        def prof = Professor.get(params?.id)
        def schoolYear = params?.int('schoolyear') ?: systemConfigurationService.getConfig('schoolyear')
        def semester = params?.int('semester')?: systemConfigurationService.getConfig('semester')
        def resultWithPercent = evaluationService.retrieveEvaluationScore(prof, schoolYear, semester,params?.usertype?:'',true)
        resultWithPercent = resultWithPercent.collect{
            [
                    DT_RowId: 'no_id',
                    category: it.category.description + ' (' + (it.category.percentage * 100) + '%)',
                    score: new DecimalFormat(FESConstants.SCORE_2DECIMAL_FORMAT).format(it.score)
            ]
        }
        def result = evaluationService.retrieveEvaluationScore(prof, schoolYear, semester,params?.usertype?:'',false)
        result = result.collect{
            [
                    DT_RowId: 'no_id',
                    category: it.category.description,
                    score: new DecimalFormat(FESConstants.SCORE_2DECIMAL_FORMAT).format(it.score)
            ]
        }
        resultWithPercent.addAll(result)
        def res = [draw: params.int('draw'),data:resultWithPercent, recordsTotal:resultWithPercent.size(),recordsFiltered:resultWithPercent.size()]
        render res as JSON
    }

    def viewJSON(){
        def res = [draw: params.int('draw'),data:[DT_RowId:'',category:'',score:''], recordsTotal:0,recordsFiltered:0]
        render res as JSON
    }

    def viewOverallScore(){
        def professor = Professor.get(params?.id)
        def schoolYear = params?.int('schoolyear') ?: systemConfigurationService.getConfig('schoolyear')
        def semester = params?.int('semester')?: systemConfigurationService.getConfig('semester')

        double score = 0
        int count = 0
        def scoreHolderWithPercent = evaluationService.retrieveEvaluationScore(professor,schoolYear,semester,params?.usertype,true)
        if(scoreHolderWithPercent.size()){
            scoreHolderWithPercent.each{
                score += it.score * it.category.percentage
            }
            count++
        }

        def scoreHolder = evaluationService.retrieveEvaluationScore(professor,schoolYear,semester,params?.usertype,false)
        if(scoreHolder.size()){
            scoreHolder.each{
                score += it.score
                count++
            }
        }

        score = score / ((count > 0) ? count: 1)

        def res = [score: new DecimalFormat(FESConstants.SCORE_2DECIMAL_FORMAT).format(score)]
        render res as JSON
    }

    def viewTallyCounter(){
        def professor = Professor.get(params?.id)
        def schoolYear = params?.int('schoolyear') ?: systemConfigurationService.getConfig('schoolyear')
        def semester = params?.int('semester')?: systemConfigurationService.getConfig('semester')

        def count = EvaluationComment.withCriteria {
            eq 'professor',professor
            eq 'schoolYear',schoolYear
            eq 'semester',semester
        }

        def res = [count: count.size()]
        render res as JSON
    }
}
