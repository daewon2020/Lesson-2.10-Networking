//
//  ViewController.swift
//  Lesson 2.10
//
//  Created by Kostya on 03.04.2022.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var datetimeLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var forecastTableView: UITableView!
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    
    private var yandexWeather: YandexWeather!
    private var forecasts: [Forecasts]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStackView.isHidden = true
        refreshWeather()
    }

}

//MARK: - Private Methods
extension WeatherViewController {
    
    private func refreshWeather() {
        NetworkManager.shared.fetchWeather { result in
            switch result {
            case .success(let yandexWeather):
                self.setUI(from: yandexWeather)
            case .failure(let error):
                self.showAlert(with: "\(error)")
            }
        }

    }
    
    private func getDayOfWeek(from dateTime: Double) -> String {
        let dateTimeFromString = Date(timeIntervalSince1970: dateTime)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        
        return dateFormatter.string(from: dateTimeFromString)
    }
    
    private func showAlert(with message: String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
        }
    }
    
    private func setUI(from yandexWeather: YandexWeather) {
        guard let temp = yandexWeather.fact?.temp else { return }
        guard let feelsLike = yandexWeather.fact?.feels_like else { return }
        guard let image = yandexWeather.fact?.condition else { return }
        guard let dayOfWeek = yandexWeather.now else { return }
        guard let forecasts = yandexWeather.forecasts else { return }
        guard let country = yandexWeather.geo_object?.country?.name else { return }
        guard let district = yandexWeather.geo_object?.province?.name else { return }
        guard let city = yandexWeather.geo_object?.locality?.name else { return }
        
        let wind = yandexWeather.fact?.windString
        let humidity = yandexWeather.fact?.humidityString
        let pressure = yandexWeather.fact?.pressureString
        
        self.locationLabel.text = "\(city), \(district), \(country)"
        self.tempLabel.text = "\(temp) ˚C"
        self.feelsLikeLabel.text = "Ощущается как: \(feelsLike) ˚C"
        self.weatherImage.image = UIImage.init(named: image)
        self.datetimeLabel.text = self.getDayOfWeek(from: dayOfWeek)
        self.windLabel.text = wind
        self.humidityLabel.text = humidity
        self.pressureLabel.text = pressure
        self.forecasts = forecasts
        
        self.activityIndicator.stopAnimating()
        self.mainStackView.isHidden = false
        
        
        self.forecastTableView.reloadData()
    }
}


//MARK: - TableView methods
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecasts != nil ? forecasts.count-1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "forecastID", for: indexPath) as? ForecastTableViewCell else { return UITableViewCell.init()}
        let index = indexPath.row + 1
        guard let temp = forecasts[index].parts?.day?.temp_avg else { return cell }
        guard let image = forecasts[index].parts?.day?.condition else { return cell }
        guard let dayOfWeek = forecasts[index].date_ts else { return cell }
        let imageWithoutDash = image.filter { $0 != "-" }
        
        cell.weatherImage.image = UIImage(named: imageWithoutDash)
        cell.tempLabel.text = "\(temp)"
        cell.dayOfWeekLabel.text = getDayOfWeek(from: dayOfWeek)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
}
