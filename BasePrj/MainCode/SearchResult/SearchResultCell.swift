//
//  SearchResultCell.swift
//  EFarmSwift
//
//  Created by n369 on 2017/9/4.
//  Copyright © 2017年 Shown. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    //MARK: - 初始化
    let titleLabel : UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: ScreenWidth - 20 - ScreenWidth/3, height: 50))
        label.font = TitleFont
        label.numberOfLines = 2
        label.textColor = TitleColor
        return label
    }()
    
    let rightImage : UIImageView = {
        let image = UIImageView.init(frame: CGRect.init(x: 10 + (ScreenWidth/3-30.0/3) * 2 + 10, y: 35, width: ScreenWidth/3-30.0/3, height: 72/375*ScreenWidth))
        return image
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 90-72+72/375*ScreenWidth, width: ScreenWidth - 20 - ScreenWidth/3, height: 30))
        label.font = DetailFont
        label.textColor = DetailColor
        return label
    }()

    func setView(model : SearchResultModel) -> Void {
        
        titleLabel.text = model.title
        rightImage.kf_setImage(with: URL.init(string: model.image), placeholder: UIImage.init(named: "pl_product"))
        
        var detail = (model.time as NSString).substring(to: 10)
        detail = detail + "  " + model.detail
        detailLabel.text = detail
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rightImage)
        self.contentView.addSubview(detailLabel)
        //        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
