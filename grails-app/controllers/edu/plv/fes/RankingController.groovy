package edu.plv.fes

import grails.converters.JSON

class RankingController {
    def rankingService

    static defaultAction = "view"

    def view() {
        render view: '/ranking/view'
    }

    def viewRankingList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = rankingService.getAllRanking(offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render  res as JSON
    }

    def viewRanking(){
        def ranking = Ranking.get(params?.id)
        def jsonData = [id:ranking.id, name:ranking.rankName, active:ranking.active]
        render jsonData as JSON
    }

    def addRanking(){
        withForm{
            def model = [success:true]
            def message = null
            if(!Ranking.findByRankName(params.rank_name)){
                Ranking ranking = new Ranking()
                ranking.rankName = params.ranking_name
                ranking.active = params.ranking_active == 'on'
                if(ranking.save(flush:true)){
                    message = '\"' + params.ranking_name + '\" successfully added!'
                }else{
                    model.success = false
                    message = 'There was a problem adding \"' + params.ranking_name + '\". Try submitting the form again.'
                    model.ranking = ranking
                }
            }else{
                model.success = false
                message = '\"' + params.ranking_name + '\" already exists!'
            }

            flash.message = message
            render view: '/ranking/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }

    def editRanking(){
        withForm{
            def model = [success:true]
            def message = null
            Ranking ranking = Ranking.get(params?.ranking_id)
            if(ranking?.rankName != params?.rank_name) {
                def byName = Ranking.findAllByRankName(params?.ranking_name)
                if (byName.size() > 0) {
                    model.success = false
                    message = '\"' + params?.ranking_name + '\" already exists!'
                }else{
                    ranking.rankName = params?.ranking_name
                }
            }

            if(model.success){
                ranking.active = params.ranking_active == 'on'
                if(ranking.save(flush:true)){
                    message = '\"' + params.ranking_name + '\" successfully updated!'
                }else{
                    model.success = false
                    message = 'There was a problem updating \"' + params.ranking_name + '\". Try submitting the form again.'
                    model.college = ranking
                }
            }

            flash.message = message
            render view: '/ranking/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }
}
