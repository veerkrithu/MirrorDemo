//
//  MDBox.swift
//  MirrorDemo
//
//  Created by Ganesan, Veeramani - Contractor {BIS} on 6/30/18.
//  Copyright © 2018 Ganesan, Veeramani - Contractor {BIS}. All rights reserved.
//

//  Generic Box class which holds any data type and it includes listeners which helps the UI controller to bind the UI for any data updates. This class notifies the data model update once consumer registers their listeners (closuers) via bind method call. This class used to support MVVM architecture

import Foundation

class MDBox <T> {
    
    typealias Listener = (T)->Void
    var listener: Listener?
    
    var value: T {
        
        didSet {
          listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
