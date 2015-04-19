package edu.plv.fes.constants

/**
 * Created by NazIsEvil on 1/18/2015.
 */
class FESConstantMaps {
    static allModules = [
        auditLog:'Audit Log',
        evaluationCategory:'Categories',
        college:'Colleges',
        evaluationComment:'Comments',
        department:'Departments',
        evaluation:'Evaluation',
        interpretation:'Interpretations',
        peerListMaintenance:'List Maintenance - Peer',
        listMaintenance:'List Maintenance - Student',
        supervisorListMaintenance:'List Maintenance - Supervisor',
        professor:'Professors',
        evaluationQuestion:'Questions',
        ranking:'Ranking',
        reports:'Reports',
        results:'Results',
        role:'Roles',
        systemConfiguration:'System Configuration',
        user:'Users'
    ]
    static allPermPrefix = [
        view:'View',
        add:'Add',
        edit:'Edit' //,
//        delete:'Delete'
    ]

    static allEvalType = [
            FESConstants.USER_TYPE_STUDENT,
            FESConstants.USER_TYPE_CHAIR,
            FESConstants.USER_TYPE_SUPER
    ]

    static allModulesAuditLogs = [
            EvaluationCategory :'Category',
            College:'College',
            EvaluationComment:'Comments',
            Department:'Departments',
            Interpretation:'Interpretations',
            EvaluationList:'Evaluation List',
            Professor:'Professors',
            EvaluationQuestion:'Questions',
            FESRole:'Roles',
            SystemConfiguration:'System Configuration',
            StudentSchedule:'Student Schedule',
            FESUser:'Users',
            Ranking:'Ranking'
    ]
}
