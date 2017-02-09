//
//  PhotoViewController.swift
//  tumblrPro
//
//  Created by mwong on 2/2/17.
//  Copyright © 2017 mwong. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    //Initialize posts as an empty array so it will not be nil
    var posts: [NSDictionary] = []
    var isMoreDataLoading = false
    let refreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(self.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        self.tableView.insertSubview(refreshControl, at: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 240;
        
        self.networkRequest()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as! PhotoCell
        
        let post = self.posts[indexPath.row]
        
        // Configure YourCustomCell using the outlets that you've defined.
        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        
        // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
        
        let imageUrl = NSURL(string: imageUrlString!)
        cell.imgView.setImageWith(imageUrl as! URL)
        cell.selectionStyle = .none
        //
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        var indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        // Get URL
        let post = self.posts[(indexPath?.row)!]
        // Configure YourCustomCell using the outlets that you've defined.
        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        
        // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
        let imageUrlString = photos?[0].value(forKeyPath: "original_size.url") as? String
        
        let imageUrl = NSURL(string: imageUrlString!)
        
        let destinationViewController = segue.destination as! PhotosDetailViewController
        
        destinationViewController.imageURL = imageUrl as? URL
    }
    
    func networkRequest() {
        // Do any additional setup after loading the view.
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print("responseDictionary: \(responseDictionary)")
                        
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
        
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // ... Create the URLRequest `myRequest` ...
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // ... Use the new data to update the data source ...
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(!isMoreDataLoading) {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThresHold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThresHold && tableView.isDragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
            
        }
    }
    
    func loadMoreData() {
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            self.isMoreDataLoading = false
            self.tableView.reloadData()
        });
        task.resume()
        
    }
    
    
}
