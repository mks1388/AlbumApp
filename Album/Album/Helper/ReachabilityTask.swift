//
//  ReachabilityTask.swift
//  Album
//
//  Created by Mithilesh Singh on 21/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import Reachability

class ReachabilityTask {
    private let reachability = Reachability()
    
    private(set) var isReachable = true
    
    init() {
        reachability?.whenReachable = { [weak self] reachability in
            self?.isReachable = true
        }
        reachability?.whenUnreachable = { [weak self] _ in
            self?.isReachable = false
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Reachability notifier not started")
        }
    }
    
    deinit {
        reachability?.stopNotifier()
    }
}
