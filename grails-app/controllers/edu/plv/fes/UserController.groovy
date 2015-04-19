package edu.plv.fes

import edu.plv.fes.constants.FESConstants
import grails.converters.JSON
import org.apache.shiro.crypto.hash.Sha512Hash

class UserController {

    def userService

    static defaultAction = "view"

    def view() {
        render view: '/user/view'
    }

    def viewUserList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = userService.getAllUsers(offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render  res as JSON
    }

    def viewUser(){
        def user = FESUser.get(params?.id)
        def jsonData = [id:user.id, username:user.username,usertype:user.usertype,firstname:user.firstname,surname:user.surname, active:user.active]
        if(user.usertype == FESConstants.USER_TYPE_CHAIR){
            jsonData.department = user?.department?.id
        }else if(user.usertype == FESConstants.USER_TYPE_ADMIN){
            jsonData.role = user?.roles?.id
        }
        render jsonData as JSON
    }

    def addUser(){
        withForm{
            def model = [success:true]
            def message = null
            if(!FESUser.findByUsername(params.user_username) || (params?.user_type == FESConstants.USER_TYPE_CHAIR && !FESUser.findByDepartmentAndActive(Department.get(params?.user_department),true))){
                FESUser user = new FESUser()
                user.firstname = params?.user_firstname
                user.surname = params?.user_surname
                user.username = params?.user_username
                if(params?.user_password){
                    if(params?.user_password == params?.user_confirm)
                    user.passwordHash = new Sha512Hash(params?.user_password).toHex()
                }
                user.usertype = params?.user_type
                if(user.usertype == FESConstants.USER_TYPE_CHAIR){
                    user.department = Department.get(params?.user_department)
                    user.addToPermissions(FESConstants.PERM_CHAIR_EVAL)
                    user.addToPermissions(FESConstants.PERM_CHAIR_LIST)
                }else if(user.usertype == FESConstants.USER_TYPE_ADMIN){
                    user.addToRoles(FESRole.get(params?.user_role))
                }else if(user.usertype == FESConstants.USER_TYPE_SUPER){
                    user.addToPermissions(FESConstants.PERM_SUPER_EVAL)
                    user.addToPermissions(FESConstants.PERM_SUPER_LIST)
                }
                user.active = params.user_active == 'on'
                if(user.save(flush:true)){
                    message = '\"' + params?.user_username + '\" successfully added!'
                }else{
                    model.success = false
                    message = 'There was a problem adding \"' + params?.user_username + '\". Try submitting the form again.'
                    model.user = user
                }
            }else{
                model.success = false
                message = 'Either \"' + params?.user_username + '\" already exists or Chairperson for the selected department already exists'
            }

            flash.message = message
            render view: '/user/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }

    def editUser(){
        withForm{
            def model = [success:true]
            def message = null
            FESUser user = FESUser.get(params?.user_id)
            if(user?.username != params?.user_username) {
                def byName = FESUser.findAllByUsername(params?.user_username)
                if (byName.size() > 0) {
                    model.success = false
                    message = '\"' + params?.user_username + '\" already exists!'
                }else{
                    user.username = params?.user_username
                }
            }
            if(Department.get(params?.user_department) != user.department && params?.user_type == FESConstants.USER_TYPE_CHAIR && FESUser.findByDepartmentAndActive(Department.get(params?.user_department),true)) {
                model.success = false
                message = 'Chairperson for '+ Department.get(params?.user_department) +' already exists'
            }


            if(model.success){
                user.firstname = params?.user_firstname
                user.surname = params?.user_surname
                if(params?.user_password){
                    if(params?.user_password == params?.user_confirm)
                        user.passwordHash = new Sha512Hash(params?.user_password).toHex()
                }
                user.usertype = params?.user_type
                if(user.usertype == FESConstants.USER_TYPE_CHAIR){
                    user.department = Department.get(params?.user_department)
                    user.roles.clear()
                    user.permissions.clear()
                    user.addToPermissions(FESConstants.PERM_CHAIR_EVAL)
                    user.addToPermissions(FESConstants.PERM_CHAIR_LIST)
                }else if(user.usertype == FESConstants.USER_TYPE_ADMIN){
                    user.department = null
                    user.roles.clear()
                    user.permissions.clear()
                    user.addToRoles(FESRole.get(params?.user_role))
                }else if(user.usertype == FESConstants.USER_TYPE_SUPER){
                    user.department = null
                    user.roles.clear()
                    user.permissions.clear()
                    user.addToPermissions(FESConstants.PERM_SUPER_EVAL)
                    user.addToPermissions(FESConstants.PERM_SUPER_LIST)
                }
                user.active = params.user_active == 'on'
                if(user.save(flush:true)){
                    message = '\"' + params.user_username + '\" successfully updated!'
                }else{
                    model.success = false
                    message = 'There was a problem updating \"' + params.user_username + '\". Try submitting the form again.'
                    model.user = user
                }
            }

            flash.message = message
            render view: '/user/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }
}
