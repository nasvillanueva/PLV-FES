package edu.plv.fes

import edu.plv.fes.constants.FESConstantMaps
import edu.plv.fes.constants.FESConstants
import grails.converters.JSON

import java.math.RoundingMode
import java.text.DecimalFormat

class ReportsController {

    def evaluationService
    def evaluationQuestionService
    def evaluationCategoryService
    def systemConfigurationService
    def pdfRenderingService
    def reportsService

    static defaultAction = "view"

    def view() {
        def evalYear = []
        Evaluation.withCriteria{
            order 'schoolYear','asc'
            projections{
                distinct 'schoolYear'
            }
        }.collect{
            if(systemConfigurationService.getConfig('schoolyear') != it){
                evalYear << it
            }
        }
        render view: '/reports/view', model: [evalYear:evalYear]
    }

    def viewEvaluatedProfessorList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = evaluationService.getEvaluatedProfessors(params, max, offset,params?.usertype,true)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render res as JSON
    }

    def viewPrintStudentEval(){
        def semester = params?.int("semester") ?: systemConfigurationService.getConfig('semester')
        def schoolYear = params?.int("schoolyear") ?: systemConfigurationService.getConfig('schoolyear')
        def profIds = []
        if(params?.ids && params?.ids != 'ALL'){
            profIds = params.ids.toString().split(',');
        }
        def evaluationProf = Evaluation.withCriteria {
            createAlias('professor', 'p')
            if (params?.ids != 'ALL'){
                if (profIds.size() > 0) {
                    inList 'p.id', profIds
                } else {
                    eq 'p.id', ''
                }
            }
            eq 'schoolYear', schoolYear
            eq 'semester', semester
            eq 'evaluator', FESConstants.USER_TYPE_STUDENT

            order 'p.surname','asc'
        }
        if(evaluationProf?.professor){
            evaluationProf = evaluationProf.professor.unique()
            def question = evaluationQuestionService.retrieveEvaluationQuestions(schoolYear,semester,FESConstants.USER_TYPE_STUDENT)
            def category = evaluationCategoryService.retrieveEvaluationCategories(question)
            def interpretation = Interpretation.withCriteria {
                eq 'active', true
                order 'scale', 'desc'
            }
            def evaluation = []

            evaluationProf.each{
                def holder = [prof: it]
                BigDecimal total = 0
                BigDecimal count = 0
                def tmpWithPercent = evaluationService.retrieveEvaluationScore(it,schoolYear,semester,FESConstants.USER_TYPE_STUDENT,true)
                if(tmpWithPercent){
                    tmpWithPercent.each { tmpScore ->
                        total += tmpScore.score * tmpScore.category.percentage
                    }
                    count++
                }
                def tmp = evaluationService.retrieveEvaluationScore(it,schoolYear,semester,FESConstants.USER_TYPE_STUDENT,false)
                if(tmp){
                    tmp.each { tmpScore ->
                        total += tmpScore.score
                        count++
                    }
                }

                holder.overall =  total.divide(count != 0 ? count : BigDecimal.ONE,2, RoundingMode.HALF_UP)
                holder.score = tmpWithPercent << tmp
                evaluation << holder
            }

            def comment = []
            def evaluationComment = EvaluationComment.withCriteria {
                inList 'professor', evaluationProf
                eq 'schoolYear', schoolYear
                eq 'semester', semester
                eq 'selected', true
                projections{
                    property 'professor'
                    property 'comment'
                }
            }

            evaluationComment.each {
                comment << [prof:it[0],comment:it[1]]
            }


            def plvlogo = new File(servletContext.getRealPath('images/plv_logo.jpg'));
            def args = [template:"reportsTemplate/result",
                        controller:this,
                        model:[category: category.unique(),
                               question:question,
                               interpretation:interpretation,
                               evaluation:evaluation,
                               comments:comment,
                               semester:semester,
                               schoolYear:schoolYear,
                               plvlogo:plvlogo.bytes
                        ]]
            pdfRenderingService.render(args,response)
        }else{
            if(params?.ids == 'ALL')
                flash.errors = "Evaluation results is empty! Please close other PLV-FES Tabs"
            else
                flash.errors = 'Evaluation results for the selected prof is empty! Please close other PLV-FES Tabs'
            redirect action:'view'
        }
    }

    def viewPrintBatch(){
        def semester = params?.int("semester") ?: systemConfigurationService.getConfig('semester')
        def schoolYear = params?.int("schoolyear") ?: systemConfigurationService.getConfig('schoolyear')
        def evalType = params?.evalType
        def filterType = params?.filterType
        def college = College?.get(params?.collegeFilter)
        def department = Department.get(params?.departmentFilter)
        def ranking = Ranking.get(params?.rankFilter)
        def message = "All Professors"
        if(filterType){
            if(filterType == 'College'){
                message = college.collegeName
            }else if(filterType == 'Department'){
                message = department.departmentName
            }
        }


        def evaluationProf = Evaluation.withCriteria {
            createAlias('professor','p')
            eq 'evaluator', evalType
            if(filterType){
                if(filterType == 'College'){
                    eq 'p.college', college
                }else if(filterType == 'Department'){
                    eq 'p.department', department
                }

            }
            if(params?.rankCheck == 'on'){
                eq 'p.ranking', ranking
            }
            eq 'schoolYear', schoolYear
            eq 'semester', semester

            projections{
                distinct 'professor'
            }
        }
        if(evaluationProf){
            def evaluationCategory = Evaluation.withCriteria {
                createAlias('question','q')
                createAlias('professor','p')
                if(evalType != 'ALL'){
                    eq 'evaluator', evalType
                }
                if(evaluationProf){
                    inList 'p.id', evaluationProf.id
                }
                eq 'schoolYear', schoolYear
                eq 'semester', semester
                projections{
                    distinct 'q.evaluationCategory'
                }
            }

            def evalHolder = []

            evaluationProf.each { prof ->
                def evalDto = [:]
                evalDto.professor = prof.toString()
                evalDto.department = prof?.department?.departmentName?: 'College not set.'
                def scoreHolder = reportsService.retrieveEvaluationScore(prof,schoolYear,semester,evalType)
                evaluationCategory.each{ cat ->
                    scoreHolder.keySet().each {
                        if(it == cat.catIndex){
                            evalDto.put("cat"+ it,new DecimalFormat(FESConstants.SCORE_2DECIMAL_FORMAT).format(scoreHolder.get(it)))
                        }
                    }
                }
                BigDecimal overall = 0.00
                BigDecimal count = 0
                def tmpWithPercent = evaluationService.retrieveEvaluationScore(prof,schoolYear,semester,evalType,true)
                if(tmpWithPercent){
                    tmpWithPercent.each { tmpScore ->
                        overall += tmpScore.score * tmpScore.category.percentage
                    }
                    count++
                }
                def tmp = evaluationService.retrieveEvaluationScore(prof,schoolYear,semester,evalType,false)
                if(tmp){
                    tmp.each { tmpScore ->
                        overall += tmpScore.score
                        count++
                    }
                }
                overall = overall / ((count > 0) ? count : 1)
                evalDto.overall = new DecimalFormat(FESConstants.SCORE_2DECIMAL_FORMAT).format(overall)
                evalHolder << evalDto
            }

            def limitPerPage = 20

            def tmpHolder = evalHolder.sort{it.overall}.reverse().subList(0, params?.limit ? params.int('limit') : evalHolder.size())
            def newEvalHolder = []
            for(int x = 0;x< tmpHolder.size() ;x+=limitPerPage){
                def tmp = []
                def toIndex = (x+limitPerPage) < tmpHolder.size() ? x+limitPerPage : tmpHolder.size()
                tmpHolder.subList(x,toIndex).each{
                    tmp << it
                }
                newEvalHolder << tmp
            }

            def plvlogo = new File(servletContext.getRealPath('images/plv_logo.jpg'));
            def args = [template:"reportsTemplate/batchResult",
                        controller:this,
                        model:[evaluation: newEvalHolder,
                               category:evaluationCategory.sort{it.catIndex},
                               evalType: evalType + 's\' Evaluation',
                               message:message,
                               semester:semester,
                               schoolYear:schoolYear,
                               plvlogo:plvlogo.bytes
                        ]]
            pdfRenderingService.render(args,response)
        }else{
            flash.errors = "Evaluation results from the selected type is empty! Please close the other PLV-FES Tabs"
            redirect action:'view'
        }
    }

    def viewPrintComparison(){
        def semester = params?.int("semester") ?: systemConfigurationService.getConfig('semester')
        def schoolYear = params?.int("schoolyear") ?: systemConfigurationService.getConfig('schoolyear')
        def filterType = params?.cFilterType
        def college = College?.get(params?.cCollegeFilter)
        def department = Department.get(params?.cDepartmentFilter)
        def ranking = Ranking.get(params?.cRankFilter)
        def message = "All Professors"
        if(filterType){
            if(filterType == 'College'){
                message = college.collegeName
            }else if(filterType == 'Department'){
                message = department.departmentName
            }
        }


        def evaluationProf = Evaluation.withCriteria {
            createAlias('professor','p')
            if(filterType){
                if(filterType == 'College'){
                    eq 'p.college', college
                }else if(filterType == 'Department'){
                    eq 'p.department', department
                }

            }
            if(params?.cRankCheck == 'on'){
                eq 'p.ranking', ranking
            }
            eq 'schoolYear', schoolYear
            eq 'semester', semester


            projections{
                distinct 'professor'
            }
        }


        if(evaluationProf){
            evaluationProf = evaluationProf.sort{it.surname}

            def evalHolder = []

            evaluationProf.each { prof ->
                def evalDto = [:]
                evalDto.professor = prof.toString()
                evalDto.department = prof?.department?.departmentName?: 'College not set.'
                FESConstantMaps.allEvalType.each{ evaluator ->
                    BigDecimal score = 0
                    BigDecimal count = 0
                    def tmpWithPercent = evaluationService.retrieveEvaluationScore(prof,schoolYear,semester,evaluator,true)
                    if(tmpWithPercent){
                        tmpWithPercent.each { tmpScore ->
                            score += tmpScore.score * tmpScore.category.percentage
                        }
                        count++
                    }
                    def tmp = evaluationService.retrieveEvaluationScore(prof,schoolYear,semester,evaluator,false)
                    if(tmp){
                        tmp.each { tmpScore ->
                            score += tmpScore.score
                            count++
                        }
                    }

                    def total = score.divide(count == 0 ? BigDecimal.ONE : count, 2, RoundingMode.HALF_UP)
                    evalDto.put(evaluator, total>1 ? total:'-')
                }
                evalHolder << evalDto
            }

            def limitPerPage = 20

            def tmpHolder = evalHolder.subList(0, params?.cLimit ? params.int('cLimit') : evalHolder.size())
            def newEvalHolder = []
            for(int x = 0;x< tmpHolder.size() ;x+=limitPerPage){
                def tmp = []
                def toIndex = (x+limitPerPage) < tmpHolder.size() ? x+limitPerPage : tmpHolder.size()
                tmpHolder.subList(x,toIndex).each{
                    tmp << it
                }
                newEvalHolder << tmp
            }

            def plvlogo = new File(servletContext.getRealPath('images/plv_logo.jpg'));
            def args = [template:"reportsTemplate/comparisonResult",
                        controller:this,
                        model:[evaluation: newEvalHolder,
                               evalType: FESConstantMaps.allEvalType,
                               message:message,
                               semester:semester,
                               schoolYear:schoolYear,
                               plvlogo:plvlogo.bytes
                        ]]
            pdfRenderingService.render(args,response)
        }else{
            flash.errors = "Evaluation results from the selected type is empty! Please close the other PLV-FES Tabs"
            redirect action:'view'
        }
    }

    def viewPrintGroupComparison(){
        def semester = params?.int("semester") ?: systemConfigurationService.getConfig('semester')
        def schoolYear = params?.int("schoolyear") ?: systemConfigurationService.getConfig('schoolyear')
        def groupType = params?.groupType
        def message = ""
        if(groupType == 'College'){
            message = "By College"
        }else if(groupType == 'Department'){
            message = "By Department"
        }



        def evalResult = Evaluation.withCriteria {
            eq 'schoolYear', schoolYear
            eq 'semester', semester
        }


        if(evalResult){
            def evalHolder = []

            if(groupType == 'College'){
                College.withCriteria {
                    order 'collegeName','asc'
                }.collect{ college ->
                    def evalDto = [:]
                    def scoreDto = [:]
                    evalDto.name = college.collegeName
                    def evaluation = Evaluation.withCriteria {
                        createAlias('professor','p')
                        eq 'schoolYear', schoolYear
                        eq 'semester', semester
                        eq 'p.college', college
                        projections{
                            distinct 'professor'
                        }
                    }
                    evaluation.each{ prof ->
                        FESConstantMaps.allEvalType.each{ evaluator ->
                            BigDecimal score = 0
                            BigDecimal count = 0
                            def tmpWithPercent = evaluationService.retrieveEvaluationScore(prof,schoolYear,semester,evaluator,true)
                            if(tmpWithPercent){
                                tmpWithPercent.each { tmpScore ->
                                    score += tmpScore.score * tmpScore.category.percentage
                                }
                                count++
                            }
                            def tmp = evaluationService.retrieveEvaluationScore(prof,schoolYear,semester,evaluator,false)
                            if(tmp){
                                tmp.each { tmpScore ->
                                    score += tmpScore.score
                                    count++
                                }
                            }
                            def total = score.divide(count == 0 ? BigDecimal.ONE : count, 2, RoundingMode.HALF_UP)
                            scoreDto << ["${evaluator + prof.surname + prof.firstname}" : total]
                        }
                    }

                    FESConstantMaps.allEvalType.each { evaluator ->
                        BigDecimal overallScore = 0
                        BigDecimal overallCount = 0
                        scoreDto.each{ key, value ->
                            if(key.toString().startsWith(evaluator) && value > BigDecimal.ZERO){
                                overallScore += value
                                overallCount++
                            }
                        }

                        def total = overallScore.divide(overallCount == 0 ? BigDecimal.ONE : overallCount, 2, RoundingMode.HALF_UP)
                        evalDto.put(evaluator, total>1 ? total:'-')
                    }
                    evalHolder << evalDto

                }
            }else if(groupType == 'Department'){
                Department.withCriteria {
                    order 'departmentName','asc'
                }.collect{ department ->
                    def evalDto = [:]
                    def scoreDto = [:]
                    evalDto.name = department.departmentName
                    def evaluation = Evaluation.withCriteria {
                        createAlias('professor','p')
                        eq 'schoolYear', schoolYear
                        eq 'semester', semester
                        eq 'p.department', department
                        projections{
                            distinct 'professor'
                        }
                    }
                    evaluation.each{ prof ->
                        FESConstantMaps.allEvalType.each{ evaluator ->
                            BigDecimal score = 0
                            BigDecimal count = 0
                            def tmpWithPercent = evaluationService.retrieveEvaluationScore(prof,schoolYear,semester,evaluator,true)
                            if(tmpWithPercent){
                                tmpWithPercent.each { tmpScore ->
                                    score += tmpScore.score * tmpScore.category.percentage
                                }
                                count++
                            }
                            def tmp = evaluationService.retrieveEvaluationScore(prof,schoolYear,semester,evaluator,false)
                            if(tmp){
                                tmp.each { tmpScore ->
                                    score += tmpScore.score
                                    count++
                                }
                            }
                            def total = score.divide(count == 0 ? BigDecimal.ONE : count, 2, RoundingMode.HALF_UP)
                            scoreDto << ["${evaluator + prof.surname}" : total]
                        }
                    }

                    FESConstantMaps.allEvalType.each { evaluator ->
                        BigDecimal overallScore = 0
                        BigDecimal overallCount = 0
                        scoreDto.each{ key, value ->
                            if(key.toString().startsWith(evaluator)){
                                overallScore += value
                                overallCount++
                            }
                        }

                        def total = overallScore.divide(overallCount == 0 ? BigDecimal.ONE : overallCount, 2, RoundingMode.HALF_UP)
                        evalDto.put(evaluator, total>1 ? total:'-')
                    }
                    evalHolder << evalDto

                }
            }

            def limitPerPage = 20

            def tmpHolder = evalHolder
            def newEvalHolder = []
            for(int x = 0;x< tmpHolder.size() ;x+=limitPerPage){
                def tmp = []
                def toIndex = (x+limitPerPage) < tmpHolder.size() ? x+limitPerPage : tmpHolder.size()
                tmpHolder.subList(x,toIndex).each{
                    tmp << it
                }
                newEvalHolder << tmp
            }

            def plvlogo = new File(servletContext.getRealPath('images/plv_logo.jpg'));
            def args = [template:"reportsTemplate/groupComparisonResult",
                        controller:this,
                        model:[evaluation: newEvalHolder,
                               evalType: FESConstantMaps.allEvalType,
                               message:message,
                               semester:semester,
                               schoolYear:schoolYear,
                               plvlogo:plvlogo.bytes
                        ]]
            pdfRenderingService.render(args,response)
        }else{
            flash.errors = "Evaluation results from the selected type is empty! Please close the other PLV-FES Tabs"
            redirect action:'view'
        }
    }

    def viewPrintListOfFaculties(){
        def semester = params?.int("semester") ?: systemConfigurationService.getConfig('semester')
        def schoolYear = params?.int("schoolyear") ?: systemConfigurationService.getConfig('schoolyear')
        def filterType = params?.lFilterType
        def college = College?.get(params?.lCollegeFilter)
        def department = Department.get(params?.lDepartmentFilter)
        def ranking = Ranking.get(params?.lRankFilter)
        def evalStatList = []
        def message = "All Professors"
        if(filterType){
            if(filterType == 'College'){
                message = college.collegeName
            }else if(filterType == 'Department'){
                message = department.departmentName
            }
        }

        if(params?.lEvalStatCheck == 'on'){
            if(params?.lEvalStat == 'evaluated'){
                message = 'Evaluated Professors'
            }else{
                message = 'Non-Evaluated Professors'
            }

            if(filterType){
                if(filterType == 'College'){
                    message = " from " + college.collegeName
                }else if(filterType == 'Department'){
                    message = " from " + department.departmentName
                }
            }

            evalStatList =  EvaluationComment.withCriteria{
                createAlias('professor','p')
                projections {
                    distinct 'p.id'
                }
            }
        }
        def evaluationProf = Professor.withCriteria {
            if(filterType){
                if(filterType == 'College'){
                    eq 'college', college
                }else if(filterType == 'Department'){
                    eq 'department', department
                }

            }
            if(params?.lRankCheck == 'on'){
                eq 'ranking', ranking
            }

            if(params?.lEvalStatCheck == 'on' && evalStatList.size() > 0){
                if(params?.lEvalStat == 'evaluated'){
                    'in' 'id',evalStatList
                }else if(params?.lEvalStat == 'nevaluated'){
                    not{
                        'in' 'id', evalStatList
                    }
                }
            }


            eq 'active',true
            order 'surname','asc'
        }


        if(evaluationProf){

            def limitPerPage = 20
            def newEvalProf = evaluationProf.subList(0, params?.lLimit ? params.int('lLimit') : evaluationProf.size())
            def evalHolder = []
            for(int x = 0;x< newEvalProf.size() ;x+=limitPerPage){
                def tmp = []
                def toIndex = (x+limitPerPage) < newEvalProf.size() ? x+limitPerPage : newEvalProf.size()
                newEvalProf.subList(x,toIndex).each{
                    tmp << it
                }
                evalHolder << tmp
            }

            def plvlogo = new File(servletContext.getRealPath('images/plv_logo.jpg'));
            def args = [template:"reportsTemplate/listOfFaculties",
                        controller:this,
                        model:[professor: evalHolder,
                               message:message,
                               semester:semester,
                               schoolYear:schoolYear,
                               plvlogo:plvlogo.bytes
                        ]]
            pdfRenderingService.render(args,response)
        }else{
            flash.errors = "Evaluation results from the selected type is empty! Please close the other PLV-FES Tabs"
            redirect action:'view'
        }
    }
}
