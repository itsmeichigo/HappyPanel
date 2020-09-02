# HappyPanel
Slack-like panel for emojis - starring SwiftUI 🙃

## Checklist 🎯

- [x] Grid to scroll smoothly
- [x] Panel to drag smoothly
- [ ] List to behave properly to panel drag gesture
- [x] List to scroll back to top after closing
- [x] Section title picker to be able to navigate to correct sections
- [ ] Section title picker to be updated when scrolling to respective sections
- [x] Keyboard-responsive UI
- [x] Show recently used emoji section on top
- [x] Dark mode
- [ ] Clean code

<img src="https://github.com/itsmeichigo/HappyPanel/blob/master/screenshot.png?raw=true" width=400>

## Discussions

The point of this project is to learn SwiftUI and make use of its declarative syntax to build a complicated control with gestures and animation. Because the biggest motivation for me to learn something new is to be able to make something beautiful and performant.

Below is how I tried to solve the problem - more like a note on what I learned.

### Start out with the smallest components first

* Search bar: essentially a text field with grey background color and search icon on the left. Search button should show up when the field is focused and disappear otherwise.
* Emoji grid: a grid of buttons that returns the content to its parent when tapped. The grid can be built with a combination of VStack and HStack (which requires a 2-dimensional array), but SwiftUI 2 provides grid which is super helpful so I used LazyVGrid instead. This is a toy project, I don't care about users using iOS 13 anyway.
* List with section headers containing the emoji grid. The cool thing about SwiftUI is that a lot of UI components are supported natively without much needed code and here's one of them: a `List` wrapping around a `Section` with header will give you a table view with sticky headers. This is way too convenient comparing to how I'd have had to implement the same thing with UIKit.
* Search result rows for filtered emoji.
* Search result list.
* Main content view: containing all the above components.
* Section title picker to navigate between sections. I want this to float above the main content view so it's not contained in the main content view.
* Main panel: containing a dimmed background, the main content view and the section title picker.

### Navigate between sections

With the help of `ScrollViewReader` and `ScrollViewProxy`, navigating to a desired section of a list is so easy with a simple `scrollTo(_ id:)` function. The problem is I had to learn how to use it the hard way with very much frustration involved. 

The magic of `ScrollViewProxy` is that it scans through the children to find the view with the `id` that you send it. It's as simple as that, but at first I tried to call the scroll function on the `List`, which crashes the app since my `List` doesn't immediately contain the view that I was looking for, but has it embeded inside a child `ForEach`. Moving the call downward to the child was the solution that took me almost a whole day. 

There's a feature that I have yet to implement. It is expected that when the emoji grid is scrolled the section picker updates its selected segment accordingly. As far as I know this is natively impossible since SwiftUI `List` doesn't offer a way to read the current offset but if it does some day, I think I can compare the offset with the pre-calculated frame of each section. This is still fugly, and also when I can determine the current visible section and update the `currentCategory` environment variable, it would cause a circular reference since the picker itself is listening on any change of this variable to scroll to the correct section. So is there a better solution?

### Moving the main panel with drag gesture

Updating the main panel offset with drag gesture isn't the hardest part to begin with. I keep the 2 variables - one for the calculated offset and one for the last offset when the dragging gesture ends, which is used for calculated the first variable. Then I have some magic code to magnetize the panel to the top or close the panel based on where the gesture ends.

A problem I noticed was that if I move the main content view's code to main panel, the dragging performance suffers. I keep the same code and move it to a separate file, the dragging gets as smooth as it can ever get. This remains a mystery to me.

There's a challenge here though. Slack utilizes the drag gesture on the emoji grid view very well, when the panel is in half mode you can't scroll the grid but instead can only drag the panel. I tried to mimick this behavior but there's no native way to do intervene the scrolling behavior of the `List`. So I just leave it there and wait to see when SwiftUI provides such feature, if ever.

### @EnvironmentObject

Originally I used a lot of `@State` and `@Binding` to send some states back and forth between children and parent views. I then decided to clean the mess up by using `@EnvironmentObject` so that all children and parents can have access to the same states of the view. This causes me to think if this is the intended behavior of the property wrapper itself - if it makes the state globablly available to all the listeners to both read and write, would it be safe? Like I may have some code in a view that has nothing to do with search keyword but alter the variable and the control will break. If SwiftUI's main purpose is to maintain states in a clean way then my usage of `@EnvironmentObject` is totally against the rule.

## Contributions

The code I wrote here is still messy as hell and there are so many problems as discussed above, so hopefully someone in the community will join and share some idea on how to make it better. My biggest mission in life is to learn and be better at whatever I do, which in this context is coding, mostly.



