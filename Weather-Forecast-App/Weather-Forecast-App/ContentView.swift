//
//  ContentView.swift
//  Weather-Forecast-App
//
//  Created by Bernardo Cervantes Mayagoitia on 8/30/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: CurrentWeatherModel?
    @State var forecast: ForecastWeatherModel?
    
    var body: some View {
        VStack {
            
            if let location = locationManager.location {
                
                if let weather = weather {
                    if let forecast = forecast {
                        WeatherView(weather: weather, forecast: forecast)
                            .environmentObject(locationManager)
                    } else {
                        LoadingView()
                            .task {
                                do {
                                   forecast = try await weatherManager.getForecastWeather(latitude: location.latitude, longitude: location.longitude)
                                } catch ErrorTypes.invalidURL {
                                    print("Error getting weather from URL")
                                } catch ErrorTypes.invalidHttpResponse {
                                    print("Error getting weather from HTTP response")
                                } catch {
                                    print("Error getting weather: \(error)")
                                }
                            }
                    }
                    
                } else {
                    LoadingView()
                        .task {
                            do {
                               weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch ErrorTypes.invalidURL {
                                print("Error getting weather from URL")
                            } catch ErrorTypes.invalidHttpResponse {
                                print("Error getting weather from HTTP response")
                            } catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
                
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
