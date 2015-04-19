package edu.plv.fes

import edu.plv.fes.constants.FESConstantMaps
import edu.plv.fes.constants.FESConstants
import grails.transaction.Transactional

@Transactional
class RoleService {

    def getAllRole(offset, max) {
        def r = FESRole.createCriteria()
        def role = r.list(max:max,offset:offset){
            order 'name', 'asc'
        }
        def display = role.collect {it.tableDisplay}
        return [totalCount: role.totalCount, display: display]
    }

    def getAllActiveRolesForSelect(){
        return FESRole.withCriteria {
            eq('active',true)
            order 'name','asc'
        }
    }

    def dividePermissionString(rolePermission, permHolder ){
        rolePermission.each{ permString ->
            def permStringSplit = permString.split(":");
            def moduleName = permStringSplit[0];
            String[] rights = permStringSplit[1].split(",");
            rights.each{ perm ->
                if(perm.startsWith(FESConstants.ROLE_VIEW_PREFIX)){
                    permHolder.add("viewRightsX"+moduleName+"X");
                }else if(perm.startsWith(FESConstants.ROLE_ADD_PREFIX)){
                    permHolder.add("addRightsX"+moduleName+"X");
                }else if(perm.startsWith(FESConstants.ROLE_EDIT_PREFIX)){
                    permHolder.add("editRightsX"+moduleName+"X");
                }else if(perm.startsWith(FESConstants.ROLE_DELETE_PREFIX)){
                    permHolder.add("deleteRightsX"+moduleName+"X");
                }
            }
        }
    }
}
