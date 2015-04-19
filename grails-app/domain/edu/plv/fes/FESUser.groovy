package edu.plv.fes

import edu.plv.fes.constants.FESConstants

class FESUser {
    String id
    String username
    String passwordHash
    String usertype //Administrator, Chairperson ,Student
    boolean active = true

    //For Student
    String section
    //For Chairperson
    Department department
    //For Admin and Chairperson
    String firstname
    String surname
    
    static hasMany = [ roles: FESRole, permissions: String ]
    static transients = ['tableDisplay','tableDisplayChairperson','tableDisplaySupervisor']
    static auditable = true

    static constraints = {
        username(nullable: false, blank: false, unique: true)
        section(nullable:true,blank:true)
        department(nullable:true,blank:false)
        firstname(nullable:true)
        surname(nullable:true)
    }

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_user'
    }

    String toString(){
        String str = ""
        if(usertype == FESConstants.USER_TYPE_ADMIN || usertype == FESConstants.USER_TYPE_CHAIR || usertype == FESConstants.USER_TYPE_SUPER){
            if(firstname && surname){
                str = firstname.toLowerCase().capitalize() + ' ' + surname.toLowerCase().capitalize()
            }
        }
        if(usertype == FESConstants.USER_TYPE_STUDENT)
            str = "Student"

        return str
    }

    def getTableDisplay(){
        return [
                DT_RowId: id,
                id: id,
                username: username,
                name: this.toString(),
                usertype: usertype,
                role: roles?.name ?: "N/A", //FESConstants.USER_TYPE_EVAL,
                department: department?.departmentName ?: "N/A", //usertype == FESConstants.USER_TYPE_ADMIN ? FESConstants.USER_TYPE_ADMIN : FESConstants.USER_TYPE_SUPER,
                active: (active) ? 'Yes':'No'
        ]
    }

    def getTableDisplayChairperson(){
        return [
                DT_RowId: id,
                id: id,
                name: this.toString(),
                department: department?.departmentName ?: "N/A" //usertype == FESConstants.USER_TYPE_ADMIN ? FESConstants.USER_TYPE_ADMIN : FESConstants.USER_TYPE_SUPER,
        ]
    }
    def getTableDisplaySupervisor(){
        return [
                DT_RowId: id,
                id: id,
                name: this.toString()
        ]
    }
}
