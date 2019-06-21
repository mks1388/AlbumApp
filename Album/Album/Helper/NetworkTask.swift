//
//  NetworkTask.swift
//  Album
//
//  Created by Mithilesh Singh on 21/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import Foundation

protocol NetworkTaskInterfaceProtocol : class {
    func fetchImages(url: String, onSuccess:@escaping (Data)->Void, onFailure:@escaping (Error?)->Void)
}

class NetworkTask : NetworkTaskInterfaceProtocol {
    
    func fetchImages(url: String, onSuccess:@escaping (Data)->Void, onFailure:@escaping (Error?)->Void) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let dataResponse = data, error == nil else {
                    onFailure(error)
                    return
                }
                onSuccess(dataResponse)
            }
            task.resume()
        }
    }
}
