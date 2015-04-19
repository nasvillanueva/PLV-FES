package edu.plv.fes

class Professor {

    static constraints = {
        department nullable: true
        college nullable: true
        ranking nullable: true
        salutation nullable: true, inList: ['Mr.','Ms.','Mrs.','Dr.','Engr.','Atty.']
    }

    String id
    int instructorId
    String salutation
    String firstname
    String middlename
    String surname
    College college
    Department department
    Ranking ranking
    boolean active = true
    Date dateCreated
    Date lastUpdated

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_professor'
    }
    static auditable = true
    static transients = ['tableDisplay']

    String toString() {
        firstname + " " + middlename + " " + surname
    }

    def getTableDisplay(){
        return [
                DT_RowId: id,
                id: id,
                name: toString(),
                ranking: ranking?.rankName ?: '',
                department: department?.departmentName ?: '',
                college: college?.collegeName ?: '',
                active: active ? 'Yes' : 'No'
        ]
    }

}
