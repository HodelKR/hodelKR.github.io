---
layout: post
title: "Building lists and navigation"
categories: IOS
---
이 글은 애플 개발자 사이트의 https://developer.apple.com/tutorials/swiftui/building-lists-and-navigation 의 내용을 실습하면서 이해한 내용을 작성한 것이다.

## 구현 실습
Landmark 구조체는 각각의 Landmark들이 가져야하는 프포러티를 포함한다. id, name, park, state, description을 일반 프로퍼티로 가지고 image 정보 프로퍼티, MapView에서 표현하기 위한 좌표 프로퍼티를 지닌다.

```swift
// Landmark.swift
import Foundation
import SwiftUI
import CoreLocation

struct Landmark: Hashable, Codable {
	var id: Int
	var name: String
	var park: String
	var state: String
	var description: String
	
	private var imageName: String
	var image: Image{
		Image(imageName)
	}
	
    private var coordinates: Coordinates

    private var coordinates: Coordinates
	var locationCoordinate: CLLocationCoordinate2D {
		CLLocationCoordinate2D(
			latitude: coordinates.latitude,
			longitude: coordinates.longitude)
	}
	
	struct Coordinates: Hashable, Codable {
		var latitude: Double
		var longitude: Double
	}
}
```
landmark 정보를 json 파일에서 가져오기 위해 json을 로드하는 함수를 작성해야 한다. Landmark 구조체에 대한 배열인 landmarks를 선언하고 작서한 load함수를 통해 landmark 정보를 가져온다.
```swift
// ModelData.swift
import Foundation

var landmarks: [Landmark] = load("landmarkData.json")

func load<T: Decodable>(_ filename: String) -> T {
	let data: Data
	
	guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
	else {
		fatalError("Couldn't find \(filename) in main bundle.")
	}
	
	do {
		data = try Data(contentsOf: file)
	} catch {
		fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
	}
	
	do {
		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: data)
	} catch {
		fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
	}
}
```
이제는 각각에 view에서 landmarks 구조체에서 정보를 가져올 수 있게 세팅해 줘야 한다. 처음은 MapView로 CLLocationCoordinate2D 타입의 프로퍼티를 만들어서 해당 좌표 정보를 map에 찍어줄 수 있게 한다.
```swift
// MapView.swift
import SwiftUI
import MapKit

struct MapView: View {
	var coordinate: CLLocationCoordinate2D


	var body: some View {
		Map(position: .constant(.region(region)))
	}


	private var region: MKCoordinateRegion {
		MKCoordinateRegion(
			center: coordinate,
			span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
		)
	}
}


#Preview {
	MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
}
```
ImageView에서도 image 프로퍼티를 통해서 Image 정보를 받아 Image를 화면에 출력되도록 해준다.
```swift
// CircleImage.swift
import SwiftUI

struct CircleImage: View {
	var image: Image


	var body: some View {
		image
			.clipShape(Circle())
			.overlay {
				Circle().stroke(.white, lineWidth: 4)
			}
			.shadow(radius: 7)
	}
}


#Preview {
	CircleImage(image: Image("turtlerock"))
}

```
이번에는 Landmark들을 목록화해서 보기 위해 각각의 행을 표현하는 landmarkRow를 만들어서 각각의 행이 하나의 랜드마크를 표현할 수 있게 만든다. 역시나 Landmakr 구조체 타입의 프로퍼티를 받아 각각의 행을 표현할 수 있게 한다.
```swift
// LandmarkRow.swift
import SwiftUI

struct LandmarkRow: View {
	var landmark: Landmark
	
    var body: some View {
		HStack {
			landmark.image
				.resizable()
				.frame(width:50, height: 50)
			Text(landmark.name)
			Spacer()
		}
    }
}

#Preview {
	Group{
		LandmarkRow(landmark: landmarks[0])
		LandmarkRow(landmark: landmarks[1])
	}
}
```
각각에 행에 대해서 만들었다면 이번엔 행을 여러개 합친 리스트를 만들어줘야 한다. 랜드마크 이름을 표현하는 행을 클릭하면 해당 랜드마크의 상세한 정보를 보여주게 하기 위해 NavigationSplitView를 사용해 label은 LandmarkRow로 표현하고 상세 정보는 LandmarkDetail로 표현한다. LandmarkDetail View에 대한 설명은 다음에 나온다.
```swift
// LandmarkList.swift
struct LandmarkList: View {
	var body: some View {
		NavigationSplitView {
			List(landmarks) { landmark in
				NavigationLink {
					LandmarkDetail(landmark: landmark)
				} label: {
					LandmarkRow(landmark: landmark)
				}
			}
			.navigationTitle("Landmarks")
		} detail: {
			Text("Select a Landmark")
		}
	}
}


#Preview {
	LandmarkList()
}
```
지난 글에서 작성했던 ContentView를 변형해서 MapView, CircleImgae에 있는 프로퍼티들에 landmark 정보를 넣어주면서 해당 Landmark의 상세 정보를 표현한다. 위 아래로 많은 정보를 담고 있기 때문에 ScrollView를 사용하여 위 아래 스크롤할 수 있게 한다.
```swift
// LandmarkDetail.swift
struct LandmarkDetail: View {
	var landmark: Landmark

	var body: some View {
		ScrollView {
			MapView(coordinate: landmark.locationCoordinate)
				.frame(height: 300)


			CircleImage(image: landmark.image)
				.offset(y: -130)
				.padding(.bottom, -130)


			VStack(alignment: .leading) {
				Text(landmark.name)
					.font(.title)


				HStack {
					Text(landmark.park)
					Spacer()
					Text(landmark.state)
				}
				.font(.subheadline)
				.foregroundStyle(.secondary)

				Divider()

				Text("About \(landmark.name)")
					.font(.title2)
				Text(landmark.description)
			}
			.padding()
		}
		.navigationTitle(landmark.name)
		.navigationBarTitleDisplayMode(.inline)
	}
}


#Preview {
	LandmarkDetail(landmark: landmarks[0])
}

```