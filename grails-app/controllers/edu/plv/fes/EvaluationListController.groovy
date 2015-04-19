package edu.plv.fes

import grails.converters.JSON

class EvaluationListController {
    def evaluationListService

    static defaultAction = "view"

    def view() {
        def availableProf = evaluationListService.getEvaluationList()
        render view: '/evaluationList/view', model: [availableProf: availableProf]
    }
}
