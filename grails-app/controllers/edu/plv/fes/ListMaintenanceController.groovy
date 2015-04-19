package edu.plv.fes

import grails.converters.JSON

class ListMaintenanceController {

    def evaluationListService
    def systemConfigurationService

    static defaultAction = "view"

    def view(){
        render view: '/listMaintenance/view'
    }
    def viewProfessorList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = evaluationListService.getProfessors(params, max, offset)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render res as JSON
    }
    def viewAvailableSectionList(){
        def sectionList = evaluationListService.getAvailableSectionList(params)
        render sectionList as JSON
    }

    def viewEvaluatingSectionList(){
        def sectionList = evaluationListService.getEvaluatingSectionList(params)
        render sectionList as JSON
    }

    def addEvaluationList(){
        withForm{
            def message = null
            def model = [success:true]
            def sy = systemConfigurationService.getConfig('schoolyear')
            def semester = systemConfigurationService.getConfig('semester')
            def prof = Professor.get(params?.id)
            message = "Evaluation list for ${prof.toString()} successfully removed!"
            EvaluationList.withCriteria {
                eq 'professor',prof
                eq 'schoolYear',sy
                eq 'semester',semester
            }*.delete(flush:true)

            if(params?.selectedSection){
                message = "Evaluation list for ${prof.toString()} successfully saved!"
                def section = params?.selectedSection?.split(',')
                if(section) {
                    def students = FESUser.withCriteria { inList 'section', section }
                    students.each { student ->
                        EvaluationList evalDTO = new EvaluationList(professor: prof, evaluator: student, schoolYear: sy, semester: semester, active: true)
                        if(!evalDTO.save(flush: true)){
                            message = "An error has occured while saving evaluation list!"
                            model.success = false
                        }
                    }
                }

            }

            flash.message = message
            render view: '/listMaintenance/view', model: model

        }.invalidToken {
            redirect action: 'view', params: [admin:true]
        }
    }
}
