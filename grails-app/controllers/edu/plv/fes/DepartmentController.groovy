package edu.plv.fes

import grails.converters.JSON

class DepartmentController {
    def departmentService

    static defaultAction = "view"

    def view() {
        render view: '/department/view'
    }

    def viewDepartmentList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = departmentService.getAllDepartment(offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render  res as JSON
    }

    def viewDepartment(){
        def department = Department.get(params?.id)
        def jsonData = [id:department.id, name:department.departmentName, active:department.active]
        render jsonData as JSON
    }

    def addDepartment(){
        withForm{
            def model = [success:true]
            def message = null
            if(!Department.findByDepartmentName(params.dept_name)){
                Department department = new Department()
                department.departmentName = params.dept_name
                department.active = params.dept_active == 'on'
                if(department.save(flush:true)){
                    message = '\"' + params.dept_name + '\" successfully added!'
                }else{
                    model.success = false
                    message = 'There was a problem adding \"' + params.dept_name + '\". Try submitting the form again.'
                    model.department = department
                }
            }else{
                model.success = false
                message = '\"' + params.dept_name + '\" already exists!'
            }

            flash.message = message
            render view: '/department/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }

    def editDepartment(){
        withForm{
            def model = [success:true]
            def message = null
            Department department = Department.get(params?.dept_id)
            if(department?.departmentName != params?.dept_name) {
                def byName = Department.findAllByDepartmentName(params?.dept_name)
                if (byName.size() > 0) {
                    model.success = false
                    message = '\"' + params?.dept_name + '\" already exists!'
                }else{
                    department.departmentName = params?.dept_name
                }
            }

            if(model.success){
                department.active = params.dept_active == 'on'
                if(department.save(flush:true)){
                    message = '\"' + params.dept_name + '\" successfully updated!'
                }else{
                    model.success = false
                    message = 'There was a problem updating \"' + params.dept_name + '\". Try submitting the form again.'
                    model.department = department
                }
            }

            flash.message = message
            render view: '/department/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }
}
