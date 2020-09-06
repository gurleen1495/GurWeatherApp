//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by Gurleen Osahan on 06/09/20.
//  Copyright © 2020 Gurleen Osahan. All rights reserved.
//

import UIKit
import  CoreLocation

class WeatherVC: UIViewController {
   
    var weatherCoordinates: CLLocationCoordinate2D?
    var kBaseUrl =  "http://api.openweathermap.org/data/2.5/weather?APPID=864e907f7fd95a4a7839302e5f971232&"
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblRain: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.callApi()

    }

    func fetchWeatherData(completionHandler: @escaping (WeatherData) -> Void) {
        guard let coord = self.weatherCoordinates else{
            return
        }
        
        guard let url = URL(string: kBaseUrl + "lat=" + "\(coord.latitude)" + "&lon=" + "\(coord.longitude)") else{
            return
        }

      let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
        
        if let error = error {
          print("Error with fetching films: \(error)")
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
          print("Error with the response, unexpected status code: \(response)")
          return
        }

        
          do {
    
            let weatherData = try JSONSerialization.jsonObject(
                with: data!,
              options: .mutableContainers) as! [String: AnyObject]
            
            let weather = WeatherData(weatherData: weatherData)
            
           completionHandler(weather)
          }
          catch let jsonError as Error {
          }
        
        
        
      })
      task.resume()
    }

    
    func callApi(){
        self.fetchWeatherData { (weather) in
                DispatchQueue.main.async {
                    self.lblCity.text = weather.city
                    
                    self.lblTemp.text = "\(Int(round(weather.tempCelsius)))°"
                    
                    if let rain = weather.rainfallInLast3Hours {
                        self.lblRain.text = "\(rain) mm"
                    }
                    else {
                        self.lblRain.text = "None"
                    }
                    
                    self.lblHumidity.text = "\(weather.humidity)%"
                }
              
                
            }
    }
}
