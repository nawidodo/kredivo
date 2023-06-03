//
//  ConfirmationPaymentViewController.swift
//  Kredivo
//
//  Created by Nugroho Arief Widodo on 01/06/23.
//

import UIKit

class ConfirmationPaymentViewController: UIViewController {

    enum ConfirmationSection {
        case mobileHeader
        case paymentDetail
        case phoneNumber
        case discount
        case additionalCost
        case subtotal
        case kredivoDiscount
        case paymentTerm
        case voucherList
        case voucherApplied
        case pinInput
        case termAndCondition
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


    lazy var buttonPay: UIButton = {
        let btn = UIButton()
        btn.setTitle("Bayar", for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
        view.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.rightAnchor.constraint(equalTo: view.rightAnchor),
            btn.leftAnchor.constraint(equalTo: view.leftAnchor),
            btn.heightAnchor.constraint(equalToConstant: 60),
            btn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        return btn
    }()

    var order: Order
    var selectedVoucher: Voucher?
    var pin: String = ""

    @Inject var service: APIService

    private var sections: [ConfirmationSection] = [.mobileHeader, .paymentDetail, .phoneNumber, .discount, .subtotal, .paymentTerm, .voucherList, .pinInput, .termAndCondition]

    init(order: Order) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func registerCells() {
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "MobileHeaderView")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "UILabel")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "DetailViewCell")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "VoucherListView")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "PINInputCellView")
        tableView.register(PaddingTableViewCell.self, forCellReuseIdentifier: "VoucherAppliedView")
    }

    private func registerNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    private func updateUI(){
        buttonPay.backgroundColor = .kredivoOrange
        self.title = "Konfirmasi Pembayaran"
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 64, right: 0)
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
    }

    @objc private func didTapPay() {
        if pin.isEmpty {
            showMessage(message: "Please enter a PIN value")
        } else {
            Task { [weak self] in
                guard let transaction = await service.getTransaction() else { return }
                await MainActor.run {
                    let payment = Payment(phoneNumber: order.phoneNumber, transaction: transaction)
                    let vc = PaymentDetailViewController(payment: payment)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        registerNotification()
        updateNavBar()
        updateUI()
    }
}

extension ConfirmationPaymentViewController: UITableViewDelegate {}

extension ConfirmationPaymentViewController: UITableViewDataSource {

    private func createMobileHeaderSection(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MobileHeaderView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! MobileHeaderView
        view.numberLabel.text = order.phoneNumber
        view.backgroundColor = .white
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.kredivoBlue.withAlphaComponent(0.1)
        cell.setCard(leading: 0, trailing: 0, bottom: 8, top: 0)

        return cell
    }

    private func createTitleSection(indexPath: IndexPath, properties: TextProperties) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UILabel", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! UILabel
        view.backgroundColor = .white
        view.text = properties.text
        view.textColor = properties.color
        view.font = .systemFont(ofSize: properties.size, weight: properties.weight)
        cell.selectionStyle = .none
        cell.setCard(leading: 16, trailing: 16, bottom: 16, top: 16)

        return cell
    }

    private func createTitleSection(indexPath: IndexPath, attributes: NSAttributedString) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UILabel", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! UILabel
        view.backgroundColor = .white
        view.numberOfLines = 0
        view.attributedText = attributes
        cell.selectionStyle = .none
        cell.setCard(leading: 16, trailing: 16, bottom: 16, top: 0)

        return cell
    }

    private func createDetailSection(indexPath: IndexPath, properties: DetailProperties) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! DetailViewCell
        view.titleLabel.paddingTop = 12
        view.titleLabel.paddingBottom = 12
        view.backgroundColor = .white
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

    private func createVoucherSection(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherListView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! VoucherListView
        view.delegate = self
        view.backgroundColor = .white
        cell.selectionStyle = .none
        cell.setCard(leading: 0, trailing: 0, bottom: 8, top: 8)
        cell.backgroundColor = UIColor.kredivoBlue.withAlphaComponent(0.1)
        return cell
    }

    private func createVoucherAppliedSection(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoucherAppliedView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! VoucherAppliedView
        view.voucherNameLabel.text = selectedVoucher?.name
        view.howToUseLabel.text = selectedVoucher?.howToUse
        view.backgroundColor = .white
        cell.selectionStyle = .none
        cell.setCard(leading: 0, trailing: 0, bottom: 8, top: 8)
        cell.backgroundColor = UIColor.kredivoBlue.withAlphaComponent(0.1)
        return cell
    }

    private func createPINSection(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PINInputCellView", for: indexPath) as! PaddingTableViewCell
        let view = cell.customView as! PINInputCellView
        view.delegate = self
        view.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        switch section {
        case .mobileHeader:
            return createMobileHeaderSection(indexPath: indexPath)
        case .paymentDetail:
            let prop = TextProperties(text: "Rincian Pembayaran", color: .black, size: 16, weight: .medium)
            return createTitleSection(indexPath: indexPath, properties: prop)
        case .phoneNumber:
            let titleText = "\(order.product.label) (\(order.phoneNumber))"
            let title = TextProperties(text: titleText, color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: order.product.price.toCurrency(), color: .black, size: 14, weight: .regular)
            let properties = DetailProperties(title: title, content: content, border: nil)
            return createDetailSection(indexPath: indexPath, properties: properties)
        case .additionalCost:
            let title = TextProperties(text: "Biaya Layanan", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: "Rp490", color: .black, size: 14, weight: .regular)
            let properties = DetailProperties(title: title, content: content, border: nil)
            return createDetailSection(indexPath: indexPath, properties: properties)
        case .discount:
            let title = TextProperties(text: "Diskon Tambahan", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: "Rp1.000", color: .black, size: 14, weight: .regular)
            let border = BorderProperties(edges: [.bottom], color: UIColor.black.withAlphaComponent(0.1), thickness: 1)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties)
        case .kredivoDiscount:
            let title = TextProperties(text: "Kredivo Diskon", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: "-Rp0", color: .black, size: 14, weight: .regular)
            let border = BorderProperties(edges: [.bottom], color: UIColor.black.withAlphaComponent(0.1), thickness: 1)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties)
        case .subtotal:
            let title = TextProperties(text: "Subtotal", color: .black, size: 14, weight: .regular)
            let content = TextProperties(text: order.product.price.toCurrency(), color: .black, size: 14, weight: .regular)
            let border = BorderProperties(edges: [.bottom], color: UIColor.black.withAlphaComponent(0.1), thickness: 1, isDashPattern: true)
            let properties = DetailProperties(title: title, content: content, border: border)
            return createDetailSection(indexPath: indexPath, properties: properties)
        case .paymentTerm:
            let title = TextProperties(text: "Bayar dalam 30 hari", color: .black, size: 14, weight: .bold)
            let content = TextProperties(text: order.product.price.toCurrency(), color: .kredivoOrange, size: 14, weight: .bold)
            let properties = DetailProperties(title: title, content: content, border: nil)
            return createDetailSection(indexPath: indexPath, properties: properties)
        case .voucherList:
            return createVoucherSection(indexPath: indexPath)
        case .voucherApplied:
            return createVoucherAppliedSection(indexPath: indexPath)
        case .pinInput:
            return createPINSection(indexPath: indexPath)
        case .termAndCondition:
            let attributedText = NSMutableAttributedString(string: "Dengan melanjutkan saya setuju dengan ", attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.5), .font: UIFont.systemFont(ofSize: 12)])
            let suffix = NSMutableAttributedString(string: "Perjanjian Pinjaman Kredivo", attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.kredivoBlue])
            attributedText.append(suffix)
            return createTitleSection(indexPath: indexPath, attributes: attributedText)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]

        switch section {
        case .mobileHeader:
            return 62
        default:
            return UITableView.automaticDimension
        }
    }

}

extension ConfirmationPaymentViewController: VoucherListViewDelegate {
    func didTapVoucherListButton() {
        let vc = VouchersViewController()
        vc.delegate = self
        vc.service = service
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ConfirmationPaymentViewController: VouchersViewControllerDelegate {
    func didSelect(voucher: Voucher) {
        selectedVoucher = voucher
        sections = [.mobileHeader, .paymentDetail, .phoneNumber, .additionalCost, .discount, .subtotal, .kredivoDiscount, .paymentTerm, .voucherApplied, .pinInput, .termAndCondition]
        tableView.reloadData()
    }
}

extension ConfirmationPaymentViewController: InputViewDelegate {
    func didGet(text: String) {
        pin = text
    }
}
