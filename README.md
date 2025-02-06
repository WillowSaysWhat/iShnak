<p align="center">
<img src="/iShankBanner.png" alt="banner">
</P>

# Table of Contents

---

* [Activity Ring](#activity-ring)
  
* [Pulse Animation](#pulse-animation)
  
---

* [Model](#model)
  
---

* [Activity Views (water, coffee...)](#activity-views-water-coffee-snacks-meals)
  
* [daily View](#daily-view)
  
* [Settings View](#settings-view)
  
* [Content View](#content-view)
  
* [iShnak](#ishnak-view)
  
---

# Activity Ring

This is a circular progress ring that represents the amount of items the user has consumed. it has 2 components. They are:

* Background Circle: A gray, semi transparent ring that serves as a base.
* Progress Ring: A dynamically trimmed, colored arc representing progress, with smooth animation for visual appeal.

It is refactored into its own view.

## Variables

The AvtivityRing has 4 variables. the `progress` variable uses decimal numbers below 1 to visualise the increase of food, water, and coffee by incrementing by 0.1. So an empty bar will be signaled at 0.0 and a full bar at 1.0. 

The `ringColour` is passed by a view. this is type `Color`. An example of a color could be `.blue` or `.brown`.

The `lineWidth` decides on the size of the donut hole.

```swift
    var progress: Double // makes the bar color progress
    var ringColour: Color // colour of the progress
    var lineWidth: CGFloat // width of the ring
    var backgroundColor: Color = Color.gray.opacity(0.2)
```

The base ring is a simple `Circle()` with the stroke modifier which creates a hole in the circle, or better yet - creates a ring from a circle. the `lineCap` rounds off the ends of the ring if necessary. Here it is not, howeve it is a required argument.

```swift
            Circle()
            .stroke( // makes the circle a donut
                backgroundColor,
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )

```

the activity ring `Circle()` has more to it. It has the same attributes as the base circle, however, a tim modifier lets us display the circle as a progress bar. The arguament accepted by `.trim` are `from:` and `to:` which decide the length of the circle. The `.stroke` modifier creates the donut-shaped bar and it is rotated by the `.rotationEffect()` to start at the top of the ring and travel clockwise. The changes are displayed by animation using the `.animation()` modifier.

```swift
            Circle()
            .trim(from: 0.0, to: progress) // decides the size of the segment (blue)
            .stroke(
                ringColour,
                style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
            )
            .rotationEffect(.degrees(-90)) // Start from top
            .animation(.easeInOut, value: progress) // Smooth animation

```

The activity ring is used on all view except the settings view.

<p align="center">
<img src="/gifs/ezgif.com-video-to-gif-converter.gif" alt="gif">
</P>

## Full implementation: Activity Ring

```swift
struct ActivityRingView: View {
    var progress: Double // makes the bar color progress
    var ringColour: Color // colour of the progress
    var lineWidth: CGFloat // width of the ring
    var backgroundColor: Color = Color.gray.opacity(0.2)

    var body: some View {
        ZStack {
            // Background Circle: The dark gray circle.
            Circle()
                .stroke( // makes the circle a donut
                    backgroundColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            
            // Progress Ring: The coloured progress ring.
            Circle()
                .trim(from: 0.0, to: progress) // decides the size of the segment (blue)
                .stroke(
                    ringColour,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.easeInOut, value: progress) // Smooth animation
        }
    }
}

```

# Pulse animation

The pulse animation can be seen above. it is a line pulse animation that is present on all activity views. When the user taps the progress button to input data, the animation is activated.
The appearance of the pulse is dictated by the view. It is a boolean variable that decides whether the animation should run. When the pulse animation view appears, the boolean value of `animate` is changed to true. This fires the animation.

## Variables

The view has 2 variables. The first is `animate` and it dictates whether the whole animation excecutes or not. The second is a `Color` type variable that is passed by the parent view. `.reddish` for example. This colour matches the colour palette of that view.

```swift
@State private var animate = false // toggles when the animation should activate.
    let colour: Color
```

## View

The animation loops 3 times, generating circles that animate in sequence.
Each circle:-

* Starts small (scaleEffect(0.5)) and fades in (opacity(1)).
* Expands (scaleEffect(1.5)) and fades out (opacity(0)) when animate is true.
* Uses animation(.easeOut(duration: 1).repeatCount(0).delay(i * 0.4)) to stagger animations with a 0.4s delay between each circle.

When the view appears, animate is set to true inside the `onappear()` modeifier, triggering the ripple animation. The pulse effect only for show and is pleasing to the eyes.

```swift
 ZStack {
        ForEach(0..<3) { i in
            Circle()
                .stroke(colour, lineWidth: 3)
                .scaleEffect(animate ? 1.5 : 0.5)
                .opacity(animate ? 0 : 1)
                 .animation(
                     .easeOut(duration: 1)
                     .repeatCount(0)
                     .delay(Double(i) * 0.4), value: animate)
            }
        }
        .onAppear {
            animate = true
    }
```

## Full implementation: Pulse Animation

```swift
// pulsing animation that activates on each press of a progress button.
struct Pulse: View {
    @State private var animate = false // toggles when the animation should activate.
    let colour: Color // each view uses a different colour.
    
    // gets the correct colour for each view. e.g. blue for water, brown for coffee.
    init(c: Color) {
        self.colour = c
    }
    
// The ripple effect is 2 circles that grow and fade using animation to change the scale and opacity.
    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(colour, lineWidth: 3)
                    .scaleEffect(animate ? 1.5 : 0.5)
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1)
                            .repeatCount(0)
                            .delay(Double(i) * 0.4), value: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

```

# Model

The Model is a large document. to read about the model please click [here](/Model.md) to navigate to the dedicated Model page.

# Activity Views (water, coffee, snacks, meals)

Each view is an almost identical implementation of the original `WaterView()` view. At first glance, it seemed appropriate to refoactor the view and use a simple implementation to cover all four view.
however, sending multiple functions as argument made the refoactoring overly complex. For readability, the implementation was repeated instead.

## Variables

The viewe uses 4 variables;

* Model object from the parent view.
* the ontap boolean for activating the button animation.
* the show pulse boolean to commence the pulse animation.
* the `Color` variable for both ring and button.

```swift
@EnvironmentObject var model: Model
    
    // animation variables
    @State private var ontap: Bool = false
    @State private var showPulse: Bool = false
    // colour for the circle, activity ring, and pulse animation.
    @State private var colour: Color = .brown

```

Most of the functionality for all activity views can be seen on line 47 of `WaterView.swift`

```swift
.onTapGesture {
                    // when te circle is tapped
                    // animate the button tap by lowering opacity
                    // show the pulse animation
                    // if the ring is full, reset.
                    // add +1 to total coffee
                    // othewise add to ring and add to total coffee.
                    // save to phone data.
                withAnimation(.linear(duration: 0.3)) {
                        ontap.toggle()
                        showPulse = true
                        if model.userData.coffeeDrank >= 0.9 {
                            model.userData.coffeeDrank = 0.0
                            model.userData.totalCoffee += 0.1
                        } else {
                            model.userData.coffeeDrank += 0.1
                            model.userData.totalCoffee += 0.1
                        }
                        model.save()
                    }
                    // now return circle and icon to their original opacity
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.linear(duration: 0.3)) {
                            ontap = false
                        }
                    }
                }

```
This `.withAnimation` is embedded within an `.ontapGesture`. When the user taps the icon button, the toggles the button animation, `ontap`, the pulse animation `showPulse`, it checks to see if the ring is full and if so - resets it back to emply while recording +1 to the total.

This lets the ring reset while maintaining the users continuous input.

if the ring is not full, the ring is filled by 1 `coffeeDrank` and plus 1 is added to the daily total.

The view is build from a single `ActivityRingView()`, a bottom `Circle()` that matches the ring colour, an icon, and an invisible `Circle()`. All in a `ZStack`.

```swift
ZStack {
            // Activity Ring
            ActivityRingView(progress: model.userData.coffeeDrank, ringColour: .brown, lineWidth: 22)
                .frame(width: 180)

            // bottom circle that you can see (brown)
            Circle()
                .frame(width: 120)
                .foregroundStyle(colour.gradient)
                .opacity(ontap ? 0.5 : 1)

            // The coffee cup icon
            Image(systemName: (model.userData.coffeeDrank >= 0.9) ? "repeat.circle" : "cup.and.heat.waves.fill")
                .font(.system(size: 70))
                .foregroundStyle(.white)
                .opacity(ontap ? 0.5 : 1) // changes opacity when tapped.
                .offset(x:4)
            // invisible circle
            Circle()
                .frame(width: 100)
                .foregroundStyle(colour.gradient)
                .opacity(0.1)
                // extra code availble in full implementation below/
}
```

The invisible circle was placed on top of the icon to remove a 'deadzone' that prevented the user from swiping up. It seems like the watch emulator demands a widget on screen to be able to activate the scroll mechanism. If the users attempted to scroll adjacent to the icon, the screen refused to react. Placing the invisible circle over the icon fixed this problem. it also allow for the attacting of all modifiers needed for activating the button.

## Full Implementaion: Activity Views (WaterView)

```swift
struct Coffee: View {
    // model from the parent view
    @EnvironmentObject var model: Model
    
    // animation variables
    @State private var ontap: Bool = false
    @State private var showPulse: Bool = false
    // colour for the circle, activity ring, and pulse animation.
    @State private var colour: Color = .brown
    
    var body: some View {
        ZStack {
            // Activity Ring
            ActivityRingView(progress: model.userData.coffeeDrank, ringColour: .brown, lineWidth: 22)
                .frame(width: 180)

            // bottom circle that you can see (brown)
            Circle()
                .frame(width: 120)
                .foregroundStyle(colour.gradient)
                .opacity(ontap ? 0.5 : 1)

            // The coffee cup icon
            Image(systemName: (model.userData.coffeeDrank >= 0.9) ? "repeat.circle" : "cup.and.heat.waves.fill")
                .font(.system(size: 70))
                .foregroundStyle(.white)
                .opacity(ontap ? 0.5 : 1) // changes opacity when tapped.
                .offset(x:4)

            // Tap Gesture Circle that you cannot see and is used as the "button"
            // to activate the activity ring. It is used because the icon was creating a
            // dead zone around it. If a user tapped slightly off the icon, nothing happened.
            Circle()
                .frame(width: 100)
                .foregroundStyle(colour.gradient)
                .opacity(0.1)
                .onTapGesture {
                    // when te circle is tapped
                    // animate the button tap by lowering opacity
                    // show the pulse animation
                    // if the ring is full, reset.
                    // add +1 to total coffee
                    // othewise add to ring and add to total coffee.
                    // save to phone data.
                    withAnimation(.linear(duration: 0.3)) {
                        ontap.toggle()
                        showPulse = true
                        if model.userData.coffeeDrank >= 0.9 {
                            model.userData.coffeeDrank = 0.0
                            model.userData.totalCoffee += 0.1
                        } else {
                            model.userData.coffeeDrank += 0.1
                            model.userData.totalCoffee += 0.1
                        }
                        model.save()
                    }
                    // now return circle and icon to their original opacity
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.linear(duration: 0.3)) {
                            ontap = false
                        }
                    }
                }

            // Pulse Animation then reset bool
            if showPulse {
                Pulse(c: colour)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            showPulse = false
                        }
                    }
            }
            
        }
    }
}
```

# Daily View

The `DailyView()` displays the totals for today and yesterday. It is a grouping of two-by-four activity rings with a button that navigates to the `SettingsView`.

<p align="center">
<img src="/gifs/Screenshot 2025-02-05 at 17.20.57.png" alt="dailyView">
</P>

Each set of rings is identical in implementation with top-left, bottom-right, and top-right, bottom-left being twins. It follows the same implemtation as the activity views except that each item has two rings. these rings are held in a Z`Stack`, which is palced in a `HStack` so that the neighbouring rings are aligned Horizontally.

This implentation is repeated for the bottom rings. both sets of rings are embedded in a vertical stack.

Here is a simplified version of the `DailyView` ring stack.

```swift
VStack {
    HStack {
        // large rings (water)
        Zstack {
            ActivityRingView()
            ActivityRingView()
            Icon()
        }
        // small rings (coffee)
        Zstack {
            ActivityRingView()
            ActivityRingView()
            Icon()
        }
    }
    HStack {
        // small rings (snacks)
        Zstack {
            ActivityRingView()
            ActivityRingView()
            Icon()
        }
        // large rings (meals)
        Zstack {
            ActivityRingView()
            ActivityRingView()
            Icon()
        }
    }
}

```

Each set of rings is built using the `ActivityRingView()` and an icon. Below is a single implementaiton for them.

```swift
        ZStack {
             // today
            ActivityRingView(progress: model.userData.totalWater, ringColour: .cyan, lineWidth: 14)
            .frame(width: width)
            // yesterday
            ActivityRingView(progress: model.userData.totalWaterYesterday, ringColour: .blue, lineWidth: 9)
            .frame( width: width - 30)
            // waterbottle icon
            Image(systemName: "waterbottle")
            .font(.system(size: 20))
            .foregroundStyle(.white)
        }

```

The activity rings are embedded in a ZStack which accommodates the settings button on the bottom-left corner. To simplify again.

```swift
// embedded in a NavigationStack
ZStack {
    // Legend/Key implementation

    Button {

    } label: {
        Icon
    }
    .naviationDestination(isPresented: $navigateToSettingsView){
        SettingsView()
    }
    .clipShape(Circle())

    VStack {
        // The Activity Rings
    }
}

```

The legend/key is 2 small `Circle()` and `Text()` that fade in during the `onAppear()`.
It is only there for user interpretation.

## Full implementation: Daily View

```swift
struct DailyView: View {
    // model from the parent view
    @EnvironmentObject var model: Model
    // navigates to the setting screen when the button is tapped.
    @State var naviagateToSettingsView = false
    // animation for the legend/key in the top right of the view.
    @State var keyOpacity: Double = 0
    // width of the larger rings.
    let width: CGFloat = 100
    
       
    var body: some View {
        // this stack lets the button naviage to the settings screen.
        NavigationStack {
            ZStack {
                // key: Today/Tomorrow
                HStack {
                    Circle()
                        .frame(width: 5)
                        .foregroundStyle(.cyan)
                    Text("Today")
                        .font(.system(size: 6))
                }
                .offset(x: 17, y: -110)
                .opacity(keyOpacity)
                HStack {
                    Circle()
                        .frame(width: 4)
                        .foregroundStyle(.blue)
                    Text("Yesterday")
                        .font(.system(size: 5))
                }
                .offset(x: 29, y: -102)
                .opacity(keyOpacity)
                
                // Settings Button
                Button {naviagateToSettingsView = true}
                label: {
                    Image(systemName: "info.circle")
                }
                .navigationDestination(isPresented: $naviagateToSettingsView) {
                    // click to navigate to the settings view
                    SettingsView()
                }
                .clipShape(Circle())
                .frame(width: 35)
                .foregroundStyle(.white)
                .offset(x: -45, y: 90)
                
                
                // activity circles start here
                VStack(alignment: .center, spacing: 12) {
                    HStack(alignment: .bottom, spacing: 14) {
                        // water (left large)
                        ZStack {
                            // today
                            ActivityRingView(progress: model.userData.totalWater, ringColour: .cyan, lineWidth: 14)
                                .frame(width: width)
                            // yesterday
                            ActivityRingView(progress: model.userData.totalWaterYesterday, ringColour: .blue, lineWidth: 9)
                                .frame( width: width - 30)
                            // waterbottle icon
                            Image(systemName: "waterbottle")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                        }
                        // coffee (right small)
                        ZStack {
                            // today
                            ActivityRingView(progress: model.userData.totalCoffee, ringColour: .brown, lineWidth: 10)
                                .frame( width: 60)
                            // Yesterday
                            ActivityRingView(progress: model.userData.totalCoffeeYesterday, ringColour: .brown.opacity(0.6), lineWidth: 7)
                                .frame(width: 40)
                            // cup icon
                            Image(systemName: "cup.and.heat.waves")
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        }
                    }
                    HStack(alignment: .top, spacing: 14) {
                        // snacks (left small)
                        ZStack {
                            // today
                            ActivityRingView(progress: model.userData.totalSnacks, ringColour: .reddish, lineWidth: 10)
                                .frame( width: 60)
                            // yesterday
                            ActivityRingView(progress: model.userData.totalSnacksYesterday, ringColour: .darkerReddish, lineWidth: 7)
                                .frame(width: 40)
                            // carrot icon
                            Image(systemName: "carrot")
                                .font(.system(size: 15))
                                .foregroundStyle(.white)
                        }
                        // meals (right large)
                        ZStack {
                            // Yesterday
                            ActivityRingView(progress: model.userData.totalMealsYesterday, ringColour: .greenish, lineWidth: 9)
                                .frame( width: width - 30)
                            // Today
                            ActivityRingView(progress: model.userData.totalMeals, ringColour: .darkerGeenish, lineWidth: 14)
                                .frame( width: width)
                            // knife and fork icon
                            Image(systemName: "fork.knife.circle")
                                .font(.system(size: 25))
                                .foregroundStyle(.white)
                        }
                    }
                }
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                .ignoresSafeArea()
                
            }
            .onAppear() {
                // after 3 seconds, animate the Legend/Key onto the screen.
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.linear(duration: 1)) {
                        self.keyOpacity = 1
                    }
                }
            }
        }
    }
}
```

# Settings View

The Settings view hold a second TabView that holds 2 Picker widgets. One is for the selection of the user's waterbottle size, the second is the selection of the frequency of the notifications.

## Variables

The variables in the settings view:

* model: the model object from the parent view.
* litreOptions: array of integers that represent the size of a water bottle e.g 100 = 100ml
* notificaitonOptions: arry with integers that represent hours.
* litreSelectedValue: is the current selected integer in the waterbottle Picker.
* notificationSelectedValue: the same as above but for the notification picker.
* savedOpacity: is the current opacity of the animated save.
* removedOpacity: as above, but for the removed hint.

## Picker

This is the default picker widget available in SwiftUI. It sits in a ZStack so the text `ml` can sit next to the numbers. It moves where needed to maintain the formatting.

```swift
    Picker("BOTTLE VOLUME", selection: $litreSelectedValue) {
        ForEach(litreOptions, id: \.self) { value in
            Text("\(value)") // values: 100, 200,etc
                .tag(value)
                .font(.title)
        }
        .foregroundStyle(.green)
    }
    .foregroundStyle(.green.opacity(0.4))
    .pickerStyle(.wheel)
    .frame(width: 150, height: 80)
                    
     Text("ml") // is the text in the picker
         .foregroundStyle(.green.opacity(0.4))
        // moves when it reaches 1000.
         .offset(x:litreSelectedValue == 1000 ? 53 : 42, y: 15)
```

Both pickers have a button that saves the data to the watch memory.
The Notification Picker has a delete button for removing all notifications.

# Content View

Content View hold the TabView that allows for navigation between all the activity views and the daily view. The EnvironmentObject is initialised in the iShnakApp file.

```swift
struct ContentView: View {
    // UI model
    @EnvironmentObject var model: Model
    
    // gets the app to open on this view.
    @State var tabSelected: Int = 0
        
    var body: some View {
        // This is the vertical navigation functionality of the app.
        // each view in the TavView is accessed by swiping up/down.
        TabView(selection: $tabSelected) {
            
            DailyView()
                .tag(0)
            Water()
                .tag(1)
            Meal()
                .tag(2)
            Coffee()
                .tag(3)
            Snacks()
                .tag(4)
            
        }
        .tabViewStyle(.verticalPage(transitionStyle: .blur))
        .onAppear {
            // loads previous data from watch.
            withAnimation(.linear(duration: 0)) {
                model.load()
            }
        }
    }
    
}
```

