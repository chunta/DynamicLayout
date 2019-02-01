//
//  ViewController.swift
//  NewsLayout
//
//  Created by nmi on 2019/1/30.
//  Copyright © 2019 nmi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

struct Magazine : Codable {
    let id:Int
    let title:String!
    let url:String!
    let des:String!
}

struct Magazines: Codable {
    var content:Array<Magazine>
}

class ViewController: UIViewController {
    
    @IBOutlet var tableView:UITableView!
    var magazines:Magazines?
    var heightMap:Dictionary<Int, CGSize>!
    var labelHeightMap:Dictionary<Int, CGFloat>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightMap = Dictionary<Int, CGSize>()
        labelHeightMap = Dictionary<Int, CGFloat>()
        
        tableView.register(UINib(nibName: "NormalTableViewCell", bundle: nil), forCellReuseIdentifier: "NormalTableViewCell")
        tableView.estimatedRowHeight = 66
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://dl.dropboxusercontent.com/s/r7vzr20i9735a37/magazine.json", headers: headers).responseJSON { response in
            if (response.result.isSuccess)
            {
                if (response.data != nil)
                {
                    let str = String(data: response.data!, encoding: .utf8)!
                    print(str)
                    let decoder = JSONDecoder()
                    self.magazines = try! decoder.decode(Magazines.self, from: response.data!)
                    print(self.magazines!)
                    self.tableView.reloadData()
                }
                
            }
        }
        //---------------------
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (heightMap[indexPath.section] == nil)
        {
            return UITableView.automaticDimension
        }
        
        let size:CGSize = heightMap[indexPath.section]!
        let ratio:CGFloat = size.width / size.height
        let h:CGFloat = tableView.frame.width / ratio
        
        let lh:CGFloat = labelHeightMap[indexPath.section] ?? NormalTableViewCell.labelHeight()
        return h + lh + NormalTableViewCell.verticalSpace()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return magazines?.content.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NormalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NormalTableViewCell") as! NormalTableViewCell
        let magazine:Magazine = (magazines?.content[indexPath.section])!
        
        cell.title.text = magazine.title.captalizeFirstCharacter()
        cell.title.sizeToFit()
        
        cell.desc.text = magazine.des
        cell.desc.sizeToFit()
        
        labelHeightMap[indexPath.section] = cell.title.bounds.size.height + cell.desc.bounds.size.height
        
        let section:Int = indexPath.section
        Alamofire.request(magazine.url).responseImage { response in
                if let image = response.result.value {
                    cell.imagev.image = image
                    if (self.heightMap[section] == nil)
                    {
                        self.heightMap[section] = image.size
                        tableView.beginUpdates()
                        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
                        tableView.endUpdates()
                    }
                }
        }
        
        return cell
    }
}
extension String {
    func captalizeFirstCharacter() -> String {
        var result = self
        
        let substr1 = String(self[startIndex]).uppercased()
        result.replaceSubrange(...startIndex, with: substr1)
        
        return result
    }
}
