package edu.plv.fes

import grails.converters.JSON

class ProfessorController {

    def professorService

    static defaultAction = "view"

    def view() {
        render view: '/professor/view'
    }

    def viewProfessorList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = professorService.getAllProfessorWithParams(params,offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render  res as JSON
    }

    def viewProfessor(){
        def professor = Professor.get(params?.id)
        def jsonData = [id:professor.id,ranking:professor.ranking?.id?:'', title:professor?.salutation?:'',firstname:professor.firstname,middlename:professor.middlename,surname:professor.surname,college:professor?.college?.id?:'',department:professor?.department?.id?:'',active:professor.active]
        render jsonData as JSON
    }

    def editProfessor(){
        withForm{
            def model = [success:true]
            def message = null
            Professor prof = Professor.get(params?.prof_id)
            if(prof?.toString()?.toLowerCase() != params.firstname.toString().toLowerCase() + ' ' + params.middlename.toString().toLowerCase() + ' ' + params.surname.toString().toLowerCase()) {
                def byName = Professor.withCriteria{
                    ilike 'firstname', params.firstname.toString().toLowerCase()
                    ilike 'middlename', params.middlename.toString().toLowerCase()
                    ilike 'surname', params.surname.toString().toLowerCase()
                }
                if (byName.size() > 0) {
                    model.success = false
                    message = '\"' + params.firstname + ' ' + params.middlename + ' ' + params.surname + '\" already exists!'
                }else{
                    prof.firstname = params?.firstname
                    prof.middlename = params?.middlename
                    prof.surname = params?.surname
                }
            }

            if(model.success){
                prof.active = params?.prof_active == 'on'
                prof.salutation = params?.title
                prof.ranking = Ranking.get(params.ranking)
                prof.college = College.get(params?.college)
                prof.department = Department.get(params?.department)
                if(prof.save(flush:true)){
                    message = '\"' + prof.toString() + '\" successfully updated!'
                }else{
                    model.success = false
                    message = 'There was a problem updating \"' + prof.toString() + '\". Try submitting the form again.'
                    model.prof = prof
                }
            }

            flash.message = message
            render view: '/professor/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }
}
