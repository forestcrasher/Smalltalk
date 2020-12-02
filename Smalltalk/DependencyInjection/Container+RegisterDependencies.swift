//
//  Container+RegisterDependencies.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 02.12.2020.
//

import Swinject

extension Container {
    func registerDependencies() {
        self.registerServices()
        self.registerViewModels()
        self.registerCoordinators()
    }
}
