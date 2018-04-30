//
//  NewsTableViewController.swift
//  NewsSample
//
//  Created by mac on 2018. 4. 26..
//  Copyright © 2018년 StudioKJ. All rights reserved.
//

import UIKit
import Moya


struct NewsInfo {
    let title: String
    let imageLink: String
    let content: String
}
let provider = MoyaProvider<NewsAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])

class NewsTableViewController: UITableViewController {
    
    var newsInfos  = [Article]()
    @IBOutlet var newsListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
    }
    
    func getNews(){
        provider.request(.getNewsInfo("Kr", "business", "04871c167cfb4a3c9c18b9d170d8ba7f")) { result in
            
            switch result {
            case .success (let response) :
                do {
                    let result = try! JSONDecoder().decode(NewsResponse.self, from: response.mapString().data(using: .utf8)!)
                    
                    if let articles = result.articles{
                        self.newsInfos = articles
                    }
                    
                    self.newsListView.reloadData()
                } catch MoyaError.statusCode(let errorResponse){
                    print(errorResponse)
                } catch {
                    
                }
                
            case .failure (let error):
                print(error)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsInfos.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "newsCell") as? NewsTableViewCell
        cell.configurateTheCell(info : self.newsInfos[indexPath.row])
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDetail" {
            let indexPath = self.tableView!.indexPathForSelectedRow
            let destinationViewController: DetailedNewsViewController = segue.destination as! DetailedNewsViewController
            destinationViewController.detailedNewsLink = self.newsInfos[(indexPath?.row)!].url
        }
    }
    
}
