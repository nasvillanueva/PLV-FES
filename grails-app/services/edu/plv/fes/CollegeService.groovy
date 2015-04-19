package edu.plv.fes

import grails.transaction.Transactional

@Transactional
class CollegeService {

    def getAllCollege(offset, max) {
        def c = College.createCriteria()
        def college = c.list(max:max,offset:offset){
            order 'collegeName', 'ASC'
        }
        def display = college.collect {it.tableDisplay}
        return [totalCount: college.totalCount, display: display]
    }
    
    def getAllActiveCollegeForSelect(){
        return College.withCriteria {
            eq('active',true)
            order 'collegeName','asc'
        }
    }
}
