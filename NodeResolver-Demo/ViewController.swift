//
//  ViewController.swift
//  NodeResolver-Demo
//
//  Created by ios on 2024/5/21.
//

import UIKit

class ViewController: UIViewController {

    var resolver: Resolver = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlRequest = URLRequest(url: .init(string: "https://www.baidu.com")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                self.resolver.body = .init(data: data, encoding: .utf8)!
                self.resolver.read(withQuery: "//p", encoding: nil)
            }
        }
        task.resume()
    }


}

