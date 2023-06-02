//
//  PaymentDetailViewController.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 02/06/23.
//

import UIKit

class PaymentDetailViewController: UIViewController {

    enum Section: CaseIterable {
        case detailOrder
        case mobileHeader
        case orderStatus
        case orderID
        case detailPayment
        case mobileDetail
        case fee
        case dicount
        case subtotal
        case divider
        case paymentTerm
        case help
    }

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        view.addSubview(tv)
        NSLayoutConstraint.activate([
            tv.rightAnchor.constraint(equalTo: view.rightAnchor),
            tv.leftAnchor.constraint(equalTo: view.leftAnchor),
            tv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tv.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        return tv
    }()


    lazy var buttonOk: UIButton = {
        let btn = UIButton()
        btn.setTitle("Oke", for: .normal)
        btn.tintColor = .white
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.rightAnchor.constraint(equalTo: view.rightAnchor),
            btn.leftAnchor.constraint(equalTo: view.leftAnchor),
            btn.heightAnchor.constraint(equalToConstant: 60),
            btn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        return btn
    }()

    var sections: [Section] = Section.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "MobileHeaderView")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "PaddingLabel")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "DetailViewCell")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "CustomView")
        buttonOk.backgroundColor = .kredivoOrange
    }
}


extension PaymentDetailViewController: UITableViewDataSource {

    private func createMobileHeaderSection(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MobileHeaderView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! MobileHeaderView
        let border = BorderProperties(edges: [.left, .right], color: UIColor.black.withAlphaComponent(0.1), thickness: 1)
        view.setBorder(properties: border)
        view.backgroundColor = .white
        cell.selectionStyle = .none
        cell.setCard(leading: 16, trailing: 16, bottom: 0, top: 0)
        
        return cell
    }


    private func createTitleSection(indexPath: IndexPath, properties: TextProperties) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaddingLabel", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! PaddingLabel
        view.paddingLeft = 16
        view.paddingTop = 16
        view.paddingRight = 16
        view.paddingBottom = 16
        view.cornerRadius = 5
        view.borderWidth = 1
        view.borderColor = UIColor.black.withAlphaComponent(0.1)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = properties.background
        view.text = properties.text
        view.textColor = properties.color
        view.font = .systemFont(ofSize: properties.size, weight: properties.weight)
        cell.selectionStyle = .none
        cell.setCard(leading: 16, trailing: 16, bottom: 0, top: 16)

        return cell
    }

    private func createHelpSection(indexPath: IndexPath, properties: NSAttributedString) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaddingLabel", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! PaddingLabel
        view.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
        view.numberOfLines = 0
        view.paddingLeft = 16
        view.paddingTop = 16
        view.paddingRight = 16
        view.paddingBottom = 16
        view.cornerRadius = 5
        view.borderWidth = 1
        view.borderColor = UIColor.black.withAlphaComponent(0.1)
        view.attributedText = properties
        cell.selectionStyle = .none
        cell.setCard(leading: 16, trailing: 16, bottom: 0, top: 16)

        return cell
    }


    private func createDetailSection(indexPath: IndexPath, properties: DetailProperties, padding: CGFloat = 8.0) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! DetailViewCell
        view.backgroundColor = .white
        view.titleLabel.paddingLeft = 16
        view.titleLabel.paddingTop = padding
        view.titleLabel.paddingBottom = padding
        view.contentLabel.paddingRight = 16
        view.titleLabel.text = properties.title.text
        view.titleLabel.textColor = properties.title.color
        view.titleLabel.font = .systemFont(ofSize: properties.title.size, weight: properties.title.weight)
        view.contentLabel.text = properties.content.text
        view.contentLabel.textColor = properties.content.color
        view.contentLabel.font = .systemFont(ofSize: properties.content.size, weight: properties.content.weight)
        cell.selectionStyle = .none
        cell.setCard(leading: 16, trailing: 16, bottom: 0, top: 0)

        if let border = properties.border {
            view.setBorder(properties: border)
        }

        return cell
    }

    private func createDividerSection(indexPath: IndexPath, properties: BorderProperties, padding: CGFloat = 8.0) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! CustomView
        cell.setCard(leading: 16, trailing: 16, bottom: 0, top: 0)
        view.setBorder(properties: properties)

        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let section = sections[indexPath.section]

        switch section {
        case .mobileHeader:
            return createMobileHeaderSection(indexPath: indexPath)
        case .detailOrder:
            var prop = TextProperties(text: "Detail Pesanan", color: .black, size: 18, weight: .medium)
            prop.background = .kredivoBlue.withAlphaComponent(0.1)
            return createTitleSection(indexPath: indexPath, properties: prop)
        case .orderStatus:
            let title = TextProperties(text: "Status", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: "Transaksi Berhasil", color: .kredivoGreen, size: 14, weight: .regular)
            let border = BorderProperties(edges: [.left, .top, .right], color: UIColor.black.withAlphaComponent(0.1), thickness: 1)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties)
        case .orderID:
            let title = TextProperties(text: "Order ID", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: "ZXDSAQWE", color: .black, size: 14, weight: .regular)
            let border = BorderProperties(edges: [.left, .bottom, .right], color: UIColor.black.withAlphaComponent(0.2), thickness: 1, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 5)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties)
        case .detailPayment:
            var prop = TextProperties(text: "Detail Pembayaran", color: .black, size: 18, weight: .medium)
            prop.background = .kredivoBlue.withAlphaComponent(0.1)
            return createTitleSection(indexPath: indexPath, properties: prop)
        case .mobileDetail:
            let title = TextProperties(text: "INDOSAT Rp 25.000 (081234567890)", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: "Rp25.000", color: .black, size: 14, weight: .regular)
            let border = BorderProperties(edges: [.left, .right], color: UIColor.black.withAlphaComponent(0.1), thickness: 1)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties, padding: 12)
        case .fee:
            let title = TextProperties(text: "Admin Fee", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: "Rp3.090", color: .black, size: 14, weight: .regular)
            let border = BorderProperties(edges: [.left, .right], color: UIColor.black.withAlphaComponent(0.1), thickness: 1)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties, padding: 12)
        case .dicount:
            let title = TextProperties(text: "Diskon Tambahan", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: "Rp1.500", color: .black, size: 14, weight: .regular)
            let border = BorderProperties(edges: [.left, .right], color: UIColor.black.withAlphaComponent(0.1), thickness: 1)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties, padding: 12)
        case .subtotal:
            let title = TextProperties(text: "Subtotal", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: "Rp9.090", color: .black, size: 14, weight: .regular)
            let border = BorderProperties(edges: [.left, .right], color: UIColor.black.withAlphaComponent(0.1), thickness: 1)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties, padding: 12)
        case .divider:
            let border = BorderProperties(edges: [.top], color: UIColor.black.withAlphaComponent(0.2), thickness: 1, isDashPattern: true)
            return createDividerSection(indexPath: indexPath, properties: border)
        case .paymentTerm:
            let title = TextProperties(text: "Bayar Dalam 30 Hari", color: .black, size: 18, weight: .medium)
            let content = TextProperties(text: "Rp 9.090", color: .kredivoOrange, size: 18, weight: .medium)
            let border = BorderProperties(edges: [.left, .bottom, .right], color: UIColor.black.withAlphaComponent(0.1), thickness: 1, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], cornerRadius: 5)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties, padding: 12)
        case .help:
            let attributedText = NSMutableAttributedString(string: "Jika kamu punya kendala terkait transaksimu, pastikan untuk menghubungi customer service kami di ", attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.5), .font: UIFont.systemFont(ofSize: 12)])
            let phone = NSMutableAttributedString(string: "0807-1-573-348", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.kredivoBlue])
            let or = NSMutableAttributedString(string: " atau ", attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.5), .font: UIFont.systemFont(ofSize: 12)])
            let email = NSMutableAttributedString(string: "support@kredivo.com", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.kredivoBlue])
            attributedText.append(phone)
            attributedText.append(or)
            attributedText.append(email)

            return createHelpSection(indexPath: indexPath, properties: attributedText)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let section = sections[indexPath.section]

        switch section {
        case .mobileHeader:
            return 70
        case .detailOrder, .detailPayment:
            return 80
        case .divider:
            return 1
        default:
            return UITableView.automaticDimension
        }
    }
}

extension PaymentDetailViewController: UITableViewDelegate {}
