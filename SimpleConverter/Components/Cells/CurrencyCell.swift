import UIKit

final class CurrencyCell: UITableViewCell {
    let currencyConverterImageView = CurrencyConverterImageView(frame: .zero)
    let label = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(metaData: MetaData) {
        label.text = metaData.assetId
        if let imageUrl = URL(string: metaData.url) {
            currencyConverterImageView.downloadImage(from: imageUrl)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        contentView.addSubview(currencyConverterImageView)
        label.font = .systemFont(ofSize: 20.0, weight: .thin)
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 50),
            currencyConverterImageView.heightAnchor.constraint(equalToConstant: 40),
            currencyConverterImageView.widthAnchor.constraint(equalToConstant: 60),
            currencyConverterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            currencyConverterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: currencyConverterImageView.trailingAnchor, constant: 16)
        ])
    }
}
