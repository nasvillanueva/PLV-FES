class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?" {
            constraints {
                // apply constraints here
            }
        }

        "/Admin"(controller:'landingPage',action:'view')
        "/AuditLog"(controller: 'auditLog',action: 'view')
        "/Category"(controller: 'evaluationCategory',action: 'view')
        "/College"(controller: 'college',action: 'view')
        "/Comments"(controller: 'evaluationComment',action: 'view')
        "/Department"(controller: 'department',action: 'view')
        "/Evaluation"(controller: 'evaluation',action: 'view')
        "/Interpretation"(controller: 'interpretation',action: 'view')
        "/List"(controller: 'evaluationList',action: 'view')
        "/StudentsListMaintenance"(controller: 'listMaintenance',action: 'view')
        "/PeerListMaintenance"(controller: 'peerListMaintenance',action: 'view')
        "/SupervisorListMaintenance"(controller: 'supervisorListMaintenance',action: 'view')
        "/Professors"(controller: 'professor',action: 'view')
        "/Question"(controller: 'evaluationQuestion',action: 'view')
        "/Ranking"(controller: 'ranking',action: 'view')
        "/Reports"(controller: 'reports',action: 'view')
        "/Results"(controller: 'results',action: 'view')
        "/Roles"(controller: 'role',action: 'view')
        "/Users"(controller: 'user',action: 'view')


        "/"(controller: 'auth', action: "index")
        "500"(view: '/error')
    }
}
