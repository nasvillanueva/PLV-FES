package edu.plv.fes

import grails.transaction.Transactional

@Transactional
class RankingService {

    def getAllRanking(offset, max) {
        def r = Ranking.createCriteria()
        def ranking = r.list(max:max,offset:offset){
            order 'rankName', 'ASC'
        }
        def display = ranking.collect {it.tableDisplay}
        return [totalCount: ranking.totalCount, display: display]
    }

    def getAllActiveRankingForSelect(){
        return Ranking.withCriteria {
            eq('active',true)
            order 'rankName','asc'
        }
    }
}
