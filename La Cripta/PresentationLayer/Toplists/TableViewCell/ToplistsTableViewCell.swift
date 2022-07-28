//
//  ToplistsTableViewCell.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit

final class ToplistsTableViewCell: UITableViewCell {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    var fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    var tickerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    var tickerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBackground
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubviews(nameLabel, fullNameLabel, priceLabel, tickerView)
        tickerView.addSubview(tickerLabel)
        
        let margin = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            
            nameLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            
            fullNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            fullNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            
            tickerView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            tickerView.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            tickerView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10),
            tickerView.heightAnchor.constraint(equalToConstant: 24),
            tickerView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
            tickerLabel.leadingAnchor.constraint(equalTo: tickerView.leadingAnchor, constant: 8),
            tickerLabel.trailingAnchor.constraint(equalTo: tickerView.trailingAnchor, constant: -8),
            tickerLabel.centerYAnchor.constraint(equalTo: tickerView.centerYAnchor)
        ])
    }
    
    func fill(with data: LCToplistsDataResponse, changeDuration: valueChangeDuration) {
        contentView.fadeOut()
        nameLabel.text = data.coinInfo.name
        fullNameLabel.text = data.coinInfo.fullName
        let change: Double? = {
            switch changeDuration {
            case .day:
                return data.raw?.usd.changeDay
            case .hour:
                return data.raw?.usd.changeHour
            case .last24Hour:
                return data.raw?.usd.change24Hour
            }
        }()
        guard let price = data.raw?.usd.price,
              let change = change
        else { return }
        let roundedChange = round(change * 100) / 100.0
        var changePercentage = ((price + change) / price)
        var changeString = ""
        if change > 0 {
            changePercentage = (changePercentage - 1.0) * 100
            let changePercentageString = String(format: "%.2f", changePercentage)
            changeString = "+\(roundedChange) (+\(changePercentageString)%)"
            tickerView.backgroundColor = .systemGreen
        } else {
            changePercentage = (1.0 - changePercentage) * 100
            let changePercentageString = String(format: "%.2f", changePercentage)
            changeString = "\(roundedChange) (-\(changePercentageString)%)"
            tickerView.backgroundColor = .systemRed
        }
        priceLabel.text = price.convertToCurrency()
        tickerLabel.text = changeString
        contentView.fadeIn()
    }
    
    func fill(with liveData: LCWSDataResponse, fullName: String, openValue: Double?) {
        contentView.fadeOut()
        nameLabel.text = liveData.fromSymbol
        fullNameLabel.text = fullName
        let price = liveData.price
        let change = price - (openValue ?? 0)
        let roundedChange = round(change * 100) / 100.0
        var changePercentage = ((price + change) / price)
        var changeString = ""
        if change > 0 {
            changePercentage = (changePercentage - 1.0) * 100
            let changePercentageString = String(format: "%.2f", changePercentage)
            changeString = "+\(roundedChange) (+\(changePercentageString)%)"
            tickerView.backgroundColor = .systemGreen
        } else {
            changePercentage = (1.0 - changePercentage) * 100
            let changePercentageString = String(format: "%.2f", changePercentage)
            changeString = "\(roundedChange) (-\(changePercentageString)%)"
            tickerView.backgroundColor = .systemRed
        }
        priceLabel.text = price.convertToCurrency()
        tickerLabel.text = changeString
        contentView.fadeIn()
    }
}
