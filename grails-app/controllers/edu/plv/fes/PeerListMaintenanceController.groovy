package edu.plv.fes

import grails.converters.JSON

class PeerListMaintenanceController {

    def userService
    def professorService
    def systemConfigurationService

    static defaultAction = "view"

    def view() { render view: '/peerListMaintenance/view' }

    def viewChairpersonList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = userService.getAllChairperson(params, offset, max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render res as JSON
    }

    def viewAvailablePeerList(){
        def peerList = professorService.getAvailablePeerList(params)
        render peerList as JSON
    }

    def viewSelectedPeerList(){
        def sectionList = professorService.getSelectedPeerList(params)
        render sectionList as JSON
    }

    def addPeerEvaluationList(){
        withForm{
            def message = null
            def model = [success:true]
            def sy = systemConfigurationService.getConfig('schoolyear')
            def semester = systemConfigurationService.getConfig('semester')
            def chairperson = FESUser.get(params?.id)
            message = "Peer Evaluation list for ${chairperson.toString()} successfully removed!"
            EvaluationList.withCriteria {
                eq 'evaluator',chairperson
                eq 'schoolYear',sy
                eq 'semester',semester
            }*.delete(flush:true)

            if(params?.selectedPeerId){
                message = "Evaluation list for ${chairperson.toString()} successfully saved!"
                def peer = params?.selectedPeerId?.split(',')
                if(peer) {
                    def professors = Professor.withCriteria {
                        inList 'id', peer
                        eq 'active',true
                    }
                    professors.each { professor ->
                        EvaluationList evalDTO = new EvaluationList(professor: professor, evaluator: chairperson, schoolYear: sy, semester: semester, active: true)
                        if(!evalDTO.save(flush: true)){
                            message = "An error has occured while saving evaluation list!"
                            model.success = false
                        }
                    }
                }

            }

            flash.message = message
            render view: '/peerListMaintenance/view', model: model

        }.invalidToken {
            redirect action: 'view', params: [admin:true]
        }
    }
}
