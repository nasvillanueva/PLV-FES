import edu.plv.fes.*
import edu.plv.fes.constants.FESConstants
import groovy.sql.Sql
import org.apache.shiro.crypto.hash.Sha512Hash
import grails.util.Environment

import static edu.plv.fes.utils.DiacriticsRemover.*

class BootStrap {
    def dataSource
    def dataSource_PLVSys
    def init = { servletContext ->

        switch(Environment.current){
            case Environment.DEVELOPMENT:
                log.info('Bootstrap initializing...')

                def ec1 = new EvaluationCategory(description: 'Teaching Competence', percentage:0.5, catIndex: 'A', active: true)
                def ec2 = new EvaluationCategory(description: 'Compliance with Administrative Requirements', percentage:0.3, catIndex: 'B', active: true)
                def ec3 = new EvaluationCategory(description: 'Attitude and Values', percentage:0.2, catIndex: 'C', active: true)
                def ec4 = new EvaluationCategory(description: 'Faculty Relationships', percentage:0, catIndex: 'D', active: true)
                def ec5 = new EvaluationCategory(description: 'Faculty Attitude Towards Work', percentage:0, catIndex: 'E', active: true)
                ec1.addToEvaluator(FESConstants.USER_TYPE_STUDENT)
                    .addToEvaluator(FESConstants.USER_TYPE_CHAIR)
                    .addToEvaluator(FESConstants.USER_TYPE_SUPER)
                ec1.save(flush: true)
                ec2.addToEvaluator(FESConstants.USER_TYPE_STUDENT)
                        .addToEvaluator(FESConstants.USER_TYPE_CHAIR)
                        .addToEvaluator(FESConstants.USER_TYPE_SUPER)
                ec2.save(flush: true)
                ec3.addToEvaluator(FESConstants.USER_TYPE_STUDENT)
                        .addToEvaluator(FESConstants.USER_TYPE_CHAIR)
                        .addToEvaluator(FESConstants.USER_TYPE_SUPER)
                ec3.save(flush: true)
                ec4.addToEvaluator(FESConstants.USER_TYPE_CHAIR)
                        .addToEvaluator(FESConstants.USER_TYPE_SUPER)
                ec4.save(flush: true)
                ec5.addToEvaluator(FESConstants.USER_TYPE_CHAIR)
                        .addToEvaluator(FESConstants.USER_TYPE_SUPER)
                ec5.save(flush: true)



                def qA1 = new EvaluationQuestion(evaluationCategory: ec1, question: 'Knows the subject matter well and comes to class prepared for the lessons', active: true)
                def qA2 = new EvaluationQuestion(evaluationCategory: ec1, question: 'Implements course objectives as given in syllabi', active: true)
                def qA3 = new EvaluationQuestion(evaluationCategory: ec1, question: 'Uses varied effective and innovative strategies of teaching', active: true)
                def qA4 = new EvaluationQuestion(evaluationCategory: ec1, question: 'Explains lesson in an interesting and challenging way', active: true)
                def qA5 = new EvaluationQuestion(evaluationCategory: ec1, question: 'Encourages students’ participation / involvement in class / area discussion / activities', active: true)
                def qA6 = new EvaluationQuestion(evaluationCategory: ec1, question: 'Selects a wide variety of materials of instruction to meet the needs and abilities of students', active: true)
                def qA7 = new EvaluationQuestion(evaluationCategory: ec1, question: 'Records and interprets test results properly for remediation', active: true)
                def qA8 = new EvaluationQuestion(evaluationCategory: ec1, question: 'Translates concepts learned in the classroom to life’s realities', active: true)
                qA1.save(flush: true)
                qA2.save(flush: true)
                qA3.save(flush: true)
                qA4.save(flush: true)
                qA5.save(flush: true)
                qA6.save(flush: true)
                qA7.save(flush: true)
                qA8.save(flush: true)

                def qB1 = new EvaluationQuestion(evaluationCategory: ec2, question: 'Submits grade reports promptly', active: true)
                def qB2 = new EvaluationQuestion(evaluationCategory: ec2, question: 'Comes to class regularly and punctually', active: true)
                def qB3 = new EvaluationQuestion(evaluationCategory: ec2, question: 'Provides course outline / syllabus', active: true)
                def qB4 = new EvaluationQuestion(evaluationCategory: ec2, question: 'Does not impose unauthorized collections', active: true)
                def qB5 = new EvaluationQuestion(evaluationCategory: ec2, question: 'Brings to class updated knowledge through continuous professional enhancement / advancement', active: true)
                def qB6 = new EvaluationQuestion(evaluationCategory: ec2, question: 'Shares to class the most recent research findings from seminars and trainings attended', active: true)
                def qB7 = new EvaluationQuestion(evaluationCategory: ec2, question: 'Participates actively in student-related program and activities', active: true)
                def qB8 = new EvaluationQuestion(evaluationCategory: ec2, question: 'Applies grading system with fairness and objectivity', active: true)
                qB1.save(flush: true)
                qB2.save(flush: true)
                qB3.save(flush: true)
                qB4.save(flush: true)
                qB5.save(flush: true)
                qB6.save(flush: true)
                qB7.save(flush: true)
                qB8.save(flush: true)

                def qC1 = new EvaluationQuestion(evaluationCategory: ec3, question: 'Respects students\' ideas and opinions', active: true)
                def qC2 = new EvaluationQuestion(evaluationCategory: ec3, question: 'Observes propriety and good taste in language', active: true)
                def qC3 = new EvaluationQuestion(evaluationCategory: ec3, question: 'Establishes good rapport with students', active: true)
                def qC4 = new EvaluationQuestion(evaluationCategory: ec3, question: 'Observes appropriate grooming', active: true)
                def qC5 = new EvaluationQuestion(evaluationCategory: ec3, question: 'Maintains dignity and respect in dealing with students by not using the position to advantage', active: true)
                def qC6 = new EvaluationQuestion(evaluationCategory: ec3, question: 'Performs tasks cheerfully and willingly', active: true)
                def qC7 = new EvaluationQuestion(evaluationCategory: ec3, question: 'Sympathetic and sensitive to students’ personal and academic problems', active: true)
                def qC8 = new EvaluationQuestion(evaluationCategory: ec3, question: 'Inculcates social responsibilities in terms of morals, values and character', active: true)
                qC1.save(flush: true)
                qC2.save(flush: true)
                qC3.save(flush: true)
                qC4.save(flush: true)
                qC5.save(flush: true)
                qC6.save(flush: true)
                qC7.save(flush: true)
                qC8.save(flush: true)

                def qD1 = new EvaluationQuestion(evaluationCategory: ec4, question: 'Observes the code of ethics for teachers (with Fellow Faculty Members)', active: true)
                def qD2 = new EvaluationQuestion(evaluationCategory: ec4, question: 'Has pleasant personality and gets along well with others (with Fellow Faculty Members)', active: true)
                def qD3 = new EvaluationQuestion(evaluationCategory: ec4, question: 'Shows cooperation in faculty affairs (with Fellow Faculty Members)', active: true)
                def qD4 = new EvaluationQuestion(evaluationCategory: ec4, question: 'Maintains healthy relationships with academic and non-academic personnel (with Fellow Faculty Members)', active: true)
                def qD5 = new EvaluationQuestion(evaluationCategory: ec4, question: 'Shows fair judgment and respect to co-workers (with Fellow Faculty Members)', active: true)
                def qD6 = new EvaluationQuestion(evaluationCategory: ec4, question: 'Maintains good relationship with the administration (with the Administration)', active: true)
                def qD7 = new EvaluationQuestion(evaluationCategory: ec4, question: 'Adheres to office rules and regulations (with the Administration)', active: true)
                def qD8 = new EvaluationQuestion(evaluationCategory: ec4, question: 'Exhibits loyalty to the administration / organization (with the Administration)', active: true)
                qD1.save(flush: true)
                qD2.save(flush: true)
                qD3.save(flush: true)
                qD4.save(flush: true)
                qD5.save(flush: true)
                qD6.save(flush: true)
                qD7.save(flush: true)
                qD8.save(flush: true)

                def qE1 = new EvaluationQuestion(evaluationCategory: ec5, question: 'Renders quality and timely compliance with the academic requirements of the University', active: true)
                def qE2 = new EvaluationQuestion(evaluationCategory: ec5, question: 'Makes himself available to students and other important matters beyond official teaching hours', active: true)
                def qE3 = new EvaluationQuestion(evaluationCategory: ec5, question: 'Welcomes changes and shows high regard for his job', active: true)
                qE1.save(flush: true)
                qE2.save(flush: true)
                qE3.save(flush: true)

                def int1 = new Interpretation(scale: 5, rating: 'Excellent', description: 'Far above and beyond the expected performance', active: true)
                def int2 = new Interpretation(scale: 4, rating: 'Very Good', description: 'Above the expected performance', active: true)
                def int3 = new Interpretation(scale: 3, rating: 'Good', description: 'Satisfactory to the level of performance', active: true)
                def int4 = new Interpretation(scale: 2, rating: 'Fair', description: 'Slightly below the expected level of performance', active: true)
                def int5 = new Interpretation(scale: 1, rating: 'Poor', description: 'Below the expected level of performance', active: true)
                int1.save(flush: true)
                int2.save(flush: true)
                int3.save(flush: true)
                int4.save(flush: true)
                int5.save(flush: true)


                def r1 = new FESRole(name: 'Super User',description:'Administrator with all access')
                r1.addToPermissions('*:*')
                r1.save(flush: true)



                def superuser = new FESUser(username: 'super_user',passwordHash: new Sha512Hash('qwerty').toHex(),usertype: FESConstants.USER_TYPE_ADMIN, firstname: 'Super', surname: 'User')
                superuser.addToRoles(r1)
                superuser.save(flush:true)

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
                        "and SY_ = 2013 and SEMESTER_ = '1'"
                def db = new Sql(dataSource_PLVSys)
                def res = db.rows(qry)
                res.each { stud ->
                    def student = new FESUser(username: stud.username, passwordHash: new Sha512Hash(removeAccents(stud.password).replaceAll(~/\s|\W/,'').toLowerCase()).toHex(), section: stud.section,usertype:FESConstants.USER_TYPE_STUDENT)
                    student.addToPermissions(FESConstants.PERM_STUDENT_EVAL)
                    student.addToPermissions(FESConstants.PERM_STUDENT_LIST)
                    student.save(flush: true)
                }

                qry = "SELECT [ID] as 'id'\n" +
                        ",[First Name] as 'fname',[Middle Name] as 'mname' ,[Last Name] as 'sname'\n" +
                        ",[ACTIVE] as 'active'\n" +
                        "FROM [PLV System].[dbo].[vw_Prof]\n" +
                        "WHERE [Last Name] NOT IN ('','-') AND [First Name] NOT IN ('','-')\n" +
                        "ORDER BY [Last Name] ASC"
                res = db.rows(qry)
                res.each { prof ->
                    def currentProf = Professor.findByInstructorId(prof.id)
                    if (!currentProf) {
                        def professor = new Professor(instructorId: prof.id, firstname: prof.fname,middlename: prof.mname,surname: prof.sname)
                        professor.save(flush: true)
                    } else {
                        currentProf.save()
                    }
                }

                def ra1 = new Ranking(rankName: 'Instructor I',active:true)
                def ra2 = new Ranking(rankName: 'Instructor II',active:true)
                def ra3 = new Ranking(rankName: 'Instructor III',active:true)
                def ra4 = new Ranking(rankName: 'Assistant Professor I',active:true)
                def ra5 = new Ranking(rankName: 'Assistant Professor II',active:true)
                def ra6 = new Ranking(rankName: 'Assistant Professor III',active:true)
                def ra7 = new Ranking(rankName: 'Assistant Professor IV',active:true)
                def ra8 = new Ranking(rankName: 'Associate Professor I',active:true)
                def ra9 = new Ranking(rankName: 'Associate Professor II',active:true)
                def ra10 = new Ranking(rankName: 'Associate Professor III',active:true)
                def ra11 = new Ranking(rankName: 'Associate Professor IV',active:true)
                def ra12 = new Ranking(rankName: 'Associate Professor V',active:true)
                def ra13 = new Ranking(rankName: 'Associate Professor VI',active:true)
                def ra14 = new Ranking(rankName: 'Professor I',active:true)
                def ra15 = new Ranking(rankName: 'Professor II',active:true)
                def ra16 = new Ranking(rankName: 'Professor III',active:true)
                def ra17 = new Ranking(rankName: 'Professor IV',active:true)
                def ra18 = new Ranking(rankName: 'Professor V',active:true)
                def ra19 = new Ranking(rankName: 'Professor VI',active:true)
                def ra20 = new Ranking(rankName: 'College Professor',active:true)
                def ra21 = new Ranking(rankName: 'University Professor',active:true)
                [ra1,ra2,ra3,ra4,ra5,ra6,ra7,ra8,ra9,ra10]*.save(flush:true)
                [ra11,ra12,ra13,ra14,ra15,ra16,ra17,ra18,ra19,ra20,ra21]*.save(flush:true)

                qry = "SELECT distinct(section_) as 'section', ins_id as 'prof_id'  FROM [PLV System].[dbo].[vw_StudListSubj]\n" +
                        "WHERE SEMESTER_ <> 'S' AND SEMESTER_ = '1' AND SY_ = 2013\n" +
                        "ORDER BY ins_id ASC"
                res = db.rows(qry)
                res.each { sched ->
                    def prof = Professor.findByInstructorId(sched.prof_id)
                    def studentSched = new StudentSchedule(professor: prof, section: sched.section)
                    studentSched.save(flush: true)
                }

                SystemConfiguration sc1 = new SystemConfiguration(configName: 'semester',configValue: 1)
                sc1.save(flush:true)
                SystemConfiguration sc2 = new SystemConfiguration(configName: 'schoolyear',configValue: 2013)
                sc2.save(flush:true)
                SystemConfiguration sc3 = new SystemConfiguration(configName: 'respondentLimit',configValue: 50)
                sc3.save(flush:true)

                College c1 = new College(collegeName: 'College of Business Administration and Accountancy',active:true);
                College c2 = new College(collegeName: 'College of Public Administration',active:true);
                College c3 = new College(collegeName: 'College of Education',active:true);
                College c4 = new College(collegeName: 'College of Engineering and Information Technology',active:true);
                College c5 = new College(collegeName: 'College of Arts and Sciences',active:true);
                c1.save(flush: true)
                c2.save(flush: true)
                c3.save(flush: true)
                c4.save(flush: true)
                c5.save(flush: true)

                Department d1 = new Department(departmentName: 'Languages (English Stream) Department',active: true);
                Department d2 = new Department(departmentName: 'Languages (Filipino Stream) Department',active: true);
                Department d3 = new Department(departmentName: 'Science Department',active: true);
                Department d4 = new Department(departmentName: 'Social Sciences Department',active: true);
                Department d5 = new Department(departmentName: 'Mathematics Department',active: true);
                Department d6 = new Department(departmentName: 'Early Childhood and Elementary Education Department',active: true);
                Department d7 = new Department(departmentName: 'Communication Studies Department',active: true);
                Department d8 = new Department(departmentName: 'Physical Education Department',active: true);
                Department d9 = new Department(departmentName: 'Electrical Engineering Department',active: true);
                Department d10 = new Department(departmentName: 'Civil Engineering Department',active: true);
                Department d11 = new Department(departmentName: 'Information Technology Department',active: true);
                Department d12 = new Department(departmentName: 'Psychology Department',active: true);
                Department d13 = new Department(departmentName: 'Social Work Department',active: true);
                Department d14 = new Department(departmentName: 'NSTP Department',active: true);
                Department d15 = new Department(departmentName: 'Accountancy Department',active: true);
                Department d16 = new Department(departmentName: 'Human Resource Management Department',active: true);
                Department d17 = new Department(departmentName: 'Marketing Mangement Department',active: true);
                Department d18 = new Department(departmentName: 'Financial Management Department',active: true);
                Department d19 = new Department(departmentName: 'Public Administration Department',active: true);
                d1.save(flush:true)
                d2.save(flush:true)
                d3.save(flush:true)
                d4.save(flush:true)
                d5.save(flush:true)
                d6.save(flush:true)
                d7.save(flush:true)
                d8.save(flush:true)
                d9.save(flush:true)
                d10.save(flush:true)
                d11.save(flush:true)
                d12.save(flush:true)
                d13.save(flush:true)
                d14.save(flush:true)
                d15.save(flush:true)
                d16.save(flush:true)
                d17.save(flush:true)
                d18.save(flush:true)
                d19.save(flush:true)

                def chairperson = new FESUser(username: 'chair_person',passwordHash: new Sha512Hash('qwerty').toHex(),usertype: FESConstants.USER_TYPE_CHAIR, firstname: 'Chair', surname: 'Person',department: d11)
                chairperson.addToPermissions(FESConstants.PERM_CHAIR_EVAL)
                chairperson.addToPermissions(FESConstants.PERM_CHAIR_LIST)
                chairperson.save(flush:true)

                def supervisor = new FESUser(username: 'super_visor',passwordHash: new Sha512Hash('qwerty').toHex(),usertype: FESConstants.USER_TYPE_SUPER, firstname: 'Super', surname: 'Visor')
                supervisor.addToPermissions(FESConstants.PERM_SUPER_EVAL)
                supervisor.addToPermissions(FESConstants.PERM_SUPER_LIST)
                supervisor.save(flush:true)

                //Chairpersons department
                def sirAps = Professor.findByFirstnameIlikeAndSurnameIlike('rommel','apostol')
                if(sirAps){
                    sirAps.salutation = 'Mr.'
                    sirAps.college = c4
                    sirAps.department = d11
                    sirAps.save(flush:true)
                }
                def sirPat = Professor.findByFirstnameIlikeAndSurnameIlike('patrick','francisco')
                if(sirPat){
                    sirPat.salutation = 'Mr.'
                    sirPat.college = c4
                    sirPat.department = d11
                    sirPat.save(flush:true)
                }
                def sirGuinto = Professor.findByFirstnameIlikeAndSurnameIlike('roberto','guinto')
                if(sirGuinto){
                    sirGuinto.salutation = 'Mr.'
                    sirGuinto.college = c4
                    sirGuinto.department = d11
                    sirGuinto.save(flush:true)
                }
                def sirJames = Professor.findByFirstnameIlikeAndSurnameIlike('rio james','de guzman')
                if(sirJames){
                    sirJames.salutation = 'Mr.'
                    sirJames.college = c4
                    sirJames.department = d11
                    sirGuinto.save(flush:true)
                }


                def sirCYA = Professor.findByFirstnameIlikeAndSurnameIlike('CHRISTIAN AMIEL'.toLowerCase(),'NARCISO'.toLowerCase())
                if(sirCYA){
                    sirCYA.salutation = 'Mr.'
                    sirCYA.college = c3
                    sirCYA.department = d1
                    sirCYA.save(flush:true)
                }

                def mamAnj = Professor.findByFirstnameIlikeAndSurnameIlike('ANGELA MAE'.toLowerCase(),'HERRERA'.toLowerCase())
                if(mamAnj){
                    mamAnj.salutation = 'Ms.'
                    mamAnj.college = c5
                    mamAnj.department = d7
                    mamAnj.save(flush:true)
                }

                def mamVillena = Professor.findByFirstnameIlikeAndSurnameIlike('ANGELECA'.toLowerCase(),'VILLENA'.toLowerCase())
                if(mamVillena){
                    mamVillena.salutation = 'Mrs.'
                    mamVillena.college = c1
                    mamVillena.department = d16
                    mamVillena.save(flush:true)
                }
                def mamJulai = Professor.findByFirstnameIlikeAndSurnameIlike('JULAI'.toLowerCase(),'SANTOS'.toLowerCase())
                if(mamJulai){
                    mamJulai.salutation = 'Mrs.'
                    mamJulai.college = c3
                    mamJulai.department = d3
                    mamJulai.save(flush:true)
                }

                def mamRazon = Professor.findByFirstnameIlikeAndSurnameIlike('ESPER'.toLowerCase(),'RAZON'.toLowerCase())
                if(mamRazon){
                    mamRazon.salutation = 'Mrs.'
                    mamRazon.college = c5
                    mamRazon.department = d4
                    mamRazon.save(flush:true)
                }

                def mamJanet = Professor.findByFirstnameIlikeAndSurnameIlike('JANET'.toLowerCase(),'MANGABANG'.toLowerCase())
                if(mamJanet){
                    mamJanet.salutation = 'Ms.'
                    mamJanet.college = c3
                    mamJanet.department = d2
                    mamJanet.save(flush:true)
                }

                def sirErnest = Professor.findByFirstnameIlikeAndSurnameIlike('ERNESTO'.toLowerCase(),'YLASCO'.toLowerCase())
                if(sirErnest){
                    sirErnest.salutation = 'Mr.'
                    sirErnest.college = c3
                    sirErnest.department = d6
                    sirErnest.save(flush:true)
                }

                def sirPoja = Professor.findByFirstnameIlikeAndSurnameIlike('ARNEL'.toLowerCase(),'POJA'.toLowerCase())
                if(sirPoja){
                    sirPoja.salutation = 'Mr.'
                    sirPoja.college = c3
                    sirPoja.department = d5
                    sirPoja.save(flush:true)
                }

                def mamShammy = Professor.findByFirstnameIlikeAndSurnameIlike('SHAMMY ROSE'.toLowerCase(),'SANTIAGO'.toLowerCase())
                if(mamShammy){
                    mamShammy.salutation = 'Mrs.'
                    mamShammy.college = c3
                    mamShammy.department = d1
                    mamShammy.save(flush:true)
                }

                def mamNancy = Professor.findByFirstnameIlikeAndSurnameIlike('NANCY HIRA'.toLowerCase(),'LIM'.toLowerCase())
                if(mamNancy){
                    mamNancy.salutation = 'Mrs.'
                    mamNancy.college = c3
                    mamNancy.department = d1
                    mamNancy.save(flush:true)
                }

                log.info('Bootstrap initialization finished!')
                break;
        }
    }
    def destroy = {
    }
}
