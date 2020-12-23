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
    
    @IBAction func refreshNews(_ sender: UIRefreshControl) {
        viewModel.fetchArticles()
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isNextPageAvailable {
            return viewModel.articles.count + 1
        }
        return viewModel.articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == viewModel.articles.count {
            viewModel.fetchArticles(paginate: true)
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLoadingCell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let article = viewModel.articles[indexPath.row]
        cell.titleLabel.text = article.title ?? "N/A"
        cell.authorLabel.text = article.author ?? "N/A"
        cell.descriptionLabel.text = article.description ?? "N/A"
        if let url = article.urlToImage {
            cell.newsImageView.setImage(url: url)
        }
        return cell
    }

}

extension NewsViewController: NewsViewModelDelegate {
    
    func viewModelDidFetchArticles(_ viewModel: NewsViewModel) {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func viewmodel(_ viewModel: NewsViewModel, failedToFetchArticles error: Error) {
        refreshControl?.endRefreshing()
        showError(error)
    }
    
}
