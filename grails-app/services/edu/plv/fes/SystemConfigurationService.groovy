package edu.plv.fes


import grails.transaction.Transactional

@Transactional
class SystemConfigurationService {

    def getConfig(configName) {
        def config = SystemConfiguration.findByConfigName(configName)
        return config.configValue
    }
}
