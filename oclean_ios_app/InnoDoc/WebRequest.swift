//
//  WebRequest.swift
//  InnoDoc
//
//  Created by Carlos Martin de Arribas on 19/10/2019.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import Alamofire

class WebRequest {
    public static let serverIP = "http://t24h.es:50002/v1/"
    
    public static func getNews(completionHandler: @escaping ((_ response: [Notice], _ success: Bool) -> Void)) {
        let url = serverIP + "news"
        print(url)
        
        Alamofire.request(url).responseJSON { (response) in
            guard let result = response.result.value as? [String: Any], let news = result["news"] as? [[String: Any]] else {
                completionHandler([], false)
                return
            }
            var notices = [Notice]()
            
            for new in news {
                notices.append(WebConverter.newToNotice(content: new))
            }
            
            completionHandler(notices, true)
            }.responseString { (response) in
                print(response)
        }
    }
    
    public static func getONGs(completionHandler: @escaping ((_ response: [Organization], _ success: Bool) -> Void)) {
        let url = serverIP + "organizations"
        print(url)
        
        Alamofire.request(url).responseJSON { (response) in
            guard let result = response.result.value as? [String: Any], let orgs = result["organizations"] as? [[String: Any]] else {
                completionHandler([], false)
                return
            }
            var organizations = [Organization]()
            
            for org in orgs {
                organizations.append(WebConverter.organizationToOrg(content: org))
            }
            
            completionHandler(organizations, true)
        }
    }
    
    public static func getHeatMat(completionHandler: @escaping ((_ response: [Notice], _ success: Bool) -> Void)) {
        let url = serverIP + "heatmap/"
        print(url)
    }
}

class WebConverter {
    public static func newToNotice(content: [String: Any]) -> Notice {
        let notice = Notice()
        
        if let title = content["title"] as? String { notice.title = title }
        if let description = content["description"] as? String { notice.description = description }
        if let publicationDate = content["publicationDate"] as? String { notice.publicationDate = publicationDate }
        if let newspaper = content["newspaper"] as? String { notice.newspaper = newspaper }
        if let image = content["image"] as? String { notice.image = image }
        if let url = content["url"] as? String { notice.url = url }
        
        return notice
    }
    
    
    public static func organizationToOrg(content: [String: Any]) -> Organization {
        let org = Organization()
        
        if let name = content["name"] as? String { org.name = name }
        if let description = content["description"] as? String { org.description = description }
        if let url = content["url"] as? String { org.url = url }
        
        return org
    }
}
