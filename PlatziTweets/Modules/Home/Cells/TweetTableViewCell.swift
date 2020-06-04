//
//  TweetTableViewCell.swift
//  PlatziTweets
//
//  Created by Kary on 28/05/20.
//  Copyright © 2020 Kary. All rights reserved.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    //IMPORTANTE:
    //Las celdas NUNCA deben invocar ViewControllers
    
    @IBAction func openVideoAction() {
        
        guard let videoUrl = videoUrl else {
            return
        }
        needsToShowVideo?(videoUrl)
    }
     //MARK: - Properties
    private var videoUrl: URL?
    var needsToShowVideo: ((_ url: URL) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWith(post: Post) {
        //Si el post no tiene un video, el botón estará oculto
        videoButton.isHidden = !post.hasVideo
        
        nameLabel.text = post.author.names
        nicknameLabel.text = post.author.nickname
        messageLabel.text = post.text
        
        if post.hasImage {
            tweetImageView.isHidden = false
            videoButton.isHidden = false
            //Configurar imagen, import Kingfisher
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl))
        }else{
            tweetImageView.isHidden = true
            
        }
        
        videoUrl = URL(string: post.videoUrl)
    }
    
}
