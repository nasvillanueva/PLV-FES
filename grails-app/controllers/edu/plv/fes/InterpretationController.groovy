package edu.plv.fes

import grails.converters.JSON

class InterpretationController {


    def interpretationService

    static defaultAction = "view"

    def view() {
        render view: '/interpretation/view'
    }

    def viewInterpretationList() {
        def offset = params.int('start') ?: 0
        def max = params.int('length') ?: 10
        def result = interpretationService.getAllInterpretation(offset,max)
        def res = [draw: params.int('draw'),data:result.display, recordsTotal:result.totalCount,recordsFiltered:result.totalCount]
        render  res as JSON
    }

    def viewInterpretation(){
        def interpretation = Interpretation.get(params?.id)
        def jsonData = [id:interpretation.id,scale:interpretation.scale, rating:interpretation.rating,description:interpretation.description, active:interpretation.active]
        render jsonData as JSON
    }

    def addInterpretation(){
        withForm{
            def model = [success:true]
            def message = null
            if(!Interpretation.findByScale(new BigInteger(params.int('interpret_scale')))){
                Interpretation interpretation = new Interpretation()
                interpretation.scale = params.int('interpret_scale')
                interpretation.rating = params.interpret_rating
                interpretation.description = params.interpret_desc
                interpretation.active = params.interpret_active == 'on'
                if(interpretation.save(flush:true)){
                    message = '\"' + params.interpret_rating + '\" successfully added!'
                }else{
                    model.success = false
                    message = 'There was a problem adding \"' + params.interpret_rating + '\". Try submitting the form again.'
                    model.interpret = interpretation
                }
            }else{
                model.success = false
                message = 'Interpretation with a scale of \"' + params.int('interpret_scale') + '\" already exists!'
            }

            flash.message = message
            render view: '/interpretation/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }


    def editInterpretation(){
        withForm{
            def model = [success:true]
            def message = null
            Interpretation interpretation = Interpretation.get(params?.interpret_id)
            if(interpretation?.scale != params.int('interpret_scale')) {
                def byScale = Interpretation.findAllByScale(new BigInteger(params.int('interpret_scale')))
                if (byScale.size() > 0) {
                    model.success = false
                    message = 'Interpretation with a scale of \"' + params.int('interpret_scale') + '\" already exists!'
                }else{
                    interpretation.scale = params.int('interpret_scale')
                }
            }

            if(model.success){
                interpretation.rating = params.interpret_rating
                interpretation.description = params.interpret_desc
                interpretation.active = params.interpret_active == 'on'
                if(interpretation.save(flush:true)){
                    message = '\"' + params.interpret_rating + '\" successfully updated!'
                }else{
                    model.success = false
                    message = 'There was a problem updating \"' + params.interpret_rating + '\". Try submitting the form again.'
                    model.evalCat = evalCat
                }
            }

            flash.message = message
            render view: '/interpretation/view', model: model
        }.invalidToken{
            redirect action: 'view'
        }
    }
}
