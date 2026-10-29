import UIKit
import AVFoundation

struct Track {
    let title: String
    let artist: String
    let fileName: String
    let coverImageName: String
    let backgroundImageName: String
}

struct TrackLibrary {
    static let tracks: [Track] = [
        Track(title: "Nervous", artist: "The Neighbourhood", fileName: "nervous", coverImageName: "CoverNervous", backgroundImageName: "BackgroundNervous"),
        Track(title: "Paint The Town Red", artist: "Doja Cat", fileName: "paint_the_town_red", coverImageName: "CoverPaintTheTownRed", backgroundImageName: "BackgroundPaintTheTownRed"),
        Track(title: "Arabella", artist: "Arctic Monkeys", fileName: "arabella", coverImageName: "CoverArabella", backgroundImageName: "BackgroundArabella"),
        Track(title: "Fireside", artist: "Arctic Monkeys", fileName: "fireside", coverImageName: "CoverFireside", backgroundImageName: "BackgroundFireside"),
        Track(title: "In Your Eyes", artist: "The Weeknd", fileName: "in_your_eyes", coverImageName: "CoverInYourEyes", backgroundImageName: "BackgroundInYourEyes"),
        Track(title: "Doin' Time", artist: "Lana Del Rey", fileName: "doin_time", coverImageName: "CoverDoinTime", backgroundImageName: "BackgroundDoinTime"),
        Track(title: "Human Nature", artist: "Michael Jackson", fileName: "human_nature", coverImageName: "CoverHumanNature", backgroundImageName: "BackgroundHumanNature"),
        Track(title: "Butterfly Effect", artist: "Travis Scott", fileName: "butterfly_effect", coverImageName: "CoverButterflyEffect", backgroundImageName: "BackgroundButterflyEffect"),
        Track(title: "Don't Blame Me", artist: "Taylor Swift", fileName: "dont_blame_me", coverImageName: "CoverDontBlameMe", backgroundImageName: "BackgroundDontBlameMe"),
        Track(title: "Good For You", artist: "Selena Gomez feat. A$AP Rocky", fileName: "good_for_you", coverImageName: "CoverGoodForYou", backgroundImageName: "BackgroundGoodForYou")
    ]
}

class ViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    let tracks = TrackLibrary.tracks
    var currentIndex = 0
    var isPlaying = false
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        previousButton.setTitle(nil, for: .normal)
        playPauseButton.setTitle(nil, for: .normal)
        nextButton.setTitle(nil, for: .normal)

        previousButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)

        showTrack()
    }

    func showTrack() {
        player?.stop()
        player = nil

        let track = tracks[currentIndex]

        titleLabel.text = track.title
        artistLabel.text = track.artist
        coverImageView.image = UIImage(named: track.coverImageName)
        backgroundImageView.image = UIImage(named: track.backgroundImageName)

        guard let url = Bundle.main.url(
            forResource: track.fileName,
            withExtension: "mp3",
            subdirectory: "Sounds"
        ) else {
            print("Audio file not found: \(track.fileName).mp3")
            isPlaying = false
            updatePlayPauseIcon()
            return
        }

        player = try? AVAudioPlayer(contentsOf: url)

        if player == nil {
            print("Could not load audio: \(track.fileName).mp3")
            isPlaying = false
            updatePlayPauseIcon()
            return
        }

        player?.delegate = self
        player?.prepareToPlay()

        if isPlaying {
            player?.play()
        }

        updatePlayPauseIcon()
    }

    func updatePlayPauseIcon() {
        if isPlaying {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    @IBAction func playPauseDidTap(_ sender: UIButton) {
        guard let player = player else {
            print("No audio player is available.")
            return
        }

        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            if player.currentTime >= player.duration {
                player.currentTime = 0
            }
            player.play()
            isPlaying = true
        }

        updatePlayPauseIcon()
    }

    @IBAction func previousDidTap(_ sender: UIButton) {
        if currentIndex == 0 {
            currentIndex = tracks.count - 1
        } else {
            currentIndex -= 1
        }

        showTrack()
    }

    @IBAction func nextDidTap(_ sender: UIButton) {
        currentIndex += 1

        if currentIndex == tracks.count {
            currentIndex = 0
        }

        showTrack()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentIndex += 1

        if currentIndex == tracks.count {
            currentIndex = 0
        }

        isPlaying = true
        showTrack()
    }
}
