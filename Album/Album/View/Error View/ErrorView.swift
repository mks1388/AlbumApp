//
//  ErrorView.swift
//  Album
//
//  Created by Mithilesh Singh on 20/06/19.
//  Copyright © 2019 Mithilesh Kumar Singh. All rights reserved.
//

import UIKit

protocol ErrorViewInterface : class {
    var delegate : ErrorViewDelegate? {get set}
    func updateError(message: String)
}

protocol ErrorViewDelegate : class {
    func errorViewDidClickRetry()
}

class ErrorView: UIView, ErrorViewInterface, ReusableInterface {

    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var retryButton: UIButton!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var imageVIew: UIImageView!
    
    weak var delegate : ErrorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = self.bounds
    }
    
    // MARK: Private
    private func loadViewNib() {
        Bundle.main.loadNibNamed(ErrorView.reuseIdentifier, owner: self, options: nil)
        self.addSubview(contentView)
        self.backgroundColor = UIColor.red
    }
    
    // MARK: ErrorViewInterface
    func updateError(message: String) {
        messageLabel.text = message
    }
    
    // MARK: IBAction
    @IBAction func retryButtonClicked(_ sender: UIButton) {
        delegate?.errorViewDidClickRetry()
    }
}
