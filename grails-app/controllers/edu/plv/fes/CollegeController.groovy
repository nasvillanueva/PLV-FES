package edu.plv.fes

import grails.converters.JSON

class CollegeController {
    def collegeService

    static defaultAction = "view"

    def view() {
        render view: '/college/view'
    }

    def viewCollegeList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = collegeService.getAllCollege(offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render  res as JSON
    }

    def viewCollege(){
        def college = College.get(params?.id)
        def jsonData = [id:college.id, name:college.collegeName, active:college.active]
        render jsonData as JSON
    }

    def addCollege(){
        withForm{
            def model = [success:true]
            def message = null
            if(!College.findByCollegeName(params.college_name)){
                College college = new College()
                college.collegeName = params.college_name
                college.active = params.college_active == 'on'
                if(college.save(flush:true)){
                    message = '\"' + params.college_name + '\" successfully added!'
                }else{
                    model.success = false
                    message = 'There was a problem adding \"' + params.college_name + '\". Try submitting the form again.'
                    model.college = college
                }
            }else{
                model.success = false
                message = '\"' + params.college_name + '\" already exists!'
            }

            flash.message = message
            render view: '/college/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }

    def editCollege(){
        withForm{
            def model = [success:true]
            def message = null
            College college = College.get(params?.college_id)
            if(college?.collegeName != params?.college_name) {
                def byName = College.findAllByCollegeName(params?.college_name)
                if (byName.size() > 0) {
                    model.success = false
                    message = '\"' + params?.college_name + '\" already exists!'
                }else{
                    college.collegeName = params?.college_name
                }
            }

            if(model.success){
                college.active = params.college_active == 'on'
                if(college.save(flush:true)){
                    message = '\"' + params.college_name + '\" successfully updated!'
                }else{
                    model.success = false
                    message = 'There was a problem updating \"' + params.college_name + '\". Try submitting the form again.'
                    model.college = college
                }
            }

            flash.message = message
            render view: '/college/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }
}
