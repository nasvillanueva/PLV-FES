package edu.plv.fes

import grails.transaction.Transactional

@Transactional
class DepartmentService {

    def getAllDepartment(offset, max) {
        def d = Department.createCriteria()
        def department = d.list(max:max,offset:offset){
            order 'departmentName','ASC'
        }
        def display = department.collect {it.tableDisplay}
        return [totalCount: department.totalCount, display: display]
    }
    def getAllActiveDepartmentForSelect(){
        return Department.withCriteria {
            eq('active',true)
            order 'departmentName','asc'
        }
    }
}
