package edu.plv.fes

import grails.converters.JSON

class SupervisorListMaintenanceController {

    def userService
    def professorService
    def systemConfigurationService

    static defaultAction = "view"

    def view() { render view: '/supervisorListMaintenance/view' }

    def viewSupervisorList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = userService.getAllSupervisor(params, offset, max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render res as JSON
    }

    def viewAvailableSupervisorList(){
        def peerList = professorService.getAvailableSupervisorList(params)
        render peerList as JSON
    }

    def viewSelectedSupervisorList(){
        def sectionList = professorService.getSelectedSupervisorList(params)
        render sectionList as JSON
    }

    def addSupervisorEvaluationList(){
        withForm{
            def message = null
            def model = [success:true]
            def sy = systemConfigurationService.getConfig('schoolyear')
            def semester = systemConfigurationService.getConfig('semester')
            def supervisor = FESUser.get(params?.id)
            message = "Supervisor Evaluation list for ${supervisor.toString()} successfully removed!"
            EvaluationList.withCriteria {
                eq 'evaluator',supervisor
                eq 'schoolYear',sy
                eq 'semester',semester
            }*.delete(flush:true)

            if(params?.selectedSupervisorId){
                message = "Evaluation list for ${supervisor.toString()} successfully saved!"
                def prof = params?.selectedSupervisorId?.split(',')
                if(prof) {
                    def professors = Professor.withCriteria { inList 'id', prof }
                    professors.each { professor ->
                        EvaluationList evalDTO = new EvaluationList(professor: professor, evaluator: supervisor, schoolYear: sy, semester: semester, active: true)
                        if(!evalDTO.save(flush: true)){
                            message = "An error has occured while saving evaluation list!"
                            model.success = false
                        }
                    }
                }

            }

            flash.message = message
            render view: '/supervisorListMaintenance/view', model: model

        }.invalidToken {
            redirect action: 'view', params: [admin:true]
        }
    }
}
