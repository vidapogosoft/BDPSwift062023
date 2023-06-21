//
//  PostsListViewController.swift
//  ProtocolsTest
//
//  Created by Victor Roldan on 4/09/21.
//

import UIKit

class PostsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    let viewModel = PostsViewModel()
    var postsList : [PostModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Posts List"
        activity(isHidden : false)
        configureTableView()
    }
    private func configureTableView(){
        tableView.estimatedRowHeight = UITableView.automaticDimension
        viewModel.getUserFromProvider {[weak self] model in
            DispatchQueue.main.async {
                self?.activity(isHidden : true)
                self?.postsList = model
                self?.tableView.reloadData()
            }
        }
    }
    
    private func activity(isHidden : Bool){
        if !isHidden{
            activityView.startAnimating()
        }else{
            activityView.stopAnimating()
        }
        activityView.isHidden = isHidden
    }
}

extension PostsListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = postsList[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = user.title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = user.body
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}
