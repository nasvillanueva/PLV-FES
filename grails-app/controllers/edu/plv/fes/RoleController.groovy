package edu.plv.fes

import edu.plv.fes.constants.FESConstantMaps
import edu.plv.fes.constants.FESConstants
import edu.plv.fes.utils.RoleParser
import grails.converters.JSON

class RoleController {

    def roleService

    static defaultAction = "view"

    def view() {
        render view: '/role/view', model:[moduleMaps: FESConstantMaps.allModules, permPrefix: FESConstantMaps.allPermPrefix]
    }

    def viewRoleList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = roleService.getAllRole(offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render  res as JSON
    }

    def viewRole(){
        def role = FESRole.get(params?.id)
        def rights = []
        roleService.dividePermissionString(role.permissions,rights)
        def jsonData = [id:role.id, name:role.name, description: role.description, active:role.active,rights:rights]
        render jsonData as JSON
    }

    def addRole(){
        withForm{
            def model = [moduleMaps: FESConstantMaps.allModules, permPrefix: FESConstantMaps.allPermPrefix,success:true]
            def message = null
            if(!FESRole.findByName(params?.role_name)){
                FESRole role = new FESRole()
                role.name = params?.role_name
                role.description = params?.role_description
                role.active = params.role_active == 'on'

                def rightsHolder = []
                RoleParser.createPermissionString(FESConstantMaps.allModules,params,rightsHolder)

                rightsHolder.each() {
                    role.addToPermissions(it)
                }

                if(role.save(flush:true)){
                    message = '\"' + role.name + '\" successfully added!'
                }else{
                    model.success = false
                    message = 'There was a problem adding \"' + params.role_name + '\". Try submitting the form again.'
                    model.role = role
                }
            }else{
                model.success = false
                message = '\"' + params.role_name + '\" already exists!'
            }

            flash.message = message
            render view: '/role/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }
    def editRole(){
        withForm{
            def model = [moduleMaps: FESConstantMaps.allModules, permPrefix: FESConstantMaps.allPermPrefix,success:true]
            def message = null
            FESRole role = FESRole.get(params?.role_id)
            if(role?.name != params?.role_name) {
                def byName = FESRole.findAllByName(params?.role_name)
                if (byName.size() > 0) {
                    model.success = false
                    message = '\"' + params?.role_name + '\" already exists!'
                }else{
                    role.name = params?.role_name
                }
            }

            if(model.success){
                role.description = params?.role_description
                role.active = params.role_active == 'on'
                def rightsHolder = []
                RoleParser.createPermissionString(FESConstantMaps.allModules,params,rightsHolder)
                if(rightsHolder) {
                    role.permissions.clear()
                    rightsHolder.each() {
                        role.addToPermissions(it)
                    }
                }
                if(role.save(flush:true)){
                    message = '\"' + params.role_name + '\" successfully updated!'
                }else{
                    model.success = false
                    message = 'There was a problem updating \"' + params.role_name + '\". Try submitting the form again.'
                    model.role = role
                }
            }

            flash.message = message
            render view: '/role/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }
}
