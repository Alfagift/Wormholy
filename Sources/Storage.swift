//
//  Storage.swift
//  Wormholy-SDK-iOS
//
//  Created by Paolo Musolino on 04/02/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import Foundation

open class Storage: NSObject {

    public static let shared: Storage = Storage()
  
    public static var limit: NSNumber? = nil

    public static var defaultFilter: String? = nil

    public static var defaultBaseUrlFilter: String? = nil
    
    public static var multipleFilterExternalUrl: [String]? = nil

    open var requests: [RequestModel] = []
    
    func saveRequest(request: RequestModel?){
        guard request != nil else {
            return
        }
        
        if let index = requests.firstIndex(where: { (req) -> Bool in
            return request?.id == req.id ? true : false
        }) {
            requests[index] = request!
        } else {
            requests.insert(request!, at: 0)
        }

        if let limit = Self.limit?.intValue {
            requests = Array(requests.prefix(limit))
        }
        
        if let _ = Self.defaultBaseUrlFilter, let multipleExternalUrl = Self.multipleFilterExternalUrl {
            setFilterMultipleUrl(urls: multipleExternalUrl)
        } else if let defaultBaseUrl = Self.defaultBaseUrlFilter {
            setFilterDefaultUrl(url: defaultBaseUrl)
        } else if let multipleExternalUrl = Self.multipleFilterExternalUrl {
            setFilterMultipleUrl(urls: multipleExternalUrl)
        }
        
        NotificationCenter.default.post(name: newRequestNotification, object: nil)
    }

    func clearRequests() {
        requests.removeAll()
    }
    
    private func setFilterDefaultUrl(url: String) {
        requests = requests.filter({ requestModel in
            requestModel.url.contains(url)
        })
    }
    
    private func setFilterMultipleUrl(urls: [String]) {
        var urls = urls
        if let defaultBaseUrl = Self.defaultBaseUrlFilter {
            urls.insert(defaultBaseUrl, at: 0)
        }
        requests = requests.filter({ request in
            urls.contains { url in
                request.url.contains(url)
            }
        })
    }
}


