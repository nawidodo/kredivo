//
//  TopUpContainerViewController.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 29/05/23.
//


import UIKit
import XLPagerTabStrip

class TopUpContainerViewController: ButtonBarPagerTabStripViewController {

    var router: UINavigationController?

    override func viewDidLoad() {
        configureButtonBar()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Configuration
    func configureButtonBar() {
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white

        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemTitleColor = .gray

        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0

        settings.style.selectedBarHeight = 3.0
        settings.style.selectedBarBackgroundColor = .kredivoOrange

        // Changing item text color on swipe
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .kredivoOrange
        }
    }

    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        let service: APIService = .init()

        let child1: TopUpTableViewController = .init()
        child1.tabTitle = "Pulsa"
        child1.router = router
        child1.service = service

        let child2: TopUpTableViewController = .init()
        child2.tabTitle = "Data Package"
        child2.router = router
        child2.service = service

        return [child1, child2]
    }

}
