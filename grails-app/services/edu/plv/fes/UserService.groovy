package edu.plv.fes

import edu.plv.fes.constants.FESConstants
import grails.transaction.Transactional

@Transactional
class UserService {

    def getAllUsers(offset, max) {
        def u = FESUser.createCriteria()
        def users = u.list(max:max,offset:offset){
            ne 'usertype',FESConstants.USER_TYPE_STUDENT
            order 'surname','asc'
        }
        def display = users.collect {it.tableDisplay}
        return [totalCount: users.totalCount, display: display]
    }

    def getAllChairperson(params,offset, max){
        def globalSearch = ('%' + params?.get('search[value]') + '%').toLowerCase()
        def department = Department.findAllByDepartmentNameIlike(globalSearch)
        def u = FESUser.createCriteria()
        def users = u.list(){
            eq 'usertype',FESConstants.USER_TYPE_CHAIR
            if(params?.get('search[value]')){
                or{
                    ilike 'firstname',globalSearch
                    ilike 'surname',globalSearch
                    if(department){
                        inList 'department', department
                    }
                }
            }
            order 'surname', 'ASC'
        }
        def newMax = (offset+max < users.size()) ? offset+max : users.size()
        def display = users.subList(offset,newMax).collect {it.tableDisplayChairperson}
        return [totalCount: users.size(), display: display]
    }

    def getAllSupervisor(params,offset, max){
        def globalSearch = ('%' + params?.get('search[value]') + '%').toLowerCase()
        def u = FESUser.createCriteria()
        def users = u.list(){
            eq 'usertype',FESConstants.USER_TYPE_SUPER
            if(params?.get('search[value]')){
                or{
                    ilike 'firstname',globalSearch
                    ilike 'surname',globalSearch
                }
            }
            order 'surname','ASC'
        }
        def newMax = (offset+max < users.size()) ? offset+max : users.size()
        def display = users.subList(offset,newMax).collect {it.tableDisplayChairperson}
        return [totalCount: users.size(), display: display]
    }
}
