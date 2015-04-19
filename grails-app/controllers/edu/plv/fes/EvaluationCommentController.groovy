package edu.plv.fes

import edu.plv.fes.constants.FESConstants
import grails.converters.JSON

import java.text.DecimalFormat

class EvaluationCommentController {

    def evaluationService
    def evaluationQuestionService
    def evaluationCategoryService
    def pdfRenderingService
    def systemConfigurationService

    static defaultAction = "view"

    def view(){
        render view: '/evaluationComment/view'
    }

    def viewEvaluatedProfessorList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = evaluationService.getEvaluatedProfessors(params, max, offset,FESConstants.USER_TYPE_STUDENT,true)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render res as JSON
    }

    def viewAllComments(){
        def selected = params?.boolean('selected') ?: false;
        def professor = Professor.get(params?.id)
        def schoolYear = systemConfigurationService.getConfig('schoolyear')
        def semester = systemConfigurationService.getConfig('semester')
        def evalComments = EvaluationComment.withCriteria{
            eq 'professor', professor
            eq 'schoolYear', schoolYear
            eq 'semester', semester
            eq 'selected', selected
            order 'comment','asc'
            projections {
                property 'id'
                property 'comment'
            }
        }
        render evalComments as JSON
    }

    def viewOverallScore(){
        def professor = Professor.get(params?.id)
        def schoolYear = systemConfigurationService.getConfig('schoolyear')
        def semester = systemConfigurationService.getConfig('semester')

        double score = 0
        def scoreHolderWithPercent = evaluationService.retrieveEvaluationScore(professor,schoolYear,semester,FESConstants.USER_TYPE_STUDENT,true)
        if(scoreHolderWithPercent.size()){
            scoreHolderWithPercent.each{
                score += it.score * it.category.percentage
            }
        }

        def res = [score: new DecimalFormat(FESConstants.SCORE_2DECIMAL_FORMAT).format(score)]
        render res as JSON
    }

    def addSaveComment(){
        withForm{
            def message = null
            def model = [success:true]
            def sy = systemConfigurationService.getConfig('schoolyear')
            def semester = systemConfigurationService.getConfig('semester')
            def prof = Professor.get(params?.prof_id)
            message = "Evaluation Comments for ${prof.toString()} successfully removed!"
            EvaluationComment.withCriteria {
                eq 'professor',prof
                eq 'schoolYear',sy
                eq 'semester',semester
            }.collect{
                it.selected = false
                it.save(flush:true)
            }

            if (params?.selectedCommentsId){
                message = "Evaluation Comments for ${prof.toString()} successfully saved!"
                def commentsId = params?.selectedCommentsId?.split(',')
                if(commentsId) {

                    def comments = EvaluationComment.withCriteria {
                        inList 'id', commentsId
                        order 'comment','asc'
                    }
                    comments.collect{
                        it.selected = true
                        it.save(flush:true)
                    }
                }
            }

            flash.message = message
            render view: '/evaluationComment/view', model: model

        }.invalidToken {
            redirect uri: '/comments'
        }
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
