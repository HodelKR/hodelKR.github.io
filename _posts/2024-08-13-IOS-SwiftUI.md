---
layout: post
title: "SwiftUI 장점 및 실습"
categories: IOS
---

# SwiftUI
SwiftUI는 IOS13의 출시와 함께 제공된 UI프레임워크이다.
- 선언전 구문과 통합플랫폼을 지향한다.
- 하나의 도구 및 API로 모든 애플 기기의 사용자 인터페이스를 만든다.
- 주로 Declarative 구문을 사용한다.
## 장점
- UIHostingController를 사용하여 UIkit과 혼합 사용 가능
- 테마를 쉽게 관리
- SwiftUI는 BindableObject, ObjectBinding 및 전체 Combine 프레임 워크를 사용하여 반응형 프로그래밍을 위한 메커니즘을 제공

# SwiftUI 프로젝트 생성 시
아래부터는 https://developer.apple.com/tutorials/swiftui/creating-and-combining-views 의 내용을 실습하면서 작성했다.


SwiftUI 앱 생명주기는 App 프로토콜을 준수한다. 구조체 안에 body 프로퍼티는 하나 이상의 화면을 반환하고 디스플레이를 위한 콘텐츠를 제공한다. `@main`속성은 앱의 엔트리 포인트를 나타낸다.
```swift
// LandmarksApp.swift
import SwiftUI

@main
struct LandmarksApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```
기본적으로 SwiftUI의 View 파일은 Struct와 Preview를 선언한다. struct는 View 프로토콜을 준수하고 View의 내용과 Layout을 정의한다. Preview는 해당 View의 미리보기를 만든다.
```swift
// ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
```
body 프로퍼티의 내용을 변경하고 preview가 업데이트되는 것을 확인할 수 있습니다.
```swift
// ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello SwiftUI!")
    }
}

#Preview {
    ContentView()
}
```

# Live mode
캔버스는 기본적으로 미리 보기를 실시간 모드로 표시하여 사용자와 상호 작용할 수 있지만 선택 가능 모드를 사용하여 대신 편집을 사용할 수 있다.

- 미리보기에서 `Cmd+Ctrl+Click`를 하고 "Show SwiftUI Inspector"를 선택한다.
- 텍스트를 "Turtle Rock"으로 변경해본다.
- Font를 "Title"로 변경해본다.
- 이번엔 코드에서 `foregroundColor(.green)`를 추가한다.
- 이번엔 코드에서 Text를 우클릭해서 "Show SwiftUI Inspector"를 클릭해서 방금 추가한 속성을 제거해보자
- Live mode에서 작업하면 원본에서 편집할 때 보기 동작을 더 쉽게 추적할 수 있다.

# View 구조
VStack은 수직으로 쌓이는 스택이고 HStack은 수평으로 쌓이는 스택이다. VStack의 생성자를 변경함으로써 `aligment: .leading`을 매개변수로 수평정렬해준다. `Spacer()`는 개체 사이에 공백을 추가하는 역할을 해주고 VStack에 `.padding()`을 추가해주면서 VStack의 가장자리의 공간을 추가한다.
```swift
// ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
		VStack(alignment: .leading) {
			Text("Turtle Rock")
				.font(.title)
			HStack {
				Text("Joshua Tree National Park")
					.font(.subheadline)
				Spacer()
				Text("California")
					.font(.subheadline)
			}
		}
		.padding()
    }
}

#Preview {
    ContentView()
}
```
# Image View
Assets.xcassets 파일에서 이미지 그림을 추가한다. `Image()`에 매개변수로 이미지 이름을 넣어주면 ImageView가 생성된다.
`.clipShape(Circle())`옵션은 ImageView의 모양을 원으로 표시한다.
`overlay`옵션에서 `Circle()`모양의 외곽선을 회색 굵기는 4로 설정했다.
`.shadow`옵션에서 그림자를 설정한다
```swift
// CircleImage.swift
import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("turtlerock")
			.clipShape(Circle())
			.overlay {
				Circle().stroke(.gray, lineWidth: 4)
			}
			.shadow(radius: 7)
    }
}

#Preview {
    CircleImage()
}
```
# Map View
이번엔 지도를 불러오는 방법이다. SwiftUI에서 MapKit을 import해서 MapView와 관련된 라이브러리를 얻어온다. region을 정하고 body안에 MapView를 지정해주면 지도를 사용할 수 있다.
```swift
// MapView.swift
import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
		Map(initialPosition: .region(region))
    }
	private var region: MKCoordinateRegion {
		MKCoordinateRegion(
			center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
			span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
		)
	}
}

#Preview {
    MapView()
}
```
# View 결합
지금까지 만들어놓은 ContentView, ImageView, MapView를 한 곳에 합칠 것이다. 새로운 `VStack`을 만들어서 거기에 MapView와 ImageView를 추가한다. 각각 보기 좋게 설정한다. `.frame`으로 높이를 조절한다. 너비는 따로 언급하지 않으면 알아서 알맞게 설정된다. `offset`, `padding`으로 위치도 조절한다. 또 아래 `Divider()`를 사용해서 TextView 사이에 구분선을 넣어줄 수 있다.
```swift
// ContentView.swift

import SwiftUI

struct ContentView: View {
    var body: some View {
		VStack {
			MapView()
				.frame(height: 300)
			
			CircleImage()
				.offset(y: -130)
				.padding(.bottom, -130)
			
			VStack(alignment: .leading) {
				Text("Turtle Rock")
					.font(.title)
				HStack {
					Text("Joshua Tree National Park")
					Spacer()
					Text("California")
				}
				.font(.subheadline)
				.foregroundColor(.secondary)
				
				Divider()
				
				Text("About Turtle Rock")
					.font(.title2)
				Text("Descriptive next goes here.")
			}
			.padding()
			
			Spacer()
		}
    }
}

#Preview {
    ContentView()
}
```
