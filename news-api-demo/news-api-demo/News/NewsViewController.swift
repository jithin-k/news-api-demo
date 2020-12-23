//
//  NewsViewController.swift
//  news-api-demo
//
//  Created by Jithin on 23/12/20.
//

import UIKit

class NewsViewController: UITableViewController {

    var viewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        viewModel.delegate = self
        viewModel.fetchArticles()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == viewModel.lastArticleIndex {
            viewModel.fetchArticles(paginate: true)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let article = viewModel.article(atIndex: indexPath)
        cell.titleLabel.text = article.title
        cell.authorLabel.text = article.author
        cell.descriptionLabel.text = article.description
        return cell
    }

}

extension NewsViewController: NewsViewModelDelegate {
    
    func viewModelDidFetchArticles(_ viewModel: NewsViewModel) {
        tableView.reloadData()
    }
    
    func viewmodel(_ viewModel: NewsViewModel, failedToFetchArticles error: Error) {
        print("failed to fetch news: ", error.localizedDescription)
    }
    
}
