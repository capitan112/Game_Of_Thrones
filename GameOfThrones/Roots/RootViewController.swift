//
//  RootViewController.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraintsForTableView()
    }

    private func setupTableView() {
        tableView.backgroundColor = .clear
    }

    func setupConstraintsForTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private(set) var activityIndicator: UIActivityIndicatorView?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func reload(tableView: UITableView) {
        performUIUpdatesOnMain {
            tableView.reloadData()
        }
    }

    func showAlertAndStopActivityIndicator() {
        showAlert()
        stopActivityIndicator()
    }

    private func showAlert() {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "Error", message: "Something goes wrong", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: UIActivityIndicatorView methods

    private func activityIndicator(style: UIActivityIndicatorView.Style = .medium,
                                   frame: CGRect? = nil,
                                   center: CGPoint? = nil) -> UIActivityIndicatorView
    {
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        activityIndicatorView.color = .white

        if let frame = frame {
            activityIndicatorView.frame = frame
        }

        if let center = center {
            activityIndicatorView.center = center
        }

        return activityIndicatorView
    }

    func addActivityIndicator(style: UIActivityIndicatorView.Style = .medium,
                              frame _: CGRect? = nil,
                              center: CGPoint? = nil)
    {
        let indicatorView = activityIndicator(style: style,
                                              center: center)
        view.addSubview(indicatorView)
        activityIndicator = indicatorView
    }

    func startActivityIndicator() {
        performUIUpdatesOnMain {
            self.activityIndicator?.startAnimating()
        }
    }

    func stopActivityIndicator() {
        performUIUpdatesOnMain {
            self.activityIndicator?.stopAnimating()
        }
    }
}
