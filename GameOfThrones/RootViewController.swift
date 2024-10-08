//
//  RootViewController.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    private var activityIndicator: UIActivityIndicatorView?

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

    private func activityIndicator(style: UIActivityIndicatorView.Style = .large,
                                   frame: CGRect? = nil,
                                   center: CGPoint? = nil) -> UIActivityIndicatorView {
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

    func addActivityIndicator(style: UIActivityIndicatorView.Style = .large,
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
