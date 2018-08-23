//
//  MHNDTASK.swift
//  MHNDB
//
//  Created by mac on 23/08/18.
//  Copyright © 2018 mhn. All rights reserved.
//

import UIKit

class MHNDTASK: NSObject {
    open class func sharedIn() -> MHNDTASK { // creat a shared instance class variable
        //
        return MHNDTASK()
    }
    
    
    
    
    public func GETRequest(_ api:String?,_ params:NSMutableDictionary?,   completionHandler: @escaping (NSDictionary?) -> Swift.Void) {
        
        var request = NSMutableURLRequest(url: NSURL(string: (api!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!))! as URL)
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 180.0
        config.timeoutIntervalForResource = 180.0
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let session = URLSession(configuration: config)
        var url = api! + "?"
        
        for (key,value) in params! {
            url = url + "\(key as! String)=\(value)&"
        }
        
        request = NSMutableURLRequest(url: NSURL(string: (url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!))! as URL)
        request.httpMethod = "GET"
        
        
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let header:NSDictionary? = nil
        if header != nil {
            if (header?.count)! > 0 {
                for (key,_) in header! {
                    request.setValue(header?.object(forKey: key) as? String, forHTTPHeaderField: "\(key)")
                }
            }
        }
        
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if let data = data {
                //   let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    do {
                        let resultJson = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                        if let json = resultJson {
                            print("Result-->",json)
                            completionHandler(json)
                            return
                        }
                        
                    } catch {
                        print("response -->\(response) \nError -> \(error)")
                        
                        completionHandler(nil)
                        
                    }
                }
            }
            
            
        });
        
        task.resume()
        
        
    }
    public func POSTRequest (_ api:String?,_ params:NSMutableDictionary? , _ images:NSMutableArray? = nil,  completionHandler: @escaping ( NSDictionary?) -> Swift.Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: (api!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!))! as URL)
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 180.0
        config.timeoutIntervalForResource = 180.0
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let session = URLSession(configuration: config)
        request.httpMethod = "POST"
        
        var data:Data! = Data()
        
        do {
          
                let boundary = generateBoundaryString()
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                
                let newParams = NSMutableDictionary()
                
                for (key,value) in params! {
                    newParams.setValue(value, forKey: key as! String)
                }
                
                for (key, value) in newParams {
                    data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.ascii)!)
                    data.append("\(value)".data(using: String.Encoding.ascii)!)
                    data.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.ascii)!)
                }
                
                if images != nil {
                    for i in 0..<(images?.count)! {
                        
                        let md = images?[i] as! NSMutableDictionary
                        
                        let param = md["param"] as! String
                        let image = md["image"] as! UIImage
                        
                        let image_data = UIImagePNGRepresentation(image)
                        
                        print("image-\(param)-\(image)-\(String(describing: image_data?.count))-")
                        
                        let fname = "test\(i).png"
                        
                        data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        data.append("Content-Disposition: form-data; name=\"\(param)\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
                        data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                        data.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
                        
                        data.append(image_data!)
                        data.append("\r\n".data(using: String.Encoding.utf8)!)
                        
                        data.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                    }
                }
                
                request.httpBody = data
            
        } catch {
            
            print("JSON serialization failed:  \(error)")
        }
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        
         let header:NSDictionary? = nil
        if header != nil {
            if (header?.count)! > 0 {
                for (key,_) in header! {
                    request.setValue(header?.object(forKey: key) as? String, forHTTPHeaderField: "\(key)")
                }
            }
        }
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if let data = data {
                //   let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    do {
                        let resultJson = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                        if let json = resultJson {
                            print("Result-->",json)
                            completionHandler(json)
                            return
                        }
                        
                    } catch {
                        print("response -->\(response) \nError -> \(error)")
                        
                        completionHandler(nil)
                        
                    }
                }
            }
            
            
        });
        
        task.resume()
        
        
    }

    
    public func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

}
