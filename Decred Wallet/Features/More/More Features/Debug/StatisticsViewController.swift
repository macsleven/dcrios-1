//
//  StatisticsViewController.swift
//  Decred Wallet
//
// Copyright (c) 2020 The Decred developers
// Use of this source code is governed by an ISC
// license that can be found in the LICENSE file.
//

import Foundation
import UIKit

class StatisticsViewController: UITableViewController  {
    @IBOutlet weak var buildDetailLabel: UILabel!
    
    @IBOutlet weak var peerConnectedDetailLabel: UILabel!
    @IBOutlet weak var uptimeDetailLabel: UILabel!
    @IBOutlet weak var networkDetailLabel: UILabel!
    @IBOutlet weak var bestBlockDetailLabel: UILabel!
    @IBOutlet weak var bestBlockTimestampDetailLabel: UILabel!
    
    @IBOutlet weak var bestBlockAgeDetailLabel: UILabel!
    @IBOutlet weak var walletFileDetailLabel: UILabel!
    @IBOutlet weak var chainDataDetailLabel: UILabel!
    
    @IBOutlet weak var transactionDetailLabel: UILabel!
    @IBOutlet weak var accountDetailLabel: UILabel!
    
    var refreshStatsTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 36, right: 0)
        self.loadStatistcs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // stop refreshing statistics when view becomes invisible
        self.refreshStatsTimer?.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshStatsTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            DispatchQueue.main.async {
                self.statsLiveUpdate()
            }
        }
    }
    
    func loadStatistcs() {
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd"
        // build date
        self.buildDetailLabel.text = "\(BuildConfig.NetType), \(dateformater.string(from: AppDelegate.compileDate as Date))"
        self.networkDetailLabel.text = "\(BuildConfig.NetType)"
        // wallet file directory
        self.walletFileDetailLabel.text = "/Documents/dcrlibwallet/\(BuildConfig.NetType)/"
        // opened wallets account
        self.accountDetailLabel.text = "\(WalletLoader.shared.multiWallet.openedWalletsCount())"
        // load live update details
        self.statsLiveUpdate()
    }
    
    func statsLiveUpdate(){
        // numbers of peers
        self.peerConnectedDetailLabel.text = "\(WalletLoader.shared.multiWallet.connectedPeers())"
        // app uptime
        let durationUpTime = Date().timeIntervalSince1970 - AppDelegate.appUpTime!
        self.uptimeDetailLabel.text = "\(Utils.timeStringFor(seconds: durationUpTime))"
        // best block
        self.bestBlockDetailLabel.text = "\(WalletLoader.shared.multiWallet.getBestBlock()?.height ?? 0)"
        // best block age info
        let bestBlockInfo = WalletLoader.shared.multiWallet.getBestBlock()
        self.bestBlockTimestampDetailLabel.text = "\(Date(timeIntervalSince1970: Double(bestBlockInfo!.timestamp)))"
        // best block age
        let bestBlockAge = Int64(Date().timeIntervalSince1970) - bestBlockInfo!.timestamp
        self.bestBlockAgeDetailLabel.text = Utils.calculateTime(timeInterval: bestBlockAge).lowercased()
        // Transaction count
         self.transactionDetailLabel.text = "\(Utils.countAllWalletTransaction())"
        // chain Data in human readable format
        self.chainDataDetailLabel.text = "\(Utils.format(bytes: Double(Utils.getDirFileSize())))"
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.darkBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.appColors.offWhite
               //Remove shadow from navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
               
        self.addNavigationBackButton()
                   
        let barButtonTitle = UIBarButtonItem(title: LocalizedStrings.statistics, style: .plain, target: self, action: nil)
               barButtonTitle.tintColor = UIColor.appColors.darkBlue
        if let barButtonReturn = self.navigationItem.leftBarButtonItem {
            self.navigationItem.leftBarButtonItems =
            [barButtonReturn, barButtonTitle]
        }
    }
}
