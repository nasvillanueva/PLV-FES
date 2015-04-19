package edu.plv.fes

class StudentSchedule {

    static constraints = {
    }

    String id
    Professor professor
    String section

    static mapping = {
        id generator: 'guid'
        table name: 'tbl_studentSched'
    }
    static auditable = true

    String toString() {
        section
    }
}
