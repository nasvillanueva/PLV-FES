package edu.plv.fes

import edu.plv.fes.constants.FESConstants
import grails.converters.JSON
import groovy.sql.Sql
import org.apache.shiro.crypto.hash.Sha512Hash

import static edu.plv.fes.utils.DiacriticsRemover.removeAccents

class SystemConfigurationController {

    def dataSource_PLVSys

    def editSysConf(){
        def schoolYear = SystemConfiguration.findByConfigName("schoolyear")
        schoolYear.configValue = params?.int("schoolYear")
        schoolYear.save(flush:true)
        def semester = SystemConfiguration.findByConfigName("semester")
        semester.configValue = params?.int("semester")
        semester.save(flush:true)

        redirect uri: params.redirectUri
    }
    def editRespondentLimit(){
        def limit = SystemConfiguration.findByConfigName("respondentLimit")
        limit.configValue = params?.int("limiter")
        limit.save(flush:true)

        redirect uri: params.redirectUri
    }

    def editSyncProfessor(){
        def pass = true
        try{
            def professors = Professor.list().instructorId
            def db = new Sql(dataSource_PLVSys)
            def qry = "SELECT [ID] as 'id'\n" +
                    ",[First Name] as 'fname',[Middle Name] as 'mname' ,[Last Name] as 'sname'\n" +
                    ",[ACTIVE] as 'active'\n" +
                    "FROM [PLV System].[dbo].[vw_Prof]\n" +
                    "WHERE [Last Name] IS NOT NULL AND [Last Name] NOT IN ('','-') AND [First Name] IS NOT NULL AND [First Name] NOT IN ('','-')\n"
            if(professors){
                qry += "and [ID] NOT IN ( "
                professors.each {
                    qry += it + ","
                }
                qry = qry.substring(0,qry.lastIndexOf(',')) + ')'
            }
            qry += " ORDER BY [Last Name] ASC"
            def res = db.rows(qry)

            res.each { prof ->
                if(pass){
                    def professor = new Professor(instructorId: prof.id, firstname: prof.fname,middlename: prof.mname,surname: prof.sname)
                    if(!professor.save(flush: true)){
                        pass = false
                    }
                }
            }
        }catch(Exception e){
            pass = false
        }
        def result = [success:pass]
        render result as JSON
    }

    def editSyncStudent(){
        def pass = true
        try{
            EvaluationList.withCriteria {
                createAlias('evaluator','e')
                eq 'e.usertype',FESConstants.USER_TYPE_STUDENT
            }*.delete(flush:true)

            def qry = "SELECT a.[Student No] as 'username'\n" +
                    ",a.[Last Name] as 'password'\n" +
                    ",a.[SECTION_] as 'section'\n" +
                    "FROM [PLV System].[dbo].[vw_StudSyLvl] a\n" +
                    "left join [PLV System].[dbo].[vw_StudInfo] b\n" +
                    "ON a.[stud_id] = b.[ID]\n" +
                    "where\n" +
                    "b.[Graduate] <> 1\n" +
                    "and b.[Active] = 1 \n" +
                    "and SEMESTER_ <> 'S' \n" +
                    "and SY_ = " + SystemConfiguration.findByConfigName("schoolyear").configValue +
                    "  and SEMESTER_ = '" + SystemConfiguration.findByConfigName("semester").configValue + "'"
            def db = new Sql(dataSource_PLVSys)
            def res = db.rows(qry)
            res.each { stud ->
                if(pass){
                    def student
                    if(!FESUser.findByUsername(stud.username)){
                        student = new FESUser(username: stud.username, passwordHash: new Sha512Hash(removeAccents(stud.password.toString()).replaceAll(~/\s|\W/,'').toLowerCase()).toHex(), section: stud.section,usertype:FESConstants.USER_TYPE_STUDENT)
                        student.addToPermissions(FESConstants.PERM_STUDENT_EVAL)
                        student.addToPermissions(FESConstants.PERM_STUDENT_LIST)
                    }else{
                        student = FESUser.findByUsername(stud.username)
                        student.section = stud.section
                    }
                    if(!student.save(flush: true)){
                        pass = false
                    }
                }
            }
        }catch(Exception e){
            pass = false
        }
        def result = [success:pass]
        render result as JSON
    }

    def editSyncStudentSchedule(){
        def pass = true
        try{
            StudentSchedule.list()*.delete(flush:true)
            def qry = "SELECT distinct(section_) as 'section', ins_id as 'prof_id'  FROM [PLV System].[dbo].[vw_StudListSubj]\n" +
                    "WHERE SEMESTER_ <> 'S' AND SY_ = " + SystemConfiguration.findByConfigName("schoolyear").configValue +
                    " AND SEMESTER_ = '" + SystemConfiguration.findByConfigName("semester").configValue + "'"
            " ORDER BY ins_id ASC"
            def db = new Sql(dataSource_PLVSys)
            def res = db.rows(qry)
            res.each { sched ->
                if(pass){
                    def prof = Professor.findByInstructorId(sched.prof_id)
                    if(prof){
                        def studentSched = new StudentSchedule(professor: prof, section: sched.section)

                        if(!studentSched.save(flush: true)){
                            pass = false
                        }
                    }
                }
            }
        }catch(Exception e){
            pass = false
        }

        def result = [success:pass]
        render result as JSON
    }
}
