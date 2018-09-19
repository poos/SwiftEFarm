//
//  HomeTableCell.swift
//  EFarmSwift
//
//  Created by Shown on 2017/8/31.
//  Copyright © 2017年 Shown. All rights reserved.
//

import UIKit
import Kingfisher

class HomeTableCell: UITableViewCell {
    var isSetTouch : Bool = false
    
    //MARK: - 初始化
    let titleLabel : UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 5, width: ScreenWidth - 20 - ScreenWidth/3, height: 50))
        label.font = TitleFont
        label.numberOfLines = 2
        label.textColor = TitleColor
        return label
    }()
    
    let leftImage : UIImageView = {
        let image = UIImageView.init(frame: CGRect.init(x: 10, y: 35, width: ScreenWidth/3-30.0/3, height: 72/115*(ScreenWidth/3-30.0/3)))
        return image
    }()
    
    let middleImage : UIImageView = {
        let image = UIImageView.init(frame: CGRect.init(x: 10 + (ScreenWidth/3-30.0/3) + 5, y: 35, width: ScreenWidth/3-30.0/3, height: 72/115*(ScreenWidth/3-30.0/3)))
        return image
    }()
    
    let rightImage : UIImageView = {
        let image = UIImageView.init(frame: CGRect.init(x: 10 + (ScreenWidth/3-30.0/3) * 2 + 10, y: 35, width: ScreenWidth/3-30.0/3, height: 72/115*(ScreenWidth/3-30.0/3)))
        return image
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 110 - 72 + 72/115*(ScreenWidth/3-30.0/3), width: ScreenWidth - 20 - ScreenWidth/3, height: 30))
        label.font = DetailFont
        label.textColor = DetailColor
        return label
    }()

    //MARK: - setValue
    func setTitleView(model : HomeModel) -> Void {
        titleLabel.text = model.title
        detailLabel.text = model.cellDetail
    }
    func setOnePicView(model : HomeModel) -> Void {
        titleLabel.text = model.title
        detailLabel.text = model.cellDetail
        
        rightImage.kf_setImage(with: URL.init(string: (model.images?.first)!), placeholder: UIImage.init(named: "img"))
    }
    func setThreePicView(model : HomeModel) -> Void {
        titleLabel.text = model.title
        detailLabel.text = model.cellDetail
        
        leftImage.kf_setImage(with: URL.init(string: (model.images?.first)!), placeholder: UIImage.init(named: "pl_product"))
        middleImage.kf_setImage(with: URL.init(string: (model.images?[1])!), placeholder: UIImage.init(named: "pl_product"))
        rightImage.kf_setImage(with: URL.init(string: (model.images?[2])!), placeholder: UIImage.init(named: "pl_product"))
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        
        if reuseIdentifier == identifierTitle {
            titleLabel.frame.size = CGSize.init(width: ScreenWidth - 20, height: 30)
            titleLabel.numberOfLines = 1
            detailLabel.frame.origin.y = 50
        }
        if reuseIdentifier == identifierOnePic {
            titleLabel.frame.size = CGSize.init(width: ScreenWidth - 20 - ScreenWidth/3, height: 50)
            titleLabel.numberOfLines = 2
            rightImage.frame.origin.y = 15
            detailLabel.frame.origin.y = 90-72 + 72/115*(ScreenWidth/3-30.0/3)
            self.contentView.addSubview(rightImage)
        }
        if reuseIdentifier == identifierThreePic {
            titleLabel.frame.size = CGSize.init(width: ScreenWidth - 20, height: 30)
            titleLabel.numberOfLines = 1
            rightImage.frame.origin.y = 35
            detailLabel.frame.origin.y = 110-72 + 72/115*(ScreenWidth/3-30.0/3)
            self.contentView.addSubview(leftImage)
            self.contentView.addSubview(middleImage)
            self.contentView.addSubview(rightImage)
        }
//        leftImage.contentMode = .center
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        
//        print(ScreenWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - mark
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
